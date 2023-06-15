> This project is still a work in progress.

With the establishment of the IL6 cloud region, we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

* [Scripts](./scripts/)
* [OS Configuration](./os-configuration.md)
    * [WSL + Ubuntu](./os-configuration.md#wsl--ubuntu)
    * [Software](./os-configuration.md#software)
    * [Extensions](./os-configuration.md#extensions)
    * [Managing Ubuntu](./os-configuration.md#managing-ubuntu)
    * [Configurations for Offline Environments](./os-configuration.md#configurations-for-offline-environments)
        * [Environment Variables](./os-configuration.md#environment-variables)
        * [Visual Studio Code](./os-configuration.md#visual-studio-code)
* [NuGet](./nuget.md)
    * [Hosting NuGet Packages](./nuget.md#hosting-nuget-packages)
        * [Building a NuGet Cache](./nuget.md#building-a-nuget-cache)
    * [Internal NuGet Packages](./nuget.md#internal-nuget-packages)
        * [Publishing NuGet Updates](./nuget.md#publishing-nuget-updates)
        * [Automating NuGet Package Deployments](./nuget.md#automating-nuget-package-deployments)
* [npm](./npm.md)
    * [Hosting npm Packages](./npm.md#hosting-npm-packages)
    * [Per-project Dependency Cache](./npm.md#per-project-dependency-cache)
    * [Local npm Packages](./npm.md#local-npm-packages)
* [Docker](./docker.md)
    * [Cache and Restore Images](./docker.md#cache-and-restore-images)
    * [Scripted Image Cache](./docker.md#scripted-image-cache)
    * [.NET Images](./docker.md#net-images)
    * [Node Images](./docker.md#node-images)
    * [Commands](./docker.md#commands)