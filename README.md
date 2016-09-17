Some customisations I have made to my ISE. To add these I have added the below code to my ISE Profile

```powershell

$GitPath = 'C:\Users\Scott\OneDrive\Github'

#DotSource the my personal customizations
. "$GitPath\IseCustomisation\AlignEqualsF6.ps1"
. "$GitPath\IseCustomisation\SnippetFunction.ps1"
. "$GitPath\IseCustomisation\SnippetRunspace.ps1"

```