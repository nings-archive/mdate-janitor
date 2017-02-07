#!/bin/bash

# mdate-janitor by ning
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
NAMES_TO_IGNORE=( "$(readlink -f $0)" )  # abs_paths only

# VARIABLES
TIME_NOW=$(date +%s)
SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT_PATH})
NAMES_IN_DIR=$(find -P ${SCRIPT_DIR})

# FUNCTIONS
element_in_array() {
    # element_in_array [str] [array]
    # return 0 if [str] in [array], return 1 otherwise
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
        if [[ -f ${name} ]]; then
	    time_last_modified=$(stat -c %Y ${name})
	    time_difference=$((${TIME_NOW}-${time_last_modified}))
	    if ((${time_difference} > ${AGE_ALLOWED})); then
		echo "DELETE: ${name}"
	        rm ${name}
	    fi
        fi
    fi
done

