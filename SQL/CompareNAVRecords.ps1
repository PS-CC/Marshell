import-module 'sqlps' -DisableNameChecking

$MyComputer = hostname
$Customer = 'Customer'
$QueryText = "SELECT * FROM [Demo Database NAV (11-0)].[dbo].[CRONUS UK Ltd_$Customer] WHERE [No_] = 10000"
$Customer1 = Invoke-Sqlcmd -ServerInstance "$($MyComputer)\SQLEXPRESS" `
              -Database 'Demo Database NAV (11-0)' `
              -Query $QueryText


$Customer2 = Invoke-Sqlcmd -ServerInstance "$($MyComputer)\SQLEXPRESS" `
              -Database 'Demo Database NAV (11-0)' `
              -Query $QueryText 

$Diff = Compare-Object -ReferenceObject $Customer1 -DifferenceObject $Customer2

for ($i = 1; $i -lt $Customer1.Count; $i++)
{ 
    Compare-Object -ReferenceObject $Customer1[$i] -DifferenceObject $Customer2[$i]     
}

$Customer1[69] | Format-Table -AutoSize
$Customer2[68] | Format-Table -AutoSize