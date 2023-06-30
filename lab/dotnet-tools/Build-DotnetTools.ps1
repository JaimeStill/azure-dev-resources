param(
    [string]
    [Parameter()]
    $Config = "tools.json"
)

function Install-DotnetTool([string] $tool, [string] $dir) {
    if ($tool.Contains('@')) {
        $split = $tool.Split('@')
        $tool = $split[0]
        $version = $split[1]

        & dotnet tool install $tool --tool-path $dir --version $version
    }
    else {
        if ($tool.EndsWith('!')) {
            & dotnet tool install $tool --tool-path $dir --prerelease
        }
        else {
            & dotnet tool install $tool --tool-path $dir
        }
    }
}

$meta = Get-Content -Raw -Path $Config | ConvertFrom-Json

if (Test-Path $meta.target) {
    Remove-Item $meta.target -Force -Recurse
}

New-Item $meta.target -ItemType Directory -Force

$meta.data | ForEach-Object {
    Install-DotnetTool $_ "$($meta.target)"
}