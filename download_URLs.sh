#!/bin/bash
#!/bin/bash

i=0
while read -r url; do
    ((i++))
    wget -q --spider "$url" || echo "$i $url"
done < URLsFile.txt | parallel -j $(nproc)

