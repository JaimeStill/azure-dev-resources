# Build-NugetCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
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

function Build-Solution([psobject] $projects, [string] $sln) {
    & dotnet new sln -o $sln

    $projects | ForEach-Object {
        Build-Project $_ $sln
    }
}

function Build-Cache([string] $cache, [string] $sln) {
    if (-not (Test-Path $cache)) {
        New-Item -Path $cache -ItemType Directory -Force
    }

    & dotnet restore $sln --packages $cache
}

Write-Host "Generating NuGet cache..." -ForegroundColor Blue

$sln = Join-Path $Config.target $Config.data.solution

if (Test-Path $sln) {
    Remove-Item $sln -Recurse -Force
}

Build-Solution $Config.data.projects $sln

if ($Config.data.clean) {
    & dotnet nuget locals all --clear
}

Build-Cache $Config.target $sln

if (-not $Config.data.keep) {
    Remove-Item $sln -Recurse -Force
}

Write-Host "NuGet cache successfully generated!" -ForegroundColor Green
```

## Config Schema

```jsonc
"nuget": {
    // cache directory for generated NuGet packages
    "target": "nuget",
    // script metadata options
    "data": {
        // directory to host the generated solution
        "solution": ".solution",
        // if true, keep the solution after generating the cache
        "keep": false,
        // if true, clean the NuGet cache before caching dependencies
        "clean": true,
        // dotnet new projects to generate in the solution
        "projects": [
            {
                // project name
                "name": "Core",
                // dotnet new <template>
                "template": "classlib",
                // dotnet new <template> -f <framework>
                "framework": "net7.0",
                // NuGet package dependencies
                "dependencies": [
                    "Microsoft.AspNetCore.SignalR.Client",
                    // ending in ! indicates --prerelease
                    "System.CommandLine!",
                    // can specify a specific version
                    "System.CommandLine@2.0.0-beta4.22272.1"
                ]
            }
        ]
    }
}
```