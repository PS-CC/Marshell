. "C:\GitHub\Marshell\Click Once\Update-NAVClickOnceDeployment.ps1"

$Folder = "C:\Deployment"
Update-NAVClickOnceDeployment -NavVersion 130 `
                             -DeploymentFolder 'C:\inetpub\wwwroot\BCClickOnceDemo' `
                             -DeploymentURL 'http://localhost/BCClickOnceDemo'  `
                             -LogFile "$($Folder)\log.txt" `
                             -Mage "$($Folder)\mage.exe" `
                             -SigningPfxFile "$($Folder)\ClickOnceSignature.pfx" `
                             -SigningPfxFilePassword 'clickoncesignaturepassword' `
                             -ClientUserSettingsFile "$($Folder)\ClientUserSettings.config" `
                             -ClickOnceVersion "13.0.0.1" `
                             -NewApplicationFilesFolderName 'ApplicationFiles2'