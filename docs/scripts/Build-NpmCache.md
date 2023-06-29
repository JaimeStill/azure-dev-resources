# Build-NpmCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

function Merge-NpmDependencies([psobject] $package, [psobject] $deps) {
    foreach ($prop in $deps.PSObject.Properties) {
        $package | Add-Member -Name $prop.Name -Value $prop.Value -MemberType $prop.MemberType
    }
}

Write-Host "Generating npm cache..." -ForegroundColor Blue

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -Recurse -Force

$Config.data | ForEach-Object {
    $project = Join-Path $Config.target $_.name

    $package = @{
        name = $_.name
        version = $_.version
    }

    Merge-NpmDependencies $package $_.packages

    New-Item -Path $project -ItemType Directory -Force
    New-Item (Join-Path $project ".npmrc") -ItemType file -Value "cache=./$($_.cache)"
    New-Item (Join-Path $project "package.json") -ItemType File -Value ($package | ConvertTo-Json)

    $path = Get-Location
    Set-Location $project

    & npm install

    if (Test-Path node_modules) {
        Remove-Item node_modules -Recurse -Force
    }

    Set-Location $path
}

Write-Host "npm cache successfully generated!" -ForegroundColor Green
```

## Config Schema

```jsonc
"npm": {
    // cache directory for generated Node.js projects
    "target": "npm",
    // Node.js project configurations
    "data": [
        {
            // package.json name
            "name": "cache",
            // package.json version
            "version": "0.0.1",
            // project dependency cache set in .npmrc
            "cache": "node_cache",
            // all dependency objects and their dependencies
            // see https://docs.npmjs.com/cli/v9/configuring-npm/package-json#dependencies
            "packages": {
                // package.json dependencies
                "dependencies": {
                    "@microsoft/signalr": "^7.0.7"
                },
                // package.json devDependencies
                "devDependencies": {
                    "typescript": "^5.1.3"
                }
            }
        }
    ]
}
```