<#
.DESCRIPTION<br>
Check Windows Files Today Date Time<br>
This is a PowerShell-based plugin for Nagios and Nagios-Like systems. This plugin can check and report on the following:<br>
- Check if a file exists between specific times.<br>

.EXAMPLE<br>
.\check_windows_files_tdt.ps1 -checkPath C:\\directory\\filename.extension -startTime 8.00 -endTime 18.00 -exists<br>
If you wish to check all the time, then set the times as 0.00 and 24.00 as it uses a 24-hour clock.<br>
If you wish to check for a file that contains today's date, then only give the filepath to the folder you're looking in and add the -today switch and the extension type.<br>

.EXAMPLE<br>
.\check_windows_files_tdt.ps1 -checkPath C:\\directory -startTime 8.00 -endTime 18.00 -exists -today -ext .txt<br>

.NOTES<br>
This plugin currently does not have a helper function to work with directories. Currently, you need to have two backslashes in your directory paths (e.g., C:\\Monitoring\\MyDir\\).<br>

.PARAMETER checkPath<br>
The path to the file or directory you wish to monitor. This is needed for all types of checks performed by the plugin.<br>

.PARAMETER startTime<br>
The time you wish to start checking for the file. This is needed for the time-based checks.<br>

.PARAMETER endTime<br>
The time you wish to stop checking for the file. This is needed for the time-based checks.<br>

.PARAMETER exists<br>
The file specified should exist. If it does not, throw a CRITICAL.<br>

.PARAMETER shouldnotexist<br>
The file specified should not exist. If it does, throw a CRITICAL.<br>

.PARAMETER today<br>
This switch is used to check for files that contain today's date. This is needed for the time-based checks.<br>

.PARAMETER ext<br>
The file extension you wish to check for. This is needed for the time-based checks.<br>

.EXAMPLE<br>
PS> .\check_windows_files.ps1 -checkPath C:\\Monitoring\\MyDir\\somelogfile.log -exists<br>
#>

