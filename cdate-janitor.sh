#!/bin/bash

# cdate-janitor by ning
# ningyuan.sg@gmail.com
# Deletes files with a created time older than ...
# in the directory containing this script

# TODO
# (1) Fix the matching of NAMES_IN_DIR and NAMES_TO_IGNORE, especially
#     considering relative path names (and vs absolute path names)

# CONFIGURABLES   | EXPLANATION
# ------------------------------------------------------------------|
# AGE_ALLOWED     | files older than this int in seconds are deleted|
# NAMES_TO_IGNORE | files and dir of filenames specified here are   |
#                 | ignored (separated by spaces)                   |
# ------------------------------------------------------------------|
AGE_ALLOWED=0  # set to delete files older than AGE_ALLOWED
NAMES_TO_IGNORE=("$(basename $0)")

# VARIABLES
TIME_NOW=$(date +%s)
NAMES_IN_DIR=$(dirname $0)/*  # TODO FIX THIS?

# FUNCTIONS
element_in_array() {
    local find=$1
    declare -a array=("${!2}")
    for element in ${array[@]}; do
        [ "${find}" == "${element}" ] &&
	return 0
    done
    return 1
}

# CODE RUNS NOW
for name in ${NAMES_IN_DIR}; do
    if ! element_in_array ${name} NAMES_TO_IGNORE[@]; then
        # CODE!
    fi
done

