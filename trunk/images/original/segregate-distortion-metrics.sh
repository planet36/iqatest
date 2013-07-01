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
# time ./segregate-distortion-metrics.sh -v $(find -type f -name metrics.csv)

renice 19 --pid $$ > /dev/null


SCRIPT_NAME=$(basename -- "${0}") || exit

VERBOSE=false

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
Usage: ${SCRIPT_NAME} [-V] [-h] METRICS_CSV_FILE ...
Segregate the distortions in the METRICS_CSV_FILE(s) to their own files.
  -V : Print the version information and exit.
  -h : Print this message and exit.
  -v : Print extra output. (default OFF)
  METRICS_CSV_FILE : A CSV file with the metrics of distorted images.
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


shift $((OPTIND - 1)) || exit


#-------------------------------------------------------------------------------


if (($# < 1))
then
	print_error "Must give at least 1 file."
fi


#-------------------------------------------------------------------------------


for METRICS_CSV_FILE in "$@"
do
	print_verbose ""

	print_verbose "METRICS_CSV_FILE=${METRICS_CSV_FILE}"

	#---------------------------------------------------------------------------

	if [[ ! -f "${METRICS_CSV_FILE}" ]]
	then
		print_error "Metrics CSV file '${METRICS_CSV_FILE}' does not exist."
	fi

	#---------------------------------------------------------------------------

	IMAGE_SET=$(dirname -- "${METRICS_CSV_FILE}") || exit
	print_verbose "IMAGE_SET=${IMAGE_SET}"

	#---------------------------------------------------------------------------

	for DISTORTION in "${DISTORTIONS[@]}"
	do
		print_verbose "DISTORTION=${DISTORTION}"

		SEGREGATED_METRICS_CSV_FILE="${IMAGE_SET}/metrics_${DISTORTION}.csv"
		print_verbose "SEGREGATED_METRICS_CSV_FILE=${SEGREGATED_METRICS_CSV_FILE}"

		# Get the header of the metrics file.
		head --lines=1 -- "${METRICS_CSV_FILE}" > "${SEGREGATED_METRICS_CSV_FILE}" || exit

		grep -- "^distorted_${DISTORTION}" "${METRICS_CSV_FILE}" >> "${SEGREGATED_METRICS_CSV_FILE}"
		if (($? > 1))
		then
			print_error "An error occurred with grep."
		fi

	done

	#---------------------------------------------------------------------------

done
