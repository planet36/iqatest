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
# time ./calculate_image_metrics.sh ./albert_einstein/{reference.png,distorted*}   | sort --version-sort > ./albert_einstein/metrics.csv
# time ./calculate_image_metrics.sh ./arnisee_region/{reference.png,distorted*}    | sort --version-sort > ./arnisee_region/metrics.csv
# time ./calculate_image_metrics.sh ./bald_eagle/{reference.png,distorted*}        | sort --version-sort > ./bald_eagle/metrics.csv
# time ./calculate_image_metrics.sh ./desiccated_sewage/{reference.png,distorted*} | sort --version-sort > ./desiccated_sewage/metrics.csv
# time ./calculate_image_metrics.sh ./gizah_pyramids/{reference.png,distorted*}    | sort --version-sort > ./gizah_pyramids/metrics.csv
# time ./calculate_image_metrics.sh ./red_apple/{reference.png,distorted*}         | sort --version-sort > ./red_apple/metrics.csv
# time ./calculate_image_metrics.sh ./sonderho_windmill/{reference.png,distorted*} | sort --version-sort > ./sonderho_windmill/metrics.csv
#
# (takes about 5 min. per image set)


renice 19 --pid $$ > /dev/null


declare -r SCRIPT_NAME="$(basename -- "${0}")"


#-------------------------------------------------------------------------------


function usage
{
	printf "Usage: ${SCRIPT_NAME} [-V] [-h] REFERENCE_IMAGE DISTORTED_IMAGE ...\n"
	printf "Calculate the image metrics of comparing the REFERENCE_IMAGE to the DISTORTED_IMAGE(s).\n"
	printf "  -V : Print the version information and exit.\n"
	printf "  -h : Print this message and exit.\n"
	printf "  REFERENCE_IMAGE : The reference image.\n"
	printf "  DISTORTED_IMAGE : The distorted image.\n"
}


#-------------------------------------------------------------------------------


while getopts "Vh" option
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

		*)
			usage
			exit 1
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


#-------------------------------------------------------------------------------


if (($# < 2))
then
	printf 'Error: Must give at least 2 files.\n'
	usage
	exit 1
fi


#-------------------------------------------------------------------------------


declare -r REFERENCE_IMAGE="${1}"


if [[ ! -f "${REFERENCE_IMAGE}" ]]
then
	printf "Error: File '${REFERENCE_IMAGE}' does not exist.\n"
	usage
	exit 1
fi


# remove the reference image from the parameters
shift || exit 1


#-------------------------------------------------------------------------------


function calculate_ssim
{
	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
img_1 = imread('${1}');
img_2 = imread('${2}');
[mssim, ssim_map] = ssim_index_sdw(img_1, img_2);
printf('%f', mssim);
EOT
}


#-------------------------------------------------------------------------------


# distorted image
printf 'distorted image'

# MSSIM
printf ','
printf 'SSIM'

# other metrics
for METRIC in $(compare -list metric)
do
	printf ','
	printf "${METRIC}"
done
printf '\n'


#-------------------------------------------------------------------------------


for DISTORTED_IMAGE in "$@"
do

	if [[ ! -f "${DISTORTED_IMAGE}" ]]
	then
		printf "Error: ${DISTORTED_IMAGE} does not exist.\n"
		exit 1
	fi

	# distorted image
	# 'tr' is necessary because 'basename' prints a newline
	basename "${DISTORTED_IMAGE}" | tr --delete '\n' || exit 1

	#---------------------------------------------------------------------------

	# MSSIM
	printf ','
	calculate_ssim "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}"

	# other metrics
	for METRIC in $(compare -list metric)
	do
		printf ','
		# 'tr' is necessary because 'compare' prints a newline
		compare -metric "${METRIC}" "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" null: 2>&1 | cut --delimiter=' ' --fields=1 | tr --delete '\n' || exit 1
	done

	#---------------------------------------------------------------------------

	printf '\n'

done
