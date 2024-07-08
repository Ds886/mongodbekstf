#!/bin/sh
set -eu

usage(){
  SCRIPT_NAME=$(basename "${0}")
  printf "Usage: %s <project name>" "${SCRIPT_NAME}"
}

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
BIN_CRUNTIME=
BIN_PODMAN="$(command -v podman)"
BIN_CRUNTIME="${BIN_PODMAN}"
[ -z "${BIN_CRUNTIME}" ] &&  logError "podman not found trying docker" 

[ -z "${BIN_CRUNTIME}" ] &&  BIN_DOCKER="$(command -v docker)" && BIN_CRUNTIME="${BIN_DOCKER}"
[ -z "${BIN_CRUNTIME}" ] &&   logError "No container runtime found please ensure you have either docker or podman on the machine" exit 1
CONT_PATH_IMAGE_FOLDER=_images
[ ! -e "${CONT_PATH_IMAGE_FOLDER}" ] && logError "Couldn't find image folder" && exit 1
CONT_PATH_IMAGE_FILE=Dockerfile.node
[ ! -e "${CONT_PATH_IMAGE_FOLDER}/${CONT_PATH_IMAGE_FILE}" ] && logError "Couldn't find Dockerfile" && exit 1

# shellcheck disable=2034
PATH_CURR="$(pwd)"
PATH_PROJ_BASE="./packages"
PATH_PROJ_TARGET="${1}"
[ -z "${PATH_PROJ_TARGET}" ] && logError "No target project provided" && usage && exit 1
PATH_PROJ_FULL="${PATH_PROJ_BASE}/${PATH_PROJ_TARGET}"
if [ ! -e "${PATH_PROJ_FULL}" ]
then
  echo "No project found with the name '${PATH_PROJ_TARGET}'"
  echo "Available projects:"
  find "${PATH_PROJ_BASE}"  -maxdepth 1  -type d |grep -vE "^${PATH_PROJ_BASE}$"
  exit 1
fi

CONT_REG=""
CONT_REG_PATH=""
CONT_NAME="${PATH_PROJ_TARGET}"
CONT_TAG="latest"
CONT_FULLNAME="${CONT_NAME}:${CONT_TAG}"
set -eu

printEnv(){
  logTrace "Path base project: ${PATH_PROJ_BASE}"
  logTrace "Target project: ${PATH_PROJ_TARGET}"
  logTrace "Container runtime: '${BIN_CRUNTIME}'"
  logTrace "Container registry: '${CONT_REG}'"
  logTrace "Container registry path: '${CONT_REG_PATH}'"
  logTrace "Container name: '${CONT_NAME}'"
  logTrace "Container tag: '${CONT_TAG}'"
  logTrace "Container full name: '${CONT_FULLNAME}'"
}

printEnv

"${BIN_CRUNTIME}" build -t "${CONT_FULLNAME}" -f "${CONT_PATH_IMAGE_FOLDER}/${CONT_PATH_IMAGE_FILE}" "${PATH_PROJ_FULL}"
# # shellcheck disable=2086
# "${BIN_CRUNTIME}" run  --rm -it ${AWS_VARS} "${CONT_FULLNAME}"
