Nagios NCPA plugin which checks if files exists. 
Allows you to set a time to perform the check as well as if you're looking for a file with todays date in the name.
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
