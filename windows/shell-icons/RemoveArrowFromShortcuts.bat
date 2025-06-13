@echo off
:: Shell Icons Modifier – erstellt leeren "29"-Wert für Netzwerksymbolunterdrückung
:: https://github.com/VoidSysLine/Scripts

:: --- Admincheck ---
NET SESSION >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [!] Starte mit Administratorrechten neu...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

:: --- Registry schreiben ---
echo [+] Erstelle Registry-Schlüssel...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /f >nul

echo [+] Setze leeren Wert "29"...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "" /f >nul

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
pause
exit
