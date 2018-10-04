. ".\New-XMLPortTableElement.ps1"

New-XMLPortTableElement -SourceTable "Cust. Ledger Entry" `
                        -TableDefinitionCsvFile ".\NewXmlPortFields.csv" `
                        -NewCodeFile ".\NewXmlPortTableElement.txt"