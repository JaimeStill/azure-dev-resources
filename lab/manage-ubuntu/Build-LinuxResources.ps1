param(
    [string]
    [Parameter()]
    $Target = "./packages"
)

. wsl -e ./cache-packages.bash -t $Target