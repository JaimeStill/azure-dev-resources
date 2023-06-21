```powershell
npm info @angular/core --json
npm info @angular/core peerDependencies
npm info rxjs@^7.4.0 dependencies
npm info tslib@~2.1.0 dist.tarball

mkdir .\.cache\
Invoke-RestMethod https://registry.npmjs.org/tslib/-/tslib-2.1.0.tgz -OutFile .\.cache\tslib-2.1.0.tgz

npm i -g http-server
cd .\.cache
http-server -g
```

$ngCore = Invoke-RestMethod https://registry.npmjs.org/@angular/core/latest

Invoke-RestMethod $ngCore.dist.tarball -OutFile .\.cache\@angular\core-16.1.1.tgz
```powershell
$deps = Get-Content -Raw -Path .\app\package.json | ConvertFrom-Json

foreach ($prop in $deps.dependencies.PSObject.Properties) {
    Write-Output "$($prop.name)@$($prop.Value)"
}
```

To figure out:

* The format to store npm packages
* How to serve the npm packages so that the `registry` value can be used for retrieval.

`corepack` directory: `$env:LocalAppData\node\corepack`