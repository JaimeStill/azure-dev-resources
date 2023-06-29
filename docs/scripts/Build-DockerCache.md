# Build-DockerCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

function Get-DockerImage([psobject] $image, [string] $dir) {
    Write-Host "Pulling $($image.repository)`:$($image.tag)"

    & docker pull "$($image.repository)`:$($image.tag)"

    $output = Join-path $dir "$($image.name)-$($image.tag).tar"
    
    Write-Host "Saving $($image.repository)`:$($image.tag) to $dir as $output"

    & docker save "$($image.repository)`:$($image.tag)" -o $output

    if ($($image.clear)) {
        Write-Host "Clearing image $($image.repository)`:$($image.tag)"
        & docker rmi "$($image.repository)`:$($image.tag)"
    }
}

Write-Host "Generating Docker image cache..." -ForegroundColor Blue

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -ItemType Directory -Force

$Config.data | ForEach-Object {
    Get-DockerImage $_ $Config.target
}

Write-Host "Docker image cache successfully generated!" -ForegroundColor Green
```

## Config Schema

```jsonc
"docker": {
    // cache directory for Docker images
    "target": "docker",
    // list of images
    "data": [
        {
            // image repository
            "repository": "mcr.microsoft.com/dotnet/sdk",
            // cached image file name
            "name": "mcr.microsoft.com-dotnet-sdk",
            // image tag
            "tag": "latest",
            // if true, remove the image after caching
            "clear": false
        }
    ]
}
```