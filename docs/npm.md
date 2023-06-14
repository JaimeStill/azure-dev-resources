# npm
[Home](./index.md)

Node.JS (JavaScript / TypeScript) dependencies, known as [npm packages](https://docs.npmjs.com/about-packages-and-modules).

## Hosting npm Packages

No strategy for self-hosting an [npm registry](https://docs.npmjs.com/cli/v9/using-npm/registry?v=true) has been established yet. [verdaccio](https://verdaccio.org/) looks promising, but need to prove it out.

## Per-project Dependency Cache

The PowerShell script [Build-NpmCache.ps1](./scripts/Build-NpmCache.md) defines the ability to generate an npm package cache based on dependencies defined in a [`package.json`](./resources/package.json) file.

> Note that this package.json file should only consist of any of the dependency arrays defined by the [package.json schema](https://docs.npmjs.com/cli/v9/configuring-npm/package-json) (dependencies, peerDependencies, bundleDependencies, and optionalDependencies). The full package.json will be generated in as a combination of script parameters and these dependencies.

The generated cache can then be transported to a disconnected network and used to establish or update the dependencies for an existing Node.js project.

Property | Type | Default Value | Description
---------|------|---------------|------------
Cache | **string** | `node_cache` | The directory to store gzipped npm packages. Used to populate the project-local [`.npmrc`](https://docs.npmjs.com/cli/v9/configuring-npm/npmrc) [cache](https://docs.npmjs.com/cli/v9/using-npm/config#cache) variable.
Source | **string** | `data\package.json` | The dependency-specific package.json file.
Name | **string** | `cache` | Specifies the name for the generated package.json file.
Version | **string** | `0.0.1` | Specifies the version for the generated package.json file.
Target | **string** | `..\npm` | The cache target directory.

**Example `package.json`**

```json
{
    "dependencies": {
        "@microsoft/signalr": "^7.0.7"
    },
    "devDependencies": {
        "@types/node": "^20.3.1",
        "typescript": "^5.1.3"
    }
}
```

The resulting directory structure should be:

* node_cache
* .npmrc
* package-lock.json
* package.json

## Local npm Packages

Prove out the steps from here: https://stackoverflow.com/questions/15806241/how-to-specify-local-modules-as-npm-package-dependencies/38417065#38417065

[Home](./index.md)