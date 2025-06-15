@echo off
:: Context Menu Switcher – Wechselt zwischen altem und neuem Windows Kontextmenü
:: Basiert auf Shell Icons Modifier Script
:: https://github.com/VoidSysLine/Scripts

:: --- Admincheck ---
NET SESSION >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [!] Starte mit Administratorrechten neu...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

:: --- Aktuellen Status prüfen ---
echo [i] Pruefe aktuellen Kontextmenu-Status...
reg query "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" >nul 2>&1
if %errorlevel% EQU 0 (
    set "current_menu=alt"
    echo [i] Aktuell: ALTES Kontextmenu aktiv
) else (
    set "current_menu=neu"
    echo [i] Aktuell: NEUES Kontextmenu aktiv
)

:: --- Auswahlmenu ---
echo.
echo ========================================
echo    Windows Kontextmenu Switcher
echo ========================================
echo.
echo [1] Zum ALTEN Kontextmenu wechseln
echo [2] Zum NEUEN Kontextmenu wechseln
echo [3] Beenden
echo.
set /p choice="Waehle eine Option (1-3): "

if "%choice%"=="1" goto :set_old_menu
if "%choice%"=="2" goto :set_new_menu
if "%choice%"=="3" goto :exit
echo [!] Ungueltige Eingabe. Versuche es erneut.
goto :menu

:set_old_menu
if "%current_menu%"=="alt" (
    echo [i] Das alte Kontextmenu ist bereits aktiv.
    goto :ask_restart
)
echo [+] Aktiviere altes Kontextmenu...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul
echo [+] Altes Kontextmenu wurde aktiviert.
goto :restart_explorer

:set_new_menu
if "%current_menu%"=="neu" (
    echo [i] Das neue Kontextmenu ist bereits aktiv.
    goto :ask_restart
)
echo [+] Aktiviere neues Kontextmenu...
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
echo [+] Neues Kontextmenu wurde aktiviert.
goto :restart_explorer

:ask_restart
echo.
set /p restart_choice="Moechtest du den Explorer trotzdem neustarten? (j/n): "
if /i "%restart_choice%"=="j" goto :restart_explorer
if /i "%restart_choice%"=="y" goto :restart_explorer
goto :exit

:restart_explorer
:: --- Automatischer Explorer-Neustart mit Verzögerung ---
echo.
echo [~] Warte 5 Sekunden vor Explorer-Neustart, um Black Screen zu vermeiden...
timeout /t 5 /nobreak >nul
echo [~] Beende explorer.exe...
taskkill /f /im explorer.exe >nul
echo [~] Warte 2 Sekunden vor dem Neustart...
timeout /t 2 /nobreak >nul
echo [~] Starte explorer.exe neu...
start explorer.exe
echo [+] Fertig.
goto :exit

:exit
echo.
pause
exit