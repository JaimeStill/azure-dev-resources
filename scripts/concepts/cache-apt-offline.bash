#!/bin/bash

create_dir() {
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}

cache_apt_offline() {
    local t=$1

    apt clean
    apt install -y -d apt-offline
    cp /var/cache/apt/archives/*.deb "$t"
    apt clean
}

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

target=${target:-"./apt-offline/"}

create_dir "$target"
cache_apt_offline "$target"