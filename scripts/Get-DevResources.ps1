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

. .\functions.ps1

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