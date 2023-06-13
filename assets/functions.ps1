function Build-Resources([string] $dir, [string] $list) {
    Write-Host "Writing resources from $list to $dir"

    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force
    }

    $data = Get-Content -Raw -Path $list | ConvertFrom-Json

    $data | ForEach-Object {
        Get-Resource $_ $dir
    }
}

function Get-Resource([psobject] $resource, [string] $dir) {
    Write-Host "Retrieving $resource.name from $resource.source"

    $output = Join-Path $dir $resource.file

    if (Test-Path $output) {
        Remove-Item -Force $output
    }

    Invoke-WebRequest -Uri $resource.source -OutFile $output -UseBasicParsing
}

