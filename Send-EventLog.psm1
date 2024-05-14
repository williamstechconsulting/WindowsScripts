<#
 .SYNOPSIS
 Streamlines creating and writing events to a custom Windows event log.
 .DESCRIPTION
 Creates custom Windows event log if one does not exist. Writes events to the custom log as information, warning, or error type along with specified message
 .PARAMETER LogName
 Name of the custom Windows event log
 .PARAMETER Source
 Name of the script or service that generates the log message
 .PARAMETER EventId
 Numerical identifier for the logged event.
 .PARAMETER Message
 Descriptive message written to the event log
 .PARAMETER Err
 Switch to designate an Error entry type
 .PARAMETER Warning
 Switch to designate a Warning entry type

 .EXAMPLE
 # Write an informational message to the event log from an intune script
 Send-EventToLog -LogName "OrgName/InTuneScripts" -Source "Install-WindowsPatch.ps1" -EventId 1 -Message "The specified patch has successfully installed"

 .EXAMPLE
 # Write a warning message to the event log
 Send-EventToLog -LogName "OrgName/InTuneScripts" -Source "Uninstall-EndpointAntiVirus.ps1" -EventId 2 -Message "Uninstallation has succeeded but some dependencies could not be removed." -Warning

 .EXAMPLE
 # Write an error message to the event log
 Send-EventToLog -LogName "OrgName/InTuneScripts" -Source "Update-MicrosoftDefenderConfig.ps1" -EventId 21 -Message "Defender configuration could not be updated. Error Message: $Error[0]" -Err
#>

Function Send-EventToLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][String]$LogName,
        [Parameter(Mandatory)][String]$Source,
        [Parameter(Mandatory)][Int32]$EventId,
        [Parameter(Mandatory)][String]$Message,
        [Parameter()][Switch]$Err,
        [Parameter()][Switch]$Warning
    )
    if (!([System.Diagnostics.EventLog]::Exists($LogName))) {
        New-EventLog -LogName $LogName -Source $Source
    }
    if (!([System.Diagnostics.EventLog]::SourceExists($Source))) {
        [System.Diagnostics.EventLog]::CreateEventSource($Source, $LogName)
    }
    if ($Err -and !$Warning) {
        Write-EventLog -LogName $LogName -Source $Source -EventId $EventId -EntryType "Error" -Message $Message
    } elseif ($Warning -and !$Err) {
        Write-EventLog -LogName $LogName -Source $Source -EventId $EventId -EntryType "Warning" -Message $Message
    } Elseif (!$Warning -and !$Err) {
        Write-EventLog -LogName $LogName -Source $Source -EventId $EventId -EntryType "Information" -Message $Message
    } Else {
        Write-Host 'You cannot include "-Warning" and -"Err" in a single log message' -ForegroundColor Red
    }
}

Export-ModuleMember -Function *