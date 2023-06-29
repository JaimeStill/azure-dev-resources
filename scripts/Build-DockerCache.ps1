param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

function Get-DockerImage([psobject] $image, [string] $dir) {
    Write-Host "Pulling $($image.repository)`:$($image.tag)"

    & docker pull "$($image.repository)`:$($image.tag)"

    $output = Join-path $dir "$($image.name)-$($image.tag).tar"
    
    Write-Host "Saving $($image.repository)`:$($image.tag) to $dir as $output"

    & docker save "$($image.repository)`:$($image.tag)" -o $output

    if ($($image.clear)) {
        Write-Host "Clearing image $($image.repository)`:$($image.tag)"
        & docker rmi "$($image.repository)`:$($image.tag)"
    }
}

Write-Host "Generating Docker image cache..." -ForegroundColor Cyan

if (Test-Path $Config.target) {
    Remove-Item $Config.target -Recurse -Force
}

New-Item $Config.target -ItemType Directory -Force

$Config.data | ForEach-Object {
    Get-DockerImage $_ $Config.target
}

Write-Host "Docker image cache successfully generated!" -ForegroundColor Cyan