#!/bin/bash

while getopts ':t:h' opt; do
 case "$opt" in
    t)
        target="$OPTARG"
        ;;
    :)
        echo -e "Option requires an argument\nUsage: $(basename $0) [-t dir]"
        exit 1
        ;;
    ?|h)
        echo "Usage: $(basename $0) [-t dir]"
        exit 0
        ;;
 esac
done

target=${target:-"./packages"}

echo "Caching snap packages..."
jq -c '.snap[]' packages.json -r | while read i; do
    echo "Caching $i at $target/$i"
done

echo "Caching apt packages..."
jq -c '.apt[]' packages.json -r | while read i; do
    echo "Caching $i at $target/$i"
done

# snap download --target-directory=./snap/dotnet/ dotnet-sdk