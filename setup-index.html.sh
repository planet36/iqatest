#!/bin/bash

# SPDX-FileCopyrightText: Steven Ward
# SPDX-License-Identifier: OSL-3.0

export VCS_REPOS_MATCH='( -type d -and ( -name CVS -or -name .svn -or -name .git -or -name .hg ) )'
export VCS_REPOS_PRUNE="( ${VCS_REPOS_MATCH} -prune , -not ${VCS_REPOS_MATCH} )"

#declare -r -a DIRS=($(find -mindepth 1 ${VCS_REPOS_PRUNE} -type d))
#printf "DIRS=(${DIRS[*]})\n"
#printf "#DIRS=${#DIRS[@]}\n"

#for DIR in "${DIRS[@]}"
# shellcheck disable=SC2044
# shellcheck disable=SC2086
for DIR in $(find . -mindepth 1 ${VCS_REPOS_PRUNE} -type d)
do
	if [[ ! -f "${DIR}/index.html" || index.html.template -nt "${DIR}/index.html" ]]
	then
		cp --verbose --preserve index.html.template "${DIR}/index.html" || exit
	fi
done
