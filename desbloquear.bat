@echo off
setlocal EnableDelayedExpansion

for /f "tokens=1-3 delims=/- " %%a in ('date /t') do set FECHA=%%a%%b%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set HORA=%%a%%b
echo Leera archivo desbloqueo.csv
echo Se creara archivo sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
pause

echo -------------------------------------------------------------------------- >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
echo Ejecutar en Servidor: exakedbadm1,  Base de dats:  APMPRODB, esquema: VTDB  >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
echo -------------------------------------------------------------------------- >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
echo: >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
echo BEGIN >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt

set contador=1

for /f "usebackq tokens=1-2 delims=," %%a in ("desbloqueo.csv") do (
    
    if not %%a == unknown (
        echo VTDB.INS_UPD_DEVICE_BLACKLIST('MP', 'DEVICE_SERIAL', '%%a',  'I', 'Gen', 'Gen'^)^; >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt 
        call :cont %%a
    )
) 

echo COMMIT; >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
echo END; >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt

endlocal

:cont
set /a contador+=1
set /a "modulo=%contador% %% 50"

if %modulo% == 0 (
    echo COMMIT; >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
    echo END; >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
    echo: >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
    echo BEGIN >> sqlMasivoDesbloqueo_%FECHA%_%HORA%.txt
)
goto :eof
