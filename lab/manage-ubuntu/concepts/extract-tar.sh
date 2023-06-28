target="./.dotnet"
source="./resources/dotnet-sdk-7.0.305-linux-x64.tar.gz"

if [ ! -d "$target" ]
then
    mkdir "$target"
fi

tar -xvf "$source" -C "$target"