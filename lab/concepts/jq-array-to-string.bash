#!/bin/bash

packages=$(jq '.apt[]' ./resources/packages.json -c -r | tr '\n' ' ')
echo "$packages"