```markdown
# Check Windows Files Today Date Time

This is a PowerShell-based plugin for Nagios and Nagios-like systems. This plugin can check and report on the following:

- Check if a file exists between specific times.

## Examples

Check if a file exists between specific times:

```powershell
.\check_windows_files_tdt.ps1 -checkPath C:\\directory\\filename.extension -startTime 8.00 -endTime 18.00 -exists
```

If you wish to check all the time then set the times as 0.00 and 24.00 as it uses a 24-hour clock.

If you wish to check for a file that contains today's date then only give the filepath to the folder you're looking in and you must add the `-today` switch and the extension type:

```powershell
.\check_windows_files_tdt.ps1 -checkPath C:\\directory -startTime 8.00 -endTime 18.00 -exists -today -ext .txt
```

## Notes

This plugin currently does not have a helper function to work with directories. Currently, you need to have two backslashes in your directory paths. E.g. `C:\\Monitoring\\MyDir\\`.

## Parameters

- `checkPath`: The path to the file or directory you wish to monitor. This is needed for all types of checks performed by the plugin.
- `exists`: The file specified should exist. If it does not, throw a CRITICAL.
- `shouldnotexist`: The file specified should not exist. If it does, throw a CRITICAL.

## Example

```powershell
PS> .\check_windows_files.ps1 -checkPath C:\\Monitoring\\MyDir\\somelogfile.log -exists
```
```
