<#
.SYNOPSIS
    Create a local admin user, set a description, and add the user to the Administrators group.

.DESCRIPTION
    This script creates a local admin user with a randomly generated password, sets a description, 
    and adds the user to the Administrators group. If the user already exists, it ensures the user 
    is a member of the Administrators group and updates the description.

.PARAMETER localAdminUserName
    The name of the local admin user to create or update.

.PARAMETER userDescription
    The description to set for the local admin user.

.NOTES
    Author: Sagi Dahan
    GitHub: https://github.com/sagid654
#>

# Parameters
param (
    [string]$localAdminUserName = "LOCALADMINUSERNAME",
    [string]$userDescription = "DESCRIPTION"
)

# Function to generate a random password
function New-RandomPassword {
    param (
        [int]$length = 14
    )

    $chars = @(
        [char[]](48..57) + # 0-9
        [char[]](65..90) + # A-Z
        [char[]](97..122) + # a-z
        [char[]](35..38) + # special characters: #, %, &, etc.
        [char[]](42..43) + # special characters: *, +
        [char[]](64..64) + # special characters: @
        [char[]](94..94)   # special characters: ^
    )

    return -join ($chars | Get-Random -Count $length)
}

# Check if the local admin user exists
$userExists = Get-WmiObject -Class Win32_UserAccount -Filter "Name='$localAdminUserName' and LocalAccount=True"

if (-not $userExists) {
    # Generate a random password
    $password = New-RandomPassword -length 14

    # Create a new local admin user
    $cmd = "net user $localAdminUserName $password /add /passwordchg:no /expires:never"
    Invoke-Expression $cmd | Out-Null

    # Add the new user to the Administrators group
    $cmd = "net localgroup Administrators $localAdminUserName /add"
    Invoke-Expression $cmd | Out-Null

    # Set the description for the user using ADSI
    $user = [ADSI]"WinNT://$env:COMPUTERNAME/$localAdminUserName,user"
    $user.Description = $userDescription
    $user.SetInfo()

    Write-Output "User '$localAdminUserName' created and added to the Administrators group with description '$userDescription'."
} else {
    # Check if the user is a member of the Administrators group
    $query = "SELECT * FROM Win32_GroupUser WHERE GroupComponent='Win32_Group.Domain=`"$env:COMPUTERNAME`",Name=`"Administrators`"' AND PartComponent='Win32_UserAccount.Domain=`"$env:COMPUTERNAME`",Name=`"$localAdminUserName`"'"
    $userInAdminGroup = Get-WmiObject -Query $query

    if (-not $userInAdminGroup) {
        # Add the existing user to the Administrators group
        $cmd = "net localgroup Administrators $localAdminUserName /add"
        Invoke-Expression $cmd | Out-Null
        Write-Output "User '$localAdminUserName' exists but was not a member of the Administrators group. User has been added to the Administrators group."
    } else {
        Write-Output "User '$localAdminUserName' already exists and is a member of the Administrators group."
    }

    # Ensure the user description is set correctly using ADSI
    $user = [ADSI]"WinNT://$env:COMPUTERNAME/$localAdminUserName,user"
    $user.Description = $userDescription
    $user.SetInfo()

    Write-Output "User '$localAdminUserName' description updated to '$userDescription'."
}
