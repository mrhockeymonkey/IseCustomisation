<#
        .SYNOPSIS
        Uses the Highlighted Text to Align based on the = delimiter - For Splatting
         
        .DESCRIPTION
        Uses the Highlighted Text to Align based on the = delimiter - For Splatting
        
        .EXAMPLE
        $psise.CurrentFile.Editor.InsertText((Get-AlignedText -Text $psISE.CurrentFile.Editor.SelectedText -Delimiter '='))
                        
        .NOTES
        AUTHOR
        Dave Wyatt
        LICENSE
        MIT 
#>

Function Format-AlignedText {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Text,

        [string]
        $Delimiter = '='
    )

    $rightmostIndex = -1

    $lines = foreach ($string in $Text) {
        foreach ($line in $string -split '\r?\n') {
            $position = $line.IndexOf($Delimiter)
            if ($position -gt $rightmostIndex) { 
                $rightmostIndex = $position 
            }

            [pscustomobject] @{
                Line     = $line
                Position = $position
            }
        }
    }

    @(
        foreach ($line in $lines) {
            if ($line.Position -ge 0 -and $line.Position -lt $rightmostIndex) {
                "{0}{1,$($rightmostIndex - $line.Position)}{2}" -f $line.Line.SubString(0, $line.Position), ' ', $line.Line.SubString($line.Position)
            }
            else {
                $line.Line
            }
        }
    ) -join "`r`n"
}


Write-Verbose "Adding Hotkey: AlignEquals (F6)" -Verbose
$MyMenu = $psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("My Tools",$null,$null)
$MyMenu.Submenus.Add("Align = signs in selected text.", { $psise.CurrentFile.Editor.InsertText((Format-AlignedText -Text $psISE.CurrentFile.Editor.SelectedText -Delimiter '=')) }, 'F6') | Out-Null