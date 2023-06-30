# Resources
[Home](./index.md)

All of the required dependencies specified below can be bundled into a single directory by running the [Build-ResourceCache.ps1](./scripts/Build-ResourceCache.md) script. These resources can then be transported to a disconnected network and used to setup the underlying dev environment.

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

### SQL Server 2022 Express

After downloading the SQL Server 2022 Express installer, it needs to be launched so that the installation files can be installed. To do so, click the **Download Media** link after launching the installer:

![download-media](https://github.com/JaimeStill/azure-dev-resources/assets/14102723/bd62d17a-36b5-420b-910a-c766ca94519c)  

Select **Express Advanced** and target a directory in your `bundle\resources` directory to store the installation files (in this case, `bindle\resources\sql-server-2022-express`):

![installer-download](https://github.com/JaimeStill/azure-dev-resources/assets/14102723/1cf970a6-59fb-403e-b872-3c6e6986cd7c)

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