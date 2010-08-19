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
# time ./segregate_distortion_metrics.sh -v $(find -type f -name metrics.csv)
#
# (takes about 1 sec. for all metrics files)


renice 19 --pid $$ > /dev/null


declare -r SCRIPT_NAME="$(basename -- "${0}")"


#-------------------------------------------------------------------------------


function usage
{
	printf "Usage: ${SCRIPT_NAME} [-V] [-h] METRICS_CSV_FILE ...\n"
	printf "Segregate the distortions in the METRICS_CSV_FILE(s) to their own files.\n"
	printf "  -V : Print the version information and exit.\n"
	printf "  -h : Print this message and exit.\n"
	printf "  -v : Print extra output. (default OFF)\n"
	printf "  METRICS_CSV_FILE : A CSV file with the metrics of distorted images.\n"
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


declare -r -a DISTORTIONS=(
	'jpeg'
	'scale'
	'blur'
	'gaussian-blur'
	'sharpen'
	'unsharp'
	'median'
	'noise'
)

((VERBOSE)) && printf "DISTORTIONS: ${DISTORTIONS[*]}\n"


#-------------------------------------------------------------------------------


for METRICS_CSV_FILE in "$@"
do
	((VERBOSE)) && printf '\n'

	#---------------------------------------------------------------------------

	if [[ ! -f "${METRICS_CSV_FILE}" ]]
	then
		printf "Error: File '${METRICS_CSV_FILE}' does not exist.\n"
		exit 1
	fi

	((VERBOSE)) && printf "METRICS_CSV_FILE: ${METRICS_CSV_FILE}\n"

	#---------------------------------------------------------------------------

	IMAGE_SET="$(dirname -- "${METRICS_CSV_FILE}")" || exit 1
	((VERBOSE)) && printf "IMAGE_SET: ${IMAGE_SET}\n"

	#---------------------------------------------------------------------------

	for DISTORTION in "${DISTORTIONS[@]}"
	do
		# do not print DISTORTION (it is already in the SEGREGATED_METRICS_CSV_FILE)

		SEGREGATED_METRICS_CSV_FILE="${IMAGE_SET}/metrics_${DISTORTION}.csv"
		((VERBOSE)) && printf "SEGREGATED_METRICS_CSV_FILE: ${SEGREGATED_METRICS_CSV_FILE}\n"

		head --lines=1 -- "${METRICS_CSV_FILE}" > "${SEGREGATED_METRICS_CSV_FILE}" || exit 1

		grep -- "^distorted_${DISTORTION}" "${METRICS_CSV_FILE}" >> "${SEGREGATED_METRICS_CSV_FILE}" || exit 1

	done

	#---------------------------------------------------------------------------

done
