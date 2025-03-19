@echo off
:: EGYRE = Egyszeru Rendszergazda eszkoztar
:: Keszitette: Simon Nandor (nandor.simon@gmail.com)
:: Forras: https://github.com/simonszoft/stools
setlocal

set "VER=1.1b"
set "DT=2025.03.19"
set "GIT_URL=https://raw.githubusercontent.com/simonszoft/stools/refs/heads/main/windows/egyre.cmd"

:: Ellenorizzük, hogy a scriptet rendszergazdakent futtatják-e
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo HIBA: A szkriptet rendszergazdakent kell futtatni!
    pause
    exit /b 1
)

:: Ellenorizzük, hogy a WMIC elérhető-e
wmic /? >nul 2>&1
if %errorlevel% neq 0 (
    echo HIBA: A WMIC nem elerhető a rendszeren!
    echo WMIC telepítése...
    dism /online /add-capability /capabilityname:Rsat.WMIC~~~~0.0.1.0 >nul 2>&1
    if %errorlevel% neq 0 (
        echo HIBA: A WMIC telepitese sikertelen!
        pause
        exit /b 1
    )
    echo WMIC sikeresen telepitve.
)

:: vonal rajzolasa
:draw_line
setlocal enabledelayedexpansion
set "line="
for /L %%i in (1,1,80) do set "line=!line!-"

:: MENU
:menu
cls
echo !line!
echo STOOLS - EGYRE v%VER% (%DT%)
echo !line!
echo (Egy)szeru (Re)ndszergazda eszkoztar - Keszitette: Simon Nandor
echo !line!

:: Lekerdezzuk az aktualis gep nevet és ip-t
for /f "tokens=2 delims==" %%i in ('wmic computersystem get name /value') do set "CurrentPCName=%%i"
echo A szamitogep jelenlegi neve: %CurrentPCName%
for /f "tokens=14 delims= " %%i in ('ipconfig ^| findstr /i "IPv4"') do echo IP(v4): %%i

:: Menupontok
echo !line!
echo 1: Gep atnevezese
echo 2: Eszkozkezelo 
echo 3: Rendszeradatok 
echo 4: Felhasznalok kezelese
echo 5: Halozati beallitas
echo 6: Halozati adatok
echo 7: Lemezkezelo
echo 8: Licenc informacio
echo 9: Frissites a legujabb verziora
echo 0: Kilepes
echo !line!
set /p choice=Valassz a fenti menubol (0-9): 

:: Menupontok kezelese
if "%choice%"=="1" goto rename_computer
if "%choice%"=="2" goto run_device_manager
if "%choice%"=="3" goto system_info
if "%choice%"=="4" goto run_user_management
if "%choice%"=="5" goto network_settings_gui
if "%choice%"=="6" goto network_info
if "%choice%"=="7" goto run_drive_manager
if "%choice%"=="8" goto get_windows_key
if "%choice%"=="9" goto update_script
if "%choice%"=="0" goto exit
echo !line!
echo HIBA: Nincs ilyen menupont!
echo !line!
pause
goto menu

:: GEP ATNEVEZESE
:rename_computer
:: Bekerjuk az uj gep nevet
echo !line!
echo A gep jelenlegi neve: %CurrentPCName%
echo !line!
set /p NewPCName=ADD MEG AZ UJ GEPNEVET: 
:: Ellenorizzuk, hogy a megadott nev ervenyes-e
if "%NewPCName%"=="" (
    echo !line!
    echo HIBA: A gep neve nem lehet ures!
    echo !line!
    pause
    goto menu
)
:: gep atnevezes
wmic computersystem where name="%CurrentPCName%" call rename name="%NewPCName%"
:: ujrainditas
shutdown /r /t 0
goto exit

:: ESZKOZKEZELO
:run_device_manager
start devmgmt.msc
goto menu

:: RENDSZERADATOK
:system_info
cls
echo !line!
echo Rendszeradatok:
echo !line!
echo OS:
wmic os get Caption,Version,OSArchitecture 
echo !line!
echo CPU:
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors
echo !line!
echo RAM:
wmic memorychip get capacity
echo !line!
echo HDD/SSD:
wmic logicaldisk get name,size,freespace
echo !line!
pause
goto menu

:: FELHASZNALOK KEZELESE
:run_user_management
start lusrmgr.msc
goto menu

:: HALOZATI BEALLITAS
:network_settings_gui
control ncpa.cpl
goto menu

:: HALOZATI ADATOK
:network_info
cls
echo !line!
echo Halozati adatok:
echo !line!
ipconfig /all
echo !line!
pause
goto menu

:: LEMEZKEZELO
:run_drive_manager
cls
start diskmgmt.msc
goto menu

:: LICENC INFORMACIO
:get_windows_key
cls
echo !line!
echo Windows Termekkulcs:
echo !line!
wmic path softwarelicensingservice get OA3xOriginalProductKey
slmgr /xpr
echo !line!
pause
goto menu

:: FRISSITES A LEGÚJABB VERZIÓRA
:update_script
cls
echo !line!
echo A szkript frissítése a legújabb verzióra...
echo !line!
powershell -Command "Invoke-WebRequest -Uri '%GIT_URL%' -OutFile '%~dp0egyre.cmd'"
if %errorlevel% neq 0 (
    echo HIBA: A frissítés sikertelen volt!
    pause
    goto menu
)
echo A frissítés sikeresen befejeződött. Indítsa újra a szkriptet!
pause
exit /b 0

:: KILEPES
:exit
endlocal
exit /b 0