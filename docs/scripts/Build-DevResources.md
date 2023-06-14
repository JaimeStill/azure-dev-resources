# Build-DevResources.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Bundle = "..\bundle"
)

Write-Output "Bundling Azure Dev Resources..."

.\Build-NugetCache.ps1 -Target "$Bundle\nuget"
.\Build-NpmCache.ps1 -Target "$Bundle\npm"
.\Build-DockerCache.ps1 -Target "$Bundle\docker"
.\Build-AdsExtensions.ps1 -Target "$Bundle\extensions\ads"
.\Build-CodeExtensions.ps1 -Target "$Bundle\extensions\code"
.\Build-Software.ps1 -Target "$Bundle\software"

Write-Output "Finished bundling Azure Dev Resources!"
```