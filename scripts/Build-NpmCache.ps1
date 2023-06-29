param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

function Merge-NpmDependencies([psobject] $package, [psobject] $deps) {
    foreach ($prop in $deps.PSObject.Properties) {
        $package | Add-Member -Name $prop.Name -Value $prop.Value -MemberType $prop.MemberType
    }
}

Write-Host "Generating npm cache..." -ForegroundColor Blue

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -Recurse -Force

$Config.data | ForEach-Object {
    $project = Join-Path $Config.target $_.name

    $package = @{
        name = $_.name
        version = $_.version
    }

    Merge-NpmDependencies $package $_.packages

    New-Item -Path $project -ItemType Directory -Force
    New-Item (Join-Path $project ".npmrc") -ItemType file -Value "cache=./$($_.cache)"
    New-Item (Join-Path $project "package.json") -ItemType File -Value ($package | ConvertTo-Json)

    $path = Get-Location
    Set-Location $project

    & npm install

    if (Test-Path node_modules) {
        Remove-Item node_modules -Recurse -Force
    }

    Set-Location $path
}

Write-Host "npm cache successfully generated!" -ForegroundColor Green