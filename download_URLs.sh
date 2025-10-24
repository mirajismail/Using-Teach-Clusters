#!/bin/bash

export check_url
check_url() {
    local i="$1"
    local url="$2"
    wget -q --spider "$url" || echo "$i $url"
}
export -f check_url

# Run in parallel, one job per URL line
cat -n URLsFile.txt | parallel -j "$(nproc)" --colsep '\t' check_url {1} {2}

