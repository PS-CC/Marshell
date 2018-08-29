. ".\AL Code Generator\New-FieldsForALPage.ps1"

New-FieldForALPage -TableDefinitionCsvFile ".\AL Code Generator\NewTableStructure.csv" `
                    -NewCodeFile ".\AL Code Generator\NewPageFields.txt"
