
# Here are the steps to set up the image sets.


# Convert the source images to grayscale and resize them to become the reference images.

# takes about 10 sec. for all images
time ./convert-colorspace-resize.sh -v *.jpg
# or
time ./convert-colorspace-resize.sh -v \
albert_einstein.jpg   \
arnisee_region.jpg    \
bald_eagle.jpg        \
desiccated_sewage.jpg \
gizah_pyramids.jpg    \
red_apple.jpg         \
sonderho_windmill.jpg


# Optimize the reference images.

# takes about 2 sec. for all images
time optipng -o 2 -fix -preserve -i 0 \
./albert_einstein/{anti-,}reference.png   \
./arnisee_region/{anti-,}reference.png    \
./bald_eagle/{anti-,}reference.png        \
./desiccated_sewage/{anti-,}reference.png \
./gizah_pyramids/{anti-,}reference.png    \
./red_apple/{anti-,}reference.png         \
./sonderho_windmill/{anti-,}reference.png


# Create various distortions of the reference images.

# takes about 10 min. for all sets
time ./create-image-distortions.sh -v $(find -type f -name 'reference.png' | sort)
# or
time ./create-image-distortions.sh -v \
./albert_einstein/reference.png   \
./arnisee_region/reference.png    \
./bald_eagle/reference.png        \
./desiccated_sewage/reference.png \
./gizah_pyramids/reference.png    \
./red_apple/reference.png         \
./sonderho_windmill/reference.png


# Optimize the distorted images.

# takes about 10 min. for all sets
time optipng -o 2 -fix -preserve -i 0 \
./albert_einstein/distorted_*.png   \
./arnisee_region/distorted_*.png    \
./bald_eagle/distorted_*.png        \
./desiccated_sewage/distorted_*.png \
./gizah_pyramids/distorted_*.png    \
./red_apple/distorted_*.png         \
./sonderho_windmill/distorted_*.png

# takes about XXX min. for all sets
time jpegoptim --threshold=1 --preserve --strip-none \
./albert_einstein/distorted_*.jpg   \
./arnisee_region/distorted_*.jpg    \
./bald_eagle/distorted_*.jpg        \
./desiccated_sewage/distorted_*.jpg \
./gizah_pyramids/distorted_*.jpg    \
./red_apple/distorted_*.jpg         \
./sonderho_windmill/distorted_*.jpg


# Calculate the image metrics.

# takes about 45 min. for all sets
time {
time ./calculate-image-metrics.sh ./albert_einstein/{reference.png,distorted*}   | tee >(sort --version-sort > ./albert_einstein/metrics.csv  )
time ./calculate-image-metrics.sh ./arnisee_region/{reference.png,distorted*}    | tee >(sort --version-sort > ./arnisee_region/metrics.csv   )
time ./calculate-image-metrics.sh ./bald_eagle/{reference.png,distorted*}        | tee >(sort --version-sort > ./bald_eagle/metrics.csv       )
time ./calculate-image-metrics.sh ./desiccated_sewage/{reference.png,distorted*} | tee >(sort --version-sort > ./desiccated_sewage/metrics.csv)
time ./calculate-image-metrics.sh ./gizah_pyramids/{reference.png,distorted*}    | tee >(sort --version-sort > ./gizah_pyramids/metrics.csv   )
time ./calculate-image-metrics.sh ./red_apple/{reference.png,distorted*}         | tee >(sort --version-sort > ./red_apple/metrics.csv        )
time ./calculate-image-metrics.sh ./sonderho_windmill/{reference.png,distorted*} | tee >(sort --version-sort > ./sonderho_windmill/metrics.csv)
}


# Segregate the distortion metrics.

# takes about 5 sec. for all metrics files
time ./segregate-distortion-metrics.sh -v $(find -type f -name metrics.csv | sort)
# or
time ./segregate-distortion-metrics.sh -v \
./albert_einstein/metrics.csv   \
./arnisee_region/metrics.csv    \
./bald_eagle/metrics.csv        \
./desiccated_sewage/metrics.csv \
./gizah_pyramids/metrics.csv    \
./red_apple/metrics.csv         \
./sonderho_windmill/metrics.csv


# Create the practice image set.

# takes less than 1 sec.
time ./create-practice-set.sh -v gizah_pyramids


# Create the image sets.

# takes less than 2 sec.
time ./create-sets.sh -v $(basename --suffix=.jpg *.jpg | grep --invert-match gizah_pyramids)
# or
time ./create-sets.sh -v \
albert_einstein   \
arnisee_region    \
bald_eagle        \
desiccated_sewage \
red_apple         \
sonderho_windmill
