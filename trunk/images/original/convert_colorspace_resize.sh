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
#
# time ./convert_colorspace_resize.sh -v *.jpg
# time ./convert_colorspace_resize.sh -v $(find -type f -name '*.jpg' | sort)
#
# (takes about 7.5 sec for all images)


renice 19 --pid $$ > /dev/null


declare -r SCRIPT_NAME="$(basename -- "${0}")"


#-------------------------------------------------------------------------------


function usage
{
	printf "Usage: ${SCRIPT_NAME} [-V] [-h] [-v] [-x SIZE_X] [-y SIZE_Y] ORIGINAL_IMAGE ...\n"
	printf "Convert the ORIGINAL_IMAGE(s) to gray-scale and resize.\n"
	printf "  -V : Print the version information and exit.\n"
	printf "  -h : Print this message and exit.\n"
	printf "  -v : Print extra output. ; default OFF\n"
	printf "  -x SIZE_X : The number of pixels on the X-axis. (default 384)\n"
	printf "  -y SIZE_Y : The number of pixels on the Y-axis. (default 384)\n"
	printf "  ORIGINAL_IMAGE : The original image to convert.\n"
}


#-------------------------------------------------------------------------------


declare -i VERBOSE=0


declare -i SIZE_X=384
declare -i SIZE_Y=384


while getopts "Vhvx:y:" option
do
	case "${option}" in

		V) # version
			printf "${SCRIPT_NAME} 2010-08-13\n"
			printf "Copyright (C) 2010 Steve Ward\n"
			exit
		;;

		h) # help
			usage
			exit
		;;

		v) # verbose
			VERBOSE=1
		;;

		x) # SIZE_X
			SIZE_X="${OPTARG}"

			if ((SIZE_X < 1))
			then
				printf "Error: SIZE_X (${SIZE_X}) is < 1.\n"
				usage
				exit 1
			fi
		;;

		y) # SIZE_Y
			SIZE_Y="${OPTARG}"

			if ((SIZE_Y < 1))
			then
				printf "Error: SIZE_Y (${SIZE_Y}) is < 1.\n"
				usage
				exit 1
			fi
		;;

		*)
			usage
			exit 1
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


((VERBOSE)) && printf "SIZE_X: ${SIZE_X}\n"
((VERBOSE)) && printf "SIZE_Y: ${SIZE_Y}\n"


#-------------------------------------------------------------------------------


if (($# < 1))
then
	printf "Error: Must give at least 1 file.\n"
	usage
	exit 1
fi


#-------------------------------------------------------------------------------


declare -r REFERENCE_IMAGE_PREFIX='reference'
declare -r REFERENCE_IMAGE_SUFFIX='png'

((VERBOSE)) && printf "REFERENCE_IMAGE_PREFIX: ${REFERENCE_IMAGE_PREFIX}\n"
((VERBOSE)) && printf "REFERENCE_IMAGE_SUFFIX: ${REFERENCE_IMAGE_SUFFIX}\n"


#-------------------------------------------------------------------------------


for ORIGINAL_IMAGE in "$@"
do
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	if [[ ! -f "${ORIGINAL_IMAGE}" ]]
	then
		printf "Error: File '${ORIGINAL_IMAGE}' does not exist.\n"
		exit 1
	fi

	((VERBOSE)) && printf "ORIGINAL_IMAGE: ${ORIGINAL_IMAGE}\n"

	#---------------------------------------------------------------------------

	IMAGE_SET="${ORIGINAL_IMAGE%.*}"
	((VERBOSE)) && printf "IMAGE_SET: ${IMAGE_SET}\n"

	if [[ -f "${IMAGE_SET}" ]]
	then
		printf "Error: File ${IMAGE_SET} already exists.\n"
		exit 1
	fi

	if [[ -d "${IMAGE_SET}" ]]
	then
		printf "Error: Directory ${IMAGE_SET} already exists.\n"
		exit 1
	fi

	if [[ -e "${IMAGE_SET}" ]]
	then
		printf "Error: ${IMAGE_SET} already exists.\n"
		exit 1
	fi

	#---------------------------------------------------------------------------

	if ((VERBOSE))
	then
		mkdir --verbose --parents "${IMAGE_SET}" || exit 1
	else
		mkdir           --parents "${IMAGE_SET}" || exit 1
	fi

	#---------------------------------------------------------------------------

	REFERENCE_IMAGE="${IMAGE_SET}/${REFERENCE_IMAGE_PREFIX}.${REFERENCE_IMAGE_SUFFIX}"
	((VERBOSE)) && printf "REFERENCE_IMAGE: ${REFERENCE_IMAGE}\n"

	# do not use '-verbose' option for 'convert', too much is printed
	convert "${ORIGINAL_IMAGE}" -colorspace Gray -resize "${SIZE_X}x${SIZE_Y}" "${REFERENCE_IMAGE}" || exit

	#---------------------------------------------------------------------------

done
