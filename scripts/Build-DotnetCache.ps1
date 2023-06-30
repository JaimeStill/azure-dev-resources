param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Install-DotnetTool([string] $tool, [string] $dir) {
    if ($tool.Contains('@')) {
        $split = $tool.Split('@')
        $tool = $split[0]
        $version = $split[1]

        & dotnet tool install $tool --tool-path $dir --version $version
    }
    else {
        if ($tool.EndsWith('!')) {
            & dotnet tool install $tool -tool-path $dir --prerelease
        }
        else {
            & dotnet tool install $tool --tool-path $dir
        }
    }
}

function Build-DotnetSdk([PSObject] $sdk, [string] $dir) {
    $dotnetUrl = "https://dotnetcli.azureedge.net/dotnet/Sdk"

    $version = Invoke-RestMethod "$dotnetUrl/$($sdk.channel)/latest.version"
    $ext = $sdk.os -eq "win" ? "exe" : "tar.gz"

    $file = "dotnet-sdk-$version-$($sdk.os)-$($sdk.arch).$ext"
    $uri = "$dotnetUrl/$version/$file"

    Invoke-RestMethod "$uri" -OutFile (Join-Path $dir "$file")
}

function Build-DotnetTools([PSObject] $tools, [string] $dir) {
    if (Test-Path $dir) {
        Remove-Item $dir -Force -Recurse
    }

    New-Item $dir -ItemType Directory -Force

    $tools.data | ForEach-Object {
        Install-DotnetTool $_ $dir
    }
}

try {
    Write-Host "Generating .NET SDK cache..." -ForegroundColor Blue

    If (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    if ($null -ne $Config.sdk) {
        Build-DotnetSdk $Config.sdk $Config.target
    }

    if ($null -ne $Config.tools) {
        Build-DotnetTools $Config.tools (Join-Path $Config.target $Config.tools.target)
    }

    Write-Host ".NET SDK cache successfully generated!" -ForegroundColor Green
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}