param(
    [string]
    [Parameter()]
    $Target = "./packages",
    [string]
    [Parameter()]
    $Source = "./packages.json",
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
    $DotnetTarget = "./packages/dotnet",
    [switch]
    [Parameter()]
    $Extract
)

Write-Host "Generating Linux resources..." -ForegroundColor Blue

$command = ". wsl --exec ./cache-packages.bash -t $Target -s $Source -p $Platform -a $Arch -c $Channel -d $DotnetTarget"

if ($Extract) {
    $command += " -e"
}

Invoke-Expression $command

Write-Host "Linux resources successfully generated!" -ForegroundColor Green