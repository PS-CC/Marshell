function Get-ConflictingObjects
{

    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [string] $SourceFolder,
        [parameter(Mandatory=$true)]
        [string] $DestinationFolder
    )

    PROCESS
    {
        $ConflictFiles = Get-ChildItem -Path "$($SourceFolder)\*.CONFLICT"

        foreach($ConflictFile in $ConflictFiles)
        {
            $ObjectFileName = $ConflictFile -replace ".CONFLICT", ".TXT"

            Copy-Item -Path "$($ObjectFileName)" -Destination "$($DestinationFolder)\$($ObjectFileName.Name)" -Verbose

        }


    }
}