
# Here are the steps to set up the image sets.

# takes about 10 sec. for all images
time ./convert-colorspace-resize.sh -v *.jpg

# takes about 1 min. per image set
time ./create-image-distortions.sh -v $(find -type f -name 'reference.png' | sort)

# takes about 8.5 min. per image set
time {
time ./calculate-image-metrics.sh ./albert_einstein/{reference.png,distorted*}   | tee >(sort --version-sort > ./albert_einstein/metrics.csv  )
time ./calculate-image-metrics.sh ./arnisee_region/{reference.png,distorted*}    | tee >(sort --version-sort > ./arnisee_region/metrics.csv   )
time ./calculate-image-metrics.sh ./bald_eagle/{reference.png,distorted*}        | tee >(sort --version-sort > ./bald_eagle/metrics.csv       )
time ./calculate-image-metrics.sh ./desiccated_sewage/{reference.png,distorted*} | tee >(sort --version-sort > ./desiccated_sewage/metrics.csv)
time ./calculate-image-metrics.sh ./gizah_pyramids/{reference.png,distorted*}    | tee >(sort --version-sort > ./gizah_pyramids/metrics.csv   )
time ./calculate-image-metrics.sh ./red_apple/{reference.png,distorted*}         | tee >(sort --version-sort > ./red_apple/metrics.csv        )
time ./calculate-image-metrics.sh ./sonderho_windmill/{reference.png,distorted*} | tee >(sort --version-sort > ./sonderho_windmill/metrics.csv)
}

# takes less than 1 sec. per metrics file
time ./segregate-distortion-metrics.sh -v $(find -type f -name metrics.csv | sort)

# takes less than 1 sec.
time ./create-practice-set.sh -v gizah_pyramids

# takes about 1 sec.
time ./create-sets.sh -v $(basename --suffix=.jpg *.jpg)
