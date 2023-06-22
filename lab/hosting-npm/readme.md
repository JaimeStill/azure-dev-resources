# Hosting npm

## Current Status - On Hold

I now have the ability to [generate a holistic dependency tree cache](./Build-NodeDependencies.ps1) using both [npm](https://docs.npmjs.com/about-npm) and [pnpm](https://pnpm.io/motivation), and can subsequently install offline via the cache. I can also optionally pack the tarballs for each dependency in the tree.

What I have yet to figure out is how to properly establish a central [registry](https://docs.npmjs.com/cli/v8/using-npm/registry) that npm can then be pointed to via [.npmrc](https://docs.npmjs.com/cli/v9/configuring-npm/npmrc).

I initially investigated using [verdaccio](https://verdaccio.org/docs/what-is-verdaccio/) to serve as an offline dependency registry. Out of the box, it serves as a registry proxy to https://registry.npmjs.org/ and interacts with the local cache in the same way as I am building it in the above scripts. 

Relying on the npm cache is inherently not ideal because anytime you need to add packages to it, you cannot cherry pick the new dependencies. You must rebuild the cache as [persistence in the cache is unreliable at best](https://docs.npmjs.com/cli/v8/commands/npm-cache#a-note-about-the-caches-design). It seems promising, but there is more investigation to be done. I'm a little hesitant to rely on another third-party product.

## Next Steps

What would be preferrable would be to establish an HTTP server that is appropriately structured to host the dependencies in their proper structure and format. This would facilitate being able to maintain a centralized, persistent npm registry that can be updated with only new artifacts with each passing update session. See [npm registry](https://docs.npmjs.com/cli/v9/using-npm/registry?v=true#description) and [CommonJS Package Registry](https://wiki.commonjs.org/wiki/Packages/Registry) for more details.

To figure out:

* The format to store npm packages
* How to serve the npm packages so that the `registry` value can be used for native retrieval via `npm i <package>` and pointing the config to the registry.

## Scripting Notes

**Use `http-server` to serve a directory**  
```bash
npm i -g http-server
cd .\.cache
http-server -g
```

**retrieve package metadata and download tarball**  
```powershell
$ngCore = Invoke-RestMethod https://registry.npmjs.org/@angular/core/latest
Invoke-RestMethod $ngCore.dist.tarball -OutFile .\.cache\@angular\core-16.1.1.tgz
```

**read a package.json and iterate through the dependencies**  
```powershell
$deps = Get-Content -Raw -Path .\app\package.json | ConvertFrom-Json

foreach ($prop in $deps.dependencies.PSObject.Properties) {
    Write-Output "$($prop.name)@$($prop.Value)"
}
```

`corepack` directory: `$env:LocalAppData\node\corepack`