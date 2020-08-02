@echo off
setlocal EnableDelayedExpansion

for /f "tokens=1-3 delims=/- " %%a in ('date /t') do set FECHA=%%a%%b%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set HORA=%%a%%b
echo Leera archivo bloqueo.csv
echo Se creara archivo sqlMasivoBloqueo_%FECHA%_%HORA%.txt
pause

echo -------------------------------------------------------------------------- >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
echo Ejecutar en Servidor: exakedbadm1,  Base de dats:  APMPRODB, esquema: VTDB  >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
echo -------------------------------------------------------------------------- >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
echo: >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
echo BEGIN >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt

set contador=1

for /f "usebackq tokens=1-2 delims=," %%a in ("bloqueo.csv") do (
    
    if not %%a == unknown (
        echo VTDB.INS_UPD_DEVICE_BLACKLIST('MP', 'DEVICE_SERIAL', '%%a',  'A', 'Gen', 'Gen'^)^; >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt 
        call :cont %%a
    )
) 

echo COMMIT; >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
echo END; >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt

endlocal

:cont
set /a contador+=1
set /a "modulo=%contador% %% 50"

if %modulo% == 0 (
    echo COMMIT; >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
    echo END; >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
    echo: >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
    echo BEGIN >> sqlMasivoBloqueo_%FECHA%_%HORA%.txt
)
goto :eof


