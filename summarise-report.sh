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
REPORT_PATH="${REPORT_DIR}Summary.md"

PLUGIN_ID="$2"
PLUGIN_VERSION="$3"

REPORT_TITLE="$4"


VERDICT_FILE="verification-verdict.txt"

VERDICT_ERROR='^([0-9]+ compatibility problems)$'
VERDICT_WARNING='^Compatible.+$'
VERDICT_SUCCESS='^Compatible$'

append_line() {
  while read -r LINE; do
    RESULT_ICON=':question:'

    if [[ "${LINE}" =~ ${VERDICT_ERROR} ]]
    then
      RESULT_ICON=':stop_sign:'
    elif [[ "${LINE}" =~ ${VERDICT_WARNING} ]]
    then
      RESULT_ICON=':warning:'
    elif [[ "${LINE}" =~ ${VERDICT_SUCCESS} ]]
    then
      RESULT_ICON=':white_check_mark:'
    fi

    echo -e "| ${1} | ${RESULT_ICON} | ${LINE} |" >> "${REPORT_PATH}"
  done <"${2}"
}


echo -e "## ${REPORT_TITLE}" > "${REPORT_PATH}"

echo -e "| IDE | Verification Result | Comment |" >> "${REPORT_PATH}"
echo -e "| :-- | :-: | :-- |" >> "${REPORT_PATH}"

for IDE_PATH in "${REPORT_DIR}"/*
do
  IDE=${IDE_PATH##*/}
  IDE_REPORT_DIR="${IDE_PATH}/plugins/${PLUGIN_ID}/${PLUGIN_VERSION}"

  append_line "${IDE}" "${IDE_REPORT_DIR}/${VERDICT_FILE}"
done
