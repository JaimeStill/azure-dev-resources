# Build-ResourceCache.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Build-Folders([psobject] $folders, [string] $dir) {
    if ($null -ne $folders) {
        $folders | ForEach-Object {
            $folder = Join-Path $dir $_.target

            if (Test-Path $folder) {
                Remove-Item $folder -Recurse -Force
            }

            New-Item $folder -ItemType Directory -Force
            
            Get-Resources $_.files $folder
            Build-Folders $_.folders $folder
        }
    }
}

function Get-Resources([psobject] $files, [string] $dir) {
    if ($null -ne $files) {
        $files | ForEach-Object {
            $file = Join-Path $dir $_.file
            Write-Host "Retrieving $file..."

            if (Test-Path $file) {
                Remove-Item -Force $file
            }
            
            Invoke-RestMethod -Uri $_.source -OutFile $file -MaximumRetryCount 10
            Write-Host "$file successfully retrieved"
        }
    }
}

try {
    Write-Host "Generating Software cache..." -ForegroundColor Blue

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    Get-Resources $Config.files $Config.target
    Build-Folders $Config.folders $Config.target

    Write-Host "Software cache successfully generated!" -ForegroundColor Green
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## Config Schema

```jsonc
"resources": {
    // cache directory for generated binaries
    "target": "resources",
    // OPTIONAL: list of files for this directory
    "files": [
        {
            // resource name
            "name": "Visual Studio Code",
            // cached binary name
            "file": "vscode.exe",
            // download URI
            "source": "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        }
    ],
    // OPTIONAL: list of sub-directories for this directory
    // each object in this array has the same schema as the root "resources" object
    "folders": [
        {
            // cache directory for the files within this folder
            //
            // note that you can lift directory by using relative
            // directory paths. For instance, if you wanted to lift
            // "fonts" to directly within the generated "bundle"
            // directory, you could define it as follows:
            //
            // "target": "../fonts"
            // 
            // this will generate the following directory structure:
            //
            // * bundle
            //    * fonts
            //    * resources
            "target": "fonts",
            "files": [
                {
                    "name": "Cascadia Code",
                    "file": "cascadia-code.zip",
                    "source": "https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip"
                }
            ]
        }
    ]
}
```