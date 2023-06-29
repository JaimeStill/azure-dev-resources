param(
    [string]
    [Parameter()]
    $Config = '..\resources\full.json'
)

$data = Get-Content -Raw -Path $Config | ConvertFrom-Json

. wsl --exec ./parse-json.bash -c $($data.linux | ConvertTo-Json)