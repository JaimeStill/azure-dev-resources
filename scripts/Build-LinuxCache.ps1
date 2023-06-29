param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

Write-Host "Generating Linux cache..." -ForegroundColor Blue

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -ItemType Directory -Force

$Config.target = $Config.target -replace '\\', '/'

. wsl -u root --exec ./cache-packages.bash -c "$($Config | ConvertTo-Json)"

Write-Host "Linux cache successfully generated!" -ForegroundColor Green