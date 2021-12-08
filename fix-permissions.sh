#!/bin/bash

# SPDX-FileCopyrightText: Steven Ward
# SPDX-License-Identifier: OSL-3.0

export VCS_REPOS_MATCH='( -type d -and ( -name CVS -or -name .svn -or -name .git -or -name .hg ) )'
export VCS_REPOS_PRUNE="( ${VCS_REPOS_MATCH} -prune , -not ${VCS_REPOS_MATCH} )"

# allow

find ${VCS_REPOS_PRUNE} -type d -print0 | xargs --null --no-run-if-empty chmod go+rx || exit
find ${VCS_REPOS_PRUNE} -type f -print0 | xargs --null --no-run-if-empty chmod go+r  || exit

# forbid

chmod go-rwx generate-image-paths.php || exit

find ./results    ${VCS_REPOS_PRUNE} -print0 | xargs --null --no-run-if-empty chmod go-rwx || exit
find ./images/src ${VCS_REPOS_PRUNE} -print0 | xargs --null --no-run-if-empty chmod go-rwx || exit

find ${VCS_REPOS_PRUNE} -type f -name '*.sh'       -print0 | xargs --null --no-run-if-empty chmod 700 || exit
find ${VCS_REPOS_PRUNE} -type f -name 'index.html' -print0 | xargs --null --no-run-if-empty chmod 644 || exit
