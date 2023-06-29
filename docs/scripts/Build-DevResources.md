# Build-DevResources.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Config = "config\full.json"
)

$data = Get-Content -Raw -Path $Config | ConvertFrom-Json

if ($null -ne $data) {
    if (! (Test-Path $data.target)) {
        New-Item $data.target -ItemType Directory -Force
    }

    foreach ($prop in $($data | Select-Object -ExcludeProperty target).PSObject.Properties) {
        $data.$($prop.Name).target = Join-Path $data.target $prop.Value.target
    }

    if ($null -ne $data.linux) {
        .\Build-LinuxCache.ps1 -Config $data.linux
    }

    if ($null -ne $data.npm) {
        .\Build-NpmCache.ps1 -Config $data.npm
    }

    if ($null -ne $data.nuget) {
        .\Build-NugetCache.ps1 -Config $data.nuget
    }

    if ($null -ne $data.ads) {
        .\Build-AdsExtensions.ps1 -Config $data.ads
    }

    if ($null -ne $data.vscode) {
        .\Build-CodeExtensions.ps1 -Config $data.vscode
    }

    if ($null -ne $data.docker) {
        .\Build-DockerCache.ps1 -Config $data.docker
    }

    if ($null -ne $data.software) {
        .\Build-SoftwareCache.ps1 -Config $data.software
    }

    if ($null -ne $data.wsl) {
        .\Build-WslCache.ps1 -Config $data.wsl
    }
}
else {
    Write-Error "$Config was not found"
}
```

## Config Schema

```json
{
    // the root cache directory
    "target": "..\\bundle",
    // Build-AdsExtensions.ps1
    "ads": {
        // cache directory for Azure Data Studio extensions
        "target": "extensions\\ads",
        // list of extensions
        "data": [
            {
                // extension name
                "name": "Admin Pack for SQL Server",
                // generated file name
                "file": "admin-pack-sql-server.vsix",
                // download URI
                "source": "https://go.microsoft.com/fwlink/?linkid=2099889"
            }
        ]
    },
    // Build-CodeExtensions.ps1
    "vscode": {
        // cache directory for Visual Studio Code extensions
        "target": "extensions\\vscode",
        // list of extensions
        "data": [
            {
                // registered publisher
                "publisher": "angular",
                // registered name
                "name": "ng-template",
                // user friendly name
                "display": "Angular Language Service"
            }
        ]
    },
    // Build-DockerCache.ps1
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
    },
    // Build-LinuxCache.ps1
    "linux": {
        // cache directory for Linux resources
        "target": "linux",
        // script metadata options
        "data": {
            // apt packages to cache
            "apt": [
                "apt-offline",
                "git",
                "jq"
            ],
            // OPTIONAL: .NET SDK metadata
            // options correspond with .NET install script options
            // see https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options
            "dotnet": {
                // see --architecture
                "arch": "x64",
                // see --channel
                "channel": "STS",
                // see --os
                "os": "linux",
                // extract the retrieved .tar.gz into a .dotnet directory
                "extract": false
            }
        }
    },
    // Build-NpmCache.ps1
    "npm": {
        // cache directory for generated Node.js projects
        "target": "npm",
        // Node.js project configurations
        "data": [
            {
                // package.json name
                "name": "cache",
                // package.json version
                "version": "0.0.1",
                // project dependency cache set in .npmrc
                "cache": "node_cache",
                // all dependency objects and their dependencies
                // see https://docs.npmjs.com/cli/v9/configuring-npm/package-json#dependencies
                "packages": {
                    // package.json dependencies
                    "dependencies": {
                        "@microsoft/signalr": "^7.0.7"
                    },
                    // package.json devDependencies
                    "devDependencies": {
                        "typescript": "^5.1.3"
                    }
                }
            }
        ]
    },
    // Build-NugetCache.ps1
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
    },
    // Build-SoftwareCache
    "software": {
        // cache directory for generated binaries
        "target": "software",
        // list of binaries
        "data": [
            {
                // resource name
                "name": "Visual Studio Code",
                // cached binary name
                "file": "vscode.exe",
                // download URI
                "source": "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
            }
        ]
    },
    // Build-WslCache
    "wsl": {
        // cache directory for generated Kernel and Ubuntu app package
        "target": "wsl",
        // system architecture - x64 or arm64
        "arch": "x64"
    }
}
```