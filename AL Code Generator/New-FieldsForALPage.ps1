function New-FieldForALPage
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [array] $TableDefinitionCsvFile,
        [parameter(Mandatory=$true)]
        [string] $NewCodeFile
    )

    PROCESS
    {
        $TableDefinition = Import-Csv $TableDefinitionCsvFile        
        New-Item -Path $NewCodeFile -ItemType File -Force
        $Tab = [char]9

        foreach ($Field in $TableDefinition)
        {

            $FieldName = $Field.Name
            if ($Field.Name -match '[^a-zA-Z0-9]')
            {
                $FieldName = """$($Field.Name)"""
            }

            "field($($FieldName);$($FieldName)){} //$($Tab)$($Field.Comment)" | Add-Content $NewCodeFile
        }
    }
}   