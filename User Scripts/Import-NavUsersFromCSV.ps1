function Import-NavUsersFromCSV
{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [int] $NavVersion,
        [parameter(Mandatory=$true)]
        [string] $NavServerInstanceName,
        [parameter(Mandatory=$true)]
        [string] $ImportFilePath,      
        [parameter(Mandatory=$true)]
        [array] $PermissionSets,
        [parameter(Mandatory=$true)]
        [ValidateSet('Windows', 'NavUserPassword')]
        [string] $AuthenticationMethod,
        [parameter(Mandatory=$false)]
        [string] $DefaultPassword
    )

    Process
    {
        Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($NavVersion)\Service\NavAdminTool.ps1"
        
        $Users = Import-Csv $ImportFilePath -Verbose

        foreach ($User in $Users)
        {

            Write-Host "Creating $($User.UserName)" -ForegroundColor Cyan

            # Create User
            if ($AuthenticationMethod -eq 'Windows')
            {
                New-NAVServerUser -ServerInstance $NavServerInstanceName `
                                  -WindowsAccount $User.UserName `
                                  -FullName $User.FullName `
                                  -ContactEmail $User.Email `
                                  -ErrorAction Inquire `
                                  -Verbose

                foreach ($PermissionSet in $PermissionSets)
                {
                    New-NAVServerUserPermissionSet -ServerInstance $NavServerInstanceName `
                                                   -WindowsAccount $User.UserName `
                                                   -PermissionSetId $PermissionSet `
                                                   -ErrorAction Inquire -Verbose   
                }                                
            }

            if ($AuthenticationMethod -eq 'NavUserPassword')
            {

                $SecureDefaultPassword = ConvertTo-SecureString $DefaultPassword -AsPlainText -Force

                New-NAVServerUser -ServerInstance $NavServerInstanceName `
                                  -UserName $User.UserName `
                                  -FullName $User.FullName `
                                  -ContactEmail $User.Email `
                                  -Password $SecureDefaultPassword `
                                  -ChangePasswordAtNextLogOn  `
                                  -ErrorAction Inquire -Verbose

                foreach ($PermissionSet in $PermissionSets)
                {
                    New-NAVServerUserPermissionSet -ServerInstance $NavServerInstanceName `
                                                   -UserName $User.UserName `
                                                   -PermissionSetId $PermissionSet `
                                                   -ErrorAction Inquire -Verbose
                }                       
            }            
        }
    }    
}

