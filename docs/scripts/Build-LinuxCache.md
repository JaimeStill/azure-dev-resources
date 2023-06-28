# Build-Linux.ps1

```powershell
param(
    [string]
    [Parameter()]
    $Target = "../linux",
    [string]
    [Parameter()]
    $Source = "./data/linux.json",
    [string]
    [Parameter()]
    $Platform = "linux",
    [string]
    [Parameter()]
    $Arch = "x64",
    [string]
    [Parameter()]
    $Channel = "STS",
    [string]
    [Parameter()]
    $DotnetTarget = "../linux/dotnet",
    [switch]
    [Parameter()]
    $Extract
)

Write-Host "Generating Linux cache..." -ForegroundColor Blue

$command = ". wsl --exec ./cache-packages.bash -t $Target -s $Source -p $Platform -a $Arch -c $Channel -d $DotnetTarget"

if ($Extract) {
    $command += " -e"
}

Invoke-Expression $command

Write-Host "Linux cache successfully generated!" -ForegroundColor Green
```

## cache-packages.bash

```bash
#!/bin/bash

dotnet_url="https://dotnetcli.azureedge.net/dotnet/Sdk"

create_dir() {
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}

cache_apt() {
    local s=$1
    local t=$2

    (
        packages=$(jq '.apt[]' $s -c -r | tr '\n' ' ')
        cd "$t/apt/" ;

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
    local p=$2
    local a=$3
    local t=$4

    file="dotnet-sdk-$v-$p-$a.tar.gz"
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
    local p=$1
    local a=$2
    local c=$3
    local e=$4
    local t=$5

    echo "Getting latest dotnet-sdk version for $c"
    local version=$(get_dotnet_version "$c")

    echo "Retrieving dotnet-sdk-$version-$p-$a.tar.gz"
    file=$(download_dotnet "$version" "$p" "$a" "$t")

    if [ "$e" = true ] ; then
        echo "Extracting $file to $t/.dotnet/"
        extract_dotnet "$t/$file" "$t/.dotnet/"
    fi
}

while getopts ':t:s:p:a:c:d:eh' opt; do
 case "$opt" in
    t)
        target="$OPTARG"
        ;;
    s)
        source="$OPTARG"
        ;;
    p)
        platform="$OPTARG"
        ;;
    a)
        arch="$OPTARG"
        ;;
    c)
        channel="$OPTARG"
        ;;
    d)
        dotnet_target="$OPTARG"
        ;;
    e)
        extract=true
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
source=${source:-"./data/linux.json"}
platform=${platform:-"linux"}
arch=${arch:-"x64"}
channel=${channel:-"STS"}
apt_target="$target/apt"
dotnet_target="$target/dotnet"

if [ ! -f $source ]
then
    echo "$source does not exist"
    exit 1;
fi

echo "Generating target directories..."
create_dir "$target"
create_dir "$dotnet_target"
create_dir "$apt_target"

echo "Caching apt packages..."
cache_apt "$source" "$target"

echo "Caching the .NET SDK..."
cache_dotnet "$platform" "$arch" "$channel" "$extract" "$dotnet_target"
```

## linux.json

```json
{
    "apt": [
        "apt-offline",
        "azure-cli",
        "git",
        "nodejs",
        "uuid-runtime"
    ]
}
```