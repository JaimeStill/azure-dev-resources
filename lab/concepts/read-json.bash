jq -c '.snap[]' ./resources/packages.json -r | while read i; do
    name=$(echo $i | jq -c '.name' -r)
    package=$(echo $i | jq -c '.package' -r)

    echo "$name: downloading snap package $package"
done