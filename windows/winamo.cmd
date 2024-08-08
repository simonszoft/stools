@echo off
:: WINAMO = WinGet and More installer script
:: By: Simon Nandor (nandor.simon@gmail.com)
:: Source: https://github.com/simonszoft/stools
setlocal enabledelayedexpansion

set "VER=1.0"
set "DT=2024.08.08"
set "WINGET_TITLE=Install Winget (or check if it is installed)"

set "STANDARD_APPS_TITLE=Install standard applications (Firefox, Chrome, VLC, 7-Zip, Notepad++, SumatraPDF, TotalCommander)"
set "STANDARD_APPS=Mozilla.Firefox Google.Chrome VideoLAN.VLC 7zip.7zip Notepad++.Notepad++ SumatraPDF.SumatraPDF Ghisler.TotalCommander"


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

:menu
cls
echo !line!
echo WINAMO v%VER% (%DT%)
echo !line!
echo (Win)Get (a)nd (Mo)re installer script
echo !line!

:: MENU
echo Select an option:
echo 1. %WINGET_TITLE%
echo 2. %STANDARD_APPS_TITLE%
echo 9. Exit
echo !line!
set /p choice=Enter your choice (1-9): 

if %choice%==1 goto install_winget
if %choice%==2 goto install_standard
if %choice%==9 goto exit

:: INSTALL WINGET
:install_winget
echo !line!
echo Installing Winget...
winget --version >nul 2>&1
if %errorlevel%==0 (
    echo !line!
    echo Winget is already installed.
    echo !line!
pause
) else (
    echo !line!
    echo Winget is not installed. Please download and install:
    echo Microsoft.DesktopAppInstaller_...msixbundle 
    echo !line!
    start https://github.com/microsoft/winget-cli/releases/latest
)
pause
goto menu

:: INSTALL STANDARD APPS
:install_standard
call :app_install_func "%STANDARD_APPS_TITLE%" "%STANDARD_APPS%"
goto menu

:: INSTALL APPS
:app_install_func
echo !line!
echo %~1
echo !line!
for %%a in (%~2) do (
    echo Installing %%a...
    winget install %%a --disable-interactivity --silent --accept-source-agreements --accept-package-agreements
)
pause
goto menu

:: KILEPES
:exit
endlocal
exit /b 0