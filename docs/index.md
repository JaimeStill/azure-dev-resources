> This project is still a work in progress.

With the establishment of the IL6 cloud region, we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

## Directory

* [Scripts](./scripts/)
* [Docker](./docker.md)
    * [Cache and Restore Images](./docker.md#cache-and-restore-images)
    * [Scripted Image Cache](./docker.md#scripted-image-cache)
    * [.NET Images](./docker.md#net-images)
    * [Node Images](./docker.md#node-images)
    * [Commands](./docker.md#commands)
* [Extensions](./extensions.md)
    * [Azure Data Studio](./extensions.md#azure-data-studio)
    * [Visual Studio Code](./extensions.md#visual-studio-code)
* [Linux](./linux.md)
* [npm](./npm.md)
    * [Hosting npm Packages](./npm.md#hosting-npm-packages)
    * [Per-project Dependency Cache](./npm.md#per-project-dependency-cache)
    * [Local npm Packages](./npm.md#local-npm-packages)
        * [TypeScript Package Setup](./npm.md#typescript-package-setup)
        * [Install and Consume a Local Package](./npm.md#install-and-consume-a-local-package)
* [NuGet](./nuget.md)
    * [Hosting NuGet Packages](./nuget.md#hosting-nuget-packages)
        * [Building a NuGet Cache](./nuget.md#building-a-nuget-cache)
    * [Internal NuGet Packages](./nuget.md#internal-nuget-packages)
        * [Publishing NuGet Updates](./nuget.md#publishing-nuget-updates)
        * [Automating NuGet Package Deployments](./nuget.md#automating-nuget-package-deployments)
* [Software](./software.md)
    * [Configurations for Offline Environments](./software.md#configurations-for-offline-environments)
        * [Environment Variables](./software.md#environment-variables)
        * [Visual Studio Code](./software.md#visual-studio-code)
* [Windows Subsystem for Linux](./wsl.md)

## Automated Resource Builds

All of the resources and dependencies specified in this documentation can be retrieved and bundled together into a single directory by executing the [Build-DevResources.ps1](./scripts/Build-DevResources.md) script. It aggregates the execution of the scripts specified in the sections of this documentation. Additionally, it allows for the generation of multiple cached Node.js projects. These resources can then be transported to a disconnected network and used to establish or update their related features.

Parameter | Type | Default Value | Description
----------|------|---------------|------------
Target | **string** | `..\bundle` | The target bundle directory.
Source | **string** | `data\resources.json` | The [JSON file](./scripts/Build-DevResources.md#resourcesjson) containing information in the JSON Schema format outlined below.
AdsTarget | **string** | `extensions\ads` | The sub-directory to store Azure Data Studio extensions.
AdsSource | **string** | `data\ads-extensions.json` | The [JSON file](./scripts/Build-AdsExtensions.md#ads-extensionsjson) specifying a list of Azure Data Studio extensions. Must conform to the proper schema!
CodeTarget | **string** | `extensions\vs-code` | The sub-directory to store Visual Studio Code extensions.
CodeSource | **string** | `data\code-extensions.json` | The [JSON file](./scripts/Build-CodeExtensions.md#code-extensionsjson) specifying a list of Visual Studio Code extensions. Must conform to the proper schema!
DockerTarget | **string** | `docker` | The sub-directory to store Docker images.
DockerSource | **string** | `data\docker.json` | The [JSON file](./scripts/Build-DockerCache.md#dockerjson) specifying a list of Docker images. Must conform to the proper schema!
NugetTarget | **string** | `nuget` | The sub-directory to store cached NuGet resources.
NugetSource | **string** | `data\solution.json` | The [JSON file](./scripts/Build-NugetCache.md#solutionjson) specifying the .NET solution structure. Must conform to the proper schema!
NugetSolution | **string** | `Solution` | Name and sub-directory within *NugetTarget* to save the .NET solution created to generate the NuGet cache.
NugetKeepSolution | **switch** | `null` | When present, do not remove the solution created to generate the cache.
NugetSkipClean | **switch** | `null` | When present, prevent the script from cleaning the local NuGet cache (`dotnet nuget locals all --clear`).
SoftwareTarget | **string** | `software` | The sub-directory to store software executables.
SoftwareSource | **string** | `data\software.json` | The [JSON file](./scripts/Build-Software.md#softwarejson) specifying a list of software executables. Must conform to the proper schema!

### JSON Schema

An object that provides metadata for passing data to the executed sub-scripts. Currently, only generating multiple Node.js projects is supported, but it is structured in such a way as to be more extensible in the future. The schema is as follows:

Property | Description
---------|------------
`npm` | an object containing metadata for Node.js projects.
`target` | the sub-directory to save the generated Node.js projects.
`projects` | an array of objects containing metadata to pass to [`Build-NpmCache.ps1`](./scripts/Build-NpmCache.md).
`name` | the name for the generated package.json file.
`version` | the version for the generated package.json file.
`cache` | the directory to store the gzipped npm packages. Used to populate the project-local `.npmrc` cache variable.
`packages` | an object containing the dependency objects specified by package.json.

**Example**  

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
