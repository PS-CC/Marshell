<#
    This script will create a new a user record with the current user id and assign super permission set to the new user in all server instances
    on the current server.

    Set the $NavVersion.
#>

# 71, 80, 90, 100
$NavVersion = 100;

Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"

$NavServices = Get-NAVServerInstance 
$me = whoami

foreach ($NavService in $NavServices)
{
    write-host $NavService.DisplayName

    $NavServicename = ($NavService.ServerInstance).Replace("MicrosoftDynamicsNavServer$", "")

    write-host "Add $($me) as a user" -ForegroundColor Cyan
    New-NAVServerUser -ServerInstance $NavServicename -WindowsAccount $me
    
    write-host "Assign super permission to $($me)" -ForegroundColor Cyan
    New-NAVServerUserPermissionSet  -ServerInstance $NavServicename -WindowsAccount $me -PermissionSetId SUPER
    
}

