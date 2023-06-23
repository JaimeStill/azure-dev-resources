#!/bin/bash

function createDir() {
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}

while getopts ':s:t:h' opt; do
 case "$opt" in
    s)
        source="$OPTARG"
        ;;
    t)
        target="$OPTARG"
        ;;
    :)
        echo -e "Option requires an argument\nUsage: $(basename $0) [-t dir] [-s <source>.json]"
        exit 1
        ;;
    ?|h)
        echo "Usage: $(basename $0) [-t dir] [-s <source>.json]"
        exit 0
        ;;
 esac
done

target=${target:-"./packages"}
source=${source:-"./packages.json"}

if [ ! -f $source ]
then
    echo "$source does not exist"
    exit 1;
fi

createDir "$target"
createDir "$target/snap/"
createDir "$target/apt/"

echo "Caching snap packages..."
jq -c '.snap[]' $source -r | while read i; do
    snap download --target-directory="$target/snap/$i/" $i
done

echo "Caching apt packages..."

(
    packages=$(jq '.apt[]' $source -c -r | tr '\n' ' ')
    cd "$target/apt/" ;

    apt-get download \
        $(apt-cache depends \
            --recurse \
            --no-recommends \
            --no-suggests \
            --no-conflicts \
            --no-breaks \
            --no-replaces \
            --no-enhances \
            --no-pre-depends \
            ${packages} \
            | grep "^\w"
        )
)