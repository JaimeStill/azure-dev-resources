> This project is still a work in progress.

With the establishment of the IL6 cloud region, we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

## Directory

* [Scripts](./scripts/)
* [Dev Environment Setup](./dev-environment-setup.md)
* [Docker](./docker.md)
    * [Cache and Restore Images](./docker.md#cache-and-restore-images)
    * [.NET Images](./docker.md#net-images)
    * [Node Images](./docker.md#node-images)
    * [Commands](./docker.md#commands)
* [Extensions](./extensions.md)
    * [Azure Data Studio](./extensions.md#azure-data-studio)
    * [Visual Studio Code](./extensions.md#visual-studio-code)
* [Linux](./linux.md)
    * [Install Apt Software](./linux.md#install-apt-software)
    * [Install the .NET SDK](./linux.md#install-the-net-sdk)
    * [apt-offline Updates](./linux.md#apt-offline-updates)
* [npm](./npm.md)
    * [Hosting npm Packages](./npm.md#hosting-npm-packages)
    * [Per-project Dependency Cache](./npm.md#per-project-dependency-cache)
    * [Local npm Packages](./npm.md#local-npm-packages)
        * [TypeScript Package Setup](./npm.md#typescript-package-setup)
        * [Install and Consume a Local Package](./npm.md#install-and-consume-a-local-package)
* [NuGet](./nuget.md)
    * [Hosting NuGet Packages](./nuget.md#hosting-nuget-packages)
    * [Internal NuGet Packages](./nuget.md#internal-nuget-packages)
        * [Publishing NuGet Updates](./nuget.md#publishing-nuget-updates)
        * [Automating NuGet Package Deployments](./nuget.md#automating-nuget-package-deployments)
* [Software](./software.md)
    * [Configurations for Offline Environments](./software.md#configurations-for-offline-environments)
        * [Environment Variables](./software.md#environment-variables)
        * [Visual Studio Code](./software.md#visual-studio-code)
* [Windows Subsystem for Linux](./wsl.md)

## Automated Resource Builds

All of the resources and dependencies specified in this documentation can be retrieved and bundled together into a single directory by executing the [Build-DevResources.ps1](./scripts/Build-DevResources.md) script and passing in a [JSON config file](#json-config-schema). It aggregates the execution of the scripts specified in the sections of this documentation based on the requirements specified in the provided configuration. These resources can then be transported to a disconnected network and used to establish or update their related features.

### JSON Config Schema

> For a comprehensive set of configuration examples, see the [scripts/config](https://github.com/JaimeStill/azure-dev-resources/tree/project-schema/scripts/config) directory in the project repository.

A [JSON config file](#json-config-schema) that specifies where to store the cached resources (`target`) and provides metadata to the executed sub-scripts (each base property apart from `target`, i.e. - `linux` for caching Ubuntu resources, `npm` for caching npm projects with their dependencies, etc.).

The sub-script base properties are optional. If a sub-script base property is provided, all of the properties within its schema are required unless specified below. You should provide at least one sub-script base property.

Each `target` within a sub-script base property will be joined with the root `target` property. For instance:

```json
{
    "target": "..\\bundle",
    "wsl": {
        "target": "wsl",
        "arch": "x64"
    }
}
```

The runtime target for `wsl.target` will be `..\bundle\wsl`.

The schema is as follows:

```jsonc
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
    // Build-SoftwareCache.ps1
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
    // Build-WslCache.ps1
    "wsl": {
        // cache directory for generated Kernel and Ubuntu app package
        "target": "wsl",
        // system architecture - x64 or arm64
        "arch": "x64"
    }
}
```