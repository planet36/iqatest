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
# time ./create_image_distortions.sh -v ./red_apple/reference.png
# time ./create_image_distortions.sh -v $(find -type f -name 'reference.png' | sort)
#
# (takes about 11 min. for all image sets)


renice 19 --pid $$ > /dev/null


declare -r SCRIPT_NAME="$(basename -- "${0}")"


#-------------------------------------------------------------------------------


function usage
{
	printf "Usage: ${SCRIPT_NAME} [-V] [-h] [-v] REFERENCE_IMAGE ...\n"
	printf "Create image distortions of the REFERENCE_IMAGE(s).\n"
	printf "  -V : Print the version information and exit.\n"
	printf "  -h : Print this message and exit.\n"
	printf "  -v : Print extra output. (default OFF)\n"
	printf "  REFERENCE_IMAGE : The reference image to create distortions of.\n"
}


#-------------------------------------------------------------------------------


declare -i VERBOSE=0


while getopts "Vhv" option
do
	case "${option}" in

		V) # version
			printf "${SCRIPT_NAME} 2010-08-17\n"
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

		*)
			usage
			exit 1
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


#-------------------------------------------------------------------------------


if (($# < 1))
then
	printf 'Error: Must give at least 1 file.\n'
	usage
	exit 1
fi


#-------------------------------------------------------------------------------


function add_salt_pepper_noise
{
	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
density = ${3} / 100;
img = imread('${1}');
assert(isgray(img));
img = im2double(img);
img = imnoise(img, 'salt & pepper', density);
img = im2uint8(img);
imwrite(img, '${2}');
EOT
}


#-------------------------------------------------------------------------------


# standard deviation values
declare -r SIGMA_MIN=0.25
declare -r SIGMA_MAX=6.375
declare -r SIGMA_INC=0.125
declare -r SIGMA_RANGE=($(seq "${SIGMA_MIN}" "${SIGMA_INC}" "${SIGMA_MAX}"))


((VERBOSE)) && printf "SIGMA_MIN: ${SIGMA_MIN}\n"
((VERBOSE)) && printf "SIGMA_MAX: ${SIGMA_MAX}\n"
((VERBOSE)) && printf "SIGMA_INC: ${SIGMA_INC}\n"
((VERBOSE)) && printf "SIGMA_RANGE: ${SIGMA_RANGE[*]}\n"


declare -r DISTORTED_IMAGE_PREFIX='distorted'
declare -r DISTORTED_IMAGE_SUFFIX='pgm'
#declare -r DISTORTED_IMAGE_SUFFIX='png'

((VERBOSE)) && printf "DISTORTED_IMAGE_PREFIX: ${DISTORTED_IMAGE_PREFIX}\n"
((VERBOSE)) && printf "DISTORTED_IMAGE_SUFFIX: ${DISTORTED_IMAGE_SUFFIX}\n"


#-------------------------------------------------------------------------------


for REFERENCE_IMAGE in "$@"
do
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	if [[ ! -f "${REFERENCE_IMAGE}" ]]
	then
		printf "Error: File '${REFERENCE_IMAGE}' does not exist.\n"
		exit 1
	fi

	((VERBOSE)) && printf "REFERENCE_IMAGE: ${REFERENCE_IMAGE}\n"

	#---------------------------------------------------------------------------

	IMAGE_SET="$(dirname -- "${REFERENCE_IMAGE}")" || exit 1
	((VERBOSE)) && printf "IMAGE_SET: ${IMAGE_SET}\n"

	#---------------------------------------------------------------------------

	# do not use '-verbose' option for 'convert', too much is printed
	COMMAND="convert ${REFERENCE_IMAGE} -strip"
	((VERBOSE)) && printf "COMMAND: ${COMMAND}\n"

	GEOMETRY="$(identify -format '%[width]x%[height]' "${REFERENCE_IMAGE}")" || exit 1
	((VERBOSE)) && printf "GEOMETRY: ${GEOMETRY}\n"

	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='quality'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# JPEG quality value
	DISTORTION_RANGE=($(seq 1 100))
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		# must save as jpg
		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_jpeg_${VARIABLE}.jpg"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} ${VARIABLE} "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='scale'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# scale to % then back to original size
	DISTORTION_RANGE=($(seq 2 2 20; seq 25 5 50; seq 60 10 90))
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} "${VARIABLE}%" -${DISTORTION} "${GEOMETRY}!" "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='blur'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# standard deviation
	DISTORTION_RANGE=(${SIGMA_RANGE[@]})
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='gaussian-blur'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# standard deviation
	DISTORTION_RANGE=(${SIGMA_RANGE[@]})
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='sharpen'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# standard deviation
	DISTORTION_RANGE=(${SIGMA_RANGE[@]})
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='unsharp'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# standard deviation
	DISTORTION_RANGE=(${SIGMA_RANGE[@]})
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='median'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# pixel radius
	DISTORTION_RANGE=($(seq 1 10))
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		${COMMAND} -${DISTORTION} ${VARIABLE} "${DISTORTED_IMAGE}" || exit 1
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	DISTORTION='noise'
	((VERBOSE)) && printf "DISTORTION: ${DISTORTION}\n"

	# impulse noise pixel density (%)
	DISTORTION_RANGE=($(seq 1 25))
	((VERBOSE)) && printf "DISTORTION_RANGE: ${DISTORTION_RANGE[*]}\n"

	COUNT=0
	for VARIABLE in "${DISTORTION_RANGE[@]}"
	do
		# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

		DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
		((VERBOSE)) && printf "DISTORTED_IMAGE: ${DISTORTED_IMAGE}\n"

		add_salt_pepper_noise "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" "${VARIABLE}"
		((COUNT++))

	done
	((VERBOSE)) && printf "COUNT: ${COUNT}\n"
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

done
