# NuGet
[Home](./index.md)

.NET (C#) dependencies, known as [NuGet Packages](https://learn.microsoft.com/en-us/nuget/what-is-nuget).

## Hosting NuGet Packages

NuGet packages can be hosted in a variety of publicly routable locations including networked file shares, [Azure DevOps Artifacts](https://learn.microsoft.com/en-us/azure/devops/artifacts/get-started-nuget?view=azure-devops&tabs=windows) feeds, or an HTTP web server.

Once a feed has been established, you can view and mangage feeds via the .NET SDK. Here are a series of commands that are helpful for managing NuGet package feeds and cached data:

```bash
# show nuget sources
dotnet nuget list source

# add official nuget source
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

# add Azure Artifacts nuget source
dotnet nuget add source https://pkgs.dev.azure.com/dev/_packaging/feed/nuget/v3/index.json -n "Azure Cache"

# add internal nuget source
dotnet nuget add source "\\dev-share\nuget" -n "Internal Cache"

# remove nuget source
dotnet nuget remove source "Azure Cache"

# disable nuget source
dotnet nuget disable source "nuget.org"

# enable nuget source
dotnet nuget enable source "Internal Cache"

# list all cache directories
dotnet nuget locals all --list

# clear the global-packages cache
dotnet nuget locals global-packages --clear

# clear the http-cache
dotnet nuget locals http-cache --clear

# clear all caches
dotnet nuget locals all --clear
```

## Building a NuGet Cache

The PowerShell script [Build-NugetCache.ps1](./scripts/Build-NugetCache.md) defines the ability to generate a NuGet Package cache based on a series of dependencies defined in a provided [JSON file](./resources/solution.json). The generated cache can then be transported to a disconnected network and used to establish or update a NuGet package feed.

Parameter | Type | Default Value | Description
----------|------|---------------|------------
Target | **string** | `..\nuget-packages` | The cache target directory.
Source | **string** | `data\solution.json` | The JSON file containing information in the JSON Schema format outlined below.
Solution | **string** | `..\solution` | The directory to create the .NET solution used to generate the cache.
KeepSolution | **switch** | null | When present, do no remove the solution created to generate the cache.
SkipClean | **switch** | null | When present, prevent the script from cleaning the local NuGet cache (`dotnet nuget locals all --clear`).

### JSON Schema

An array of objects that provide metadata for a .NET project. Object schema is as follows:

Property | Description
---------|------------
`name` | the name of the project
`template` | the `dotnet new <template>` to use to generate the project
`framework` | the target framework when generating the project
`dependencies` | an array of NuGet packages dependencies to use with `dotnet add package <dependency>`. To specify a version, use the following format: `package@version`.

**Example**  

```json
[
    {
        "name": "Core",
        "template": "classlib",
        "framework": "net7.0",
        "dependencies": [
            "DocumentFormat.OpenXml",
            "Microsoft.Data.SqlClient",
            "Microsoft.EntityFrameworkCore",
            "Microsoft.EntityFrameworkCore.Design",
            "Microsoft.EntityFrameworkCore.Relational",
            "Microsoft.EntityFrameworkCore.SqlServer",
            "Microsoft.EntityFrameworkCore.Tools",
            "Microsoft.Extensions.Configuration.Abstractions",
            "Microsoft.Extensions.Configuration.Binder",
            "System.DirectoryServices",
            "System.DirectoryServices.AccountManagement"
        ]
    },
    {
        "name": "Web",
        "template": "webapi",
        "framework": "net7.0",
        "dependencies": [
            "Microsoft.AspNetCore.OData",
            "Microsoft.Data.SqlClient",
            "Swashbuckle.AspNetCore",
            "System.Linq.Dynamic.Core"
        ]
    }
]
```

## Internal NuGet Packages

Internal NuGet packages should be managed and published on an unclassfied network and resolved with all additional external dependencies.

### Publishing NuGet Updates

```bash
dotnet pack -c Release -o ./.nuget/

dotnet nuget push \
    ./.nuget/<Package>.<Version>.nupkg \
    --api-key <key> \
    --source https://api.nuget.org/v3/index.json \
    --skip-duplicate
```

### Automating NuGet Package Deployments

Deployment to NuGet can be automated through GitHub Actions:

```yaml
name: Pack and Push <Package> to NuGet

on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
jobs:
  build:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./<package-directory>/
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Set VERSION variable from tag
      run: echo "VERSION=${GITHUB_REF/refs\/tags\/v/}" >> $GITHUB_ENV
    - name: Build
      run: dotnet build -c Release /p:Version=${VERSION}
    - name: Pack
      run: dotnet pack -c Release /p:Version=${VERSION} --no-build --output .
    - name: Push
      run: >
        dotnet nuget push <Package>.${VERSION}.nupkg
            --source https://api.nuget.org/v3/index.json
            --api-key ${{ secrets.NUGET_KEY }}
            --skip-duplicate
```

To initiate an updated version, create a new GitHub Tag (this can be done at: `https://github.com/<User>/<Repo>/tags`) in the format of `v[0-9].[0-9].[0-9]`. This should be done after an approved pull request. 

## Configuration Hierarchy

> NuGet's behavior is driven by the accumulated settings in one or more `NuGet.Config` (XML) files that can exist at project-, user-, and machine-wide levels. A global `NuGetDefaults.Config` file also specifically configured package sources. Settings apply to all commands issued in the CLI, the Package Manager Console, and the Package Manager UI.
>
> [NuGet Microsoft Docs - Common NuGet Configurations](https://docs.microsoft.com/en-us/nuget/consume-packages/configuring-nuget-behavior)

Settings are applied from top to bottom, with more specific configs overwriting broader-level configs.

Scope | `NuGet.Config` File Location | Description
------|------------------------------|------------
Solution | Current folder (aka Solution folder) or any folder up to the drive root. | In a solution folder, settings apply to all projects in subfolders. Note that if a config file is placed in a project folder, it has no effect on that project.
User | **Windows**: `%appdata%\NuGet\NuGet.Config` <br />**Mac/Linux**: `~/.config/NuGet/NuGet.Config` or `~/.nuget/NuGet/NuGet.Config` (varies by OS distribution) | Settings apply to all operations, but are overridden by any project-level settings.
Computer | **Windows**: `%ProgramFiles(x86)%\NuGet\Config` <br />**Mac/Linux**: `$XDG_DATA_HOME`. If `$XDG_DATA_HOME` is null or empty, `~/.local/share` or `/usr/local/share` will be used (varies by OS distribution) | Settings apply to all operations on the computer, but are overridden by any user- or project-level settings.
    
[Home](./index.md)