echo off

SET appDataPath=%APPDATA%\Factorio\mods\Airport-Logistics-Factorio
IF NOT EXIST "%appDataPath%" MKDIR "%appDataPath%"

echo Copying files and subfolders to the Factorio mods directory...
ROBOCOPY "%cd%" "%appDataPath%" /E /XD "update-factorio.bat" ".git" > "%cd%\update-factorio-batch-log.txt"

IF ERRORLEVEL 8 (
    echo An error occurred while copying files. Check update-factorio-batch-log.txt for details.
) ELSE (
    echo Files and subfolders copied successfully. Check update-factorio-batch-log.txt for details.
)

PAUSE