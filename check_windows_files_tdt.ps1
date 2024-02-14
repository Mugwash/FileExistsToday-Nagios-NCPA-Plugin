<#
.DESCRIPTION
Check Windows Files Today Date Time
This is a Powershell based plugin for Nagios and Nagios-Like systems. This plugin can check and report on the folling:
#check if file exists between specific times 
.EXAMPLE
.\check_windows_files_tdt.ps1 -checkPath C:\\directory\\filename.extension -startTime 8.00 -endTime 18.00 -exists
#if you wish to check all the time then set the times as 0.00 and 24.00 as it uses a 24 hour clock
#if you wish to check for a file that contains todays date then only give the filepath to the folder you're looking in and you must add the -today switch and the extension type
.EXAMPLE
.\check_windows_files_tdt.ps1 -checkPath C:\\directory -startTime 8.00 -endTime 18.00 -exists -today -ext .txt
.NOTES
This plugin currently does not have a helper function to work with directories. Currently you need to have two backslashes in your directory paths. E.g. C:\\Monitoring\\MyDir\\
.PARAMETER checkPath
The path to the file or directory you wish to monitor. This is needed for all types of checks performed by the plugin.
.PARAMETER exists
The file specified should exist. If it does not, throw a CRITICAL.
.PARAMETER shouldnotexist
The file specified should not exist. If it does, throw a CRITICAL.
.EXAMPLE
PS> .\check_windows_files.ps1 -checkPath C:\\Monitoring\\MyDir\\somelogfile.log -exists
#>

param (
    [Parameter(Mandatory=$true)][string]$checkPath,
    [Parameter(Mandatory=$true)][float]$startTime,
    [Parameter(Mandatory=$true)][float]$EndTime,
    
    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$exists,
    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$shouldnotexist,


    [Parameter(Mandatory=$false)][switch]$today,
    [Parameter(Mandatory=$false)][string]$extension

)

#Setting global error action preference
#Will probably revisit this when I add the verbose switch
$ErrorActionPreference = "SilentlyContinue"
[int]$exitCode = 2
[string]$exitMessage = "CRITICAL: something wicked happened"
[decimal]$version = 1.3

function sanitizePath {
    #TODO: Need to figure out how to sanitize a path in Powershell.
    #I want people to be able to do C:\Path\To\File, not C:\\Path\\To\\File
    param (
        [Parameter(Mandatory=$true)][string]$checkPath
    )

    $returnPath = $checkPath

    return $returnPath
}

function checkFileExists {
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )

    $returnBool = $false

    if (Get-CimInstance -ClassName CIM_LogicalFile `
        -Filter "Name='$Path'" `
        -KeyOnly `
        -Namespace root\cimv2) {

        $returnBool = $true

    }

    return $returnBool
}


## MAIN SCRIPT ##
#Set the date and times  
$currentDate = Get-Date
$formattedTime = $currentDate.ToString("HH.mm")/1
$formattedDate = $currentDate.ToString("dd_MM_yyyy")

#check if command wants to check for a file that is todays date
If ($today -eq $true){
    $checkPath = $checkPath+"\\"+$formattedDate+$extension
}

#check if the current time is between the start and end times
If ($formattedTime -ge $startTime -and $formattedTime -le $EndTime)
{
    #confirm that the current time is applicable
    Write-Output "$formattedTime time is between $startTime and $EndTime"
    #check if the file exists
    if ($exists -eq $true) {
    if (checkFileExists -Path $checkPath) {
        if ($shouldnotexist -eq $true) {
            $exitMessage = "CRITICAL: I found the file $checkPath, and it shouldn't exist!"
            $exitCode = 2
        }
        else {
            $exitMessage = "OK: I found the file $checkPath"
            $exitCode = 0
        }
    }
    else {
        if ($shouldnotexist -eq $true) {
            $exitMessage = "OK: I did not find the file $checkpath, and it shouldn't exist."
            $exitCode = 0
        }
        else {
            $exitMessage = "CRITICAL: I did not find the file, $checkPath"
            $exitCode = 2
        }
    }
}
}
else
{   #if the time is not between the stated start and end time then exit as true as you are not wanting to check for a file therefore you don't want to flag Nagios'
    $exitMessage = "$formattedTime time is not between $startTime and $EndTime therefore default true"
    $exitCode = 0
}
#output relevant info to console/nagios
Write-Output $exitMessage
exit [int]$exitCode