#!/bin/bash

# SPDX-FileCopyrightText: Steven Ward
# SPDX-License-Identifier: OSL-3.0

declare -r EXT='tar.xz'

tar --verbose --create --auto-compress --file archive-$(date +'%Y-%m-%d-%H-%M-%S').${EXT} *.html *.js *.php *.css *.txt *.sh index.html.template || exit

chmod go-rwx archive-*.${EXT} || exit
