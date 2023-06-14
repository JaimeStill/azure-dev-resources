# Build-NugetCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
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

function Add-ProjectDependency([psobject] $dependency, [string] $output) {
    if ($_.Contains('@')) {
        $split = $_.Split('@');
        $dependency = $split[0];
        $version = $split[1];

        & dotnet add $output package $dependency --version $version
    } else {
        & dotnet add $output package $_
    }
}

function Build-Project([psobject] $project, [string] $sln, [string] $framework) {
    $output = Join-Path $sln $project.name

    & dotnet new $project.template -o $output -f $framework
    & dotnet sln $sln add $output

    $project.dependencies | ForEach-Object {
        Add-ProjectDependency $_ $output
    }
}

function Build-Solution([psobject] $data, [string] $sln, [string] $framework) {
    & dotnet new sln -o $sln

    $data | ForEach-Object {
        Build-Project $_ $sln $framework
    }
}

function Build-Cache([string] $cache, [string] $sln) {
    if (-not (Test-Path $cache)) {
        New-Item -Path $cache -ItemType Directory -Force
    }

    & dotnet restore $sln --packages $cache
}

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
```