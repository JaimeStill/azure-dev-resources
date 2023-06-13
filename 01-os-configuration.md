# OS Configuration

The following sections outline the configurations and infrastructure needed to facilitate containerized cloud development on a development machine lacking a connection to the internet.

## WSL + Ubuntu

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

> Ubuntu cloud images: https://cloud-images.ubuntu.com/releases

[Download](https://learn.microsoft.com/en-us/windows/wsl/install-manual#downloading-distributions) a Linux Distribution:

```PowerShell
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile ubuntu.appx -UseBasicParsing

Add-AppxPackage .\ubuntu.appx
```

## Software

Name | Description | Download | Notes
-----|-------------|------|------
[Visual Studio Code](https://code.visualstudio.com/) | A streamlined code editor with support for development operations like debugging, task running, and version control. | [Download](https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user)
[git](https://git-scm.com/) | Distributed version control system designed to handle everything from small to very large projects with speed and efficiency | [Download](https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.1/Git-2.41.0-64-bit.exe)
[.NET SDK](https://dotnet.microsoft.com/en-us/) | Free, open-source, cross-platform framework for building modern apps and powerful cloud services. | [Download](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-7.0.302-windows-x64-installer)
[Node.js (LTS)](https://nodejs.org/) | An open-source, cross-platform JavaScript runtime environment. | [Download](https://nodejs.org/dist/v18.16.0/node-v18.16.0-x64.msi) | Includes [npm](https://www.npmjs.com/), the package manager necessary for building JavaScript-based projects.
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) | A set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation. | [Download](https://aka.ms/installazurecliwindows)
[PowerShell](https://learn.microsoft.com/en-us/powershell/) | Cross-platform automation and configuration tool / framework that works well with existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models. | [Download](https://github.com/PowerShell/PowerShell/releases/download/v7.2.11/PowerShell-7.2.11-win-x64.msi)
[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) | A free edition of SQL Server, ideal for development and production for desktop, web, and small server applications. | [Download](https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us) | For local development to prevent unnecessary charges developing directly against Azure SQL.
[Azure Data Studio](https://azure.microsoft.com/en-us/products/data-studio) | A modern open-source, cross-platform hybrid data analytics tool designed to simplify the data landscape. It's built for data professionals who use SQL Server and Azure databases on-premises or in multicluod environments. | [Download](https://go.microsoft.com/fwlink/?linkid=2237020)
[Docker Desktop](https://www.docker.com/products/docker-desktop/) | An application that enables you to build, manage, and share containerized applications and microservices. | [Download](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
[Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/) | A modern, fast, efficient, powerful, and productive terminal application for users of command-line tools and shells like Command Prompt, Powershell, and WSL. | [Download](https://github.com/microsoft/terminal/releases/download/v1.17.11461.0/Microsoft.WindowsTerminal_1.17.11461.0_8wekyb3d8bbwe.msixbundle) | [Installation](https://github.com/microsoft/terminal#other-install-methods)
[PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/) | A set of utilities for power users to tune and streamline their Windows experience for greater productivity. | [Download](https://github.com/microsoft/PowerToys/releases/download/v0.70.1/PowerToysSetup-0.70.1-x64.exe)

## Code Extensions

## Managing Ubuntu

## Configurations for Offline Environments