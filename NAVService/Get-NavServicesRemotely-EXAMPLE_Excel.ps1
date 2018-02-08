. "C:\YourFolder\Get-NavServicesRemotely.ps1"

$Servers = ('localhost')
$NavServices = Get-NavServicesRemotely -NavVersion 90 -Severs $Servers

$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $true
$Workbook = $excel.Workbooks.Add()
$Sheets = $workbook.Worksheets

foreach ($Server in $Servers)
{
    $NavServicesFiltered = $NavServices | Where-Object {$_.PSComputerName -eq $Server}

    $CurrentWorkSheet = $Sheets.Add()
    $CurrentWorkSheet.Name = $Server

    $lineNo = 1

    # Create Headers
    $currentWorkSheet.Cells.Item($lineNo,1) = "Service Instance"
    $currentWorkSheet.Cells.Item($lineNo,2) = "Database Server"
    $currentWorkSheet.Cells.Item($lineNo,3) = "Database Instance"
    $currentWorkSheet.Cells.Item($lineNo,4) = "Database Name"
    $currentWorkSheet.Cells.Item($lineNo,5) = "Service Account"
    $currentWorkSheet.Cells.Item($lineNo,6) = "State"

    $format = $currentWorkSheet.UsedRange
    $format.Font.Bold = "True"

    foreach ($NavService in $NavServicesFiltered)
    {
        $lineNo = $lineNo + 1

        $currentWorkSheet.Cells.Item($lineNo,1) = $NavService.InstanceName
        $currentWorkSheet.Cells.Item($lineNo,2) = $NavService.DatabaseServer
        $currentWorkSheet.Cells.Item($lineNo,3) = $NavService.DatabaseInstance
        $currentWorkSheet.Cells.Item($lineNo,4) = $NavService.DatabaseName
        $currentWorkSheet.Cells.Item($lineNo,5) = $NavService.ServiceAccount
        $currentWorkSheet.Cells.Item($lineNo,6) = $NavService.State   
    }

}

$Excel.Quit()