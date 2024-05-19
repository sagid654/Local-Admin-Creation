<#
.SYNOPSIS
    Detects if a local admin user exists and is a member of the Administrators group.

.DESCRIPTION
    This script checks if a specified local admin user exists and verifies if the user is a member 
    of the Administrators group.

.PARAMETER localAdminUserName
    The name of the local admin user to check.

.NOTES
    Author: Sagi Dahan
    GitHub: https://github.com/sagid654
#>

# Parameters
param (
    [string]$localAdminUserName = "LOCALADMINUSERNAME"
)

# Check if the local admin user exists using WMI
$userExists = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$localAdminUserName' and LocalAccount=True"

if ($userExists) {
    # Check if the user is a member of the Administrators group
    $query = "SELECT * FROM Win32_GroupUser WHERE GroupComponent='Win32_Group.Domain=`"$env:COMPUTERNAME`",Name=`"Administrators`"' AND PartComponent='Win32_UserAccount.Domain=`"$env:COMPUTERNAME`",Name=`"$localAdminUserName`"'"
    $userInAdminGroup = Get-WmiObject -Query $query
    
    if ($userInAdminGroup) {
        Write-Output "User '$localAdminUserName' exists and is a member of the Administrators group."
        exit 0 # User exists and is in the Administrators group
    } else {
        Write-Output "User '$localAdminUserName' exists and is not a member of the Administrators group."
        exit 1 # User exists but is not in the Administrators group
    }
} else {
    Write-Output "User '$localAdminUserName' does not exist."
    exit 1 # User does not exist
}
