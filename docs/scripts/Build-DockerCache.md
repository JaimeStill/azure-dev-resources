# Build-DockerCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Target = "..\docker",
    [string]
    [Parameter()]
    $Source = "data\docker.json",
    [switch]
    [Parameter()]
    $ClearImage
)

function Get-DockerImage([psobject] $image, [string] $dir) {
    Write-Output "Pulling $($image.repository)`:$($image.tag)"

    & docker pull "$($image.repository)`:$($image.tag)"

    $output = Join-path $dir "$($image.name)-$($image.tag).tar"
    
    Write-Output "Saving $($image.repository)`:$($image.tag) to $dir as $output"

    & docker save "$($image.repository)`:$($image.tag)" -o $output

    if ($ClearImage) {
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
```

## docker.json

```json
[
    {
        "repository": "node",
        "name": "node",
        "tag": "latest"
    },
    {
        "repository": "mcr.microsoft.com/dotnet/sdk",
        "name": "mcr.microsoft.com-dotnet-sdk",
        "tag": "latest"
    },
    {
        "repository": "mcr.microsoft.com/dotnet/aspnet",
        "name": "mcr.microsoft.com-dotnet-aspnet",
        "tag": "latest"
    }
]
```