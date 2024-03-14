$LatestOPAVersion = '0.62.1'
$ScubaConfigPath = '.\PowerShell\ScubaGear\Modules\ScubaConfig\ScubaConfig.psm1'
$OPAVerRegex = "\'\d+\.\d+\.\d+\'"
$DefaultVersionPattern = "DefaultOPAVersion = $OPAVerRegex"

$ScubaConfigModule = Get-Content $ScubaConfigPath -Raw

# Find our current OPA version using some dirty string
# manipulation
$CurrentOPAVersion = '0.0.0'
if ($ScubaConfigModule -match $DefaultVersionPattern) {
    $CurrentOPAVersion = ($Matches[0] -split "=")[1] -replace " ", ""
    $CurrentOPAVersion = $CurrentOPAVersion -replace "'", ""
}


# Replace Default version
$ScubaConfigPath = '.\PowerShell\ScubaGear\Modules\ScubaConfig\ScubaConfig.psm1'
$OPAVerRegex = "\'\d+\.\d+\.\d+\'"
$DefaultVersionPattern = "DefaultOPAVersion = $OPAVerRegex"
$ScubaConfigModule = Get-Content $ScubaConfigPath -Raw
$Content = $ScubaConfigModule -replace $DefaultVersionPattern, "DefaultOPAVersion = '$'"
Set-Content -Path $ScubaConfigPath -Value $Content

# Handle SupportModule
$SupportModulePath = '.\PowerShell\ScubaGear\Modules\Support\Support.psm1'
$MAXIMUM_VER_PER_LINE = 4 # Handle long lines of acceptable versions
$END_VERSIONS_COMMENT = "# End Versions" # EOL comment in the PowerShell file
$EndAcceptableVerRegex = ".*$END_VERSIONS_COMMENT"
$Replace = $false # replace the current version or not

# (Get-Content -Path $SupportModulePath) | ForEach-Object {
#     $ExpectedVerMatch = $_ -match "ExpectedVersion = "
#     $EndAcceptableVarMatch = $_ -match $EndAcceptableVerRegex
#     if ($ExpectedVerMatch -and ($LatestOPAVersion -gt $CurrentVersion)) {
#         $_ -replace $OPAVerRegex, "'$LatestOPAVersion'"
#         $Replace = $true
#     }
#     elseif ($EndAcceptableVarMatch -and $Replace) {
#         $VersionsLength = ($_ -split ",").length

#         # Split the line if we reach our version limit per line
#         # in the the file. This is to prevent long lines.
#         if ($VersionsLength -gt $MAXIMUM_VER_PER_LINE) {
#             $VersionsArr = $_ -split "#"

#             # Create a new line
#             # Then add the new version on the next line
#             ($VersionsArr[$VersionsArr.length - 2]).TrimEnd()
#             "    '$LatestOPAVersion' $END_VERSIONS_COMMENT" # 4 space indentation
#         }
#         else {
#             $VersionsArr = $_ -split "#"
#             $NewVersions = $VersionsArr[0..($VersionsArr.Length-2)] -join ","
#             $NewVersions + "'$LatestOPAVersion' $END_VERSIONS_COMMENT"
#         }
#     }
#     else {
#         $_
#     }
# } | Set-Content $SupportModulePath
