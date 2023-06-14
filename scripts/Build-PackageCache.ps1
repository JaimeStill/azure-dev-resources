param(
    [string]
    [Parameter()]
    $Cache = "..\nuget-packages",
    [string]
    [Parameter()]
    $Source = "data\solution.json",
    [string]
    [Parameter()]
    $Solution = "..\solution",
    [string]
    [Parameter()]
    [ValidateSet("net6.0", "net7.0", "netstandard2.0", "netstandard2.1")]
    $Framework = "net7.0",
    [switch]
    [Parameter()]
    $KeepSolution,
    [switch]
    [Parameter()]
    $SkipClean
)

. .\CacheFunctions.ps1

$data = Get-Content -Raw -Path $Source | ConvertFrom-Json

if (Test-Path $Solution) {
    Remove-Item $Solution -Recurse -Force
}

Build-Solution $data $Solution $Framework

if (-not $SkipClean) {
    & dotnet nuget locals all --clear
}

Build-Cache $Cache $Solution

if (-not $KeepSolution) {
    Remove-Item $Solution -Recurse -Force
}