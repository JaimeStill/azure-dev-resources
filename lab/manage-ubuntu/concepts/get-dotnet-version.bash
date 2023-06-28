feed="https://dotnetcli.azureedge.net/dotnet/Sdk/"

get_version() {
    local channel=$1
    channel=${channel:-"STS"}

    echo "$(curl "$feed$channel/latest.version" -s)"    
}

while getopts ':c:h' opt; do
    case "$opt" in
        c)
            channel="$OPTARG"
            ;;
        :)
            echo -e "Option requires an argument\nUsage: $(basename $0) [-c channel]"
            exit 1
            ;;
        ?|h)
            echo "Usage: $(basename $0) [-c channel]"
            exit 0
            ;;
    esac
done

channel=${channel:-"STS"}

version=$(get_version "$channel")

echo "$version"