#!/bin/bash

###############################################################################
#    Copyright 2023 Slawomir Czerwinski
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
###############################################################################

REPORT_DIR="$1"
REPORT_PATH="${REPORT_DIR}.md"

PLUGIN_ID="$2"
PLUGIN_VERSION="$3"


RESULT_FILE="verification-verdict.txt"
DEPENDENCIES_FILE="dependencies.txt"

h1() {
  echo -e "\n### ${1}\n" >> "${REPORT_PATH}"
}

h2() {
  echo -e "\n#### ${1}\n" >> "${REPORT_PATH}"
}

append() {
  while read -r LINE; do
    echo -e "${LINE}" >> "${REPORT_PATH}"
  done <"${1}"
}

append_as_bullets() {
  while read -r LINE; do
    echo -e "- ${LINE}" >> "${REPORT_PATH}"
  done <"${1}"
}

append_as_code() {
  echo '```' >> "${REPORT_PATH}"

  while read -r LINE; do
    echo -e "${LINE}" >> "${REPORT_PATH}"
  done <"${1}"

  echo '```' >> "${REPORT_PATH}"
}


for IDE_PATH in "${REPORT_DIR}"/*
do
  IDE=${IDE_PATH##*/}
  IDE_REPORT_DIR="${IDE_PATH}/plugins/${PLUGIN_ID}/${PLUGIN_VERSION}"

  h1 ":receipt: ${IDE}"
  append "${IDE_REPORT_DIR}/${RESULT_FILE}"

  for PATH in "${IDE_REPORT_DIR}"/*
  do
    FILE="${PATH##*/}"
    FILENAME="${FILE%.txt}"
    HEADER="${FILENAME//-/ }"

    case "${FILE}" in

      "${RESULT_FILE}")
        ;;

      "${DEPENDENCIES_FILE}")
        ;;

      *)
        h2 ":warning: ${HEADER^}"
        append_as_bullets "${PATH}"
        ;;
    esac
  done

  h2 ":arrow_double_up: Dependencies"
  append_as_code "${IDE_REPORT_DIR}/${DEPENDENCIES_FILE}"
done
