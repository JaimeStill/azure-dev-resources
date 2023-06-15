# Build-CodeExtensions.ps1
[Home](../index.md) | [Scripts](./index.md)

```powershell
param(
    [string]
    [Parameter()]
    $Target = "..\bundle\extensions\code",
    [string]
    [Parameter()]
    $Extensions = "data\code-extensions.json"
)

function Get-CodeExtension([psobject] $extension, [string] $path) {
    Write-Output "Retrieving $($extension.label)"
    
    Write-Output "Getting Version Number for $($extension.label)"

    $uri = "https://marketplace.visualstudio.com/items?itemName=$($extension.publisher).$($extension.name)"
    $content = Invoke-RestMethod -Uri $uri
    $content -match '<script class="jiContent" defer="defer" type="application/json">.*</script>' | Out-Null
    $json = $Matches[0] -replace '<script class="jiContent" defer="defer" type="application/json">' -replace '</script>'
    $json = $json | ConvertFrom-Json

    Write-Output "Generating Download URI for $($extension.label).$($json.Resources.Version)"

    $download = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$($extension.publisher)/vsextensions/$($extension.name)/$($json.Resources.Version)/vspackage"

    $output = Join-Path $path "$($extension.name).$($json.Resources.Version).vsix"

    if (Test-Path $output) {
        Remove-Item $output -Force
    }

    try {
        Write-Output "Downloading $($extension.label) from $download"
        Invoke-WebRequest -Uri $download -OutFile $output -MaximumRetryCount 3
        Write-Output "$($extension.label) successfully downloaded"
    }
    catch {
        Write-Error $_
    }
}

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

try {
    if (-not (Test-Path $Target)) {
        New-Item -Path $Target -ItemType Directory -Force
    }

    $exts = Get-Content -Raw -Path $Extensions | ConvertFrom-Json

    Write-Output "Generating Code Extensions in $Target"

    $exts | ForEach-Object {
        Get-CodeExtension $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}
```

## code-extensions.json

```json
[
    {
        "publisher": "angular",
        "name": "ng-template",
        "label": "Angular Language Service"
    },
    {
        "publisher": "ms-dotnettools",
        "name": "csdevkit",
        "label": "C# Dev Kit"
    },
    {
        "publisher": "ms-azuretools",
        "name": "vscode-docker",
        "label": "Docker"
    },
    {
        "publisher": "editorconfig",
        "name": "editorconfig",
        "label": "EditorConfig"
    },
    {
        "publisher": "bierner",
        "name": "github-markdown-preview",
        "label": "GitHub Markdown Preview"
    },
    {
        "publisher": "github",
        "name": "github-vscode-theme",
        "label": "GitHub Theme"
    },
    {
        "publisher": "ms-vscode",
        "name": "powershell",
        "label": "PowerShell"
    },
    {
        "publisher": "ms-vscode-remote",
        "name": "vscode-remote-extensionpack",
        "label": "Remote Development"
    },
    {
        "publisher": "spmeesseman",
        "name": "vscode-taskexplorer",
        "label": "Task Explorer"
    },
    {
        "publisher": "rangav",
        "name": "vscode-thunder-client",
        "label": "Thunder Client"
    },
    {
        "publisher": "redhat",
        "name": "vscode-yaml",
        "label": "YAML"
    }
]
```