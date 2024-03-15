# $LatestOPAVersion = '0.62.1'
# $ScubaConfigPath = '.\PowerShell\ScubaGear\Modules\ScubaConfig\ScubaConfig.psm1'
# $OPAVerRegex = "\'\d+\.\d+\.\d+\'"
# $DefaultVersionPattern = "DefaultOPAVersion = $OPAVerRegex"

# $ScubaConfigModule = Get-Content $ScubaConfigPath -Raw

# # Find our current OPA version using some dirty string
# # manipulation
# $CurrentOPAVersion = '0.0.0'
# if ($ScubaConfigModule -match $DefaultVersionPattern) {
#     $CurrentOPAVersion = ($Matches[0] -split "=")[1] -replace " ", ""
#     $CurrentOPAVersion = $CurrentOPAVersion -replace "'", ""
# }


# # Replace Default version in Config Module
# $ScubaConfigPath = '.\PowerShell\ScubaGear\Modules\ScubaConfig\ScubaConfig.psm1'
# $OPAVerRegex = "\'\d+\.\d+\.\d+\'"
# $DefaultVersionPattern = "DefaultOPAVersion = $OPAVerRegex"
# $ScubaConfigModule = Get-Content $ScubaConfigPath -Raw
# $Content = $ScubaConfigModule -replace $DefaultVersionPattern, "DefaultOPAVersion = '$'"
# Set-Content -Path $ScubaConfigPath -Value $Content

# # Update Acceptable Versions in Support Module
# $SupportModulePath = '.\PowerShell\ScubaGear\Modules\Support\Support.psm1'
# $MAXIMUM_VER_PER_LINE = 4 # Handle long lines of acceptable versions
# $END_VERSIONS_COMMENT = "# End Versions" # EOL comment in the PowerShell file
# $EndAcceptableVerRegex = ".*$END_VERSIONS_COMMENT"
# $DefaultOPAVersionVar = "[ScubaConfig]::ScubaDefault('DefaultOPAVersion')"

# (Get-Content -Path $SupportModulePath) | ForEach-Object {
#     $EndAcceptableVarMatch = $_ -match $EndAcceptableVerRegex
#     if ($EndAcceptableVarMatch) {
#         $VersionsLength = ($_ -split ",").length

#         # Split the line if we reach our version limit per line
#         # in the the file. This is to prevent long lines.
#         if ($VersionsLength -gt $MAXIMUM_VER_PER_LINE) {
#             Write-Host "split"
#             $VersionsArr = $_ -split ","
#             # Create a new line
#             # Then add the new version on the next line
#             ($VersionsArr[0..($VersionsArr.Length-2)] -join ",") + ","
#             "    '$CurrentOPAVersion', $DefaultOPAVersionVar $END_VERSIONS_COMMENT" # 4 space indentation
#         }
#         else {
#             Write-Host "nosplit"
#             $VersionsArr = $_ -split ","
#             $NewVersions = ($VersionsArr[0..($VersionsArr.Length-2)] -join ",")
#             $NewVersions + ", '$CurrentOPAVersion'" + ", $DefaultOPAVersionVar $END_VERSIONS_COMMENT"
#         }
#     }
#     else {
#         $_
#     }
# } | Set-Content $SupportModulePath

$LatestOPAVersion = "x"
$READMEPath = '.\README.md'
$LatestOPAVerRegex = ".*OPA version \(Currently v\d+\.\d+\.\d+\)"
$READMEContent = Get-Content -Path $READMEPath -Raw
Set-Content -Path $READMEPath -Value $Content

if ($READMEContent -match $LatestOPAVerRegex) {
    Write-Output "Replaced"
    $NewContent = $READMEContent -replace $LatestOPAVerRegex, "OPA version (Currently v$LatestOPAVersion) "
    Set-Content -Path $READMEPath -Value $NewContent -NoNewline
}
#  #
#           # Replace latest supported OPA version in the README
#           #
#           $READMEPath = '.\README.md'
#           $OPARegex = ".*OPA version \(Currently v\d+\.\d+\.\d+\)"
#           (Get-Content -Path $READMEPath) | ForEach-Object {
#             $OPARegexMatch = $_ -match $OPARegex
#             if ($OPARegexMatch) {
#               Write-Host "a"
#               $_ -replace $OPARegex, "OPA version (Currently v$LatestOPAVersion) "
#             } 
#             else {
#               #$_
#             }
#           } #| Set-Content -Path $READMEPath
