@echo off
REM ===================================================================
REM Timyx Tweaks - Skripta za optimizaciju Windows sistema
REM Kreirana od strane timyxa
REM Verzija: 1.0
REM ===================================================================

setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:glavni_meni
cls
color 0B
echo ===============================================
echo               TIMYX TWEAKS                  
echo ===============================================
echo    Skripta za optimizaciju Windows sistema    
echo ===============================================
echo.
color 0E
echo Izaberite opciju:
echo.
color 0F
echo 1 - Ocisti DNS kes
echo 2 - Iskljuci animacije pri pokretanju
echo 3 - Postavi plan snage na Visoke Performanse
echo 4 - Ocisti TEMP folder
color 0C
echo 5 - Izlaz
color 0F
echo.
echo ===============================================
echo.
set /p "korisnik_izbor=Unesite broj opcije (1-5): "

REM Provjera unosa
if "%korisnik_izbor%"=="1" goto potvrdi_dns_kes
if "%korisnik_izbor%"=="2" goto potvrdi_animacije
if "%korisnik_izbor%"=="3" goto potvrdi_plan_snage
if "%korisnik_izbor%"=="4" goto potvrdi_temp_folder
if "%korisnik_izbor%"=="5" goto izlaz_iz_skripte
goto neispravan_unos

:neispravan_unos
echo.
color 0C
echo Greska: Neispravan unos! Molimo unesite broj od 1 do 5.
color 0F
pause
goto glavni_meni

REM ===================================================================
REM FUNKCIJA: Potvrda za ciscenje DNS kesa
REM ===================================================================
:potvrdi_dns_kes
echo.
color 0E
echo Da li zelite da ocistite DNS kes? (Y/N): 
color 0F
set /p "potvrda_dns="
if /i "%potvrda_dns%"=="Y" goto pokreni_ociscavanje_dns
if /i "%potvrda_dns%"=="N" goto glavni_meni
color 0C
echo Molimo unesite Y za DA ili N za NE.
color 0F
goto potvrdi_dns_kes

:pokreni_ociscavanje_dns
echo.
color 09
echo Ciscenje DNS kesa u toku...
color 0F
ipconfig /flushdns >nul 2>&1
if %errorlevel%==0 (
    color 0A
    echo Uspjesno: DNS kes je obrisan!
    color 0F
) else (
    color 0C
    echo Greska: DNS kes nije mogao biti obrisan!
    color 0F
)
echo.
pause
goto glavni_meni

REM ===================================================================
REM FUNKCIJA: Potvrda za iskljucivanje animacija
REM ===================================================================
:potvrdi_animacije
echo.
color 0E
echo Da li zelite da iskljucite animacije pri pokretanju? (Y/N): 
color 0F
set /p "potvrda_animacije="
if /i "%potvrda_animacije%"=="Y" goto pokreni_iskljucivanje_animacija
if /i "%potvrda_animacije%"=="N" goto glavni_meni
color 0C
echo Molimo unesite Y za DA ili N za NE.
color 0F
goto potvrdi_animacije

:pokreni_iskljucivanje_animacija
echo.
color 09
echo Iskljucivanje animacija u toku...
color 0F
REM Iskljucivanje animacija kroz registry
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9032078010000000 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
if %errorlevel%==0 (
    color 0A
    echo Uspjesno: Animacije su iskljucene! Ponovo pokrenite racunar.
    color 0F
) else (
    color 0C
    echo Greska: Animacije nisu mogle biti iskljucene!
    color 0F
)
echo.
pause
goto glavni_meni

REM ===================================================================
REM FUNKCIJA: Potvrda za plan snage
REM ===================================================================
:potvrdi_plan_snage
echo.
color 0E
echo Da li zelite da postavite plan snage na Visoke Performanse? (Y/N): 
color 0F
set /p "potvrda_snaga="
if /i "%potvrda_snaga%"=="Y" goto pokreni_postavljanje_snage
if /i "%potvrda_snaga%"=="N" goto glavni_meni
color 0C
echo Molimo unesite Y za DA ili N za NE.
color 0F
goto potvrdi_plan_snage

:pokreni_postavljanje_snage
echo.
color 09
echo Postavljanje plana snage na Visoke Performanse...
color 0F
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if %errorlevel%==0 (
    color 0A
    echo Uspjesno: Plan snage je postavljen na Visoke Performanse!
    color 0F
) else (
    color 0C
    echo Greska: Plan snage nije mogao biti promijenjen!
    color 0F
)
echo.
pause
goto glavni_meni

REM ===================================================================
REM FUNKCIJA: Potvrda za ciscenje TEMP foldera
REM ===================================================================
:potvrdi_temp_folder
echo.
color 0E
echo Da li zelite da ocistite TEMP folder? (Y/N): 
color 0F
set /p "potvrda_temp="
if /i "%potvrda_temp%"=="Y" goto pokreni_ociscavanje_temp
if /i "%potvrda_temp%"=="N" goto glavni_meni
color 0C
echo Molimo unesite Y za DA ili N za NE.
color 0F
goto potvrdi_temp_folder

:pokreni_ociscavanje_temp
echo.
color 09
echo Ciscenje TEMP foldera u toku...
color 0F
set "temp_putanja=%TEMP%"
set "windows_temp=C:\Windows\Temp"
set "ukupno_obrisano=0"

REM Brisanje iz korisnickog TEMP foldera
if exist "%temp_putanja%" (
    for /f %%i in ('dir /s /b "%temp_putanja%\*" 2^>nul ^| find /c /v ""') do set "broj_fajlova_user=%%i"
    del /f /s /q "%temp_putanja%\*" >nul 2>&1
    rd /s /q "%temp_putanja%" >nul 2>&1
    md "%temp_putanja%" >nul 2>&1
    color 0A
    echo - Korisniski TEMP folder obrisan
    color 0F
)

REM Brisanje iz Windows TEMP foldera
if exist "%windows_temp%" (
    for /f %%i in ('dir /s /b "%windows_temp%\*" 2^>nul ^| find /c /v ""') do set "broj_fajlova_win=%%i"
    del /f /s /q "%windows_temp%\*" >nul 2>&1
    color 0A
    echo - Windows TEMP folder obrisan
    color 0F
)

REM Brisanje Prefetch fajlova
if exist "C:\Windows\Prefetch" (
    del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
    color 0A
    echo - Prefetch fajlovi obrisani
    color 0F
)

echo.
color 0A
echo Uspjesno: TEMP folderi su ocisceni!
color 0F
echo.
pause
goto glavni_meni

REM ===================================================================
REM FUNKCIJA: Izlaz iz skripte
REM ===================================================================
:izlaz_iz_skripte
cls
color 0B
echo.
echo ===============================================
echo               TIMYX TWEAKS                  
echo ===============================================
echo.
color 0A
echo Hvala vam sto ste koristili Timyx Tweaks!
color 0F
echo Skripta je zavrsena.
echo.
echo ===============================================
timeout /t 3 /nobreak >nul
exit /b 0