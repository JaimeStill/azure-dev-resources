# Build-DevResources.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Target = "..\bundle",
    [string]
    [Parameter()]
    $Source = "data\resources.json",
    [string]
    [Parameter()]
    $AdsTarget = "extensions\ads",
    [string]
    [Parameter()]
    $AdsSource = "data\ads-extensions.json",
    [string]
    [Parameter()]
    $CodeTarget = "extensions\vs-code",
    [string]
    [Parameter()]
    $CodeSource = "data\code-extensions.json",
    [string]
    [Parameter()]
    $DockerTarget = "docker",
    [string]
    [Parameter()]
    $DockerSource = "data\docker.json",
    [string]
    [Parameter()]
    $NugetTarget = "nuget",
    [string]
    [Parameter()]
    $NugetSource = "data\solution.json",
    [string]
    [Parameter()]
    $NugetSolution = "Solution",
    [switch]
    [Parameter()]
    $NugetKeepSolution,
    [switch]
    [Parameter()]
    $NugetSkipClean,
    [string]
    [Parameter()]
    $SoftwareTarget = "software",
    [string]
    [Parameter()]
    $SoftwareSource = "data\software.json"
)

Write-Output "Bundling Azure Dev Resources..."

$data = Get-content -Raw -Path $Source | ConvertFrom-Json

$($data.npm.projects) | ForEach-Object {
    .\Build-NpmCache -Target (Join-Path $Target $($data.npm.target) $($_.name)) `
        -Name $($_.name) `
        -Version $($_.version) `
        -Cache $($_.cache) `
        -Dependencies $($_.packages)
}

.\Build-NugetCache.ps1 -Target "$Target\$NugetTarget" `
    -Source $NugetSource `
    -Solution $NugetSolution `
    -KeepSolution:$NugetKeepSolution `
    -SkipClean:$NugetSkipClean

.\Build-AdsExtensions.ps1 -Target "$Target\$AdsTarget" `
    -Source $AdsSource

.\Build-CodeExtensions.ps1 -Target "$Target\$CodeTarget" `
    -Source $CodeSource

.\Build-DockerCache.ps1 -Target "$Target\$DockerTarget" `
    -Source $DockerSource

.\Build-Software.ps1 -Target "$Target\$SoftwareTarget" `
    -Source $SoftwareSource

Write-Output "Finished bundling Azure Dev Resources!"
```

## resources.json

```json
{
    "npm": {
        "target": "npm",
        "projects": [
            {
                "name": "cache",
                "version": "0.0.1",
                "cache": "node_cache",
                "packages": {
                    "dependencies": {
                        "@microsoft/signalr": "^7.0.7"
                    },
                    "devDependencies": {
                        "@types/node": "^20.3.1",
                        "typescript": "^5.1.3"
                    }
                }
            },
            {
                "name": "optimus",
                "version": "0.1.0",
                "cache": "optimus_prime",
                "packages": {
                    "dependencies": {
                        "moleculer": "^0.14.29"
                    },
                    "devDependencies": {
                        "typescript": "^5.1.3"
                    }
                }
            }
        ]
    }
}
```