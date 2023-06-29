param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-AdsExtension([psobject] $ext, [string] $dir) {
    Write-Host "Retrieving $($ext.name) from $($ext.source)"

    $output = Join-Path $dir $ext.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $ext.source -OutFile $output -MaximumRetryCount 10 -RetryIntervalSec 6
        Write-Host "$($ext.name) successfully retrieved"
    }
    catch {
        Write-Error $_
    }
}

try {
    Write-Host "Generating Azure Data Studio extension cache..." -ForegroundColor Cyan

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    $Config.data | ForEach-Object {
        Get-AdsExtension $_ $Config.target
    }

    Write-Host "Azure Data Studio extension cache successfully generated!" -ForegroundColor Cyan
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}