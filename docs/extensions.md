# Extensions

> All of the extensions specified below can be bundled into a single directory by running the [Build-AdsExtensions.ps1](./scripts/Build-AdsExtensions.md) and [Build-CodeExtensions.ps1](./scripts/Build-CodeExtensions.md) scripts.

## Azure Data Studio

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

### Scripted ADS Extension Cache

The PowerShell script [Build-AdsExtensions.ps1](./scripts/Build-AdsExtensions.md) defines the ability to generate a cache of Azure data Studio extensions. The cached extensions are defined in a provided [JSON file](./scripts/Build-AdsExtensions.md#ads-extensionsjson). The cached extensiosn can then be transported to a disconnected network for local use.

Paramter | Type | Default Value | Description
---------|------|---------------|------------
Target | **string** | `..\bundle\extensions\ads` | The cache target directory
Source | **string** | `data\ads-extensions.json` | The JSON file containing extension metadata in the JSON Schema outlined below

#### JSON Schema

An array of objects that provide metadata for acquiring an Azure Data Studio extension:

Property | Description
---------|------------
`name` | the name of the extension
`file` | the cached extension file name
`source` | the URI for acquiring the extension

## Visual Studio Code

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

### Scripted Code Extension Cache

The PowerShell script [Build-CodeExtensions.ps1](./scripts/Build-CodeExtensions.md) defines the ability to generate a cache of Visual Studio Code extensions. The cached extensions are defined in a provided [JSON file](./scripts/Build-CodeExtensions.md#code-extensionsjson), and the script retrieves the latest version of the specified extension. The cached extensiosn can then be transported to a disconnected network for local use.

Paramter | Type | Default Value | Description
---------|------|---------------|------------
Target | **string** | `..\bundle\extensions\vs-code` | The cache target directory
Source | **string** | `data\code-extensions.json` | The JSON file containing extension metadata in the JSON Schema outlined below

#### JSON Schema

An array of objects that provide metadata for acquiring a Visual Studio Code extension:

Property | Description
---------|------------
`publisher` | the name of the extension publisher
`name` | the registered name of the extension
`label` | a display-friendly label for the extension