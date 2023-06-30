param(
    [string]
    [Parameter()]
    $Config = "npm.json"
)

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

function Build-GlobalBinary([PSObject] $binary, [string] $dir) {
    $cache = Join-Path $dir $binary.target

    if (Test-Path $cache) {
        Remove-Item $cache -Force -Recurse
    }

    New-Item $cache -ItemType Directory -Force

    $file = Join-Path $cache $binary.file

    Invoke-RestMethod -Uri $binary.source -OutFile $file -MaximumRetryCount 10
}

$meta = Get-Content -Raw -Path $Config | ConvertFrom-Json

try {
    if (Test-Path $meta.target) {
        Remove-Item $meta.target -Force -Recurse
    }

    New-Item $meta.target -ItemType Directory -Force

    if ($null -ne $meta.environment) {
        Set-Environment $meta.environment
    }

    $meta.packages | ForEach-Object {
        & npm i -g $_ --prefix $meta.target
    }

    $meta.binaries | ForEach-Object {
        Build-GlobalBinary $_ $meta.target
    }
}
finally {
    if ($null -ne $meta.environment) {
        Clear-Environment $meta.environment
    }    
}