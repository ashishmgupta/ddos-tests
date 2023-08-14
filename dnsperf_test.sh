#!/bin/bash

while getopts "d:s:Q:l:" opt; do
    case $opt in
        d) dns_query_file="$OPTARG";;
        s) nameserver="$OPTARG";;
        Q) queries_per_second="$OPTARG";;
        l) time_limit_in_seconds="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2
            exit 1;;
        :) echo "Option -$OPTARG requires an argument." >&2
            exit 1;;
    esac
done

if [[ -z "$dns_query_file" || -z "$nameserver" || -z "$queries_per_second" || -z "$time_limit_in_seconds" ]]; then
        echo "Usage: $0 -d dns_query_file -s nameserver -Q queries_per_second -l time_limit_in_seconds"
	echo "-d DNS Query File path"
	echo "-s Nameserver"
	echo "-Q Queries per Second"
	echo "-l For how long the queries send operation would last [in Seconds]"
    exit 1
fi

echo "DNS Query File: $dns_query_file"
line_count=$(wc -l < "$dns_query_file")
echo "Lines in DNS Query File: $line_count"
echo "Showing first 10 lines as sample from the file:"
head "$dns_query_file"
echo "Nameserver: $nameserver"
echo "Queries per Second: $queries_per_second"
echo "For how long the queries send operation would last [in Seconds]: $time_limit_in_seconds"

read -p "Confirm the values (y/n) and run the script? " confirm

if [[ "$confirm" == "y" ]]; then
    timestamp=$(date +"%Y%m%d%H%M%S")
    output_file="${timestamp}_${nameserver}_test_legit_queries.txt"
    echo "Running dnsperf..."
    
    dnsperf -d "$dns_query_file" -s "$nameserver" -Q "$queries_per_second" -l "$time_limit_in_seconds" > "$output_file"
    
    echo "Output saved to: $output_file"
    cat "$output_file"
else
    echo "Operation canceled."
fi
