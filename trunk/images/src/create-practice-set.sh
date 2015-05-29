#!/bin/bash

# Image Quality Assessment Test
# Copyright (C) 2015 Steve Ward
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
# time ./create-practice-set.sh -v gizah_pyramids

renice 19 --pid $$ > /dev/null


SCRIPT_NAME=$(basename -- "${0}") || exit

VERBOSE=false
VERBOSE_STRING=''

DISTORTION=quality

source distortions.sh || exit


#-------------------------------------------------------------------------------


function print_version
{
	cat <<EOT
${SCRIPT_NAME} 2015-05-25
Copyright (C) 2015 Steve Ward
EOT
}


function print_usage
{
	cat <<EOT
Usage: ${SCRIPT_NAME} [-V] [-h] [-v] [-d DISTORTION] IMAGE_SET
Create a practice image set with images from IMAGE_SET having distortion DISTORTION and matching particular metrics.
  -V : Print the version information and exit.
  -h : Print this message and exit.
  -v : Print extra output. (default OFF)
  -d DISTORTION : The type of distortion of the images used in the image set. (default "quality")
  IMAGE_SET : The image set.
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


while getopts "Vhvd:" option
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

		d) # distortion
			DISTORTION="${OPTARG}"

			if ! is_valid_distortion "${DISTORTION}"
			then
				print_error "DISTORTION (${DISTORTION}) is not in the list of distortions (${DISTORTIONS[*]})."
			fi
		;;

		*)
			# Note: ${option} is '?'
			print_error "Option is unknown."
		;;

	esac
done


shift $((OPTIND - 1)) || exit


print_verbose "DISTORTION=${DISTORTION}"


declare -r PRACTICE_SET_DIRECTORY="../practice-set"
print_verbose "PRACTICE_SET_DIRECTORY=${PRACTICE_SET_DIRECTORY}"


#-------------------------------------------------------------------------------


if (($# != 1))
then
	print_error "Must give 1 image set."
fi


#-------------------------------------------------------------------------------


declare -r IMAGE_SET="${1}"
print_verbose "IMAGE_SET=${IMAGE_SET}"


if [[ ! -d "${IMAGE_SET}" ]]
then
	print_error "Image set %q does not exist." "${IMAGE_SET}"
fi


DESTINATION="${PRACTICE_SET_DIRECTORY}/${IMAGE_SET}"
print_verbose "DESTINATION=${DESTINATION}"


#-------------------------------------------------------------------------------


# Create the practice set directory, if it doesn't exist.
if [[ ! -d "${PRACTICE_SET_DIRECTORY}" ]]
then
	mkdir ${VERBOSE_STRING} -- "${PRACTICE_SET_DIRECTORY}" || exit
fi


# Copy the index.html to the practice set directory, if it doesn't exist.
if [[ ! -f "${PRACTICE_SET_DIRECTORY}/index.html" ]]
then
	cp ${VERBOSE_STRING} --preserve -- ../../index.html.template "${PRACTICE_SET_DIRECTORY}/index.html" || exit
fi


# If the destination directory already exists, make a backup copy.
if [[ -d "${DESTINATION}" ]]
then
	mv ${VERBOSE_STRING} -- "${DESTINATION}" "${DESTINATION}"$(date +'.%s.%N') || exit
fi


# Create the destination directory.
mkdir ${VERBOSE_STRING} -- "${DESTINATION}" || exit


# Copy the index.html to the destination directory.
cp ${VERBOSE_STRING} --preserve -- ../../index.html.template "${DESTINATION}/index.html" || exit


#-------------------------------------------------------------------------------


DISTORTED_IMAGES=$(php filter-ssim-values.php --inc=0.08 --limit=2 "${IMAGE_SET}/metrics_${DISTORTION}.csv")
print_verbose "DISTORTED_IMAGES=${DISTORTED_IMAGES}"


# Eval is used to do the brace expansion after the variable expansion.
IMAGES=($(eval echo "${IMAGE_SET}/{anti-reference.png,reference.png,${DISTORTED_IMAGES}}"))
print_verbose "IMAGES=${IMAGES[*]}"
print_verbose "#IMAGES=${#IMAGES[@]}"


if (("${#IMAGES[@]}" != 4))
then
	print_error "The number of images (${#IMAGES[@]}) must be 4."
fi


# Copy the images.
cp ${VERBOSE_STRING} --preserve --update -- "${IMAGES[@]}" "${DESTINATION}" || exit


#-------------------------------------------------------------------------------


DISTORTED_IMAGES_EXTENSION="${IMAGES[2]##*.}"
print_verbose "DISTORTED_IMAGES_EXTENSION=${DISTORTED_IMAGES_EXTENSION}"


DISTORTED_IMAGES_EXTENSION_2="${IMAGES[3]##*.}"
print_verbose "DISTORTED_IMAGES_EXTENSION_2=${DISTORTED_IMAGES_EXTENSION_2}"


if [[ "${DISTORTED_IMAGES_EXTENSION}" != "${DISTORTED_IMAGES_EXTENSION_2}" ]]
then
	print_error "File extensions of distorted images (${DISTORTED_IMAGES_EXTENSION}) (${DISTORTED_IMAGES_EXTENSION_2}) do not match."
fi


unset DISTORTED_IMAGES_EXTENSION_2


#-------------------------------------------------------------------------------


cd "${PRACTICE_SET_DIRECTORY}" || exit


LINKS=(anti-reference.png reference.png "distorted_severe.${DISTORTED_IMAGES_EXTENSION}" "distorted_subtle.${DISTORTED_IMAGES_EXTENSION}")
print_verbose "LINKS=${LINKS[*]}"
print_verbose "#LINKS=${#LINKS[*]}"


if (("${#IMAGES[@]}" != "${#LINKS[@]}"))
then
	print_error "The number of images (${#IMAGES[@]}) does not match the number of links (${#LINKS[@]})."
fi


# Remove existing symbolic links.
rm ${VERBOSE_STRING} --force -- "${LINKS[0]}" || exit
rm ${VERBOSE_STRING} --force -- "${LINKS[1]}" || exit
rm ${VERBOSE_STRING} --force -- "${LINKS[2]}" || exit
rm ${VERBOSE_STRING} --force -- "${LINKS[3]}" || exit


# Make the symbolic links.
ln ${VERBOSE_STRING} --symbolic -- "${IMAGES[0]}" "${LINKS[0]}" || exit
ln ${VERBOSE_STRING} --symbolic -- "${IMAGES[1]}" "${LINKS[1]}" || exit
ln ${VERBOSE_STRING} --symbolic -- "${IMAGES[2]}" "${LINKS[2]}" || exit
ln ${VERBOSE_STRING} --symbolic -- "${IMAGES[3]}" "${LINKS[3]}" || exit
