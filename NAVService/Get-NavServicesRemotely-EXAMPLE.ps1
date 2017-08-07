. "C:\Github\Marshell\NAVService\Get-NavServicesRemotely.ps1"

$Servers = ('localhost')
Get-NavServicesRemotely -NavVersion 90 -Severs $Servers | Format-Table -AutoSize