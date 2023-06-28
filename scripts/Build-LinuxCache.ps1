param(
    [string]
    [Parameter()]
    $Target = "../linux",
    [string]
    [Parameter()]
    $Source = "./data/linux.json",
    [string]
    [Parameter()]
    $Platform = "linux",
    [string]
    [Parameter()]
    $Arch = "x64",
    [string]
    [Parameter()]
    $Channel = "STS",
    [string]
    [Parameter()]
    $DotnetTarget = "../linux/dotnet",
    [switch]
    [Parameter()]
    $Extract
)

Write-Host "Generating Linux cache..." -ForegroundColor Blue

$command = ". wsl -u root --exec ./cache-packages.bash -t $Target -s $Source -p $Platform -a $Arch -c $Channel -d $DotnetTarget"

if ($Extract) {
    $command += " -e"
}

Invoke-Expression $command

Write-Host "Linux cache successfully generated!" -ForegroundColor Green