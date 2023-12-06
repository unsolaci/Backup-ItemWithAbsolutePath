<#PSScriptInfo
.VERSION     1.0.0
.DESCRIPTION Copies files and directories including absolute paths.
.AUTHOR      Wojciech Ros (code@unsola.ci)
.COPYRIGHT   Copyright 2023 Wojciech Ros (code@unsola.ci)
.LICENSEURI  http://www.apache.org/licenses/LICENSE-2.0
.GUID        ccc7658f-3ac5-4bb1-ac21-6c8032c44056
#>

<#
.SYNOPSIS
    Copies files and directories including absolute paths.
.DESCRIPTION
    Inspired by 7-Zip's `-spf` switch, copies files and directories,
    including the full specified absolute source paths into the
    destination path, creating all the necessary parent directories
    if they don't exist.

    For example:

    > Backup-ItemWithAbsolutePath `
        -Path "/etc/sourcedirectory/source.file" `
        -Destinaion "/home/user/backup/"

    will copy `source.file` into `/home/user/backup/etc/sourcedirectory/`.

    **Note:** The path created in the destination directory will be exactly
              as specified in the source path, i.e. if the specified source
              path is not fully qualified, it will NOT be converted to a
              fully qualified path, e.g.:

    > Backup-ItemWithAbsolutePath `
        -Path "./sourcedirectory/source.file" `
        -Destinaion "/home/user/backup/"

    will copy `source.file` into `/home/user/backup/sourcedirectory/`.
#>

function Backup-ItemWithAbsolutePath {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        [string[]]$Path,
        [string]$Destination
    )

    function Write-DebugVariableValue {
        param(
            [string]$VariableName
        )
    
        $VariableValue =
            (Get-Variable $VariableName).Value
    
        Write-Debug "`$$VariableName == $VariableValue"
    }

    $Path | Foreach-Object {
        $Path = $_
    
        Write-DebugVariableValue "VerbosePreference"
        Write-DebugVariableValue "Path"
        Write-DebugVariableValue "Destination"

        $SourceParentPath =
            $Path | Split-Path -Parent
        Write-DebugVariableValue "SourceParentPath"

        $SourceLeafName =
            $Path | Split-Path -Leaf
        Write-DebugVariableValue "SourceLeafName"

        $AbsoluteDestinationDirectory =
            Join-Path `
                -Path $Destination `
                -ChildPath $SourceParentPath
        Write-DebugVariableValue "AbsoluteDestinationDirectory"

        $AbsoluteDestination =
            Join-Path `
                -Path $AbsoluteDestinationDirectory `
                -ChildPath $SourceLeafName
        Write-DebugVariableValue "AbsoluteDestination"

        $AbsoluteDestinationDirectoryExists = 
            [bool](
                Get-Item `
                    -Path $AbsoluteDestinationDirectory `
                    -ErrorAction SilentlyContinue
            )
        Write-DebugVariableValue "AbsoluteDestinationDirectoryExists"

        if (! $AbsoluteDestinationDirectoryExists) {
            New-Item `
                -ItemType Directory `
                -Name "$AbsoluteDestinationDirectory" `
                -Force `
                -Verbose:$VerbosePreference
                | Out-Null
        }

        Copy-Item `
            -Path $Path `
            -Destination $AbsoluteDestination `
            -Recurse `
            -Verbose:$VerbosePreference
    }
}

