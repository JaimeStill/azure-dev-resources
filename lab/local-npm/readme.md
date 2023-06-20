# Local npm Package

This directory demonstrates setting up a [local npm package](./lib/), then installing and using it as a dependency in a separate [app](./app/) project. The following sections will walk through the implementation details of this capability.

## TypeScript Package Setup

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

4. Adjust [package.json](./lib/package.json) with the following:

    ```json
    {
        "types": "dist/index.d.ts",
        "scripts": {
            "build": "tsc",
            "watch": "tsc --watch"
        }
    }
    ```

5. Create [tsconfig.json](./lib/tsconfig.json):

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

## Install and Consume a Local Package

1. In a Node.js project, install the package as a dependency:

    ```bash
    npm i ../lib
    ```

    [package.json](./app/package.json) should now contain a reference:

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