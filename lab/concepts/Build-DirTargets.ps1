param(
    [string]
    [Parameter()]
    $Config = ".\resources\full.json"
)

$data = Get-Content -Raw -Path $Config | ConvertFrom-Json

foreach ($prop in $($data | Select-Object -ExcludeProperty target).PSObject.Properties) {
    Write-Host "Joining targets: $($data.target) with $($prop.Value.target)"

    $data.$($prop.Name).target = Join-Path $data.target $prop.Value.target

    Write-Host "Combined target: $($data.$($prop.Name).target)"
    Write-Host "For Linux: $($data.$($prop.Name).target -replace '\\', '/')"
}