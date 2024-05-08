#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <sql-file> <output-dir>"
    exit 1
fi

sql_file="$1"
output_dir="$2"

[[ ! -d "$output_dir" ]] && mkdir -p "$output_dir"

awk -v output_dir="$output_dir" '
BEGIN { query_num = 1 }
{
    if ($0 ~ /^[[:space:]]*$/) next
    query = $0
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", query)
    output_file = output_dir "/" query_num ".sql"
    print query > output_file
    close(output_file)
    query_num++
}
' "$sql_file"
