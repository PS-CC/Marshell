. "C:\GitHub\Marshell\User Scripts\Import-NavUsersFromCSV.ps1"

$Permissions = ('BASIC', 'TEAM MEMBER', 'SUPER')
Import-NavUsersFromCSV -NavVersion 100 `
                       -NavServerInstanceName 'DynamicsNAV100' `
                       -AuthenticationMethod Windows `
                       -ImportFilePath 'C:\GitHub\Marshell\User Scripts\NAV Create NAV Users From CSV.csv' `
                       -PermissionSets $Permissions

                       
                       