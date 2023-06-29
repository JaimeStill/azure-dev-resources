param(
    [string]
    [Parameter()]
    $Config = ".\resources\full.json"
)

$data = Get-Content -Raw -Path $Config | ConvertFrom-Json

if ($null -ne $data.wsl) {
    Write-Host ($data.wsl | ConvertTo-Json) -ForegroundColor Green
}

if ($null -eq $data.foo) {
    Write-Host '$data.foo is not configured' -ForegroundColor Yellow
}