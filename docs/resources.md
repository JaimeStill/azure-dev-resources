# Resources
[Home](./index.md)

All of the required dependencies specified below can be acquired by running the [Build-DotnetCache.ps1](./scripts/Build-DotnetCache.md) script for the .NET SDK and .NET CLI tools, and the [Build-ResourceCache.ps1](./scripts/Build-ResourceCache.md) script for the remaining resources. These resources can then be transported to a disconnected network and used to setup the underlying dev environment.

Name | Description
-----|------------
[Visual Studio Code](https://code.visualstudio.com/) | A streamlined code editor with support for development operations like debugging, task running, and version control.
[git](https://git-scm.com/) | Distributed version control system designed to handle everything from small to very large projects with speed and efficiency
[.NET SDK](https://dotnet.microsoft.com/en-us/) | Free, open-source, cross-platform framework for building modern apps and powerful cloud services. Installer generated via [Build-DotnetCache.ps1](./scripts/Build-DotnetCache.md).
[Node.js (LTS)](https://nodejs.org/) | An open-source, cross-platform JavaScript runtime environment. Includes [npm](https://www.npmjs.com/), the package manager necessary for building JavaScript-based projects.
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) | A set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation.
[PowerShell](https://learn.microsoft.com/en-us/powershell/) | Cross-platform automation and configuration tool / framework that works well with existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models.
[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) | A free edition of SQL Server, ideal for development and production for desktop, web, and small server applications. For local development to prevent unnecessary charges developing directly against Azure SQL.
[Azure Data Studio](https://azure.microsoft.com/en-us/products/data-studio) | A modern open-source, cross-platform hybrid data analytics tool designed to simplify the data landscape. It's built for data professionals who use SQL Server and Azure databases on-premises or in multicluod environments.
[Docker Desktop](https://www.docker.com/products/docker-desktop/) | An application that enables you to build, manage, and share containerized applications and microservices.
[Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/) | A modern, fast, efficient, powerful, and productive terminal application for users of command-line tools and shells like Command Prompt, Powershell, and WSL. [Installation](https://github.com/microsoft/terminal#other-install-methods).
[PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/) | A set of utilities for power users to tune and streamline their Windows experience for greater productivity.

## .NET SDK and .NET CLI Tools

The [Build-DotnetCache.ps1](./scripts/Build-DotnetCache.md) script provides a configurable way of downloading the latest installer for the .NET SDK. It is a trimmed down version of the [dotnet-install script](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script) that is purely focused on acquiring the latest installation package. The trimmed down options, derived from the [dotnet-install script - Options](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options)

* The system architecture (see [`--architecture`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options)):
    * `<auto>`
    * `amd64`
    * `x64`
    * `x86`
    * `arm64`
    * `arm`
    * `s390x`
    * `ppc64le`

* The intended channel (see [`--channel`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options)):
    * `STS` - the most recent Standard Term Support release
    * `LTS` - the most recent Long Term Support release
    * `Major.Minor` semantic version (i.e. `3.1` or `6.0`)
    * `Major.Minor.Patch` semantic version for a specific SDK release (i.e. - `6.0.1xx` or `6.0.2xx`)

* The target operating system (see [`--os`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#options)):
    * `win`
    * `linux`
    * `linux-musl`
    * `osx`
    * `freebsd`

Additionally, the [Build-DotnetCache.ps1](./scripts/Build-DotnetCache.md) provides the ability to cache global [.NET CLI tools](https://learn.microsoft.com/en-us/dotnet/core/tools/global-tools). These are optional enhancements to the .NET CLI that extend the functionality of the CLI. For instance, the [dotnet-ef](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) command line tool provides a CLI interface for working with [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/). The CLI tools for Entity Framework Core perform design-time development tasks. For example, they create migrations, apply migrations, and generate code for a model based on an existing database.

The configuration for specifying tools is:

```jsonc
"tools": {
    // sub-directory to store cached tools
    "target": "tools",
    // list of tools to cache
    // 
    "data": [
        "dotnet-ef",
        // can specify a specific version
        "dotnet-serve@1.10.172",
        // ending in ! indicates --prerelease
        "dotnetsay!"
    ]
}
```

Once cached, you can copy the contents of `tools` to the global path (`$env:USERPROFILE\.dotnet\tools` on windows or `~/.dotnet/tools` on linux) and the tools will become globally available.

## SQL Server 2022 Express

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