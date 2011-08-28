#!/bin/bash

# Image Quality Assessment Test
# Copyright (C) 2011  Steve Ward
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
# time ./create_image_distortions.sh -v ./red_apple/reference.png
# time ./create_image_distortions.sh -v $(find -type f -name 'reference.png' | sort)
#
# (takes about 5.8 min. per image set)


renice 19 --pid $$ > /dev/null


SCRIPT_NAME="$(basename -- "${0}")" || exit 1

VERBOSE=false


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
Usage: ${SCRIPT_NAME} [-V] [-h] [-v] REFERENCE_IMAGE ...
Create image distortions of the REFERENCE_IMAGE(s).
  -V : Print the version information and exit.
  -h : Print this message and exit.
  -v : Print extra output. (default OFF)
  REFERENCE_IMAGE : The reference image to create distortions of.
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


while getopts "Vhv" option
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

		*)
			# Note: ${option} is '?'
			print_error "Option is unknown."
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


#-------------------------------------------------------------------------------


if (($# < 1))
then
	print_error "Must give at least 1 file."
fi


#-------------------------------------------------------------------------------


function add_salt_pepper_noise
{
	local local_INFILE="${1}"
	local local_OUTFILE="${2}"
	local local_DENSITY="${3}"

	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
img = imread('${local_INFILE}');
img = im2double(img);
img = imnoise(img, 'salt & pepper', ${local_DENSITY} / 100);
imwrite(img, '${local_OUTFILE}');
EOT
}


function add_gaussian_noise
{
	local local_INFILE="${1}"
	local local_OUTFILE="${2}"
	local local_VARIANCE="${3}"

	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
img = imread('${local_INFILE}');
img = im2double(img);
img = imnoise(img, 'gaussian', 0, ${local_VARIANCE});
imwrite(img, '${local_OUTFILE}');
EOT
}


function add_speckle_noise
{
	local local_INFILE="${1}"
	local local_OUTFILE="${2}"
	local local_VARIANCE="${3}"

	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
img = imread('${local_INFILE}');
img = im2double(img);
img = imnoise(img, 'speckle', ${local_VARIANCE});
imwrite(img, '${local_OUTFILE}');
EOT
}


#-------------------------------------------------------------------------------


# standard deviation values
declare -r SIGMA_MIN=0.375
declare -r SIGMA_MAX=6.500
declare -r SIGMA_INC=0.125
declare -r -a SIGMA_RANGE=($(seq "${SIGMA_MIN}" "${SIGMA_INC}" "${SIGMA_MAX}"))


print_verbose "SIGMA_MIN=${SIGMA_MIN}"
print_verbose "SIGMA_MAX=${SIGMA_MAX}"
print_verbose "SIGMA_INC=${SIGMA_INC}"
print_verbose "SIGMA_RANGE=(${SIGMA_RANGE[*]})"


declare -r DISTORTED_IMAGE_PREFIX='distorted'
print_verbose "DISTORTED_IMAGE_PREFIX=${DISTORTED_IMAGE_PREFIX}"


declare -r -a DISTORTIONS=(
	'quality'
	'scale'
	'blur'
	'gaussian-blur'
	'sharpen'
	'unsharp'
	'median'
	'salt-pepper-noise'
	'gaussian-noise'
	'speckle-noise'
)
print_verbose "DISTORTIONS=(${DISTORTIONS[*]})"


#-------------------------------------------------------------------------------


for REFERENCE_IMAGE in "$@"
do
	print_verbose ""

	print_verbose "REFERENCE_IMAGE=${REFERENCE_IMAGE}"

	#---------------------------------------------------------------------------

	if [[ ! -f "${REFERENCE_IMAGE}" ]]
	then
		print_error "File '${REFERENCE_IMAGE}' does not exist."
	fi

	#---------------------------------------------------------------------------

	IMAGE_SET="$(dirname -- "${REFERENCE_IMAGE}")" || exit 1
	print_verbose "IMAGE_SET=${IMAGE_SET}"

	#---------------------------------------------------------------------------

	# do not use '-verbose' option for 'convert', too much is printed
	COMMAND="convert ${REFERENCE_IMAGE} -strip"
	print_verbose "COMMAND=${COMMAND}"

	GEOMETRY="$(identify -format '%[width]x%[height]' "${REFERENCE_IMAGE}")" || exit 1
	print_verbose "GEOMETRY=${GEOMETRY}"

	COLORSPACE="$(identify -format '%[colorspace]' "${REFERENCE_IMAGE}")" || exit 1
	print_verbose "COLORSPACE=${COLORSPACE}"

	case "${COLORSPACE}" in

	Gray)
		DISTORTED_IMAGE_SUFFIX='pgm'
		;;

	RGB)
		DISTORTED_IMAGE_SUFFIX='ppm'
		;;

	*)
		print_error "Unknown colorspace (${COLORSPACE}) for reference image '${REFERENCE_IMAGE}'."
		;;

	esac

	print_verbose "DISTORTED_IMAGE_SUFFIX=${DISTORTED_IMAGE_SUFFIX}"

	print_verbose ""

	#---------------------------------------------------------------------------

	for DISTORTION in "${DISTORTIONS[@]}"
	do
		print_verbose "DISTORTION=${DISTORTION}"

		COUNT=0

		case "${DISTORTION}" in

		#-----------------------------------------------------------------------

		quality)
			# JPEG quality value
			DISTORTION_RANGE=($(seq 1 100))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				# must save as jpg
				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.jpg"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} ${VARIABLE} "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		scale)
			# scale to % then back to original size
			DISTORTION_RANGE=($(seq 1 1 30 ; seq 32 2 60 ; seq 65 5 85))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} "${VARIABLE}%" -${DISTORTION} "${GEOMETRY}!" "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		blur)
			# standard deviation
			DISTORTION_RANGE=(${SIGMA_RANGE[@]})
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		gaussian-blur)
			# standard deviation
			DISTORTION_RANGE=(${SIGMA_RANGE[@]})
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		sharpen)
			# standard deviation
			DISTORTION_RANGE=(${SIGMA_RANGE[@]})
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		unsharp)
			# standard deviation
			DISTORTION_RANGE=(${SIGMA_RANGE[@]})
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} "0x${VARIABLE}" "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		median)
			# pixel radius
			DISTORTION_RANGE=($(seq 1 10))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				${COMMAND} -${DISTORTION} ${VARIABLE} "${DISTORTED_IMAGE}" || exit 1
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		salt-pepper-noise)
			# impulse noise pixel density (%)
			DISTORTION_RANGE=($(seq 0.05 0.05 3.0))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				add_salt_pepper_noise "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" "${VARIABLE}"
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		gaussian-noise)
			# variance
			DISTORTION_RANGE=($(seq 0.0001 0.0001 0.0050 ; seq 0.0052 0.0002 0.0100))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				add_gaussian_noise "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" "${VARIABLE}"
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		speckle-noise)
			# variance
			DISTORTION_RANGE=($(seq 0.0001 0.0001 0.0050 ; seq 0.0052 0.0002 0.0100))
			print_verbose "DISTORTION_RANGE=(${DISTORTION_RANGE[*]})"

			for VARIABLE in "${DISTORTION_RANGE[@]}"
			do
				# do not print VARIABLE (it is already in the DISTORTED_IMAGE)

				DISTORTED_IMAGE="${IMAGE_SET}/${DISTORTED_IMAGE_PREFIX}_${DISTORTION}_${VARIABLE}.${DISTORTED_IMAGE_SUFFIX}"
				print_verbose "DISTORTED_IMAGE=${DISTORTED_IMAGE}"

				add_gaussian_noise "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" "${VARIABLE}"
				((COUNT++))

			done
		;;

		#-----------------------------------------------------------------------

		*)
			print_error "Unknown distortion (${DISTORTION})."
		;;

		#-----------------------------------------------------------------------

		esac

		print_verbose "COUNT=${COUNT}"

		print_verbose ""

	done

done
