function Import-NAVObjectsFromFolder
{

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Folder,
        [Parameter(Mandatory=$true)]
        [string] $DatabaseServer,
        [Parameter(Mandatory=$true)]
        [string] $Database,
        [Parameter(Mandatory=$true)]
        [int] $NavVersion,
        [Parameter(Mandatory=$false)]
        [string] $DoneFolder
    )

    Process
    {
        . "C:\Program Files (x86)\Microsoft Dynamics NAV\$($NavVersion)\RoleTailored Client\NavModelTools.ps1" "C:\Program Files (x86)\Microsoft Dynamics NAV\$($NavVersion)\RoleTailored Client\finsql.exe"

        $ObjectFiles = dir "$($Folder)\*.TXT"

        foreach ($ObjectFile in $ObjectFiles)
        {
            Write-Host $ObjectFile.Name -ForegroundColor Cyan
            Import-NAVApplicationObject -Path $ObjectFile.FullName `
                                        -DatabaseName $Database `
                                        -DatabaseServer $DatabaseServer `
                                        -ImportAction Overwrite
                                        -Confirm:$false

            if ($DoneFolder -ne "")
            {
                if (Copy-Item -Path $ObjectFile.FullName -Destination "$($DoneFolder)\$($ObjectFile.Name)")
                {
                    Remove-Item -Path $ObjectFile.FullName
                }
                
            }                                        
        }
    }
}