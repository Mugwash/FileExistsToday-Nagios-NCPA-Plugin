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
    [Parameter(Mandatory=$false)][string]$dateTimeFormat,
    [Parameter(Mandatory=$true)][float]$startTime,
    [Parameter(Mandatory=$true)][float]$endTime,
    [Parameter(Mandatory=$false)][string]$filename,
    
    
    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$exists,
    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$shouldnotexist,


    [Parameter(Mandatory=$false)][switch]$today

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
        [Parameter(Mandatory=$true)][string]$path,
        [Parameter(Mandatory=$false)][string]$formattedDateTime,
        [Parameter(Mandatory=$true)][string]$remainingFilename
    )

    $returnBool = $false

    foreach ($extension in $fileExtensions) {
    $tempPath = "$path\\$formattedDateTime$remainingFilename$extension"
    Write-Host "File extension: $tempPath"
    if (Get-CimInstance -ClassName CIM_LogicalFile `
        -Filter "Name='$tempPath'" `
        -KeyOnly `
        -Namespace root\cimv2) {

        $returnBool = $true

    }}

    return $returnBool
}

## MAIN SCRIPT ##
##possible file extensions array
$fileExtensions = @(
    ".txt",
    ".doc",
    ".docx",
    ".pdf",
    ".jpg",
    ".png",
    ".xlsx",
    ".csv",
    ".mp3",
    ".mp4",
    ".html",
    ".xml",
    ".json",
    ".zip",
    ".rar"
    # Add more extensions as needed
)
#Set the date and times  
$currentDate = Get-Date
$formattedTime = $currentDate.ToString("HH.mm")/1

Write-Host "$checkpath$formattedDate"

If ($today -eq $true){
    $formattedDate = $currentDate.ToString($dateTimeFormat)
}
#check if the current time is between the start and end times
If ($formattedTime -ge $startTime -and $formattedTime -le $endTime)
{
    #confirm that the current time is applicable
    Write-Output "$formattedTime time is between $startTime and $EndTime"
    #check if the file exists
    if ($exists -eq $true) {
    if (checkFileExists -path $checkpath -formattedDateTime $formattedDate -remainingFilename $filename) {
        if ($shouldnotexist -eq $true) {
            $exitMessage = "CRITICAL: I found the file $checkpath\\$formattedDate$filename, and it shouldn't exist!"
            $exitCode = 2
        }
        else {
            $exitMessage = "OK: I found the file $checkpath\\$formattedDate$filename"
            $exitCode = 0
        }
    }
    else {
        if ($shouldnotexist -eq $true) {
            $exitMessage = "OK: I did not find the file $checkpath\\$formattedDate$filename, and it shouldn't exist."
            $exitCode = 0
        }
        else {
            $exitMessage = "CRITICAL: I did not find the file, $checkpath\\$formattedDate$filename"
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
