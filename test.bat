@echo off
title WiFi Information Retrieval
echo ===================================
echo    WiFi Information Retrieval
echo ===================================
echo.

:: Create output directory
set outputdir=%TEMP%\wifi_info
mkdir %outputdir% 2>nul

:: Get currently connected WiFi
echo Getting current WiFi connection...
netsh wlan show interfaces | findstr "SSID" | findstr /V "BSSID" > "%outputdir%\current_wifi.txt"
for /f "tokens=2 delims=:" %%a in ('type "%outputdir%\current_wifi.txt"') do set currentwifi=%%a
set currentwifi=%currentwifi:~1%
echo Current WiFi: %currentwifi%
echo.

:: Get all saved WiFi profiles
echo Getting all saved WiFi profiles...
netsh wlan show profiles > "%outputdir%\wifi_profiles.txt"
echo.

:: Create a summary file
echo Creating WiFi information report...
echo WIFI INFORMATION REPORT > "%outputdir%\wifi_report.txt"
echo ================================== >> "%outputdir%\wifi_report.txt"
echo. >> "%outputdir%\wifi_report.txt"

echo CURRENT CONNECTION: >> "%outputdir%\wifi_report.txt"
echo %currentwifi% >> "%outputdir%\wifi_report.txt"
echo. >> "%outputdir%\wifi_report.txt"

echo ALL SAVED WIFI NETWORKS AND PASSWORDS: >> "%outputdir%\wifi_report.txt"
echo ================================== >> "%outputdir%\wifi_report.txt"
echo. >> "%outputdir%\wifi_report.txt"

:: List all profiles and get their passwords
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr /C:"All User Profile"') do (
    set wifi=%%a
    set wifi=!wifi:~1!
    echo Processing network: !wifi!
    
    echo. >> "%outputdir%\wifi_report.txt"
    echo Network: !wifi! >> "%outputdir%\wifi_report.txt"
    
    :: Get password for this network
    netsh wlan show profile name="!wifi!" key=clear | findstr /C:"Key Content" > "%outputdir%\temp_pwd.txt"
    for /f "tokens=2 delims=:" %%b in ('type "%outputdir%\temp_pwd.txt"') do set pwd=%%b
    set pwd=!pwd:~1!
    
    echo Password: !pwd! >> "%outputdir%\wifi_report.txt"
    echo ---------------------------------- >> "%outputdir%\wifi_report.txt"
)

echo.
echo ===================================
echo Report completed!
echo Opening report...
start notepad "%outputdir%\wifi_report.txt"

echo.
echo Report saved to: %outputdir%\wifi_report.txt
echo ===================================

pause