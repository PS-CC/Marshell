function New-XMLPortTableElement
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string] $SourceTable,
        [parameter(Mandatory=$true)]
        [string] $TableDefinitionCsvFile,
        [parameter(Mandatory=$true)]
        [string] $NewCodeFile
    )
    process 
    {
        $TableDefinition = Import-Csv $TableDefinitionCsvFile        
        New-Item -Path $NewCodeFile -ItemType File -Force
        $Tab = [char]9    
        $SpecialCharPattern = '[^a-zA-Z]'
        $SourceTable = """$SourceTable"""
        $Name = $SourceTable -replace $SpecialCharPattern, ''

        "tableelement($($Name); $($SourceTable))" | Add-Content $NewCodeFile
        "{" | Add-Content $NewCodeFile

        foreach ($Field in $TableDefinition)
        {
            $SourceExpr = """$($Field.FieldName)"""
            $FieldElementName = $SourceExpr -replace $SpecialCharPattern, ''

            "$($Tab)fieldelement($($FieldElementName); $($Name).$($SourceExpr)) { }" | Add-Content $NewCodeFile
        }
        "}" | Add-Content $NewCodeFile
       
    }
}