# OS Configuration
[Home](./index.md)

The following sections outline the configurations and infrastructure needed to facilitate containerized cloud development on a development machine lacking a connection to the internet.

> All of the required dependencies specified below can be bundled into a single directory by running the [Build-DevResources.ps1](./scripts/Build-DevResources.md) script.

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
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile ubuntu.appx

Add-AppxPackage .\ubuntu.appx
```

## Software

Name | Description
-----|------------
[Visual Studio Code](https://code.visualstudio.com/) | A streamlined code editor with support for development operations like debugging, task running, and version control.
[git](https://git-scm.com/) | Distributed version control system designed to handle everything from small to very large projects with speed and efficiency
[.NET SDK](https://dotnet.microsoft.com/en-us/) | Free, open-source, cross-platform framework for building modern apps and powerful cloud services.
[Node.js (LTS)](https://nodejs.org/) | An open-source, cross-platform JavaScript runtime environment. Includes [npm](https://www.npmjs.com/), the package manager necessary for building JavaScript-based projects.
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) | A set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation.
[PowerShell](https://learn.microsoft.com/en-us/powershell/) | Cross-platform automation and configuration tool / framework that works well with existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models.
[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) | A free edition of SQL Server, ideal for development and production for desktop, web, and small server applications. For local development to prevent unnecessary charges developing directly against Azure SQL.
[Azure Data Studio](https://azure.microsoft.com/en-us/products/data-studio) | A modern open-source, cross-platform hybrid data analytics tool designed to simplify the data landscape. It's built for data professionals who use SQL Server and Azure databases on-premises or in multicluod environments.
[Docker Desktop](https://www.docker.com/products/docker-desktop/) | An application that enables you to build, manage, and share containerized applications and microservices.
[Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/) | A modern, fast, efficient, powerful, and productive terminal application for users of command-line tools and shells like Command Prompt, Powershell, and WSL. [Installation](https://github.com/microsoft/terminal#other-install-methods).
[PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/) | A set of utilities for power users to tune and streamline their Windows experience for greater productivity.

## Extensions

**Visual Studio Code**

Extension | Description
----------|------------
[Angular Language Service](https://marketplace.visualstudio.com/items?itemName=Angular.ng-template) | Provides a rich editing experience for Angular templates, both inline and external templates.
[C# Dev Kit](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit) | Enhances your C# environment by adding a set of powerful tools and utilities that integrate natively with VS Code to help C# developers write, debug, and maintain their code faster and with fewer errors.
[Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) | Makes it easy to build, maange, and deploy containerized applications from Visual Studio Code. It also provides one-click debugging of Node.js, Python, and .NET inside a container.
[EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) | Override user / workspace settings with settings found in `.editorconfig` files.
[GitHub Markdown Preview](https://marketplace.visualstudio.com/items?itemName=bierner.github-markdown-preview) | Changes VS Code's built-in markdown preview to match GitHub markdown rendering in style and content.
[GitHub Theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme) | GitHub's VS Code themes
[PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell) | Provides rich PowerShell language support for Visual Studio Code. Write and debug PowerShell scripts using teh IDE-like interface that VS Code provides.
[Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) | Allows you to open any folder in a container, on a remote machine, or in the Windows Subsystem for Linux (WSL) and take advantage of VS Code's full feature set.
[Task Explorer](https://marketplace.visualstudio.com/items?itemName=spmeesseman.vscode-taskexplorer) | Provides a view in either (or both) the Sidebar and/or Explorer that displays all supported tasks organized into a treeview, with parent task file nodes, grouped nodes, and project folders. Tasks can be opened for view/edit, executed, and stopped, among other things for specific task types, via context menu.
[Thunder Client](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client) | A lightweight Rest API client extension for VS Code wiht simple and clean design.
[YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) | Provides comprehensive YAML Language support to VS Code with built-in Kubernetes syntax support.

**Azure Data Studio**  

Encountered the following installing PostgreSQL extension:
```
Downloading https://github.com/Microsoft/pgtoolsservice/releases/download/v1.7.1/pgsqltoolsservice-win-x64.zip
(180574 KB)....................Done!
Installing pgSQLToolsService to c:\Users\<user>\.azuredatastudio\extensions\microsoft.azuredatastudio-postgresql-0.3.1\out\ossdbtoolsservice\Windows\v1.7.1
Installed
```

Extension | Description
----------|------------
[Admin Pack for SQL Server](https://github.com/microsoft/azuredatastudio/tree/main/extensions/admin-pack) | A collection of popular database administration extension to help you manage SQL Server.
[Database Admin Tool Extensions for Windows](https://github.com/microsoft/azuredatastudio/tree/main/extensions/admin-tool-ext-win) | Adds Windows-specific functionality into Azure data Studio. Includes the ability to launch a set of SQL Server Management Studio experiences directly from Azure Data Studio.
[PostgreSQL](https://github.com/microsoft/azuredatastudio-postgresql) | Connect, query, and manage Postgres databases with Azure Data Studio.
[Query History](https://github.com/microsoft/azuredatastudio/tree/main/extensions/query-history) | Adds a Query History view for viewing and running past executed queries.

## Managing Ubuntu

See [How to Update Ubuntu Offline without Internet Connection](https://www.debugpoint.com/how-to-update-or-upgrade-ubuntu-offline-without-internet/) and verify.

[How to get the updating list and import to my offline computer](https://unix.stackexchange.com/questions/649476/how-to-get-the-updating-list-and-import-to-my-offline-computer)

**Installing Packages Offline**  

* https://unix.stackexchange.com/questions/657165/how-to-install-locally-stored-deb-packages
* [apt-offline](https://manpages.ubuntu.com/manpages/bionic/man8/apt-offline.8.html)
* https://superuser.com/questions/393109/how-can-i-download-ubuntu-packages-in-windows-to-install-them-on-an-offline-ubun
* https://www.nstec.com/how-to-install-software-on-linux-without-internet-connection/
* https://unix.stackexchange.com/questions/574266/problem-downloading-a-package-and-installing-it-without-internet-on-ubuntu-18-04
* https://unix.stackexchange.com/questions/159094/how-to-install-a-deb-file-by-dpkg-i-or-by-apt

## Configurations for Offline Environments

The following steps will be used to adjust settings for disabling background network traffic that will never succeed in an offline environment.

### Environment Variables

1. Type <kbd>Win + R</kbd> to open the **Run...** prompt, type **SystemPropertiesAdvanced**, press <kbd>Enter</kbd>, then click **Environment Variables...**

2. In **System variables**, using the **New...** button, add teh following:

    Variable | Value
    ---------|------
    `POWERSHELL_TELEMTRY_OPTOUT` | 1
    `POWERSHELL_UPDATECHECK` | 0
    `POWERSHELL_UPDATECHECK_OPTOUT` | 1

3. Click **OK** and close all windows created from this task.

### Visual Studio Code

Press <kbd>F1</kbd> -> **Preferences: Open Settings (JSON)**:

```json
{
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "telemetry.enableCrashReporter": false,
    "telemetry.enableTelemetry": false,
    "update.enableWindowsBackgroundUpdates": false,
    "update.mode": "none"
}
```

[Home](./index.md)