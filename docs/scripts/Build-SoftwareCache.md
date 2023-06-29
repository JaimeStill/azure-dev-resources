# Build-SoftwareCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-Software([psobject] $software, [string] $dir) {
    Write-Host "Retrieving $($software.name) from $($software.source)"

    $output = Join-Path $dir $software.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $software.source -OutFile $output -MaximumRetryCount 10
        Write-Host "$($software.name) successfully retrieved"
    }
    catch {
        Write-Error $_
    }
}

try {
    Write-Host "Generating Software cache..." -ForegroundColor Blue

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    $Config.data | ForEach-Object {
        Get-Software $_ $Config.target
    }

    Write-Host "Software cache successfully generated!" -ForegroundColor Green
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## Config Schema

```jsonc
"software": {
    // cache directory for generated binaries
    "target": "software",
    // list of binaries
    "data": [
        {
            // resource name
            "name": "Visual Studio Code",
            // cached binary name
            "file": "vscode.exe",
            // download URI
            "source": "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        }
    ]
}
```