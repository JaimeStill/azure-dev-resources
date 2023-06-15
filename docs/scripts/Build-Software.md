# Build-Software.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Target = "..\bundle\software",
    [string]
    [Parameter()]
    $List = "data\software.json"
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-Software([psobject] $software, [string] $dir) {
    Write-Output "Retrieving $($software.name) from $($software.source)"

    $output = Join-Path $dir $software.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $software.source -OutFile $output -MaximumRetryCount 3
        Write-Output "$($software.name) successfully retrieved"
    }
    catch {
        Write-Error $_
    }
}

try {
    if (-not (Test-Path $Target)) {
        New-Item -Path $Target -ItemType Directory -Force
    }

    $data = Get-Content -Raw -Path $List | ConvertFrom-Json

    Write-Output "Generating Software in $Target"

    $data | ForEach-Object {
        Get-Software $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## software.json

```json
[
    {
        "name": "Visual Studio Code",
        "file": "vscode.exe",
        "source": "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    },
    {
        "name": "git",
        "file": "git.exe",
        "source": "https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.1/Git-2.41.0-64-bit.exe"
    },
    {
        "name": ".NET SDK",
        "file": "dotnet.exe",
        "source": "https://download.visualstudio.microsoft.com/download/pr/2ab1aa68-3e14-401a-b106-833d66fa992b/060457e640f4095acf4723c4593314b6/dotnet-sdk-7.0.304-win-x64.exe"
    },
    {
        "name": "NodeJS LTS",
        "file": "node.msi",
        "source": "https://nodejs.org/dist/v18.16.0/node-v18.16.0-x64.msi"
    },
    {
        "name": "Azure CLI",
        "file": "azurecli.msi",
        "source": "https://aka.ms/installazurecliwindows"
    },
    {
        "name": "PowerShell",
        "file": "pwsh.msi",
        "source": "https://github.com/PowerShell/PowerShell/releases/download/v7.2.11/PowerShell-7.2.11-win-x64.msi"
    },
    {
        "name": "SQL Server Express",
        "file": "sql-express.exe",
        "source": "https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us"
    },
    {
        "name": "Azure Data Studio",
        "file": "azure-data-studio.exe",
        "source": "https://go.microsoft.com/fwlink/?linkid=2237020"
    },
    {
        "name": "Docker Desktop",
        "file": "docker.exe",
        "source": "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    },
    {
        "name": "Windows Terminal",
        "file": "terminal.msixbundle",
        "source": "https://github.com/microsoft/terminal/releases/download/v1.17.11461.0/Microsoft.WindowsTerminal_1.17.11461.0_8wekyb3d8bbwe.msixbundle"
    },
    {
        "name": "PowerToys",
        "file": "powertoys.exe",
        "source": "https://github.com/microsoft/PowerToys/releases/download/v0.70.1/PowerToysSetup-0.70.1-x64.exe"
    },
    {
        "name": "WSL2 Linux Kernel Update Package",
        "file": "wsl-update.msi",
        "source": "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    },
    {
        "name": "Ubuntu",
        "file": "ubuntu.appx",
        "source": "https://aka.ms/wslubuntu2204"
    }
]
```