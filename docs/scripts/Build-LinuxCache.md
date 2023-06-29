# Build-Linux.ps1

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

Write-Host "Generating Linux cache..." -ForegroundColor Blue

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -ItemType Directory -Force

$Config.target = $Config.target -replace '\\', '/'

. wsl -u root --exec ./cache-packages.bash -c "$($Config | ConvertTo-Json)"

Write-Host "Linux cache successfully generated!" -ForegroundColor Green
```

## cache-packages.bash

```bash
#!/bin/bash

dotnet_url="https://dotnetcli.azureedge.net/dotnet/Sdk"

create_dir() {
    if [ ! -d $1 ]
    then
        mkdir -p $1
    fi
}

cache_apt() {
    local packages=$1
    local t=$2

    apt clean
    apt remove -y ${packages}
    apt autoremove -y
    apt install -y -d ${packages}
    cp /var/cache/apt/archives/*.deb "$t"
    apt clean

    echo "sudo dpkg -i ./*.deb" > "$t/install.bash"
}

get_dotnet_version() {
    local c=$1
    c=${c:-"STS"}

    echo "$(curl "$dotnet_url/$c/latest.version" \
        --retry 20 \
        --retry-delay 2 \
        --connect-timeout 15 \
        -sSL -f
    )"
}

download_dotnet() {
    local v=$1
    local a=$2
    local o=$3
    local t=$4

    file="dotnet-sdk-$v-$o-$a.tar.gz"
    uri="$dotnet_url/$v/$file"

    curl "$uri" -o "$t/$file" \
        --retry 20 \
        --retry-delay 2 \
        --connect-timeout 15 \
        --create-dirs \
        -sSL -f

    echo "$file"
}

extract_dotnet() {
    create_dir "$2"
    tar -xvf "$1" -C "$2"
}

cache_dotnet() {
    local a=$1
    local c=$2
    local o=$3
    local e=$4
    local t=$5

    echo "Getting latest dotnet-sdk version for $c"
    local version=$(get_dotnet_version "$c")

    echo "Retrieving dotnet-sdk-$version-$o-$a.tar.gz"
    file=$(download_dotnet "$version" "$a" "$o" "$t")

    if [ "$e" = true ] ; then
        echo "Extracting $file to $t/.dotnet/"
        extract_dotnet "$t/$file" "$t/.dotnet/"
    fi
}

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
        exit 0
        ;;
 esac
done

if [ -z "$config" ]
then
    echo "config was not provided"
    exit 1;
fi

if ! [ -x "$(command -v jq)" ]; then
    apt install -y jq
fi

target=$(echo $config | jq '.target' -r)
dotnet=$(echo $config | jq '.data.dotnet' -r)

if [ -n "$dotnet" ]; then
    arch=$(echo $dotnet | jq '.arch' -r)
    channel=$(echo $dotnet | jq '.channel' -r)
    os=$(echo $dotnet | jq '.os' -r)
    extract=$(echo $dotnet | jq '.extract' -r)
    dotnet_target="$target/dotnet"

    create_dir "$dotnet_target"
    cache_dotnet "$arch" "$channel" "$os" "$extract" "$dotnet_target"
fi

apt=$(echo $config | jq '.data.apt[]' -r | tr '\n' ' ')
apt_target="$target/apt-cache"
create_dir "$apt_target"
cache_apt "$apt" "$apt_target"
```

## Config Schema

```jsonc
"linux": {
    // cache directory for Linux resources
    "target": "linux",
    // script metadata options
    "data": {
        // apt packages to cache
        "apt": [
            "apt-offline",
            "git",
            "jq"
        ],
        // OPTIONAL: .NET SDK metadata
        // options correspond with .NET install script options
        // see https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options
        "dotnet": {
            // see --architecture
            "arch": "x64",
            // see --channel
            "channel": "STS",
            // see --os
            "os": "linux",
            // extract the retrieved .tar.gz into a .dotnet directory
            "extract": false
        }
    }
}
```