param(
    [string]
    [Parameter()]
    $Target = "../linux/apt-offline"
)

Write-Host "Caching apt-offline..." -ForegroundColor Blue

if (Test-Path $Target) {
    Remove-Item $Target -Recurse -Force
}

New-Item $Target -ItemType Directory -Force

. wsl -u root --exec ./cache-apt-offline.bash -t $Target

"apt install ./*.deb" | Out-File (Join-Path $Target "install.bash")

Write-Host "apt-offline successfully cached!" -ForegroundColor Green