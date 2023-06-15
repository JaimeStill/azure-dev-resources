# Build-AdsExtensions.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Target = "..\bundle\extensions\ads",
    [string]
    [Parameter()]
    $Source = "data\ads-extensions.json"
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-AdsExtension([psobject] $ext, [string] $dir) {
    Write-Output "Retrieving $($ext.name) from $($ext.source)"

    $output = Join-Path $dir $ext.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $ext.source -OutFile $output -MaximumRetryCount 10 -RetryIntervalSec 6
        Write-Output "$($ext.name) successfully retrieved"
    }
    catch {
        Write-Error $_
    }
}

try {
    if (-not (Test-Path $Target)) {
        New-Item -Path $Target -ItemType Directory -Force
    }

    $data = Get-Content -Raw -Path $Source | ConvertFrom-Json

    Write-Output "Generating Azure Data Studio extensions in $Target"

    $data | ForEach-Object {
        Get-AdsExtension $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## ads-extensions.json

```json
[
    {
        "name": "Admin Pack for SQL Server",
        "file": "admin-pack-sql-server.vsix",
        "source": "https://go.microsoft.com/fwlink/?linkid=2099889"
    },
    {
        "name": "Database Admin Tool Extensions for Windows",
        "file": "db-admin-tool.vsix",
        "source": "https://go.microsoft.com/fwlink/?linkid=2099888"
    },
    {
        "name": "PostgreSQL",
        "file": "postgresql.vsix",
        "source": "https://github.com/microsoft/azuredatastudio-postgresql/releases/download/v0.3.1/azuredatastudio-postgresql-0.3.1-win-x64.vsix"
    },
    {
        "name": "Query History",
        "file": "query-history.vsix",
        "source": "https://go.microsoft.com/fwlink/?linkid=2109534"
    }
]
```