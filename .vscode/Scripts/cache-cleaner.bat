@echo off
setlocal

:: Set number of days between runs
set "INTERVAL=7"

:: Where the timestamp will be stored
set "TIMESTAMP_FILE=%TEMP%\vscode_cache_clean_timestamp.txt"

:: Get current date in YYYYMMDD format
for /f %%A in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyyMMdd\")"') do set "TODAY=%%A"

:: If timestamp file exists, read it
if exist "%TIMESTAMP_FILE%" (
    set /p LAST_RUN=<"%TIMESTAMP_FILE%"
) else (
    set "LAST_RUN=0"
)

:: Check if difference is >= INTERVAL
for /f %%D in ('powershell -NoProfile -Command "[int](New-TimeSpan -Start ([datetime]::ParseExact('%LAST_RUN%','yyyyMMdd',$null)) -End ([datetime]::ParseExact('%TODAY%','yyyyMMdd',$null))).TotalDays"') do set "DAYS_SINCE_RUN=%%D"

if %DAYS_SINCE_RUN% GEQ %INTERVAL% (
    echo Cleaning VS Code cache...
    rmdir /s /q "%APPDATA%\Code\Cache"
    rmdir /s /q "%APPDATA%\Code\CachedData"
    rmdir /s /q "%APPDATA%\Code\GPUCache"
    echo %TODAY% > "%TIMESTAMP_FILE%"
    echo ✅ Cache cleaned after %DAYS_SINCE_RUN% days.
) else (
    echo ⏩ Skipped cleanup. Only %DAYS_SINCE_RUN% days since last run.
)

pause
endlocal
