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


# Usage:
#
# time ./convert_colorspace_resize.sh -v *.jpg
# time ./convert_colorspace_resize.sh -v $(find -type f -name '*.jpg' | sort)
#
# (takes about 7.5 sec for all images)


renice 19 --pid $$ > /dev/null


SCRIPT_NAME="$(basename -- "${0}")" || exit 1

VERBOSE=false

declare -i SIZE_X=384
declare -i SIZE_Y=384


#-------------------------------------------------------------------------------


function print_version
{
	cat <<EOT
${SCRIPT_NAME} 2010-04-24
Copyright (C) 2011 Steve Ward
EOT
}


function print_usage
{
	cat <<EOT
Usage: ${SCRIPT_NAME} [-V] [-h] [-v] [-x SIZE_X] [-y SIZE_Y] ORIGINAL_IMAGE ...
Convert the ORIGINAL_IMAGE(s) to gray-scale and resize.
  -V : Print the version information and exit.
  -h : Print this message and exit.
  -v : Print extra output. (default OFF)
  -x SIZE_X : The number of pixels on the X-axis. (default 384)
  -y SIZE_Y : The number of pixels on the Y-axis. (default 384)
  ORIGINAL_IMAGE : The original image to convert.
EOT
}


function print_error
{
	printf "Error: ${1}\n" > /dev/stderr
	print_usage
	exit 1
}


function print_verbose
{
	${VERBOSE} && printf "${1}\n"
}


#-------------------------------------------------------------------------------


while getopts "Vhvx:y:" option
do
	case "${option}" in

		V) # version
			print_version
			exit
		;;

		h) # help
			print_usage
			exit
		;;

		v) # verbose
			VERBOSE=true
		;;

		x) # SIZE_X
			SIZE_X="${OPTARG}"

			if ((SIZE_X < 1))
			then
				print_error "SIZE_X (${SIZE_X}) is < 1."
			fi
		;;

		y) # SIZE_Y
			SIZE_Y="${OPTARG}"

			if ((SIZE_Y < 1))
			then
				print_error "SIZE_Y (${SIZE_Y}) is < 1."
			fi
		;;

		*)
			# Note: ${option} is '?'
			print_error "Option is unknown."
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


print_verbose "SIZE_X=${SIZE_X}"
print_verbose "SIZE_Y=${SIZE_Y}"


#-------------------------------------------------------------------------------


if (($# < 1))
then
	print_error "Must give at least 1 file."
fi


#-------------------------------------------------------------------------------


for ORIGINAL_IMAGE in "$@"
do
	print_verbose ""

	print_verbose "ORIGINAL_IMAGE=${ORIGINAL_IMAGE}"

	#---------------------------------------------------------------------------

	if [[ ! -f "${ORIGINAL_IMAGE}" ]]
	then
		print_error "File '${ORIGINAL_IMAGE}' does not exist."
	fi

	#---------------------------------------------------------------------------

	IMAGE_SET="${ORIGINAL_IMAGE%.*}"
	print_verbose "IMAGE_SET=${IMAGE_SET}"

	if [[ -f "${IMAGE_SET}" ]]
	then
		print_error "File ${IMAGE_SET} already exists."
	fi

	if [[ -d "${IMAGE_SET}" ]]
	then
		print_error "Directory ${IMAGE_SET} already exists."
	fi

	if [[ -e "${IMAGE_SET}" ]]
	then
		print_error "Image set ${IMAGE_SET} already exists."
	fi

	#---------------------------------------------------------------------------

	if ((VERBOSE))
	then
		mkdir --verbose --parents "${IMAGE_SET}" || exit 1
	else
		mkdir           --parents "${IMAGE_SET}" || exit 1
	fi

	#---------------------------------------------------------------------------

	# Note: Do not use the '-verbose' option for 'convert' because too much is printed.

	# Create a reference image from the original image by converting it to grayscale and resizing it.
	# http://www.imagemagick.org/script/command-line-options.php#colorspace
	convert "${ORIGINAL_IMAGE}" -colorspace Rec709Luma -resize "${SIZE_X}x${SIZE_Y}" "${IMAGE_SET}/reference.png" || exit 1

	# Create an anti-reference image that's the same size as the reference image from the 50% gray pattern.
	# http://www.imagemagick.org/script/formats.php#builtin-patterns
	convert -size "${SIZE_X}x${SIZE_Y}" pattern:gray50 "${IMAGE_SET}/anti-reference.png" || exit 1

	#---------------------------------------------------------------------------

done
