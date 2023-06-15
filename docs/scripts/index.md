# Scripts
[Home](../index.md)

As external dependencies needed to facilitate disconnected cloud development are identified, their acquisition will be automated. Where relevant, each script below also includes an example of the JSON file it points to for acquiring resources.

Script | Description
-------|------------
[Build-DevResources](./Build-DevResources.md) | Aggregates all resources into a single bundle by calling each of the below scripts in sequence.
[Build-AdsExtensions](./Build-AdsExtensions.md) | Retrieves the specified extensions for Azure Data Studio.
[Build-CodeExtensions](./Build-CodeExtensions.md) | Retrieves the latest version of the specified extensions for Visual Studio Code.
[Build-DockerCache](./Build-DockerCache.md) | Pulls and saves the specified Docker images.
[Build-NpmCache](./Build-NpmCache.md) | Builds and caches dependencies for a Node.js project.
[Build-NugetCache](./Build-NugetCache.md) | Generates a cache of the full dependency hierarchy for a series of specified projects and dependencies. Can optionally retain the solution that is created to generate the cache.
[Build-Software](./Build-Software.md) | Retrieves the specified software installers.