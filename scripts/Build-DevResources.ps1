param(
    [string]
    [Parameter()]
    $Config = "config\new-build.json"
)

$data = Get-Content -Raw -Path $Config | ConvertFrom-Json

if ($null -ne $data) {
    if (! (Test-Path $data.target)) {
        New-Item $data.target -ItemType Directory -Force
    }

    foreach ($prop in $($data | Select-Object -ExcludeProperty target).PSObject.Properties) {
        $data.$($prop.Name).target = Join-Path $data.target $prop.Value.target
    }

    if ($null -ne $data.ads) {
        .\Build-AdsExtensions.ps1 -Config $data.ads
    }

    if ($null -ne $data.docker) {
        .\Build-DockerCache.ps1 -Config $data.docker
    }

    if ($null -ne $data.dotnet) {
        .\Build-DotnetCache.ps1 -Config $data.dotnet
    }

    if ($null -ne $data.linux) {
        .\Build-LinuxCache.ps1 -Config $data.linux
    }

    if ($null -ne $data.npm) {
        .\Build-NpmCache.ps1 -Config $data.npm
    }

    if ($null -ne $data.nuget) {
        .\Build-NugetCache.ps1 -Config $data.nuget
    }

    if ($null -ne $data.resources) {
        .\Build-ResourceCache.ps1 -Config $data.resources
    }

    if ($null -ne $data.vscode) {
        .\Build-CodeExtensions.ps1 -Config $data.vscode
    }

    if ($null -ne $data.wsl) {
        .\Build-WslCache.ps1 -Config $data.wsl
    }
}
else {
    Write-Error "$Config was not found"
}