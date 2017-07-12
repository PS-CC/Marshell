. "C:\GitHub\Marshell\Click Once\Update-NAVClickOnceDeployment.ps1"

Update-NAVClickOnceDeployment -NavVersion 100 `
                             -DeploymentFolder 'C:\inetpub\wwwroot\ClickOnceDemo' `
                             -DeploymentURL 'http://localhost/ClickOnceDemo'  `
                             -LogFile 'C:\Deployment\log.txt' `
                             -Mage 'C:\Deployment\mage.exe' `
                             -SigningPfxFile 'C:\Deployment\ClickOnceSignature.pfx' `
                             -SigningPfxFilePassword 'clickoncesignaturepassword' `
                             -ClientUserSettingsFile 'C:\Deployment\ClientUserSettings.config' `
                             -ClickOnceVersion "10.0.0.1" `
                             -NewApplicationFilesFolderName 'ApplicationFiles2'