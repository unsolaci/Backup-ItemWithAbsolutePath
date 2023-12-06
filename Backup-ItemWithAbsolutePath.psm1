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

