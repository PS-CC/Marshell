function Export-NavUserPermissionsToExcel
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [int] $NavVersion,
        [Parameter(Mandatory=$true)]
        [string] $NavServerInstanceName,
        [Parameter(Mandatory=$false)]
        [string] $NavUser

    )

    Process
    {
        Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"
        
        if ($NavUser -eq "")
        {
            $NavUsers = Get-NAVServerUser -ServerInstance $NavServerInstanceName
        }
        else
        {
            $NavUsers = Get-NAVServerUser -ServerInstance $NavServerInstanceName | Where-Object {$_.Username -eq $NavUser}
        }
        
        $LineNo = 0
        $Excel = New-Object -ComObject Excel.Application
        $Excel.Visible = $true
        $Workbook = $Excel.Workbooks.Add()
        $Sheets = $Workbook.Worksheets
        $CurrentWorkSheet = $Sheets.Add()

        foreach ($User in $NavUsers)
        {
            $LineNo = $LineNo + 2

            $CurrentWorkSheet.Cells.Item($lineNo,1) = $User.Username

            $LineNo++
            
            $CurrentWorkSheet.Cells.Item($lineNo,1) = "Username"
            $CurrentWorkSheet.Cells.Item($lineNo,2) = "PermissionSet ID"
            $CurrentWorkSheet.Cells.Item($lineNo,3) = "PermissionSet Name"
            $CurrentWorkSheet.Cells.Item($lineNo,4) = "Company"
            
            $Permissions = Get-NAVServerUserPermissionSet -ServerInstance $NavServerInstanceName -UserName $User.Username
            foreach ($Permission in $Permissions)
            {
                $LineNo++

                $CurrentWorkSheet.Cells.Item($lineNo,1) = $Permission.Username
                $CurrentWorkSheet.Cells.Item($lineNo,2) = $Permission.PermissionSetID
                $CurrentWorkSheet.Cells.Item($lineNo,3) = $Permission.PermissionSetName
                $CurrentWorkSheet.Cells.Item($lineNo,4) = $Permission.CompanyName

            }
        }      
        $Excel.Quit()
    }
}