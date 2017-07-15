function Export-DataRowCount
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [array] $Databases,
        [parameter(Mandatory=$true)]
        [string] $OutputFolder
    )

    PROCESS
    {
        foreach ($Database in $Databases)
        {
            Write-Host $Database -ForegroundColor Green

            $Step = 0
            $OutputFile = "$($OutputFolder)\$($Database).csv"

            # Create header
            'Table, Number of Rows' | Add-Content $OutputFile

            # Export Row Count
            $Tables = dir ".\Databases\$($Database)\Tables\"
            foreach ($Table in $Tables)
            {
                Write-Host $table.Name 'Number of rows: ' $table.RowCount -ForegroundColor Cyan
                $Line = "$($table.Name), $($table.RowCount)";
                $Line | Add-Content $OutputFile;   
                
                
                # Progress Bar
                $Step++; 
                $Percent = ($Step/($Tables.Count/100));
                Write-Progress -Activity $Table -Status "$($Percent) %" -PercentComplete $Percent
            }

            $Tables.Clear()
        }
    }
}