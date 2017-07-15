. "C:\GitHub\Marshell\SQL\Export-DatabaseRowCount.ps1"

$DatabaseList = ('Demo Database NAV (10-0)', 'Demo Database NAV (9-0)')

Export-DataRowCount -Databases $DatabaseList `
                    -OutputFolder 'C:\Temp'