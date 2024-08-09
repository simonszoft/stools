@echo off
:: WINCS - Windows Classic Setting script
:: Keszitette: Simon Nandor (nandor.simon@gmail.com)
:: Forras: https://github.com/simonszoft/stools
setlocal enabledelayedexpansion

set "VER=1.0"
set "DT=2024.08.08"

:: Check if the script is run as an administrator
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run the script as an administrator!
    pause
    exit /b 1
)

:: draw line
:draw_line
set "line="
for /L %%i in (1,1,80) do set "line=!line!-"

cls
echo !line!
echo STOOLS - WDEFSET v%VER% (%DT%)
echo !line!
echo (Win)dows (C)lassic (s)etting script - By: Simon Nandor
echo !line!

:: Enable "This PC", "My Documents / User's Files ", and "Recycle Bin" icons on the desktop
echo Enable "This PC", "My Documents / User's Files", and "Recycle Bin" icons on the desktop? (Y/N)
choice /c YN /n /m "?: "
if errorlevel 2 goto N1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{450D8FBA-AD25-11D0-98A8-0800361B1103}" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
echo Icons enabled successfully!
echo !line!
:N1

:: Set the search panel to icon only
echo Set the search panel to icon only?
choice /c YN /n /m "?: "
if errorlevel 2 goto N2
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 1 /f
:N2

:: Check if the OS is Windows 11
for /f "tokens=4-5 delims=[.] " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" geq "10.0" (
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" | findstr /i "Windows 11" >nul
    if %errorlevel% equ 0 (
        :: Set classic startmenu
        echo Windows 11 detected. 
        echo Set the classic startmenu?
        choice /c YN /n /m "?: "
        if errorlevel 2 goto N3
        reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d 1 /f
        echo Classic startmenu enabled successfully!
        echo !line!
    )
)
:N3

:: Refresh the desktop to apply changes
echo !line!
echo Refreshing the desktop to apply changes...
powershell -command "Stop-Process -Name explorer -Force"
start explorer
echo !line!
echo Everything done!
pause

:: EXIT
:exit
endlocal
exit /b 0