$Snippet = @{
    Title = 'A Runspace Pool'
    Author = 'Scott Matthews'
    Description = 'Framework for Async Runspace Pool'
    Force = $true
    Text = @' 
#Create an Array List to Track Jobs
$Runspaces = [System.Collections.ArrayList]::new()

#Create the Runspace Pool
$SessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$RunspacePool = [runspacefactory]::CreateRunspacePool(
    1,             #Min Runspaces
    10,            #Max Runspaces
    $SessionState, #Initial Session State
    $host          #System.Management.Automation.Host.PSHost
)
$RunspacePool.Open()


1..20 | ForEach-Object {
    
    #Define the Script and Params
    $Params = @{
        Seconds = Get-Random -Minimum 1 -Maximum 11
    }
    $Script = {
        [CmdletBinding()]
        Param(
            $Seconds
        )
        $ThreadID = [System.AppDomain]::GetCurrentThreadId()
        Write-Output "Starting ThreadId $ThreadID"
        Start-Sleep -Seconds $Seconds
        Write-Output "Ending ThreadId $ThreadID after $Seconds seconds"
    }

    #Create Powershell Instance for your job
    $PowerShell = [powershell]::Create()
    $PowerShell.RunspacePool = $RunspacePool
    [Void]$PowerShell.AddScript($Script).AddParameters($Params)
    
    #Invoke Async and Track
    [Void]$Runspaces.Add([PSCustomObject]@{
        Runspace = $PowerShell.BeginInvoke()
        PowerShell = $PowerShell
    })
}

#Retreive output and cleanup as jobs complete
Do {
    $More = $false    
    $CompletedRunspaces = [System.Collections.ArrayList]::new()
    $Runspaces | Where-Object -FilterScript {$_.Runspace.isCompleted} | ForEach-Object {
        $_.Powershell.EndInvoke($_.Runspace)
        $_.Powershell.Dispose()
        [Void]$CompletedRunspaces.Add($_)
    }
    $CompletedRunspaces | ForEach-Object {
        [Void]$Runspaces.Remove($_)
    }
    If ($Runspaces.Count -gt 0) {
        $More = $True
        Start-Sleep -Milliseconds 100
    }
}
While ($More)
'@
}

Write-Verbose "Adding Snippet: Runspace Pool" -Verbose
Get-IseSnippet | ?{$_.Name -eq "$($Snippet.Title).snippets.ps1xml"} | Remove-Item
New-IseSnippet @snippet
