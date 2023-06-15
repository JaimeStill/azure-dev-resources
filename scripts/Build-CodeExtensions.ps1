param(
    [string]
    [Parameter()]
    $Target = "..\bundle\extensions\code",
    [string]
    [Parameter()]
    $Source = "data\code-extensions.json"
)

function Invoke-CodeDownload([string] $download, [string] $output) {
    try {
        Invoke-WebRequest -Uri $download -OutFile $output -MaximumRetryCount 10 -RetryIntervalSec 6
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 429) {
            $RetryPeriod = 60
            Write-Output "Rate Limit Exceeded. Sleeping $RetryPeriod seconds due to HTTP 429 response"
            Start-Sleep -Seconds $RetryPeriod
            Invoke-CodeDownload @PSBoundParameters
        } else {
            Write-Error -Exception $_.Exception -Message "Failed to download Code Extension: $_"
        }
    }
}

function Get-CodeExtension([psobject] $extension, [string] $path) {
    Write-Output "Retrieving $($extension.label)"
    
    Write-Output "Getting Version Number for $($extension.label)"

    $uri = "https://marketplace.visualstudio.com/items?itemName=$($extension.publisher).$($extension.name)"
    $content = Invoke-RestMethod -Uri $uri
    $content -match '<script class="jiContent" defer="defer" type="application/json">.*</script>' | Out-Null
    $json = $Matches[0] -replace '<script class="jiContent" defer="defer" type="application/json">' -replace '</script>'
    $json = $json | ConvertFrom-Json

    Write-Output "Generating Download URI for $($extension.label).$($json.Resources.Version)"

    $download = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$($extension.publisher)/vsextensions/$($extension.name)/$($json.Resources.Version)/vspackage"

    $output = Join-Path $path "$($extension.name).$($json.Resources.Version).vsix"

    if (Test-Path $output) {
        Remove-Item $output -Force
    }

    Write-Output "Downloading $($extension.label) from $download"
    Invoke-CodeDownload $download $output
    Write-Output "$($extension.label) successfully downloaded"
}

$initialProgressPreference = $global:ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'

try {
    if (-not (Test-Path $Target)) {
        New-Item -Path $Target -ItemType Directory -Force
    }

    $exts = Get-Content -Raw -Path $Source | ConvertFrom-Json

    Write-Output "Generating Code Extensions in $Target"

    $exts | ForEach-Object {
        Get-CodeExtension $_ $Target
    }
}
finally {
    $global:ProgressPreference = $initialProgressPreference
}