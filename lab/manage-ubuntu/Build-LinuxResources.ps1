param(
    [string]
    [Parameter()]
    $Target = "./packages",
    [string]
    [Parameter()]
    $Source = "./packages.json"
)

. wsl -e ./cache-packages.bash -t $Target -s $Source