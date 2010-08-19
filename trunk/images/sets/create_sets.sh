#!/bin/bash

# Image Quality Assessment Test
# Copyright (C) 2010  Steve Ward
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


# example:
# ./create_sets.sh *.png *.jpg

renice 19 --pid $$


if (($# == 0))
then
	echo "Error: must give at least 1 file."
	echo "Usage: $0 FILE1 [FILE2 ...]"
	exit 1
fi


for FILE in "$@"
do

	if [[ ! -f "${FILE}" ]]
	then
		echo "Error: ${FILE} does not exist."
		continue
	fi

	#echo "FILE: ${FILE}"

	FILE_NAME="${FILE%.*}"

	#echo "FILE_NAME: ${FILE_NAME}"

	FILE_EXTENSION="${FILE##*.}"

	#echo "FILE_EXTENSION: ${FILE_EXTENSION}"

	SET_NAME=''

	FILE_NEW=''

	case "${FILE_EXTENSION}" in

	'PNG' | 'png')
	#[Pp][Nn][Gg])

		# reference image

		SET_NAME="${FILE_NAME}"

		FILE_NEW='reference.png'

		;;

	'JPG' | 'jpg')
	#[Jj][Pp][Gg])

		# distorted image

		SET_NAME=$(echo "${FILE_NAME}" | sed --regexp-extended 's/_quality_([[:digit:]]+)$//') || exit

		FILE_NEW=$(echo "${FILE_NAME}" | sed --regexp-extended 's/^.+_quality_([[:digit:]]+)$/distorted_\1.jpg/') || exit

		;;

	*)
		echo "FILE_EXTENSION ${FILE_EXTENSION} is unknown"

		continue

		;;

	esac

	#echo "SET_NAME: ${SET_NAME}"

	#echo "FILE_NEW: ${FILE_NEW}"

	if [[ ! -d "${SET_NAME}" ]]
	then
		mkdir --verbose "${SET_NAME}" || exit
	fi

	mv --verbose "${FILE}" "${SET_NAME}/${FILE_NEW}" || exit

	echo

done
