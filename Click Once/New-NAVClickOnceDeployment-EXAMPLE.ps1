. "C:\GitHub\Marshell\Click Once\New-NAVClickOnceDeployment.ps1"

$Folder = "C:\Deployment"
New-NAVClickOnceDeployment -NavVersion 130 `
                                -DeploymentFolder 'C:\inetpub\wwwroot\BCClickOnceDemo' `
                                -DeploymentURL 'http://localhost/BCClickOnceDemo' `
                                -LogFile "$($Folder)\log.txt" `
                                -Mage "$($Folder)\mage.exe" `
                                -SigningPfxFile "$($Folder)\ClickOnceSignature.pfx" `
                                -SigningPfxFilePassword 'clickoncesignaturepassword' `
                                -ClientUserSettingsFile "$($Folder)\ClientUserSettings.config" `
                                -WebConfigFile "$($Folder)\web.config" `
                                -PartnerName 'Marcellus' `
                                -CustomerName 'NorthWind' `
                                -ProductName 'Business Central DEMO'