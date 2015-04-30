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

# Usage:
#
# time ./convert-colorspace-resize.sh -v red_apple.jpg
# time ./convert-colorspace-resize.sh -v *.jpg

renice 19 --pid $$ > /dev/null


SCRIPT_NAME=$(basename -- "${0}") || exit

VERBOSE=false
VERBOSE_STRING=''

declare -i SIZE_X=384
declare -i SIZE_Y=384


OPTIPNG_EXISTS=false


#-------------------------------------------------------------------------------


function program_exists
{
	which -- "${@}" &> /dev/null
}


#-------------------------------------------------------------------------------


function print_version
{
	cat <<EOT
${SCRIPT_NAME} 2013-02-26
Copyright (C) 2013 Steve Ward
EOT
}


function print_usage
{
	cat <<EOT
Usage: ${SCRIPT_NAME} [-V] [-h] [-v] [-x SIZE_X] [-y SIZE_Y] ORIGINAL_IMAGE ...
Create a reference image (and anti-reference image) of ORIGINAL_IMAGE by converting to gray-scale and resizing.
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
	printf 'Error: ' 1>&2
	printf -- "${@}" 1>&2
	printf '\n' 1>&2

	printf 'Try "%q -h" for more information.\n' "${SCRIPT_NAME}" 1>&2
	exit 1
}


function print_verbose
{
	${VERBOSE} && { printf -- "${@}" ; printf '\n' ; }
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
			VERBOSE_STRING='--verbose'
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


shift $((OPTIND - 1)) || exit


print_verbose "SIZE_X=${SIZE_X}"
print_verbose "SIZE_Y=${SIZE_Y}"


#-------------------------------------------------------------------------------


if (($# < 1))
then
	print_error "Must give at least 1 file."
fi


#-------------------------------------------------------------------------------


if program_exists optipng
then
	OPTIPNG_EXISTS=true
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

	mkdir ${VERBOSE_STRING} --parents --mode='go-rwx' -- "${IMAGE_SET}" || exit

	#---------------------------------------------------------------------------

	# Create a reference image from the original image by converting it to grayscale and resizing it.

	# Note: Do not use the '-verbose' option for 'convert' because too much is printed.

	# http://www.imagemagick.org/script/command-line-options.php#colorspace
	convert "${ORIGINAL_IMAGE}" -set colorspace RGB -colorspace Rec709Luma -resize "${SIZE_X}x${SIZE_Y}" "${IMAGE_SET}/reference.png" || exit
:<<'EOT'
There is a bug in ImageMagick 6.7.7+.

http://www.imagemagick.org/Usage/color_basics/#grayscale
"Note as of IM v6.7.7 the grayscale images stored without gamma or sRGB modifications, both in memory and when saved. As such they tend to be darker than they did before this version."
EOT
	# http://www.graphicsmagick.org/GraphicsMagick.html#details-colorspace
	#gm convert "${ORIGINAL_IMAGE}" -colorspace Rec709Luma -resize "${SIZE_X}x${SIZE_Y}" "${IMAGE_SET}/reference.png" || exit

	if ${OPTIPNG_EXISTS}
	then
		print_verbose "$(stat --printf '%N\t%s B\n' -- "${IMAGE_SET}/reference.png")"

		if ${VERBOSE}
		then
			# Optimize the png image.
			optipng ${VERBOSE_STRING} -o 2 -fix -preserve -i 0 -- "${IMAGE_SET}/reference.png" || exit
		else
			# Optimize the png image.
			optipng -quiet            -o 2 -fix -preserve -i 0 -- "${IMAGE_SET}/reference.png" || exit
		fi

		print_verbose "$(stat --printf '%N\t%s B\n' -- "${IMAGE_SET}/reference.png")"
	fi

	# Preserve the timestamp.
	touch --reference "${ORIGINAL_IMAGE}" -- "${IMAGE_SET}/reference.png" || exit

	# http://www.imagemagick.org/script/escape.php
	GEOMETRY=$(identify -format '%wx%h' "${IMAGE_SET}/reference.png") || exit
	# http://www.graphicsmagick.org/GraphicsMagick.html#details-format
	#GEOMETRY=$(gm identify -format '%wx%h' "${IMAGE_SET}/reference.png") || exit
	print_verbose "GEOMETRY=${GEOMETRY}"

	# Create an anti-reference image (that's the same size as the reference image) from the 50% gray pattern.
	# http://www.imagemagick.org/script/formats.php#builtin-patterns
	convert -size "${GEOMETRY}" pattern:gray50 "${IMAGE_SET}/anti-reference.png" || exit
	# http://www.graphicsmagick.org/formats.html
	#gm convert -size "${GEOMETRY}" pattern:gray50 "${IMAGE_SET}/anti-reference.png" || exit

	if ${OPTIPNG_EXISTS}
	then
		print_verbose "$(stat --printf '%N\t%s B\n' -- "${IMAGE_SET}/anti-reference.png")"

		if ${VERBOSE}
		then
			# Optimize the png image.
			optipng ${VERBOSE_STRING} -o 2 -fix -preserve -i 0 -- "${IMAGE_SET}/anti-reference.png" || exit
		else
			# Optimize the png image.
			optipng -quiet            -o 2 -fix -preserve -i 0 -- "${IMAGE_SET}/anti-reference.png" || exit
		fi

		print_verbose "$(stat --printf '%N\t%s B\n' -- "${IMAGE_SET}/anti-reference.png")"
	fi

	#---------------------------------------------------------------------------

done
