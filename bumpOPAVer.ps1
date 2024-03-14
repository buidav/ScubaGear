$LatestOPAVersion = '0.62.1'
$OPAVersionPath = '.\PowerShell\ScubaGear\Modules\Support\Support.psm1'
$OPAVerRegex = "\'\d+\.\d+\.\d+\'"
$ExpectedVersionPattern = "ExpectedVersion = $OPAVerRegex"

$SupportModule = Get-Content $OPAVersionPath -Raw

# Find our current OPA version using some dirty string
# manipulation
if ($SupportModule -match $ExpectedVersionPattern) {
    $CurrentVersion = ($Matches[0] -split "=")[1] -replace " ", ""
    $CurrentVersion = $CurrentVersion -replace "'", ""
    $CurrentVersion
}

$MAXIMUM_VER_PER_LINE = 8 # Handle long lines of acceptable versions
$END_VERSIONS_COMMENT = "# End Versions" # EOL comment in the PowerShell file
$EndAcceptableVerRegex = ".*$END_VERSIONS_COMMENT"
$Replace = $false # replace the current version or not

(Get-Content -Path $OPAVersionPath) | ForEach-Object {
    $ExpectedVerMatch = $_ -match "ExpectedVersion = "
    $EndAcceptableVarMatch = $_ -match $EndAcceptableVerRegex
    if ($ExpectedVerMatch -and ($LatestOPAVersion -gt $CurrentVersion)) {
        $_ -replace $OPAVerRegex, "'$LatestOPAVersion'"
        $Replace = $true
    }
    elseif ($EndAcceptableVarMatch -and $Replace) {
        $VersionsLength = ($_ -split ",").length

        # Split the line if we reach our version limit per line
        # in the the file. This is to prevent long lines.
        if ($VersionsLength -gt $MAXIMUM_VER_PER_LINE) {
            $VersionsArr = $_ -split "#"

            # Create a new line
            # Then add the new version on the next line
            ($VersionsArr[$VersionsArr.length - 2]).TrimEnd()
            "    '$LatestOPAVersion' $END_VERSIONS_COMMENT" # 4 space indentation
        }
        else {
            $VersionsArr = $_ -split "#"
            $NewVersions = $VersionsArr[0..($VersionsArr.Length-2)] -join ","
            $NewVersions + "'$LatestOPAVersion' $END_VERSIONS_COMMENT"
        }
    }
    else {
        $_
    }
} | Set-Content $OPAVersionPath
