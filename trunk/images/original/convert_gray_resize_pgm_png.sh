#!/bin/bash

# Copyright (C) 2010 Steve Ward


# example:
# ./convert_gray_resize_pgm_png.sh $(find -type f -name '*.jpg' | sort)
# ./convert_gray_resize_pgm_png.sh *.jpg


renice 19 --pid $$


declare -r -i SIZE_X=384
declare -r -i SIZE_Y=384
#declare -r -i SIZE_PIXELS=$((SIZE_X*SIZE_Y))
#echo "SIZE_PIXELS: $SIZE_PIXELS"


if (($# == 0))
then
	echo "Error: must give at least 1 file."
	echo "Usage: $0 FILE1 [FILE2 ...]"
	exit 1
fi


for FILE in "$@"
do
	if [[ ! -f "${FILE}" ]]
	then
		echo "file does not exist: ${FILE}"
		exit 1
	fi

	OUTFILE_PREFIX="${FILE%.*}"

	#---------------------------------------------------------------------------

	# NOTE: a PGM image needs to be created because GNU Octave, version 3.0.5 thinks a gray-scale PNG file has 3 channels (which is not compatible with the SSIM algorithm)

	convert -verbose "${FILE}" -colorspace Gray -resize "${SIZE_X}x${SIZE_Y}" "${OUTFILE_PREFIX}.pgm" || exit
	#convert -verbose "${FILE}" -colorspace Gray -resize "${SIZE_PIXELS}@" "${OUTFILE_PREFIX}.pgm" || exit

	convert -verbose "${OUTFILE_PREFIX}.pgm" "${OUTFILE_PREFIX}.png" || exit

	#---------------------------------------------------------------------------

done