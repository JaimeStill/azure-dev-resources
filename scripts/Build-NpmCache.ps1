param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Merge-NpmDependencies([psobject] $package, [psobject] $deps) {
    foreach ($prop in $deps.PSObject.Properties) {
        $package | Add-Member -Name $prop.Name -Value $prop.Value -MemberType $prop.MemberType
    }
}

function Set-Environment([PSObject] $vars) {
    $vars | ForEach-Object {
        Set-Item -Path "env:\$($_.key)" -Value "$($_.value)"
    }
}

function Clear-Environment([PSObject] $vars) {
    $vars | ForEach-Object {
        Remove-Item -Path "env:\$($_.key)"
    }
}

function Build-NpmProjects([psobject] $projects, [string] $dir) {
    $path = Get-Location

    $projects | ForEach-Object {
        $project = Join-Path $dir $_.name

        $package = @{
            name    = $_.name
            version = $_.version
        }

        Merge-NpmDependencies $package $_.packages

        if (Test-Path $project) {
            Remove-Item $project -Recurse -Force
        }

        New-Item -Path $project -ItemType Directory -Force
        New-Item (Join-Path $project ".npmrc") -ItemType File -Value "cache=./$($_.cache)"
        New-Item (Join-Path $project "package.json") -ItemType File -Value ($package | ConvertTo-Json)

        Set-Location $project

        & npm install

        if (Test-Path node_modules) {
            Remove-Item node_modules -Recurse -Force
        }

        Set-Location $path
    }
}

function Build-GlobalBinary([PSObject] $binary, [string] $dir) {
    $cache = Join-Path $dir $binary.target

    if (Test-Path $cache) {
        Remove-Item $cache -Force -Recurse
    }

    New-Item $cache -ItemType Directory -Force

    $file = Join-Path $cache $binary.file

    Invoke-RestMethod -Uri $binary.source -OutFile $file -MaximumRetryCount 10
}

function Build-GlobalNpm([psobject] $globe, [string] $dir) {
    if ($null -ne $globe.environment) {
        Set-Environment $globe.environment
    }

    try {
        if (Test-Path $dir) {
            Remove-Item $dir -Recurse -Force
        }

        New-Item $dir -ItemType Directory -Force

        if ($null -ne $globe.packages) {
            $globe.packages | ForEach-Object {
                & npm i -g $_ --prefix $dir
            }
        }

        if ($null -ne $globe.binaries) {
            $globe.binaries | ForEach-Object {
                Build-GlobalBinary $_ $dir
            }
        }
    }
    finally {
        if ($null -ne $globe.environment) {
            Clear-Environment $globe.environment
        }
    }
}

try {
    Write-Host "Generating npm cache..." -ForegroundColor Blue

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    if ($null -ne $Config.projects) {
        Build-NpmProjects $Config.projects $Config.target
    }

    if ($null -ne $Config.global) {
        Build-GlobalNpm $Config.global (Join-Path $Config.target $Config.global.target)
    }

    Write-Host "npm cache successfully generated!" -ForegroundColor Green
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}