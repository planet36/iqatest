
# Here are the steps to set up the image sets.

# takes about 45 sec. for all images
time ./convert-colorspace-resize.sh -v *.jpg

# takes about 10 min. for all sets
time ./create-image-distortions.sh -v $(find -type f -name 'reference.png' | sort)

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

# takes about 5 sec. for all metrics files
time ./segregate-distortion-metrics.sh -v $(find -type f -name metrics.csv | sort)

# takes less than 1 sec.
time ./create-practice-set.sh -v gizah_pyramids

# takes less than 2 sec.
time ./create-sets.sh -v $(basename --suffix=.jpg *.jpg | grep --invert-match gizah_pyramids)
