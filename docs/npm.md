# npm
[Home](./index.md)

Node.JS (JavaScript / TypeScript) dependencies, known as [npm packages](https://docs.npmjs.com/about-packages-and-modules).

## Hosting npm Packages

> See the [hosting-npm lab directory](https://github.com/JaimeStill/azure-dev-resources/tree/main/lab/hosting-npm) for research and progress pertaining to this feature.

I now have the ability to [generate a holistic dependency tree cache](./scripts/Build-NodeDependencies.md) using both [npm]() and [pnpm](https://pnpm.io/motivation), and can subsequently install offline via the cache. I can also optionally pack the tarballs for each dependency in the tree.

What I have yet to figure out is how to properly establish a central [registry](https://docs.npmjs.com/cli/v8/using-npm/registry) that npm can then be pointed to via [.npmrc](https://docs.npmjs.com/cli/v9/configuring-npm/npmrc).

I initially investigated using [verdaccio](https://verdaccio.org/docs/what-is-verdaccio/) to serve as an offline dependency registry. Out of the box, it serves as a registry proxy to https://registry.npmjs.org/ and interacts with the local cache in the same way as I am building it in the above scripts.

Relying on the npm cache is inherently not ideal because anytime you need to add packages to it, you cannot cherry pick the new dependencies. You must rebuild the cache as [persistence in the cache is unreliable at best](https://docs.npmjs.com/cli/v8/commands/npm-cache#a-note-about-the-caches-design). It seems promising if there ends up being no other alternatives, but there is more investigation to be done. I'm a little hesitant to rely on another third-party product.

### Next Steps

What would be preferrable would be to establish an HTTP server that is appropriately structured to host the dependencies in their proper structure and format. This would facilitate being able to maintain a centralized, persistent npm registry that can be updated with only new artifacts with each passing update session. See [npm registry](https://docs.npmjs.com/cli/v9/using-npm/registry?v=true#description) and [CommonJS Package Registry](https://wiki.commonjs.org/wiki/Packages/Registry) for more details.

To figure out:

* The format to store npm packages
* How to serve the npm packages so that the `registry` value can be used for native retrieval via `npm i <package>` and pointing the config to the registry.

## Per-project Dependency Cache

The PowerShell script [Build-NpmCache.ps1](./scripts/Build-NpmCache.md) defines the ability to generate npm projects with locally cached packages. The generated projects can then be transported to a disconnected network and used to establish new projects or update the dependencies for an existing Node.js project.

The resulting directory structure for each project should be:

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