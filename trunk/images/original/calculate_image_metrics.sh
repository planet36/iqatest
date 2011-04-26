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
# time ./calculate_image_metrics.sh ./albert_einstein/{reference.png,distorted*}   | tee >(sort --version-sort > ./albert_einstein/metrics.csv  )
# time ./calculate_image_metrics.sh ./arnisee_region/{reference.png,distorted*}    | tee >(sort --version-sort > ./arnisee_region/metrics.csv   )
# time ./calculate_image_metrics.sh ./bald_eagle/{reference.png,distorted*}        | tee >(sort --version-sort > ./bald_eagle/metrics.csv       )
# time ./calculate_image_metrics.sh ./desiccated_sewage/{reference.png,distorted*} | tee >(sort --version-sort > ./desiccated_sewage/metrics.csv)
# time ./calculate_image_metrics.sh ./gizah_pyramids/{reference.png,distorted*}    | tee >(sort --version-sort > ./gizah_pyramids/metrics.csv   )
# time ./calculate_image_metrics.sh ./red_apple/{reference.png,distorted*}         | tee >(sort --version-sort > ./red_apple/metrics.csv        )
# time ./calculate_image_metrics.sh ./sonderho_windmill/{reference.png,distorted*} | tee >(sort --version-sort > ./sonderho_windmill/metrics.csv)
#
# (takes about 22.6 min. per image set)


renice 19 --pid $$ > /dev/null


SCRIPT_NAME="$(basename -- "${0}")" || exit 1


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
Usage: ${SCRIPT_NAME} [-V] [-h] REFERENCE_IMAGE DISTORTED_IMAGE ...
Calculate the image metrics of comparing the REFERENCE_IMAGE to the DISTORTED_IMAGE(s).
  -V : Print the version information and exit.
  -h : Print this message and exit.
  REFERENCE_IMAGE : The reference image.
  DISTORTED_IMAGE : The distorted image.
EOT
}


function print_error
{
	printf "Error: ${1}\n" > /dev/stderr
	print_usage
	exit 1
}


#-------------------------------------------------------------------------------


while getopts "Vh" option
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

		*)
			# Note: ${option} is '?'
			print_error "Option is unknown."
		;;

	esac
done


shift $((OPTIND - 1)) || exit 1


#-------------------------------------------------------------------------------


if (($# < 2))
then
	print_error "Must give at least 2 files."
fi


#-------------------------------------------------------------------------------


declare -r REFERENCE_IMAGE="${1}"


if [[ ! -f "${REFERENCE_IMAGE}" ]]
then
	print_error "File '${REFERENCE_IMAGE}' does not exist."
fi


# remove the reference image from the parameters
shift || exit 1


#-------------------------------------------------------------------------------


function calculate_ssim
{
	local local_REFERENCE_IMAGE="${1}"
	local local_DISTORTED_IMAGE="${2}"

	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing || exit 1
img_1 = imread('${local_REFERENCE_IMAGE}');
img_2 = imread('${local_DISTORTED_IMAGE}');
[mssim, ssim_map] = ssim_index_sdw(img_1, img_2);
printf('%f', mssim);
EOT
}


#-------------------------------------------------------------------------------


declare -r -a METRIC_LIST=($(compare -list metric))


#-------------------------------------------------------------------------------


# distorted image
printf 'distorted image'

# MSSIM
printf ','
printf 'SSIM'

# other metrics
for METRIC in "${METRIC_LIST[@]}"
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
		print_error "Distorted image '${DISTORTED_IMAGE}' does not exist."
	fi

	# distorted image
	# 'tr' is necessary because 'basename' prints a newline
	basename "${DISTORTED_IMAGE}" | tr --delete '\n' || exit 1

	#---------------------------------------------------------------------------

	# MSSIM
	printf ','
	calculate_ssim "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}"

	# other metrics
	for METRIC in "${METRIC_LIST[@]}"
	do
		printf ','
		# 'tr' is necessary because 'compare' prints a newline
		compare -metric "${METRIC}" "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" null: 2>&1 | cut --delimiter=' ' --fields=1 | tr --delete '\n' || exit 1
	done

	#---------------------------------------------------------------------------

	printf '\n'

done
