param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$temp = '.\temp'
$distro = 'ubuntu'
$kernelUri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_$($Config.arch).msi"
$ubuntuUri = 'https://aka.ms/wslubuntu'
$filter = "Ubuntu.+($($Config.arch))+.appx"

Write-Host "Generating WSL cache..." -ForegroundColor Blue

if (Test-Path $temp) {
    Remove-Item $temp -Recurse -Force
}

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -ItemType Directory -Force

Invoke-WebRequest -Uri $kernelUri -OutFile (Join-Path $Config.target "wsl-kernel-$($Config.arch).msi") -MaximumRetryCount 10

Invoke-WebRequest -Uri $ubuntuUri -OutFile "$distro.appx" -MaximumRetryCount 10

Expand-Archive "$distro.appx" $temp

$package = (Get-ChildItem "$temp" -File `
    | Select-Object Name `
    | Select-String -Pattern $filter `
).Matches.Value

Expand-Archive (Join-Path $temp $package) (Join-Path $Config.target $distro)

Remove-Item "$distro.appx" -Force
Remove-Item $temp -Recurse -Force

Write-Host "WSL cache successfully generated!" -ForegroundColor Green