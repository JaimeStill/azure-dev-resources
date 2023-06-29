param(
    [PSObject]
    [Parameter(Mandatory)]
    $Config
)

function Invoke-CodeDownload([string] $download, [string] $output) {
    try {
        Invoke-WebRequest -Uri $download -OutFile $output -MaximumRetryCount 10 -RetryIntervalSec 6
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 429) {
            $RetryPeriod = 60
            Write-Host "Rate Limit Exceeded. Sleeping $RetryPeriod seconds due to HTTP 429 response"
            Start-Sleep -Seconds $RetryPeriod
            Invoke-CodeDownload @PSBoundParameters
        } else {
            Write-Error -Exception $_.Exception -Message "Failed to download Code Extension: $_"
        }
    }
}

function Get-CodeExtension([psobject] $extension, [string] $path) {
    Write-Host "Retrieving $($extension.display)"
    
    Write-Host "Getting Version Number for $($extension.display)"

    $uri = "https://marketplace.visualstudio.com/items?itemName=$($extension.publisher).$($extension.name)"
    $content = Invoke-RestMethod -Uri $uri
    $content -match '<script class="jiContent" defer="defer" type="application/json">.*</script>' | Out-Null
    $json = $Matches[0] -replace '<script class="jiContent" defer="defer" type="application/json">' -replace '</script>'
    $json = $json | ConvertFrom-Json

    Write-Host "Generating Download URI for $($extension.display)@$($json.Resources.Version)"

    $download = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$($extension.publisher)/vsextensions/$($extension.name)/$($json.Resources.Version)/vspackage"

    $output = Join-Path $path "$($extension.name).$($json.Resources.Version).vsix"

    if (Test-Path $output) {
        Remove-Item $output -Force
    }

    Write-Host "Downloading $($extension.display) from $download"
    Invoke-CodeDownload $download $output
    Write-Host "$($extension.display) successfully downloaded"
}

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

try {
    Write-Host "Generating Visual Studio Code extension cache..." -ForegroundColor Cyan

    if (Test-Path $Config.target) {
        Remove-Item $Config.target -Recurse -Force
    }

    New-Item $Config.target -ItemType Directory -Force

    $Config.data | ForEach-Object {
        Get-CodeExtension $_ $Config.target
    }

    Write-Host "Visual Studio Code extension cache successfully generated!" -ForegroundColor Cyan
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}