@echo off
:: Silvermage installer for Windows (cmd.exe).
::
:: Usage:
::   curl -fsSL https://silvermage.com/install.cmd -o install.cmd ^&^& install.cmd ^&^& del install.cmd
::
:: Environment overrides:
::   SILVERMAGE_VERSION     — tag to install (default: latest release)
::   SILVERMAGE_INSTALL_DIR — install directory (default: %LOCALAPPDATA%\Programs\silvermage)
::   SILVERMAGE_NO_VERIFY   — set to any value to skip SHA256 verification
::
:: Requires Windows 10 1803+ (ships curl.exe + bsdtar).

setlocal EnableExtensions EnableDelayedExpansion

set "REPO=silvermage-cli/silvermage"
set "BIN=silvermage.exe"
set "TARGET=x86_64-pc-windows-msvc"

if not defined SILVERMAGE_VERSION     set "SILVERMAGE_VERSION=latest"
if not defined SILVERMAGE_INSTALL_DIR set "SILVERMAGE_INSTALL_DIR=%LOCALAPPDATA%\Programs\silvermage"

if /i "%SILVERMAGE_VERSION%"=="latest" (
    set "BASE_URL=https://github.com/%REPO%/releases/latest/download"
) else (
    set "BASE_URL=https://github.com/%REPO%/releases/download/%SILVERMAGE_VERSION%"
)

set "ARCHIVE=silvermage-%TARGET%.zip"
set "ASSET_URL=%BASE_URL%/%ARCHIVE%"
set "SHA_URL=%ASSET_URL%.sha256"

echo [silvermage] target:   %TARGET%
echo [silvermage] version:  %SILVERMAGE_VERSION%
echo [silvermage] dest:     %SILVERMAGE_INSTALL_DIR%\%BIN%

where curl >nul 2>nul
if errorlevel 1 (
    echo [silvermage] error: curl.exe not found. Requires Windows 10 1803+ or manual curl install. 1>&2
    exit /b 1
)

set "TMPDIR=%TEMP%\silvermage-%RANDOM%%RANDOM%"
mkdir "%TMPDIR%" 2>nul
if errorlevel 1 (
    echo [silvermage] error: failed to create temp dir 1>&2
    exit /b 1
)

set "ZIP=%TMPDIR%\%ARCHIVE%"
set "SHA_FILE=%ZIP%.sha256"

echo [silvermage] downloading %ARCHIVE%
curl -fsSL "%ASSET_URL%" -o "%ZIP%"
if errorlevel 1 (
    echo [silvermage] error: download failed 1>&2
    rmdir /S /Q "%TMPDIR%" 2>nul
    exit /b 1
)

if not defined SILVERMAGE_NO_VERIFY (
    echo [silvermage] verifying checksum
    curl -fsSL "%SHA_URL%" -o "%SHA_FILE%"
    if errorlevel 1 (
        echo [silvermage] error: checksum download failed 1>&2
        rmdir /S /Q "%TMPDIR%" 2>nul
        exit /b 1
    )
    set "EXPECTED="
    set /p EXPECTED=<"%SHA_FILE%"
    for /f "tokens=1" %%x in ("!EXPECTED!") do set "EXPECTED=%%x"

    set "ACTUAL="
    for /f "skip=1 tokens=*" %%h in ('certutil -hashfile "%ZIP%" SHA256') do (
        if not defined ACTUAL set "ACTUAL=%%h"
    )
    set "ACTUAL=!ACTUAL: =!"

    if /i not "!ACTUAL!"=="!EXPECTED!" (
        echo [silvermage] error: checksum mismatch ^(expected !EXPECTED!, got !ACTUAL!^) 1>&2
        rmdir /S /Q "%TMPDIR%" 2>nul
        exit /b 1
    )
) else (
    echo [silvermage] SILVERMAGE_NO_VERIFY set — skipping checksum ^(not recommended^)
)

echo [silvermage] extracting
set "EXTRACT_DIR=%TMPDIR%\extract"
mkdir "%EXTRACT_DIR%" 2>nul

where tar >nul 2>nul
if not errorlevel 1 (
    tar -xf "%ZIP%" -C "%EXTRACT_DIR%"
) else (
    powershell -NoProfile -Command "Expand-Archive -Path '%ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force"
)
if errorlevel 1 (
    echo [silvermage] error: extraction failed 1>&2
    rmdir /S /Q "%TMPDIR%" 2>nul
    exit /b 1
)

set "BIN_SRC="
for /f "delims=" %%f in ('dir /s /b "%EXTRACT_DIR%\%BIN%" 2^>nul') do (
    if not defined BIN_SRC set "BIN_SRC=%%f"
)
if not defined BIN_SRC (
    echo [silvermage] error: binary '%BIN%' not found inside archive 1>&2
    rmdir /S /Q "%TMPDIR%" 2>nul
    exit /b 1
)

if not exist "%SILVERMAGE_INSTALL_DIR%" mkdir "%SILVERMAGE_INSTALL_DIR%"

copy /Y "%BIN_SRC%" "%SILVERMAGE_INSTALL_DIR%\%BIN%" >nul
if errorlevel 1 (
    echo [silvermage] error: install failed 1>&2
    rmdir /S /Q "%TMPDIR%" 2>nul
    exit /b 1
)

:: Shorter command aliases. Windows symlinks need developer mode or
:: admin elevation, so ship file copies (~31 MB each stripped binary)
:: in exchange for a no-prompt install. Matches install.ps1 behavior.
for %%a in (silver.exe silv.exe sm.exe) do (
    copy /Y "%SILVERMAGE_INSTALL_DIR%\%BIN%" "%SILVERMAGE_INSTALL_DIR%\%%a" >nul
)

rmdir /S /Q "%TMPDIR%" 2>nul

echo [silvermage] installed: %SILVERMAGE_INSTALL_DIR%\%BIN% ^(aliases: silver, silv, sm^)

set "ON_PATH="
echo ;%PATH%; | findstr /I /C:";%SILVERMAGE_INSTALL_DIR%;" >nul && set "ON_PATH=1"
if not defined ON_PATH (
    echo.
    echo [silvermage] note: %SILVERMAGE_INSTALL_DIR% is not on your user PATH
    echo [silvermage]       add it with PowerShell:
    echo.
    echo         [Environment]::SetEnvironmentVariable^('Path', "%SILVERMAGE_INSTALL_DIR%;" + [Environment]::GetEnvironmentVariable^('Path', 'User'^), 'User'^)
    echo.
    echo [silvermage]       then restart your shell.
)

echo [silvermage] run 'silvermage --help' to get started
endlocal
exit /b 0
