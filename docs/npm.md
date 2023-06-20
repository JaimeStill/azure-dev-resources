# npm
[Home](./index.md)

Node.JS (JavaScript / TypeScript) dependencies, known as [npm packages](https://docs.npmjs.com/about-packages-and-modules).

## Hosting npm Packages

No strategy for self-hosting an [npm registry](https://docs.npmjs.com/cli/v9/using-npm/registry?v=true) has been established yet. [verdaccio](https://verdaccio.org/) looks promising, but need to prove it out.

## Per-project Dependency Cache

The PowerShell script [Build-NpmCache.ps1](./scripts/Build-NpmCache.md) defines the ability to generate an npm package cache based on dependencies defined in a [`package.json`](./resources/package.json) file.

> Note that this package.json file should only consist of any of the dependency objects defined by the [package.json schema](https://docs.npmjs.com/cli/v9/configuring-npm/package-json) (dependencies, peerDependencies, bundleDependencies, and optionalDependencies). The full package.json will be generated in as a combination of script parameters and these dependencies.

The generated cache can then be transported to a disconnected network and used to establish or update the dependencies for an existing Node.js project.

Parameter | Type | Default Value | Description
----------|------|---------------|------------
Target | **string** | `..\npm` | The cache target directory.
Source | **string** | `data\package.json` | The dependency-specific package.json file.
Name | **string** | `cache` | Specifies the name for the generated package.json file.
Version | **string** | `0.0.1` | Specifies the version for the generated package.json file.
Cache | **string** | `node_cache` | The directory to store gzipped npm packages. Used to populate the project-local [`.npmrc`](https://docs.npmjs.com/cli/v9/configuring-npm/npmrc) [cache](https://docs.npmjs.com/cli/v9/using-npm/config#cache) variable.
Dependencies | **PSObject** | `null` | If present, provides a dependency object to use instead of retrieving dependencies from *Source*.

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

> A sample project for this capability can be found at [/lab/local-npm](https://github.com/JaimeStill/azure-dev-resources/tree/main/lab/local-npm).

In the [`npm install`](https://docs.npmjs.com/cli/v9/commands/npm-install) docs define a `package` as:

* a) a folder containing a program described by a [package.json](https://docs.npmjs.com/cli/v9/configuring-npm/package-json) file
* b) a gzipped tarball containing (a)
* c) a url that resolves to (b)
* d) a `<name>@<version>` that is published on the registry (see [registry](https://docs.npmjs.com/cli/v9/using-npm/registry)) with (c)
* e) a `<name>@<tag>` (see [npm dist-tag](https://docs.npmjs.com/cli/v9/commands/npm-dist-tag)) that points to (d)
* f) a `<name>` that has a *latest* tag satisfying (e)
* g) a `<git remote url>` that resolves to (a)

The sections that follow will walk through how to scaffold a local TypeScript package that satisfies (a) above, then install and consume the local package in a Node.js project.

### TypeScript Package Setup

1. Initialize a Node.js project

    ```bash
    # create the root package directory
    mkdir lib

    # change directory to the package
    cd ./lib/

    # initialize the Node.js project
    npm init
    ```

2. Fill in the `npm init` details:

    ```json
    {
        "name": "@local/simple-storage",
        "version": "0.0.1",
        "description": "Abstraction layer for interfacing with browser storage",
        "main": "dist/index.js",
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        },
        "author": "Jaime Still",
        "license": "MIT"
    }
    ```

3. Add dependencies:

    ```bash
    # dependencies
    npm i uuid

    # dev dependencies
    npm i -D @types/uuid typescript
    ```

4. Adjust `package.json` with the following:

    ```json
    {
        "types": "dist/index.d.ts",
        "scripts": {
            "build": "tsc",
            "watch": "tsc --watch"
        }
    }
    ```

5. Create a `tsconfig.json`:

    ```json
    {
        "compileOnSave": false,
        "compilerOptions": {
            "moduleResolution": "node",
            "target": "ES2022",
            "module": "ES2022",
            "rootDir": "./src",
            "outDir": "./dist",
            "declaration": true,
            "esModuleInterop": false,
            "forceConsistentCasingInFileNames": true,
            "strict": true
        }
    }
    ```

6. Create a `./src` directory, build out your TypeScript files, and export your public API in [index.ts](./lib/src/index.ts):

    ```ts
    export * from './base-storage'
    export * from './istorage'
    export * from './local-storage'
    export * from './session-storage'
    ```

### Install and Consume a Local Package

1. In a Node.js project, install the package as a dependency:

    ```bash
    npm i ../lib
    ```

    `package.json` should now contain a reference:

    ```json
    {
        "dependencies": {
            "@local/simple-storage": "file:../lib"
        }
    }
    ```

2. Use the package in your project:

    ```ts
    import { 
        IStorage,
        SessionStorage
    } from '@local/simple-storage';

    store: IStorage<string> = new SessionStorage();
    ```

[Home](./index.md)