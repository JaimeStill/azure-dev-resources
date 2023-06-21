param(
    [string]
    [Parameter()]
    $Target = ".\.cache",
    [string]
    [Parameter()]
    $Source = ".\package.json",
    [string]
    [Parameter()]
    [ValidateSet("npm", "pnpm")]
    $PackageManager = "npm",
    [switch]
    [Parameter()]
    $PackDependencies
)

$script:packages = @();

function Build-PackageManagerCache {
    $cache = Join-Path $Target $PackageManager

    if (-not (Test-Path $cache)) {
        New-Item $cache -ItemType Directory -Force | Out-Null
    }

    return $cache
}

function Get-DependencyDetails([string] $name, [string] $version) {
    Write-Host "Retrieving details for $($name)@$($version)"
    return . npm view "$name@$version" --json | ConvertFrom-Json
}

function Write-NpmCache([psobject] $package) {
    Write-Host "Caching $($package.name)@$($package.version) to $cache"
    return . npm cache add "$($package.name)@$($package.version)" --cache $cache
}

function Write-PnpmCache([psobject] $package) {
    Write-Host "Caching $($package.name)@$($package.version) to $cache"
    return . pnpm store add "$($package.name)@$($package.version)" --store-dir $cache
}

function Write-DependencyPack([psobject] $package) {
    $path = Join-Path $Target $package.name

    if (-not (Test-Path $path)) {
        New-Item $path -ItemType Directory -Force | Out-Null
    }

    Write-Host "Packing $($package.name)@$($package.version) to $path"
    . npm pack "$($package.name)@$($package.version)" --pack-destination $path --silent
}

function Get-SemVersions([string] $name, [string] $semver) {
    $filter = '(?<=.?)(\d+\.){2}\d$'

    if ($semver -match '^\^{1}') {
        $filter = '(?<=.?)(\d+\.){1}'
    }
    
    if ($semver -match '^\~{1}') {
        $filter = '(?<=.?)(\d+\.){2}'
    }

    $semver -match $filter | Out-Null

    $filter = "^$($Matches[0])[\d\.]*$"

    $versions = . npm view $name versions --json | ConvertFrom-Json | Where-Object { $_ -Match $filter }

    return $versions
}

function Write-DependencyCache([string] $name, [string] $semver) {
    if (-not ($script:packages -contains "$($name)@$($semver)")) {
        $script:packages += "$($name)@$($semver)"

        $versions = Get-SemVersions $name $semver

        foreach ($version in $versions) {
            $details = Get-DependencyDetails $name $version

            foreach ($package in $details) {
                if (-not ($script:packages -contains "$($package.name)@$($package.version)")) {
                    $script:packages += "$($package.name)@$($package.version)"

                    switch ($PackageManager) {
                        "npm" { Write-NpmCache $package }
                        "pnpm" { Write-PnpmCache $package }
                    }

                    if ($PackDependencies) {
                        Write-DependencyPack $package
                    }

                    foreach ($dep in $package.peerDependencies.PSObject.Properties) {
                        if ($dep.Value -match "\|\|") {
                            foreach ($version in $($dep.Value -split "\|\|")) {
                                Write-DependencyCache $dep.Name $version
                            }
                        }
                        else {
                            Write-DependencyCache $dep.Name $dep.Value
                        }
                    }

                    foreach ($dep in $package.dependencies.PSObject.Properties) {
                        if ($dep.Value -match "\|\|") {
                            foreach ($version in $($dep.Value -split "\|\|")) {
                                Write-DependencyCache $dep.Name $version
                            }
                        }
                        else {
                            Write-DependencyCache $dep.Name $dep.Value
                        }
                    }

                    foreach ($dep in $package.optionalDependencies.PSObject.Properties) {
                        if ($dep.Value -match "\|\|") {
                            foreach ($version in $($dep.Value -split "\|\|")) {
                                Write-DependencyCache $dep.Name $version
                            }
                        }
                        else {
                            Write-DependencyCache $dep.Name $dep.Value
                        }
                    }
                }
            }
        }
    }
}

if (Get-Command $PackageManager) {
    $data = Get-Content -Raw -Path $Source | ConvertFrom-Json

    if (Test-Path $Target) {
        Remove-Item $Target -Recurse -Force
    }

    $cache = Build-PackageManagerCache

    foreach ($dep in $data.dependencies.PSObject.Properties) {
        Write-DependencyCache $dep.Name $dep.Value
    }

    Write-Host "Finished generating Node dependencies!" -ForegroundColor Green
}
else {
    Write-Error "Cannot find $PackageManager"
}