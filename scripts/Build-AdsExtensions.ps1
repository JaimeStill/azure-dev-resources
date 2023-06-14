param(
    [string]
    [Parameter()]
    $Target = "..\bundle\extensions\ads",
    [string]
    [Parameter()]
    $List = "data\ads-extensions.json"
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-AdsExtension([psobject] $ext, [string] $dir) {
    Write-Output "Retrieving $($ext.name) from $($ext.source)"

    $output = Join-Path $dir $ext.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $ext.source -OutFile $output -MaximumRetryCount 3
        Write-Output "$($ext.name) successfully retrieved"
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

    Write-Output "Generating Azure Data Studio extensions in $Target"

    $data | ForEach-Object {
        Get-AdsExtension $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}