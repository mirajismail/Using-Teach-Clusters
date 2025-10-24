#!/bin/bash

BASE_URL="https://www.example.com/path/to"
OUTPUT_DIR="images"
mkdir -p "$OUTPUT_DIR"

# Generate list of URLs for the past 30 days
URLS=$(for i in $(seq 0 29); do
    date=$(date -d "-$i day" +"%Y%m%d")
    for n in $(seq -w 1 24); do
        echo "$BASE_URL/${date}${n}.jpg"
    done
done)

# Download in parallel using wget
echo "$URLS" | parallel -j "$(nproc)" wget -q -P "$OUTPUT_DIR" {}

