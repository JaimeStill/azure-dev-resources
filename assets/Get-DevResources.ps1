. .\functions.ps1

Build-Resources "software" "software.json"
Build-Resources "extensions/ads" "ads-extensions.json"
Build-Resources "extensions/code" "code-extensions.json"

Write-Host "Finished retrieving Azure Dev Resources"
