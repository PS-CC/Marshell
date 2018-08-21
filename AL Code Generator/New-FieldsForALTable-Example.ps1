. ".\AL Code Generator\New-FieldsForALTable.ps1"

New-FieldForALTable -TableDefinitionCsvFile ".\AL Code Generator\NewTableStructure.csv" `
                    -NewCodeFile ".\AL Code Generator\NewTableFields.txt"
