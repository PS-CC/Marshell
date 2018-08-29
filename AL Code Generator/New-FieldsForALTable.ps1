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
        $Tab = [char]9

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
                "$($Tab)CaptionML = ENG='$($Field.Caption)',ENU='$($Field.Caption)';" | Add-Content $NewCodeFile                
            }

            if ($Field.Comment -ne "")
            {
                "$($Tab)// $($Field.Comment)" | Add-Content $NewCodeFile
                "$($Tab)DataClassification = ToBeClassified;" | Add-Content $NewCodeFile
            }
            "}" | Add-Content $NewCodeFile
        }
    }
}   