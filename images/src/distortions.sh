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


declare -r -a DISTORTIONS=(
	'quality'
	'scale'
	'blur'
	'gaussian-blur'
	'sharpen'
	'unsharp'
	'median'
	#'salt-pepper-noise' # depends on Octave
	#'gaussian-noise' # depends on Octave
	#'speckle-noise' # depends on Octave
)


#-------------------------------------------------------------------------------


# Determine if the given argument is in the list of distortions.
function is_valid_distortion
{
	local DISTORTION

	for DISTORTION in "${DISTORTIONS[@]}"
	do
		if [[ "${DISTORTION}" == "${1}" ]]
		then
			return 0
		fi
	done

	return 1
}
