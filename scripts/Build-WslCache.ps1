param(
    [string]
    [Parameter()]
    $Target = "..\wsl",
    [string]
    [Parameter()]
    [ValidateSet("x64", "arm64")]
    $Arch = "x64"
)

$temp = '.\temp'
$distro = 'ubuntu'
$kernelUri = "https://aka.ms/wsl2kernelmsi$Arch"
$ubuntuUri = 'https://aka.ms/wslubuntu'
$filter = "Ubuntu.+($Arch)+.appx"

Write-Host "Retrieving WSL Ubuntu Infrastructure"

if (Test-Path $temp) {
    Remove-Item $temp -Recurse -Force
}

if (Test-Path $Target) {
    Remove-Item $Target -Recurse -Force
}

New-Item $Target -ItemType Directory -Force

Invoke-WebRequest -Uri $kernelUri -OutFile (Join-Path $Target "wsl-kernel-$Arch.msi") -MaximumRetryCount 10

Invoke-WebRequest -Uri $ubuntuUri -OutFile "$distro.appx" -MaximumRetryCount 10

Expand-Archive "$distro.appx" $temp

$package = (Get-ChildItem "$temp" -File `
    | Select-Object Name `
    | Select-String -Pattern $filter `
).Matches.Value

Expand-Archive (Join-Path $temp $package) (Join-Path $Target $distro)

Remove-Item "$distro.appx" -Force
Remove-Item $temp -Recurse -Force