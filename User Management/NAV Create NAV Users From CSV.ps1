<#
    This script will read a CSV file where the usernames are entered for the new users and create new user records.
    It will also assign the permission sets defined in the $PermissionSets array to the users.

    Set the $NavServiceName and $NavVersion.
#>
$workfolder = (Get-Item $psISE.CurrentFile.FullPath).Directory
Write-Host "Workfolder is: $($workfolder)" -ForegroundColor Gray

# 71, 80, 90, 100
$NavVersion = 100

Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"

# NAV Service Tier Name
$NavServiceName = '';
$NewUsers = Import-Csv "$($workfolder)\NAV Create NAV Users From CSV.csv"

$PermissionSets = ('SUPER', 'BASIC')

# For NAV Username and password authentication
#$Password = ConvertTo-SecureString -String 'Password' -AsPlainText -Force

foreach ($User in $NewUsers)
{
    # Auth: Win
    Write-Host $User.UserName $User.FullName -ForegroundColor Cyan
    New-NAVServerUser -ServerInstance $NavService -WindowsAccount $User.UserName -ErrorAction Inquire

    # Auth: NAV UserName and Password
    # New-NAVServerUser -ServerInstance $NavService -UserName $User.UserName -FullName $User.FullName -ContactEmail $User.Email -Password $Pass -ChangePasswordAtNextLogOn  -ErrorAction Inquire
    # New-NAVServerUserPermissionSet -ServerInstance $NavService -UserName $User.UserName -PermissionSetId 'SUPER' -ErrorAction Inquire

    foreach($PermissionSet in $PermissionSets)
    {
        Write-Host $User.UserName - $PermissionSet -ForegroundColor Yellow
        New-NAVServerUserPermissionSet -ServerInstance $NavService -WindowsAccount $User.UserName -PermissionSetId $PermissionSet -ErrorAction Inquire
    }
}