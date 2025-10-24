#!/bin/bash
# Convert all JPGs in this directory into 120px thumbnails in parallel

parallel -j $(nproc) convert -geometry 120 {} thumb_{} ::: *.jpg

