# Azure Dev Resources

> This project is still a work in project. As this documentation is established, any capabilities that still need to be fully researched and tested are documented in [Tasks](./tasks.md).

With the establishment of the IL6 cloud region, we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

## Aggregate Resources

As external dependencies needed to facilitate disconnected cloud development are identified, their acquisition will be automated in the [scripts](./scripts/) directory via the [Get-DevResources.ps1](./scripts/Get-DevResources.ps1) script.

## Documentation

* [OS Configuration](./01-os-configuration.md)
    * [WSL + Ubuntu](./01-os-configuration.md#wsl--ubuntu)
    * [Software](./01-os-configuration.md#software)
    * [Extensions](./01-os-configuration.md#extensions)
    * [Managing Ubuntu](./01-os-configuration.md#managing-ubuntu)
    * [Configurations for Offline Environments](./01-os-configuration.md#configurations-for-offline-environments)
        * [Environment Variables](./01-os-configuration.md#environment-variables)
        * [Visual Studio Code](./01-os-configuration.md#visual-studio-code)
* [NuGet](./02-nuget.md)
    * [Hosting NuGet Packages](./02-nuget.md#hosting-nuget-packages)
        * [Building a NuGet Cache](./02-nuget.md#building-a-nuget-cache)
    * [Internal NuGet Packages](./02-nuget.md#internal-nuget-packages)
        * [Publishing NuGet Updates](./02-nuget.md#publishing-nuget-updates)
        * [Automating NuGet Package Deployments](./02-nuget.md#automating-nuget-package-deployments)
* [npm](./03-npm.md)
    * [Hosting npm Packages](./03-npm.md#hosting-npm-packages)
    * [Per-project Dependency Cache](./03-npm.md#per-project-dependency-cache)
    * [Local npm Packages](./03-npm.md#local-npm-packages)
* [Docker](./04-docker.md)
    * [Cache and Restore Images](./04-docker.md#cache-and-restore-images)
    * [.NET Images](./04-docker.md#net-images)
    * [Node Images](./04-docker.md#node-images)