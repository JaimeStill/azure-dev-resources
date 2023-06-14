param(
    [string]
    [Parameter()]
    $Cache = "node_cache",
    [string]
    [Parameter()]
    $Source = "data\package.json",
    [string]
    [Parameter()]
    $Name = "cache",
    [string]
    [Parameter()]
    $Version = "0.0.1",
    [string]
    [Parameter()]
    $Target = "..\npm"
)

function Merge-NpmDependencies([psobject] $package, [psobject] $deps) {
    foreach ($prop in $deps.PSObject.Properties) {
        $package | Add-Member -Name $prop.Name -Value $prop.Value -MemberType $prop.MemberType
    }
}

if (Test-Path $Target) {
    Remove-Item $Target -Recurse -Force
}

New-Item -Path $Target -ItemType Directory -Force
New-Item (Join-Path $Target ".npmrc") -ItemType File -Value "cache=./$Cache"

$deps = Get-Content -Raw -Path $Source | ConvertFrom-Json

$package = @"
{
    "name": "$Name",
    "version": "$Version"
}
"@ | ConvertFrom-Json

Merge-NpmDependencies $package $deps

New-Item (Join-Path $Target "package.json") -ItemType File -Value ($package | ConvertTo-Json)

$path = Get-Location

Set-Location $Target

& npm install

Remove-Item node_modules -Recurse -Force

Set-Location $path