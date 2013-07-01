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
:<<'EOT'
time {
time ./calculate-image-metrics.sh ./albert_einstein/{reference.png,distorted*}   | tee >(sort --version-sort > ./albert_einstein/metrics.csv  )
time ./calculate-image-metrics.sh ./arnisee_region/{reference.png,distorted*}    | tee >(sort --version-sort > ./arnisee_region/metrics.csv   )
time ./calculate-image-metrics.sh ./bald_eagle/{reference.png,distorted*}        | tee >(sort --version-sort > ./bald_eagle/metrics.csv       )
time ./calculate-image-metrics.sh ./desiccated_sewage/{reference.png,distorted*} | tee >(sort --version-sort > ./desiccated_sewage/metrics.csv)
time ./calculate-image-metrics.sh ./gizah_pyramids/{reference.png,distorted*}    | tee >(sort --version-sort > ./gizah_pyramids/metrics.csv   )
time ./calculate-image-metrics.sh ./red_apple/{reference.png,distorted*}         | tee >(sort --version-sort > ./red_apple/metrics.csv        )
time ./calculate-image-metrics.sh ./sonderho_windmill/{reference.png,distorted*} | tee >(sort --version-sort > ./sonderho_windmill/metrics.csv)
}
EOT

renice 19 --pid $$ > /dev/null


SCRIPT_NAME=$(basename -- "${0}") || exit


#-------------------------------------------------------------------------------


function print_version
{
	cat <<EOT
${SCRIPT_NAME} 2013-03-01
Copyright (C) 2013 Steve Ward
EOT
}


function print_usage
{
	cat <<EOT
Usage: ${SCRIPT_NAME} [-V] [-h] REFERENCE_IMAGE DISTORTED_IMAGE ...
Calculate the image metrics of comparing the REFERENCE_IMAGE to the DISTORTED_IMAGE(s).
The SSIM metric depends on octave.
  -V : Print the version information and exit.
  -h : Print this message and exit.
  REFERENCE_IMAGE : The reference image.
  DISTORTED_IMAGE : The distorted image.
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


shift $((OPTIND - 1)) || exit


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


# Remove the reference image from the parameters.
shift || exit


#-------------------------------------------------------------------------------


function calculate_ssim
{
	local local_REFERENCE_IMAGE="${1}"
	local local_DISTORTED_IMAGE="${2}"

	# '--no-site-file' causes error: 'isgray' undefined
	# '--no-init-path' causes error: 'pkg' undefined

	cat <<EOT | octave --quiet --no-init-file --no-history --no-line-editing
img_1 = imread('${local_REFERENCE_IMAGE}');
img_2 = imread('${local_DISTORTED_IMAGE}');
[mssim, ssim_map] = ssim_index_sdw(img_1, img_2);
printf('%f', mssim);
EOT
}


#-------------------------------------------------------------------------------


# http://www.imagemagick.org/script/command-line-options.php#list
# http://www.imagemagick.org/script/command-line-options.php#metric
#declare -r -a METRIC_LIST=($(compare -list metric))
# GraphicsMagick has no way to print a list of metrics.
declare -r -a METRIC_LIST=(MAE MSE PAE PSNR RMSE)


#-------------------------------------------------------------------------------


# distorted image
printf 'distorted image'

# MSSIM
printf ',SSIM'

# other metrics
for METRIC in "${METRIC_LIST[@]}"
do
	printf ',%s' "${METRIC}"
done
printf '\n'


#-------------------------------------------------------------------------------


for DISTORTED_IMAGE in "$@"
do
	declare -a FIELDS

	if [[ ! -f "${DISTORTED_IMAGE}" ]]
	then
		print_error "Distorted image '${DISTORTED_IMAGE}' does not exist."
	fi

	# Append distorted image basename.
	FIELDS[${#FIELDS[@]}]=$(basename -- "${DISTORTED_IMAGE}") || exit

	#---------------------------------------------------------------------------

	# MSSIM
	FIELDS[${#FIELDS[@]}]=$(calculate_ssim "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}")

	# other metrics
	for METRIC in "${METRIC_LIST[@]}"
	do
		# http://www.imagemagick.org/script/command-line-options.php#metric
		FIELDS[${#FIELDS[@]}]=$(compare -metric "${METRIC}" "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" null: 2>&1 | awk '{if(NF > 1){gsub(/[()]/,"",$2);print $2}else{print}}') || exit
		# http://www.graphicsmagick.org/compare.html
		#FIELDS[${#FIELDS[@]}]=$(gm compare -metric "${METRIC}" "${REFERENCE_IMAGE}" "${DISTORTED_IMAGE}" | awk '/Total: /{printf "%s", $2}') || exit
	done

	#---------------------------------------------------------------------------

	# Print the fields (joined by commas).
	(IFS=','; echo "${FIELDS[*]}")

	unset FIELDS
done
