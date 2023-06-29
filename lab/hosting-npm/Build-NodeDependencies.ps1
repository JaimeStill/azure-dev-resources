param(
    [string]
    [Parameter()]
    $Target = ".\node_cache",
    [string]
    [Parameter()]
    $Source = ".\package.json",
    [string]
    [Parameter()]
    [ValidateSet("npm", "pnpm")]
    $PackageManager = "npm",
    [string]
    [Parameter()]
    $PackTarget = ".\.cache",
    [switch]
    [Parameter()]
    $CleanTarget,
    [switch]
    [Parameter()]
    $CleanPackTarget,
    [switch]
    [Parameter()]
    $PackDependencies
)

<#
    Keep track of all packages that are encountered
    to ensure they are only cached once.
#>
$script:packages = @();

<#
    Creates $dir if it does not exist.

    If $clean is provided, remove any pre-existing
    instances of $dir before creation logic.
#>
function Build-Directory([string] $dir, [switch] $clean) {
    if ($clean) {
        if (Test-Path $dir) {
            Remove-Item $dir -Recurse -Force
        }
    }

    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }
    
    return $dir
}

<#
    Get package.json for $name@$version
#>
function Get-Package([string] $name, [string] $version) {
    Write-Host "Retrieving package $name@$version"
    return . npm view "$name@$version" --json | ConvertFrom-Json
}

<#
    Use npm to cache $package.name@$package.version to $cache directory
#>
function Write-NpmCache([psobject] $package) {
    Write-Host "Caching $($package.name)@$($package.version) to $cache"
    return . npm cache add "$($package.name)@$($package.version)" --cache $cache
}

<#
    Use pnpm to cache $package.name@$package.version to pnpm store at $cache
#>
function Write-PnpmCache([psobject] $package) {
    Write-Host "Caching $($package.name)@$($package.version) to $cache"
    return . pnpm store add "$($package.name)@$($package.version)" --store-dir $cache
}

<#
    Pack the $package.name@$package.version tarball to $path
#>
function Write-DependencyPack([psobject] $package) {
    $path = Join-Path $PackTarget $package.name

    if (-not (Test-Path $path)) {
        New-Item $path -ItemType Directory -Force | Out-Null
    }

    Write-Host "Packing $($package.name)@$($package.version) to $path"
    . npm pack "$($package.name)@$($package.version)" --pack-destination $path --silent
}

<#
    Get all versions of a package that match the semantic version
    16.1.1  -> 16.1.1 (match exact version)
    ~16.1.1 -> 16.1.x (flexible patch version)
    ^16.1.1 -> 16.x.x (flexible major.patch version)
    See: https://docs.npmjs.com/about-semantic-versioning
#>
function Get-SemVersions([string] $name, [string] $semver) {
    # default filter to exact match
    $filter = '(?<=.?)(\d+\.){2}\d$'

    <#
        If $semver starts with ^,
        set filter to match 16.
    #>
    if ($semver -match '^\^{1}') {
        $filter = '(?<=.?)(\d+\.){1}'
    }
    
    <#
        If $semver starts with ~,
        set filter to match 16.1.
    #>
    if ($semver -match '^\~{1}') {
        $filter = '(?<=.?)(\d+\.){2}'
    }

    <#
        Initialize the match filter.
    #>
    $semver -match $filter | Out-Null

    <#
        Set filter to match semantic
        version only for official releases.

        If ~16.1.1:
        16.1.1          -> match
        16.1.4          -> match
        16.2.0          -> no match
        16.1.4-rc-next  -> no match
        
    #>
    $filter = "^$($Matches[0])[\d\.]*$"

    <#
        Get all versions of the package
        that match the semantic version filter.
    #>
    $versions = . npm view $name versions --json `
    | ConvertFrom-Json `
    | Where-Object { $_ -Match $filter }

    return $versions
}

<#
    Handle extended version formats before initiating
    the cache build to ensure all versions are accounted
    for.

    This currently only supports any variation of
    ~<version> || ^<version> || <version>.

    Will need to be extended to handle the following cases:
    * >version
    * >=version
    * <version
    * <=version
    * 1.2.x
    * * or ""
    * <version> - <version>

    See https://docs.npmjs.com/cli/v9/configuring-npm/package-json#dependencies
#>
function Build-Dependencies([psobject] $dependencies) {
    foreach ($dep in $dependencies.Properties) {
        if ($dep.Value -match "\|\|") {
            foreach ($version in $($dep.Value -split "\|\|").Trim()) {
                Build-DependencyCache $dep.Name $version
            }
        }
        else {
            Build-DependencyCache $dep.Name $dep.Value
        }
    }
}

<#
    Cache all relevant versions and its dependencies.
    If specified, pack the package tarball.
    Ensures a package is not cached more than once.
#>
function Build-DependencyCache([string] $name, [string] $semver) {
    <#
        Only proceed if the package has not been encountered yet.
    #>
    if (-not ($script:packages -contains "$name@$semver")) {
        $script:packages += "$name@$semver"
        Write-Host "Generating dependency cache for $name@$semver"

        $versions = Get-SemVersions $name $semver

        foreach ($version in $versions) {
            if (-not ($script:packages -contains "$name@$version")) {
                $script:packages += "$name@$version"
                $package = Get-Package $name $version

                <#
                    Cache using the appropriate package manager
                #>
                switch ($PackageManager) {
                    "npm" { Write-NpmCache $package }
                    "pnpm" { Write-PnpmCache $package }
                }

                if ($PackDependencies) {
                    Write-DependencyPack $package
                }

                Build-Dependencies $package.dependencies.PSObject
                Build-Dependencies $package.peerDependencies.PSObject
                Build-Dependencies $package.optionalDependencies.PSObject
            }
        }
    }
}

<#
    Ensure the specified package manager is installed
#>
if (Get-Command $PackageManager) {
    <#
        Get the package.json file specified at $Source
    #>
    $data = Get-Content -Raw -Path $Source | ConvertFrom-Json
    $guid = (New-Guid).ToString()

    Build-Directory $Target $CleanTarget
    $cache = Build-Directory (Join-Path $Target $PackageManager)

    if ($PackDependencies) {
        Build-Directory $PackTarget $CleanPackTarget
    }

    Build-Dependencies $data.dependencies.PSObject
    Build-Dependencies $data.devDependencies.PSObject
    Build-Dependencies $data.peerDependencies.PSObject
    Build-Dependencies $data.optionalDependencies.PSObject

    <#
        Write a file of all packages encountered
    #>
    $packages | Sort-Object | Out-File -Append (Join-Path $Target "packages-$guid.txt")

    Write-Host "Finished generating Node dependencies!" -ForegroundColor Green
}
else {
    Write-Error "Cannot find $PackageManager"
}