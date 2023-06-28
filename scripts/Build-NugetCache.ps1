param(
    [string]
    [Parameter()]
    $Target = "..\nuget",
    [string]
    [Parameter()]
    $Source = "data\solution.json",
    [string]
    [Parameter()]
    $Solution = "Solution",
    [switch]
    [Parameter()]
    $KeepSolution,
    [switch]
    [Parameter()]
    $SkipClean
)

function Add-ProjectDependency([string] $dependency, [string] $output) {    
    if ($dependency.Contains('@')) {
        $split = $dependency.Split('@')
        $dependency = $split[0]
        $version = $split[1]
        
        & dotnet add $output package $dependency --version $version
    }
    else {
        if ($dependency.EndsWith('!')) {
            & dotnet add $output package $($dependency.Replace('!', '')) --prerelease
        }
        else {
            & dotnet add $output package $dependency
        }
    }
}

function Build-Project([psobject] $project, [string] $sln) {
    $output = Join-Path $sln $project.name

    & dotnet new $project.template -o $output -f $project.framework
    & dotnet sln $sln add $output

    $project.dependencies | ForEach-Object {
        Add-ProjectDependency $_ $output
    }
}

function Build-Solution([psobject] $data, [string] $sln) {
    & dotnet new sln -o $sln

    $data | ForEach-Object {
        Build-Project $_ $sln
    }
}

function Build-Cache([string] $cache, [string] $sln) {
    if (-not (Test-Path $cache)) {
        New-Item -Path $cache -ItemType Directory -Force
    }

    & dotnet restore $sln --packages $cache
}

$data = Get-Content -Raw -Path $Source | ConvertFrom-Json
$sln = Join-Path $Target $Solution

if (Test-Path $sln) {
    Remove-Item $sln -Recurse -Force
}

Build-Solution $data $sln

if (-not $SkipClean) {
    & dotnet nuget locals all --clear
}

Build-Cache $Target $sln

if (-not $KeepSolution) {
    Remove-Item $sln -Recurse -Force
}