function Confirm-PowerShellUpdateRequirements {
    <#
        .SYNOPSIS
        Determine if PowerShell dependency updates is required
    #>

    Write-Warning "Determining if any PowerShell modules need to be updated..."

    # Assume it does not need to be update until proven otherwise
    $UpdateRequired = $false
    # Get latest version of OPA via REST

    #$DependencyModulePath = "./PowerShell/ScubaGear/RequiredVersions.ps1"

    $DependencyModulePath = "../../PowerShell/ScubaGear/RequiredVersions.ps1"
    . $DependencyModulePath

    $GraphVersions = New-Object System.Collections.Generic.HashSet[string]
    $ModulesToBump = @{}

    foreach ($Module in $ModuleList) {

        # Handle Graph specific
        $DependencyPSGalleryVersion = (Find-Module -Name $Module.ModuleName | Select-Object -Property Version).Version
        if ($DependencyPSGalleryVersion -le $Module.MaximumVersion) {
            continue
        }

        if (($Module.ModuleName).StartsWith("Microsoft.Graph")) {
            $GraphVersions.add($DependencyPSGalleryVersion) | Out-Null
            Write-Warning ( "$($Module.ModuleName) current ScubaGear MaximumVersion: $($Module.MaximumVersion); Current latest PSGallery Version: $($DependencyPSGalleryVersion)")
                if (-not $ModulesToBump.ContainsKey("Graph")) {
                    $ModulesToBump["Graph"] = @($Module)
                }
                else {
                    # If it exists, append the module to the existing array
                    $ModulesToBump["Graph"] += $Module
                }
            }
        }
        elseif(($Module.ModuleName).StartsWith("PnP.PowerShell")) {
            # PnP PowerShell stopped PowerShell 5.1 support with v1.12
            # So we'll skip any dependency updates
            Write-Debug "Skipping PnP PowerShell dependency check for now"
            continue
        }
        else {
            $ModulesToBump[$Module.ModuleName] = $Module
        }
    }

    

    # # Check if there is already an update branch
    # $OPAVersionBumpBranch = "opa-version-bump-$($LatestOPAVersion)"
    # [Diagnostics.CodeAnalysis.SuppressMessagAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification='$Temp required to avoid having PS eat the return code from git.')]
    # $Temp = git ls-remote --exit-code --heads origin $OPAVersionBumpBranch
    # $OPAVersionBranchExists = $false
    # if ($LASTEXITCODE -eq 0) {
    #     $OPAVersionBranchExists = $true
    # }

    # # Get the version of OPA defined in the config class.
    # $CurrentOPAVersion = [ScubaConfig]::GetOpaVersion()

    # # Check to see if updates are required, and if not, why not.
    # $Summary = ''
    # if ($LatestOPAVersion -gt $CurrentOPAVersion) {
    #     if (-not $OPAVersionBranchExists) {
    #         $Summary = "OPA version update required."
    #         $UpdateRequired = $true
    #     }
    #     else {
    #         $Summary = "Update branch ($($OPAVersionBumpBranch)) already exists; no update required."
    #     }
    # }
    # else {
    #     $Summary = "OPA version is already up to date; no update required."
    # }

    # # Return values in a hashtable
    # $ReturnValues = @{
    #     "Summary" = $Summary
    #     "LatestOPAVersion" = $LatestOPAVersion
    #     "OPAVersionBumpBranch" = $OPAVersionBumpBranch
    #     "UpdateRequired" = $UpdateRequired
    #     "CurrentOPAVersion" = $CurrentOPAVersion
    # }
    # return $ReturnValues
}
Confirm-PowerShellUpdateRequirements
