$workfolder = (Get-Item $psISE.CurrentFile.FullPath).Directory
Write-Host "Workfolder is: $($workfolder)" -ForegroundColor Gray

# 71, 80, 90, 100
$NavVersion = 100

Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"

# NAV Service Tier Name
$NavServiceName = '';
$NewUsers = Import-Csv "$($workfolder)\Users.csv"

$PermissionSets = ('SUPER')

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