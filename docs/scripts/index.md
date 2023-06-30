# Scripts
[Home](../index.md)

As external dependencies needed to facilitate disconnected cloud development are identified, their acquisition will be automated. Where relevant, each script below also includes an example of the JSON file it points to for acquiring resources.

Script | Description
-------|------------
[Build-DevResources](./Build-DevResources.md) | Aggregates all resources into a single bundle by calling each of the below scripts in sequence.
[Build-AdsExtensions](./Build-AdsExtensions.md) | Retrieves the specified extensions for Azure Data Studio. See [Extensions - Azure Data Studio](../extensions.md#azure-data-studio) for more details.
[Build-CodeExtensions](./Build-CodeExtensions.md) | Retrieves the latest version of the specified extensions for Visual Studio Code. See [Extensions - Visual Studio Code](../extensions.md#visual-studio-code) for more details.
[Build-DockerCache](./Build-DockerCache.md) | Pulls and saves the specified Docker images. See [Docker  Scripted Image Cache](../docker.md#scripted-image-cache) for more details.
[Build-DotnetCache](./Build-DotnetCache.md) | Generates a .NET SDK installer and caches .NET CLI tools.
[Build-LinuxCache](./Build-LinuxCache.md) | Retrieves software an dupdates for ubuntu. see [Linux](../linux.md) for more details.
[Build-NpmCache](./Build-NpmCache.md) | Builds and caches dependencies for a Node.js project. See [npm - Per-project Dependency Cache](../npm.md#per-project-dependency-cache) for more details.
[Build-NugetCache](./Build-NugetCache.md) | Generates a cache of the full dependency hierarchy for a series of specified projects and dependencies. Can optionally retain the solution that is created to generate the cache. See [NuGet - Building a NuGet Cache](../nuget.md#building-a-nuget-cache) for more details.
[Build-ResourceCache](./Build-ResourceCache.md) | Retrieves the specified binary resources. See [Resources](../resources.md) for more details.
[Build-WslCache](./Build-WslCache.md) | Initializes the resources required to setup WSL2 and Ubuntu on a disconnected machine. see [Windows Subsystem for Linux](../wsl.md) for more details.