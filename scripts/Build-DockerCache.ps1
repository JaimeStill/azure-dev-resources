param(
    [string]
    [Parameter()]
    $Target = "..\docker",
    [string]
    [Parameter()]
    $Source = "data\docker.json"
)

function Get-DockerImage([psobject] $image, [string] $dir) {
    Write-Output "Pulling $($image.repository)`:$($image.tag)"

    & docker pull "$($image.repository)`:$($image.tag)"

    $output = Join-path $dir "$($image.name)-$($image.tag).tar"
    
    Write-Output "Saving $($image.repository)`:$($image.tag) to $dir as $output"

    & docker save "$($image.repository)`:$($image.tag)" -o $output

    if ($($image.clear)) {
        Write-Output "Clearing image $($image.repository)`:$($image.tag)"
        & docker rmi "$($image.repository)`:$($image.tag)"
    }
}

if (-not (Test-Path $Target)) {
    New-Item -Path $Target -ItemType Directory -Force
}

$data = Get-Content -Raw -Path $Source | ConvertFrom-Json

$data | ForEach-Object {
    Get-DockerImage $_ $Target
}