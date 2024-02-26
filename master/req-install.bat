@echo off

REM Check if the script is running with administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM If the previous command's exit code is not 0, the script is not running as administrator
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Please run it as an administrator.
    echo Right-click on the batch file and select "Run as Administrator".
    pause
    exit /b 1
)




echo Checking chocolatey installation....
REM Check if Chocolatey is installed
where choco >nul 2>&1
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Installing Chocolatey...
    @powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
) else (
    echo Chocolatey is already installed.
)

REM Wait for Chocolatey to settle
timeout /t 2 /nobreak >nul

echo Checking NodeJS installation....
REM Install Node.js if not already installed
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo NodeJS is not installed. Installing NodeJS...
    call :RunCommand start /wait cmd /c "choco install nodejs-lts -y && timeout /t 2 /nobreak >nul"
) else (
    echo Nodejs is already installed.
)


echo Checking Volta installation....
REM Install Volta if not already installed
where volta >nul 2>&1
if %errorlevel% neq 0 (
    echo Volta is not installed. Installing Volta...
    call :RunCommand start /wait cmd /c "choco install volta -y && timeout /t 2 /nobreak >nul"
) else (
    echo Volta is already installed.
)


echo Checking FFMPEG installation....
REM Install FFmpeg if not already installed
where ffmpeg >nul 2>&1
if %errorlevel% neq 0 (
    echo FFMPEG is not installed. Installing FFMPEG...
    call :RunCommand start /wait cmd /c "choco install ffmpeg-full -y && timeout /t 2 /nobreak >nul"
) else (
    echo FFMPEG is already installed.
)


REM Get the path of the batch script
set "script_path=%~dp0"

REM Move to the script dir
cd /d "%script_path%"


echo ================ OK LANJUT =====================




REM Prompt user before closing
pause
exit /b 0

:RunCommand
echo Running command: %*
%*
timeout /t 2 /nobreak >nul
goto :eof
