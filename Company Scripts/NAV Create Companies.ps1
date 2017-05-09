<#
    This script will create new empty companies with the names defined in the $Companies array.

    Set the $NavServiceName and $NavVersion.
#>

# 71, 80, 90, 100
$NavVersion = 100;

Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"

$NavServiceName = 'DynamicsNAV100'

$Companies = ('Company 1', 'Company 2')

foreach ($Company in $Companies)
{
    Write-Host "Creating $($Company)" -ForegroundColor Cyan
    New-NAVCompany -ServerInstance $NavServiceName  -CompanyName $Company
}