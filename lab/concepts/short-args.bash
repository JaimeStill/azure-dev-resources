#!/bin/bash

while getopts ':abc:h' opt; do
    case "$opt" in
        a)
            echo "Processing option 'a'"
            ;;
        b)
            echo "Processing option 'b'"
            ;;
        c)
            arg="$OPTARG"
            echo "Processing option 'c' with '${OPTARG}' argument"
            ;;
        h)
            echo "Usage: $(basename $0) [-a] [-b] [-c arg]"
            exit 0
            ;;
        :)
            echo -e "option requires an argument.\nUsage: $(basename $0) [-a] [-b] [-c arg]"
            exit 1
            ;;
        ?)
            echo -e "Invalid command option.\nUsage: $(basename $0) [-a] [-b] [-c arg]"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"