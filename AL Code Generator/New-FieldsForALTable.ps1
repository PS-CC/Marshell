function New-FieldForALTable
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

        foreach ($Field in $TableDefinition)
        {

            $FieldName = $Field.Name
            if ($Field.Name -match '[^a-zA-Z0-9]')
            {
                $FieldName = """$($Field.Name)"""
            }

            "field($($Field.Id);$($FieldName);$($Field.DataType))" | Add-Content $NewCodeFile
            "{" | Add-Content $NewCodeFile

            if ($Field.Caption -ne "")
            {
                "   CaptionML = ENG='$($Field.Caption)'," | Add-Content $NewCodeFile
                "               ENU='$($Field.Caption)';" | Add-Content $NewCodeFile
            }

            if ($Field.Comment -ne "")
            {
                "   // $($Field.Comment)" | Add-Content $NewCodeFile
                "   DataClassification = ToBeClassified;" | Add-Content $NewCodeFile
            }
            "}" | Add-Content $NewCodeFile
        }
    }
}   