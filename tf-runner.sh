#!/bin/sh
set -eu

logBase(){
  set +u
  LOG_LEVEL="$0"
  [ -z "${LEVEL}" ] && echo "warn: no level provided. defaulting to TRACE" && LEVEL="TRACE"
  LOG_MSG="$1"
  [ -z "${MSG}" ] && echo "warn: no message provided defaulting to null" && MSG="NULL"
  LOG_DATE="$(date)"
  set -u

  printf "%s - %s - %s" "${LOG_DATE}" "${LOG_LEVEL}" "${LOG_MSG}"
}

logWarn(){
  set +u
  WARN_MSG="$0"
  [ -z "${WARN_MSG}" ] && echo "warn: no message provided defaulting to null" && WARN_MSG="NULL"
  set -u
  logBase "WARN" "${WARN_MSG}"
}

logTrace(){
  set +u
  TRACE_MSG="$0"
  [ -z "${TRACE_MSG}" ] && echo "Trace: no message provided defaulting to null" && TRACE_MSG="NULL"
  set -u
  logBase "TRACE" "${TRACE_MSG}"
}
logError(){
  set +u
  ERR_MSG="$0"
  [ -z "${ERR_MSG}" ] && echo "warn: no message provided defaulting to null" && ERR_MSG="NULL"
  set -u
  logBase "ERROR" "${ERR_MSG}"
}

set +eu
BIN_TF_VER_EXPECT="1.9.0"
BIN_TF="$(command -v terraform)"
[ -z "${BIN_TF}" ] &&  logError "Terraform not found" && exit 1
BIN_TF_VER="$(${BIN_TF} --version --json|grep version|tr -d\ ,\"|cut -d: -f2)"
[ "${BIN_TF_VER}" != "${BIN_TF_VER_EXPECT}" ] && logError "Terraform version is incorrect: expected '${BIN_TF_VER_EXPECT}'; got '${BIN_TF_VER}"

BIN_CRUNTIME=
BIN_AWS="$(command -v aws)"
[ -z "${BIN_AWS}" ] &&  logError "awscli not found" && exit 1

BIN_PODMAN="$(command -v podman)"
BIN_CRUNTIME="${BIN_PODMAN}"
[ -z "${BIN_CRUNTIME}" ] &&  logError "podman not found trying docker" 

[ -z "${BIN_CRUNTIME}" ] &&  BIN_DOCKER="$(command -v docker)"
[ -z "${BIN_CRUNTIME}" ] && [ -z "${BIN_DOCKER}" ] &&  logError "No container runtime found" exit 1
set -eu




