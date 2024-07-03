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
[ -z "${BIN_TF_VER_EXPECT}" ] && BIN_TF_VER_EXPECT="1.9.0"
BIN_TF="$(command -v terraform)"
[ -z "${BIN_TF}" ] &&  logError "Terraform not found" && exit 1
BIN_TF_VER="$(${BIN_TF} --version --json|grep version|tr -d \ ,\"|cut -d: -f2)"
[ "${BIN_TF_VER}" != "${BIN_TF_VER_EXPECT}" ] && logError "Terraform version is incorrect: expected '${BIN_TF_VER_EXPECT}'; got '${BIN_TF_VER}"

BIN_AWS="$(command -v aws)"
[ -z "${BIN_AWS}" ] &&  logError "awscli not found" && exit 1

BIN_CRUNTIME=
BIN_PODMAN="$(command -v podman)"
BIN_CRUNTIME="${BIN_PODMAN}"
[ -z "${BIN_CRUNTIME}" ] &&  logError "podman not found trying docker" 

[ -z "${BIN_CRUNTIME}" ] &&  BIN_DOCKER="$(command -v docker)" && BIN_CRUNTIME="${BIN_DOCKER}"
[ -z "${BIN_CRUNTIME}" ] &&   logError "No container runtime found please ensure you have either docker or podman on the machine" exit 1

TARGETS="$@"
[ -z "${TARGETS}" ] && TARGETS="init plan apply"
set -eu

printEnv(){
  logTrace "Terraform path: '${BIN_TF}'"
  logTrace "Terraform version: '${BIN_TF_VER}'"
  logTrace "AWS path: '${BIN_AWS}'"
  logTrace "Container runtime: '${BIN_CRUNTIME}'"
}

printEnv

for TARGET in ${TARGETS} 
do
  case $TARGET in
    "init")
      "${BIN_TF}" init
      ;;
    "plan")
      "${BIN_TF}" plan
      ;;
    "apply")
      "${BIN_TF}" apply
      ;;
    "destroy")
      "${BIN_TF}" destroy
      ;;
  esac
done




