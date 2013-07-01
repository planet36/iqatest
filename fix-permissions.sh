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

# allow

find ${VCS_REPOS_PRUNE} -type d -print0 | xargs --null --no-run-if-empty chmod go+rx || exit
find ${VCS_REPOS_PRUNE} -type f -print0 | xargs --null --no-run-if-empty chmod go+r  || exit

# forbid

chmod go-rwx generate-image-paths.php || exit

find ./results         ${VCS_REPOS_PRUNE} -print0 | xargs --null --no-run-if-empty chmod go-rwx || exit
find ./images/original ${VCS_REPOS_PRUNE} -print0 | xargs --null --no-run-if-empty chmod go-rwx || exit

find ${VCS_REPOS_PRUNE} -type f -name '*.sh'       -print0 | xargs --null --no-run-if-empty chmod 700 || exit
find ${VCS_REPOS_PRUNE} -type f -name 'index.html' -print0 | xargs --null --no-run-if-empty chmod 444 || exit
