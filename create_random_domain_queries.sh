#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="dns_queries.txt"
grep -E '^[a-zA-Z0-9]+$' "$input_file" | sed -E 's/ //g' > "${output_file}_cleaned"

cut -c 1-20 "${output_file}_cleaned" > "${output_file}_truncated"

while IFS= read -r line; do
    echo "${line}.marvel.local A"
done < "${output_file}_truncated" > "$output_file"

rm "${output_file}_cleaned" "${output_file}_truncated"

echo "Transformation complete. Result saved in $output_file"
