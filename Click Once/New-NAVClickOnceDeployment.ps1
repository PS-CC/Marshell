function New-NAVClickOnceDeployment
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [int] $NavVersion,

        [parameter(Mandatory=$true)]
        [string] $DeploymentFolder,

        [parameter(Mandatory=$true)]
        [string] $DeploymentURL,

        [parameter(Mandatory=$true)]
        [string] $Mage,

        [parameter(Mandatory=$true)]
        [string] $LogFile,

        [parameter(Mandatory=$true)]
        [string] $SigningPfxFile,

        [parameter(Mandatory=$true)]
        [string] $SigningPfxFilePassword,

        [parameter(Mandatory=$true)]
        [string] $ClientUserSettingsFile,

        [parameter(Mandatory=$true)]
        [string] $WebConfigFile,

        [parameter(Mandatory=$true)]
        [string] $PartnerName,

        [parameter(Mandatory=$true)]
        [string] $CustomerName,

        [parameter(Mandatory=$true)]
        [string] $ProductName

    )

    PROCESS
    {

        # Generate Setup Values

        ## Deployment Folder
        $ApplicationFolderName = 'ApplicationFiles';
        $ApplicationfilesFolderPath = "$($DeploymentFolder)\Deployment\$($ApplicationFolderName)"
        $DeploymentFilePath = "$($DeploymentFolder)\Deployment\"

        ## NAV Client Folder
        if (110 -ge $NavVersion)
        {
            $NavClientFolder = "C:\Program Files (x86)\Microsoft Dynamics NAV\$($NavVersion)\"
        }else
        {
            $NavClientFolder = "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$($NavVersion)\"
        }
        $RoleTailoredClientFolder = "$($NavClientFolder)\RoleTailored Client"
        $ClickOnceTemplateFolder = "$($NavClientFolder)\ClickOnce Installer Tools\TemplateFiles\"

        # Create Folder
        mkdir $DeploymentFolder -Verbose

        # Copy Files

        ## Copy Template Files
        cd $ClickOnceTemplateFolder
        $Templatefiles = dir
        foreach($Templatefile in $Templatefiles)
        { 
            Copy-Item -Path $Templatefile -Destination $DeploymentFolder -Recurse -Verbose
        }

        ## Copy WebConfig
        Copy-Item -Path $WebConfigFile -Destination $DeploymentFolder -Verbose

        ## Copy Client User Settings File
        Copy-Item -Path $ClientUserSettingsFile -Destination $ApplicationfilesFolderPath -Verbose

        ## Copy Role Tailored Client Files        
        Copy-Item "$RoleTailoredClientFolder\RapidStart.ico"                           -Destination "$ApplicationfilesFolderPath" -Verbose
        Copy-Item "$RoleTailoredClientFolder\Microsoft.Dynamics.Nav.Client.exe"        -Destination "$ApplicationfilesFolderPath" -Verbose
        Copy-Item "$RoleTailoredClientFolder\Microsoft.Dynamics.Nav.Client.exe.config" -Destination "$ApplicationfilesFolderPath" -Verbose
        Copy-Item "$RoleTailoredClientFolder\*.dll"                                    -Destination "$ApplicationfilesFolderPath" -Verbose

        Copy-Item "$RoleTailoredClientFolder\Add-ins"                                  -Destination "$ApplicationfilesFolderPath\Add-ins" -Recurse -Verbose        
        Copy-Item "$RoleTailoredClientFolder\SLT"                                      -Destination "$ApplicationfilesFolderPath\SLT" -Recurse -Verbose
        Copy-Item "$RoleTailoredClientFolder\Images"                                   -Destination "$ApplicationfilesFolderPath\Images"  -Recurse -Verbose
        Get-ChildItem -Path "$RoleTailoredClientFolder\??-??" -Directory | % {
            $Name = $_.Name
            Copy-Item "$RoleTailoredClientFolder\$Name" -Destination "$ApplicationfilesFolderPath\$Name" -Recurse -Verbose
        }

        if (Test-Path -Path "$ApplicationfilesFolderPath\Add-ins\Microsoft.IdentityModel.Clients.ActiveDirectory.dll")
        {
            Remove-Item -Path "$ApplicationfilesFolderPath\Add-ins\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        }

        # Update and Sign Application Manifest
        cd $ApplicationfilesFolderPath -Verbose

        ## Update
        $MageParams = ("-Update " + "Microsoft.Dynamics.Nav.Client.exe.manifest"), "-FromDirectory ."
        $Process = Start-process $Mage -ArgumentList $MageParams -RedirectStandardOutput $LogFile -Wait
        $MageOutput = Get-Content $LogFile
        Write-host -ForegroundColor Cyan $MageOutput

        ## Sign
        $MageParams = ("-sign " + "Microsoft.Dynamics.Nav.Client.exe.manifest"), `
                        ("-certfile " + $SigningPfxFile), `
                        ("-password " + $SigningPfxFilePassword)
        $Process = Start-process $Mage -ArgumentList $MageParams -RedirectStandardOutput $LogFile -Wait
        $MageOutput = Get-Content $LogFile
        Write-host -ForegroundColor Cyan $MageOutput

        # Update and Sign Deployment Manifest
        cd "$($DeploymentFolder)\Deployment" -Verbose

        ## Update
        $MageParams = ("-Update " + "Microsoft.Dynamics.Nav.Client.application"), `
                                 ("-appmanifest " + "$($ApplicationFolderName)/Microsoft.Dynamics.Nav.Client.exe.manifest"), `
                                 ("-appcodebase " + "$($DeploymentURL)/Deployment/$($ApplicationFolderName)/Microsoft.Dynamics.Nav.Client.exe.manifest")
        $Process = Start-process $Mage -ArgumentList $MageParams -RedirectStandardOutput $LogFile -Wait
        $MageOutput = Get-Content $LogFile
        Write-host -ForegroundColor Cyan $MageOutput

        
        $PublisherName = "Microsoft Corporation and " + $PartnerName
        $DeploymentCodeBase = "$($DeploymentURL)/Deployment/Microsoft.Dynamics.Nav.Client.application"

        $xml = [xml](Get-Content ("$($DeploymentFilePath)\Microsoft.Dynamics.Nav.Client.application"))

        $node = $xml.assembly.assemblyIdentity
        $node.Name = $ProductName
        $node = $xml.assembly.description
        $node.publisher = $PublisherName
        $node.product = $ProductName
        $node = $xml.assembly.deployment.deploymentProvider
        $node.codebase = $DeploymentCodeBase

        $xml.Save("$($DeploymentFilePath)\Microsoft.Dynamics.Nav.Client.application")


        ## Sign
        $MageParams = ("-sign " + "Microsoft.Dynamics.Nav.Client.application"), `
                       ("-certfile " + "$($SigningPfxFile)"), `
                       ("-password " + "$($SigningPfxFilePassword)")
        $Process = Start-process $Mage -ArgumentList $MageParams -RedirectStandardOutput $LogFile -Wait
        $MageOutput = Get-Content $LogFile
        Write-host -ForegroundColor Cyan $MageOutput
    }
}
