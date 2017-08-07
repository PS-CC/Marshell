. "C:\Github\Marshell\NAVService\Get-NavServicesRemotely.ps1"

$Servers = ('localhost')
Get-NavServicesRemotely -NavVersion 100 -Severs $Servers | Format-Table -AutoSize