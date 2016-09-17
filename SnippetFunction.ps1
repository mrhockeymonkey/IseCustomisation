$Snippet = @{
    Title = 'A Function (+help)'
    Author = 'Scott Matthews'
    Description = 'Framework for a function'
    Force = $true
    Text = @' 
<#
    .SYNOPSIS
        Short description
    
    .DESCRIPTION
        Long description
    
    .PARAMETER Name
        Description of parameter
    
    .EXAMPLE
        Example of how to use this cmdlet
    
    .EXAMPLE
        Another example of how to use this cmdlet
#>
   
Function Verb-Noun {
    [CmdletBinding()]
    Param (

    )

    Begin {}

    Process {}

    End {}
}
'@
}

Write-Verbose "Adding Snippet: Function" -Verbose
Get-IseSnippet | ?{$_.Name -eq "$($Snippet.Title).snippets.ps1xml"} | Remove-Item
New-IseSnippet @snippet
