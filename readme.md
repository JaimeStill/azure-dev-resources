# Azure Dev Resources

* [npm]()
* [NuGet]()
* [Azure CLI]()
* [Docker]()
* []

Resource | Description | Notes
---------|-------------|------
NuGet packages | .NET (C#) dependencies | Any networked file-share should be able to serve as a resolution point for NuGet packages, configurable via `dotnet nuget` commands.

## OS Configuration

### WSL + Ubuntu

https://learn.microsoft.com/en-us/windows/wsl/install-manual

```PowerShell
# enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# enable virtual machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Download and install the [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

```PowerShell
# Set WSL2 as your default version
wsl --set-default-version 2
```

[Download](https://learn.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions) a Linux Distribution:

```PowerShell
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile ubuntu.appx -UseBasicParsing

Add-AppxPackage
```

## Software

* Visual Studio Code
    * Extensions
* Windows Terminal
    * [Installation](https://github.com/microsoft/terminal#other-install-methods)
* Node.js (LTS)
* .NET SDK
* Git
* PowerShell Core
* Azure CLI
* Docker Desktop
* SQL Server Express
    * For local dev to prevent unnecessary Azure SQL charges
* Azure Data Studio and / or SQL Server Management Studio

### Configurations for Offline Environments

## Ubuntu Software

## npm

Node.JS (JavaScript / TypeScript) dependencies.

### Self-Hosting

Project-local dependency cache strategy has been established. No strategy for self-hosting an npm registry yet. [verdaccio](https://verdaccio.org/) looks promising, but need to prove it out.

## NuGet

.NET (C#) dependencies. 

### Self-Hosting

Any networked file-share should be able to serve as a resolution point for NuGet packages, configurable via `dotnet nuget` commands.

### Internal NuGet Packages

Internal NuGet packages should be managed and published on an unclassfied network and resolved with all additional external dependencies out outlined in the above *Self-Hosting* section.

* Internal NuGet Package Strategy
* Internal NuGet CI / CD Actions

## Docker Images