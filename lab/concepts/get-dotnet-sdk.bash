feed="https://dotnetcli.azureedge.net/dotnet/Sdk/"

get_version() {
    local c=$1
    c=${c:-"STS"}

    echo "$(curl "$feed$channel/latest.version" -s)"
}

create_dir() {
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}

download_sdk() {
    v=$1
    p=$2
    a=$3
    t=$4

    file="dotnet-sdk-$v-$p-$a.tar.gz"
    uri="$feed$v/$file"

    curl "$uri" -o "$t$file" -s

    echo "$file"
}

extract_sdk() {
    create_dir "$2"
    tar -xvf "$1" -C "$2"
}

while getopts ':p:a:c:t:eh' opt; do
    case "$opt" in
        p)
            platform="$OPTARG"
            ;;
        a)
            arch="$OPTARG"
            ;;
        c)
            channel="$OPTARG"
            ;;
        t)
            target="$OPTARG"
            ;;
        e)
            extract=true
            ;;
        :)
            echo -e "Option requires an argument
Usage: $(basename $0) [-p platform] [-a arch] [-c channel] [-t dir] [-e]
    -p: platform -   linux
    -a: arch     -   x64
    -c: channel  -   LTS, STS, X.X
    -t: target   -   ./dotnet/
    -e: extract
See: https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options"
            exit 1
            ;;
        ?|h)
            echo "Usage: $(basename $0) [-p platform] [-a arch] [-c channel] [-t dir] [-e]
    -p: platform -   linux
    -a: arch     -   x64
    -c: channel  -   LTS, STS, X.X
    -t: target   -   ./dotnet/
    -e: extract
See: https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options"
            exit 0
            ;;
    esac
done

platform=${platform:-"linux"}
arch=${arch:-"x64"}
channel=${channel:-"STS"}
target=${target:-"./dotnet/"}

echo "Getting latest dotnet-sdk version for $channel"
version=$(get_version "$channel")

echo "Ensuring $target exists"
create_dir "$target"

echo "Retrieving dotnet-sdk-$version-$platform-$arch.tar.gz"
file=$(download_sdk "$version" "$platform" "$arch" "$target")

if [ "$extract" = true ] ; then
    echo "Extracting $file to $target"
    extract_sdk "$target$file" "$target"
fi