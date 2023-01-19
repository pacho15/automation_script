#!/bin/bash

# Check for the presence of required arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 -f <subdomain_file> -o <output_file>"
    exit 1
fi

# Parse arguments
while getopts ":f:o:" opt; do
    case $opt in
        f)
            file="$OPTARG"
            ;;
        o)
            output="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# Loop through subdomains
while read subdomain; do
    # Check for subdomain takeover using subzy
    subzy -d $subdomain >> $output
    # Check for subdomain takeover using subjack
    subjack -w $subdomain -t 100 -timeout 30 -ssl -c >> $output
    # Check for subdomain takeover using NtHiM
    nthim -d $subdomain >> $output
done < $file

echo "Scan results saved to $output"
