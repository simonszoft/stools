@echo off
:: WINAMO = WinGet and More installer script
:: By: Simon Nandor (nandor.simon@gmail.com)
:: Source: https://github.com/simonszoft/stools
setlocal enabledelayedexpansion

set "VER=1.0"
set "DT=2024.08.08"
set "WINGET_TITLE=Install Winget v1.8.1911 (or check if it is installed)"
set "WINGET_URL=https://github.com/microsoft/winget-cli/releases/download/v1.8.1911/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

set "LATEST_WINGET_TITLE=Check last Winget version"
set "LATEST_WINGET_URL=https://github.com/microsoft/winget-cli/releases/latest"

set "STANDARD_APPS_TITLE=Install standard applications (Firefox, Chrome, VLC, 7-Zip, SPDF, Total Commander, etc.)"
set "STANDARD_APPS=Mozilla.Firefox Google.Chrome VideoLAN.VLC 7zip.7zip Notepad++.Notepad++ SumatraPDF.SumatraPDF Ghisler.TotalCommander Oracle.JavaRuntimeEnvironment"

set "OFFICE_APPS_TITLE=Install office applications (LibreOffice, PDF tools, Greenshot, Pinta, Zettlr, etc.)"
set "OFFICE_APPS=TheDocumentFoundation.LibreOffice PDFsam.PDFsam Bullzip.PDFPrinter Greenshot.Greenshot Pinta.Pinta Zettlr.Zettlr GIMP.GIMP"

set "MSG_APPS_TITLE=Install messaging/communication applications (Messenger, Skype, Telegram, Viber, Thunderbird etc.)"
set "MSG_APPS=Facebook.Messenger Microsoft.Skype Telegram.TelegramDesktop Viber.Viber Mozilla.Thunderbird"

set "MEDIA_APPS_TITLE=Install multimedia applications (AIMP, Audacity, OpenShot, VSDC, OBSStudio etc.)"
set "MEDIA_APPS=AIMP.AIMP Audacity.Audacity OpenShot.OpenShot VSDC.Editor OBSProject.OBSStudio"

set "SYS_APPS_TITLE=Install sysadmin applications (KeePassXC, PuTTY, NETworkManager, WinSCP, RustDesk, EasyConnect, etc.)"
set "SYS_APPS=KeePassXCTeam.KeePassXC PuTTY.PuTTY BornToBeRoot.NETworkManager WinSCP.WinSCP RustDesk.RustDesk lstratman.easyconnect Microsoft.PowerToys KurtZimmermann.TweakPower MiniTool.PartitionWizard.Free NirSoft.NirCmd TopalaSoftwareSolutions.SIW Glarysoft.GlaryUtilities"

set "DEV_APPS_TITLE=Install developer applications (VS, Atom, Git, Postman, HeidiSQL, ResourceHacker, Wireshark, OpenVPN, etc.)"
set "DEV_APPS=Microsoft.VisualStudioCode GitHub.Atom Git.Git GitHub.GitHubDesktop Postman.Postman HeidiSQL.HeidiSQL AngusJohnson.ResourceHacker stnkl.EverythingToolbar NickeManarin.ScreenToGif WiresharkFoundation.Wireshark OpenVPNTechnologies.OpenVPNConnect SweetScape.010Editor" 

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
echo STOOLS - WINAMO v%VER% (%DT%)
echo !line!
echo (Win)Get (a)nd (Mo)re installer script - By: Simon Nandor
echo !line!

:: MENU
echo Select an option:
echo 1. %WINGET_TITLE%
echo 2. %LATEST_WINGET_TITLE%
echo 3. %STANDARD_APPS_TITLE%
echo 4. %OFFICE_APPS_TITLE%
echo 5. %MSG_APPS_TITLE%
echo 6. %MEDIA_APPS_TITLE%
echo 7. %SYS_APPS_TITLE%
echo 8. %DEV_APPS_TITLE%
echo 9. Exit
echo !line!
set /p choice=Enter your choice (1-9): 

if %choice%==1 goto install_winget
if %choice%==2 goto last_winget
if %choice%==3 goto install_standard
if %choice%==4 goto install_office
if %choice%==5 goto install_msg
if %choice%==6 goto install_media
if %choice%==7 goto install_sys
if %choice%==8 goto install_dev
if %choice%==9 goto exit

echo !line!
echo ERROR: Invalid choice!
echo !line!
pause
goto menu

:: INSTALL WINGET
:install_winget
echo !line!
echo %WINGET_TITLE%
winget --version >nul 2>&1
if %errorlevel%==0 (
    echo !line!
    echo Winget is already installed.
    echo !line!
    echo Installed version:
    winget --version
    echo !line!
pause
) else (
    echo !line!
    echo Winget is not installed, installing...
    echo !line!
    powershell -Command "Invoke-WebRequest -Uri %WINGET_URL% -OutFile %filename%"
    echo Running %filename%...
    start /wait %filename%    
)
goto menu

:: CHECK LAST WINGET
:last_winget
echo !line!
echo %LATEST_WINGET_TITLE%
echo !line!
start https://github.com/microsoft/winget-cli/releases/latest
goto menu

:: INSTALL STANDARD APPS
:install_standard
call :app_install_func "%STANDARD_APPS_TITLE%" "%STANDARD_APPS%"
goto menu

:: INSTALL OFFICE APPS
:install_office
call :app_install_func "%OFFICE_APPS_TITLE%" "%OFFICE_APPS%"
goto menu

:: INSTALL MSG APPS
:install_msg
call :app_install_func "%MSG_APPS_TITLE%" "%MSG_APPS%"
goto menu

:: INSTALL MEDIA APPS
:install_media
call :app_install_func "%MEDIA_APPS_TITLE%" "%MEDIA_APPS%"
goto menu

:: INSTALL SYS APPS
:install_sys
call :app_install_func "%SYS_APPS_TITLE%" "%SYS_APPS%"
goto menu

:: INSTALL DEV APPS
:install_dev
call :app_install_func "%DEV_APPS_TITLE%" "%DEV_APPS%"
goto menu

:: INSTALL APPS
:app_install_func

winget --version >nul 2>&1
if %errorlevel%==0 ( goto winget_ok ) else ( goto winget_not_ok )

:winget_ok
:: defender disable
echo !line!
echo Application install started...
echo Disabling Windows Defender temporarily...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo !line!
echo %~1
echo !line!
for %%a in (%~2) do (
    echo Installing %%a...
    winget install %%a --disable-interactivity --silent --accept-source-agreements --accept-package-agreements
)
echo !line!
echo Application install finished.
echo !line!
:: defender enable
echo Enabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
pause
goto menu

:winget_not_ok
echo !line!
echo Winget is not installed, please install it first!
echo !line!
pause
goto menu


:: KILEPES
:exit
endlocal
exit /b 0