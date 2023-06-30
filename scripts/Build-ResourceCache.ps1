param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

function Build-Folders([psobject] $folders, [string] $dir) {
    if ($null -ne $folders) {
        $folders | ForEach-Object {
            $folder = Join-Path $dir $_.target

            if (Test-Path $folder) {
                Remove-Item $folder -Recurse -Force
            }

            New-Item $folder -ItemType Directory -Force
            
            Get-Resources $_.files $folder
            Build-Folders $_.folders $folder
        }
    }
}

function Get-Resources([psobject] $files, [string] $dir) {
    if ($null -ne $files) {
        $files | ForEach-Object {
            $file = Join-Path $dir $_.file
            Write-Host "Retrieving $file..."

            if (Test-Path $file) {
                Remove-Item -Force $file
            }
            
            Invoke-RestMethod -Uri $_.source -OutFile $file -MaximumRetryCount 10
            Write-Host "$file successfully retrieved"
        }
    }
}

try {
    Write-Host "Generating Software cache..." -ForegroundColor Blue

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    Get-Resources $Config.files $Config.target
    Build-Folders $Config.folders $Config.target

    Write-Host "Software cache successfully generated!" -ForegroundColor Green
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}