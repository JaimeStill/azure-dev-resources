param(
    [string]
    [Parameter()]
    $Bundle = "..\bundle",
    [string]
    [Parameter()]
    $DataPath = "data",
    [string]
    [Parameter()]
    $Resources = "resources.json"
)

function Build-Resources([string] $bundle, [string] $dataPath, [string] $list) {
    $data = Get-Content -Raw -Path (Join-Path $dataPath $list) | ConvertFrom-Json

    $data | ForEach-Object {
        Get-Resources (Join-Path $bundle $_.dir) (Join-Path $dataPath $_.list)
    }
}

function Get-Resources([string] $dir, [string] $list) {
    Write-Output "Writing resources from $list to $dir"

    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force
    }

    $data = Get-Content -Raw -Path $list | ConvertFrom-Json

    $data | ForEach-Object {
        Get-Resource $_ $dir
    }
}

function Get-Resource([psobject] $resource, [string] $dir) {
    Write-Output "Retrieving $($resource.name) from $($resource.source)"

    $output = Join-Path $dir $resource.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    Invoke-WebRequest -Uri $resource.source -OutFile $output -UseBasicParsing

    Write-Output "$($resource.name) successfully retrieved"
}

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

try {
    Write-Output "Bundling Azure Dev Resources..."

    Build-Resources $Bundle $DataPath $Resources

    Write-Output "Finished bundling Azure Dev Resources!"
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}