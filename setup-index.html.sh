#!/bin/bash

# Image Quality Assessment Test
# Copyright (C) 2013 Steve Ward
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

export VCS_REPOS_MATCH='( -type d -and ( -name CVS -or -name .svn -or -name .git -or -name .hg ) )'
export VCS_REPOS_PRUNE="( ${VCS_REPOS_MATCH} -prune , -not ${VCS_REPOS_MATCH} )"

declare -r -a DIRS=($(find -mindepth 1 ${VCS_REPOS_PRUNE} -type d))
printf "DIRS=(${DIRS[*]})\n"
printf "#DIRS=${#DIRS[@]}\n"

for DIR in "${DIRS[@]}"
do
	#[[ ! -f "${DIR}/index.html" ]] && { cp --verbose --preserve=timestamps index.html.template "${DIR}/index.html" || exit 1 ; }
	if [[ ! -f "${DIR}/index.html" ]]
	then
		#cp --verbose --preserve=timestamps index.html.template "${DIR}/index.html" || exit
		cp --verbose --preserve index.html.template "${DIR}/index.html" || exit
	fi
done
