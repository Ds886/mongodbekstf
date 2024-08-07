#!/bin/sh
set -eu

logBase(){
  set +u
  LOG_LEVEL="$1"
  [ -z "${LOG_LEVEL}" ] && echo "warn: no level provided. defaulting to TRACE" && LOG_LEVEL="TRACE"
  LOG_MSG="$2"
  [ -z "${LOG_MSG}" ] && echo "warn: no message provided defaulting to null" && LOG_MSG="NULL"
  LOG_DATE="$(date)"
  set -u

  printf "%s - %s - %s\n" "${LOG_DATE}" "${LOG_LEVEL}" "${LOG_MSG}"
}

logWarn(){
  set +u
  WARN_MSG="$1"
  [ -z "${WARN_MSG}" ] && echo "warn: no message provided defaulting to null" && WARN_MSG="NULL"
  set -u
  logBase "WARN" "${WARN_MSG}"
}

logTrace(){
  set +u
  TRACE_MSG="$1"
  [ -z "${TRACE_MSG}" ] && echo "Trace: no message provided defaulting to null" && TRACE_MSG="NULL"
  set -u
  logBase "TRACE" "${TRACE_MSG}"
}
logError(){
  set +u
  ERR_MSG="$1"
  [ -z "${ERR_MSG}" ] && echo "warn: no message provided defaulting to null" && ERR_MSG="NULL"
  set -u
  logBase "ERROR" "${ERR_MSG}"
}

set +eu
BIN_AWS="$(command -v aws)"
[ -z "${BIN_AWS}" ] &&  logError "awscli not found" && exit 1
"${BIN_AWS}" sts get-caller-identity > /dev/null
AWS_STS_EC=$?
[ "${AWS_STS_EC}" != 0 ] && logError "Not logged in to AWS" && exit 1
AWS_VARS=$(env|grep AWS|(while read -r line; do printf ' -e %s' "$line";done))


BIN_CRUNTIME=
BIN_PODMAN="$(command -v podman)"
BIN_CRUNTIME="${BIN_PODMAN}"
[ -z "${BIN_CRUNTIME}" ] &&  logError "podman not found trying docker" 

[ -z "${BIN_CRUNTIME}" ] &&  BIN_DOCKER="$(command -v docker)" && BIN_CRUNTIME="${BIN_DOCKER}"
[ -z "${BIN_CRUNTIME}" ] &&   logError "No container runtime found please ensure you have either docker or podman on the machine" exit 1
CONT_PATH_IMAGE_FOLDER=_images
[ ! -e "${CONT_PATH_IMAGE_FOLDER}" ] && logError "Couldn't find image folder" && exit 1
CONT_PATH_IMAGE_FILE=Dockerfile.terraformaws
[ ! -e "${CONT_PATH_IMAGE_FOLDER}/${CONT_PATH_IMAGE_FILE}" ] && logError "Couldn't find Dockerfile" && exit 1
CONT_REG=""
CONT_REG_PATH=""
CONT_NAME="terraform-run"
CONT_TAG="base"
CONT_FULLNAME="${CONT_NAME}:${CONT_TAG}"
[ -n "${CONT_REG_PATH}" ] && CONT_FULLNAME="${CONT_REG_PATH}/${CONT_FULLNAME}"
[ -n "${CONT_REG}" ] && CONT_FULLNAME="${CONT_REG}/${CONT_FULLNAME}"

set -eu

printEnv(){
  logTrace "Container runtime: '${BIN_CRUNTIME}'"
  logTrace "Container registry: '${CONT_REG}'"
  logTrace "Container registry path: '${CONT_REG_PATH}'"
  logTrace "Container name: '${CONT_NAME}'"
  logTrace "Container tag: '${CONT_TAG}'"
  logTrace "Container full name: '${CONT_FULLNAME}'"
}

printEnv
"${BIN_CRUNTIME}" build -t "${CONT_FULLNAME}" -f "${CONT_PATH_IMAGE_FOLDER}/${CONT_PATH_IMAGE_FILE}" .
# shellcheck disable=2086
"${BIN_CRUNTIME}" run  --rm -it ${AWS_VARS} "${CONT_FULLNAME}"
