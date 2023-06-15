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