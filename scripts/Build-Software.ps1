param(
    [string]
    [Parameter()]
    $Target = "..\bundle\software",
    [string]
    [Parameter()]
    $List = "data\software.json"
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Get-Software([psobject] $software, [string] $dir) {
    Write-Output "Retrieving $($software.name) from $($software.source)"

    $output = Join-Path $dir $software.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    try {
        Invoke-WebRequest -Uri $software.source -OutFile $output -MaximumRetryCount 3
        Write-Output "$($software.name) successfully retrieved"
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

    Write-Output "Generating Software in $Target"

    $data | ForEach-Object {
        Get-Software $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}