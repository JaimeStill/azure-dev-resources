#!/bin/bash

while getopts ':c:h' opt; do
    case "$opt" in
        c)
            config="$OPTARG"
            ;;
        :)
            echo -e "Option requires an argument\nUsage: $(basename $0) [-c config]"
            exit 1
            ;;
        ?|h)
            echo "Usage: $(basename $0) [-c config]"
    esac
done

echo "$config"

target=$(echo $config | jq '.target' -r)
apt=$(echo $config | jq '.data.apt[]' -r)

echo "$target"
echo "${apt}"