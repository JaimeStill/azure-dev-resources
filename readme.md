> This project is still a work in progress. As this documentation is established, any capabilities that still need to be fully researched and tested are documented in [Tasks](./tasks.md).

With the establishment of the IL6 cloud region, we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

## Aggregate Resources

As external dependencies needed to facilitate disconnected cloud development are identified, their acquisition will be automated in the [scripts](./scripts/) directory via the [Get-DevResources.ps1](./scripts/Get-DevResources.ps1) script.

## Documentation

* [OS Configuration](./docs/os-configuration.md)
    * [WSL + Ubuntu](./docs/os-configuration.md#wsl--ubuntu)
    * [Software](./docs/os-configuration.md#software)
    * [Extensions](./docs/os-configuration.md#extensions)
    * [Managing Ubuntu](./docs/os-configuration.md#managing-ubuntu)
    * [Configurations for Offline Environments](./docs/os-configuration.md#configurations-for-offline-environments)
        * [Environment Variables](./docs/os-configuration.md#environment-variables)
        * [Visual Studio Code](./docs/os-configuration.md#visual-studio-code)
* [NuGet](./docs/nuget.md)
    * [Hosting NuGet Packages](./docs/nuget.md#hosting-nuget-packages)
        * [Building a NuGet Cache](./docs/nuget.md#building-a-nuget-cache)
    * [Internal NuGet Packages](./docs/nuget.md#internal-nuget-packages)
        * [Publishing NuGet Updates](./docs/nuget.md#publishing-nuget-updates)
        * [Automating NuGet Package Deployments](./docs/nuget.md#automating-nuget-package-deployments)
* [npm](./docs/npm.md)
    * [Hosting npm Packages](./docs/npm.md#hosting-npm-packages)
    * [Per-project Dependency Cache](./docs/npm.md#per-project-dependency-cache)
    * [Local npm Packages](./docs/npm.md#local-npm-packages)
* [Docker](./docs/docker.md)
    * [Cache and Restore Images](./docs/docker.md#cache-and-restore-images)
    * [.NET Images](./docs/docker.md#net-images)
    * [Node Images](./docs/docker.md#node-images)