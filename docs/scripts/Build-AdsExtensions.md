# Build-AdsExtensions.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-AdsExtension([psobject] $ext, [string] $dir) {
    Write-Host "Retrieving $($ext.name) from $($ext.source)"

    $output = Join-Path $dir $ext.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $ext.source -OutFile $output -MaximumRetryCount 10 -RetryIntervalSec 6
        Write-Host "$($ext.name) successfully retrieved"
    }
    catch {
        Write-Error $_
    }
}

try {
    Write-Host "Generating Azure Data Studio extension cache..." -ForegroundColor Cyan

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    $Config.data | ForEach-Object {
        Get-AdsExtension $_ $Config.target
    }

    Write-Host "Azure Data Studio extension cache successfully generated!" -ForegroundColor Cyan
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## Config Schema

```json
"ads": {
    // cache directory for Azure Data Studio extensions
    "target": "extensions\\ads",
    // list of extensions
    "data": [
        {
            // extension name
            "name": "Admin Pack for SQL Server",
            // generated file name
            "file": "admin-pack-sql-server.vsix",
            // download URI
            "source": "https://go.microsoft.com/fwlink/?linkid=2099889"
        }
    ]
}
```