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
# time ./create-sets.sh -v $(basename --suffix=.jpg *.jpg)

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
${SCRIPT_NAME} 2013-02-04
Copyright (C) 2013 Steve Ward
EOT
}


function print_usage
{
	cat <<EOT
Usage: ${SCRIPT_NAME} [-V] [-h] [-v] [-d DISTORTION] IMAGE_SET ...
Create an image set with images from IMAGE_SET having distortion DISTORTION and matching particular metrics.
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


declare -r SETS_DIRECTORY="../sets"
print_verbose "SETS_DIRECTORY=${SETS_DIRECTORY}"


#-------------------------------------------------------------------------------


if (($# < 1))
then
	print_error "Must give at least 1 image set."
fi


#-------------------------------------------------------------------------------


for IMAGE_SET in "$@"
do
	print_verbose ""

	print_verbose "IMAGE_SET=${IMAGE_SET}"


	if [[ ! -d "${IMAGE_SET}" ]]
	then
		print_error "IMAGE_SET (${IMAGE_SET}) does not exist."
	fi


	DESTINATION="${SETS_DIRECTORY}/${IMAGE_SET}"
	print_verbose "DESTINATION=${DESTINATION}"


	#---------------------------------------------------------------------------


	##### move this to outside the loop

	# Create the sets directory, if it doesn't exist.
	if [[ ! -d "${SETS_DIRECTORY}" ]]
	then
		mkdir ${VERBOSE_STRING} -- "${SETS_DIRECTORY}" || exit
	fi


	# Copy the index.html to the sets directory, if it doesn't exist.
	if [[ ! -f "${SETS_DIRECTORY}/index.html" ]]
	then
		cp ${VERBOSE_STRING} --preserve -- ../../index.html.template "${SETS_DIRECTORY}/index.html" || exit
	fi


	##### if the DESTINATION already exists, mv it to make a backup


	# Create the destination directory, if it doesn't exist.
	if [[ ! -d "${DESTINATION}" ]]
	then
		mkdir ${VERBOSE_STRING} -- "${DESTINATION}" || exit
	fi


	# Copy the index.html to the destination directory, if it doesn't exist.
	if [[ ! -f "${DESTINATION}/index.html" ]]
	then
		cp ${VERBOSE_STRING} --preserve -- ../../index.html.template "${DESTINATION}/index.html" || exit
	fi


	#---------------------------------------------------------------------------


	DISTORTED_IMAGES=$(php filter-ssim-values.php "${IMAGE_SET}/metrics_${DISTORTION}.csv")
	print_verbose "DISTORTED_IMAGES=${DISTORTED_IMAGES}"


	# Eval is used to do the brace expansion after the variable expansion.
	IMAGES=($(eval echo "${IMAGE_SET}/{anti-reference.png,reference.png,${DISTORTED_IMAGES}}"))
	print_verbose "IMAGES=${IMAGES[*]}"
	print_verbose "#IMAGES=${#IMAGES[@]}"


	# Copy the images.
	cp ${VERBOSE_STRING} --preserve --update -- "${IMAGES[@]}" "${DESTINATION}" || exit


	#---------------------------------------------------------------------------

done
