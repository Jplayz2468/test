@echo off
title System Utility Script
echo ===================================
echo    SYSTEM UTILITY SCRIPT
echo ===================================
echo.

:: Create a timestamp for logging
set timestamp=%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
set timestamp=%timestamp: =0%

:: Create a report directory in temp folder
set reportdir=%TEMP%\system_report
mkdir %reportdir% 2>nul

echo Creating system report in %reportdir%...
echo.

:: Get system info
echo Collecting system information...
systeminfo | findstr /C:"OS" /C:"System Type" /C:"Total Physical Memory" > "%reportdir%\sysinfo.txt"
echo Done.

:: Get network info
echo Collecting network information...
ipconfig /all > "%reportdir%\network.txt"
echo Done.

:: Get running processes
echo Listing running processes...
tasklist /v > "%reportdir%\processes.txt"
echo Done.

:: Get installed software
echo Listing installed software...
wmic product get name,version > "%reportdir%\software.txt"
echo Done.

:: Create a summary file
echo Creating summary report...
echo SYSTEM REPORT - %timestamp% > "%reportdir%\summary.txt"
echo ================================== >> "%reportdir%\summary.txt"
echo. >> "%reportdir%\summary.txt"

echo SYSTEM INFORMATION: >> "%reportdir%\summary.txt"
type "%reportdir%\sysinfo.txt" >> "%reportdir%\summary.txt"
echo. >> "%reportdir%\summary.txt"

echo IP CONFIGURATION: >> "%reportdir%\summary.txt"
ipconfig | findstr /C:"IPv4" /C:"Subnet" /C:"Gateway" >> "%reportdir%\summary.txt"
echo. >> "%reportdir%\summary.txt"

echo TOP 5 PROCESSES BY MEMORY USAGE: >> "%reportdir%\summary.txt"
wmic process get Caption,WorkingSetSize /format:list | findstr /C:"Caption" /C:"WorkingSetSize" | sort >> "%reportdir%\summary.txt"
echo. >> "%reportdir%\summary.txt"

:: Open the summary file
echo.
echo ===================================
echo Report completed successfully!
echo Opening summary report...
start notepad "%reportdir%\summary.txt"

:: Create a shortcut to the report directory on desktop
echo Creating shortcut on desktop...
powershell "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\System Report.lnk'); $Shortcut.TargetPath = '%reportdir%'; $Shortcut.Save()"

echo.
echo ===================================
echo All tasks completed successfully!
echo Report location: %reportdir%
echo ===================================

pause