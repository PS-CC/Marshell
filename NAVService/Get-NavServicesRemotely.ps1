function Get-NavServicesRemotely
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [int] $NavVersion,
        [Parameter(Mandatory=$true)]
        [array] $Severs
    )

    Process
    {
        $Arguments = ($NavVersion) 
        $ServiceConfigurations

        foreach($Server in $Servers)
        {
            Write-Host "Connecting To $($server)..." -ForegroundColor Cyan
        
            $LineNo = 1

            $RemoteSession = New-PSSession -ComputerName $Server -EnableNetworkAccess

            Invoke-Command -Session $RemoteSession -ArgumentList $Arguments `
            -ScriptBlock{
                Import-Module "c:\Program Files\Microsoft Dynamics NAV\$($args[0])\Service\NavAdminTool.ps1" | Out-Null
                $ServiceConfigurations = New-Object System.Collections.ArrayList

                Write-Host '..............................' -ForegroundColor Cyan
                Write-Host 'Retreiving services...' -ForegroundColor Cyan
                Write-Host '..............................' -ForegroundColor Cyan

                $Services = Get-NAVServerInstance
                foreach ($Service in $Services)
                {
                    $LineNo++

                    $NavServerInstance = $Service.ServerInstance
                    $NavServerInstance = $NavServerInstance.Replace('MicrosoftDynamicsNavServer$', '')

                    $ConfigObjectProperties = @{
                        "InstanceName" = ""
                        "DatabaseServer" = ""
                        "DatabaseInstance" = ""
                        "DatabaseName" = ""
                        "ServiceAccount" = ""
                        "State" = ""
                    }

                    $Config = New-Object -TypeName psobject -Property $ConfigObjectProperties
                    
                    $Config.InstanceName = $NavServerInstance
                    $Config.ServiceAccount = $Service.ServiceAccount
                    $Config.State = $Service.State

                    $NavServiceConfig = Get-NavServerConfiguration $NavServerInstance

                    foreach ($Element in $NavServiceConfig)
                    {
                        if ($Element.key -eq "DatabaseServer")
                        {
                            $Config.DatabaseServer = $Element.value
                        }
                        if ($Element.key -eq "DatabaseInstance")
                        {
                            $Config.DatabaseInstance = $Element.value
                        }
                        if ($Element.key -eq "DatabaseName")
                        {
                            $Config.DatabaseName = $Element.value
                        }
                    }

                    $ServiceConfigurations.Add($Config) | Out-Null
                }  
                return $ServiceConfigurations
            }
        }    
    }
}