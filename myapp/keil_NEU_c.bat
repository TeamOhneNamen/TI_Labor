@echo off
REM Batch procedure to create a basic project for Keil uVision
REM Copies the necessary file for the TI-Board at HAW-hamburg
REM
REM           Alfed Lohmann
REM           Labor fuer technische Informatik
REM           HAW-Hamburg
REM           12. August 2013
REM
REM Restrict searchpath
set PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\system32\WBEM;C:\WINDOWS\system32\nls;
set PATH=%PATH%,C:\Keil_v5;C:\Keil_v5\ARM\BIN;
REM Set up directory checking
set PROJEKT=" "
ECHO Anlegen oder bearbeiten eines Projekts fuer Keil uVison
ECHO.
ECHO.
for /f "tokens=*" %%i in ('cscript //nologo  projektname.vbs') do set PROJEKT=%%i
if %PROJEKT% ==" " goto doit2
ECHO Projektname: %PROJEKT%
REM
REM The project has to reside on drive C:
C:
cd C:
if errorlevel 1 goto nodrive

REM Check if base directory exists
if exist C:\TI_Labor goto check1
REM ..if not we make ist
MD C:\TI_Labor
REM
REM we have the directory
:check1
CD C:\TI_Labor
if errorlevel 1 goto nodrive
REM
REM If directory exists we execute Keil on this projects
if exist %PROJEKT% goto doit

REM Else we create a new project directory and copy files
CLS
ECHO Anlegen oder bearbeiten eines C-Projekts fuer Keil uVison
ECHO.
ECHO.
ECHO Projektname: %PROJEKT%
md %PROJEKT%
REM copy C:\Keil_v5\Keil_Basis_Projekt\Keil_Basis_3\*.*  .\%PROJEKT%\*.* >NUL
xcopy C:\Keil_v5\Keil_Basis_Projekt\Keil_Basis_3 .\%PROJEKT%\ /S >NUL
cd .\%PROJEKT%
C:\Keil_v5\Keil_Basis_Projekt\find_replace3  uvopt  %PROJEKT%
C:\Keil_v5\Keil_Basis_Projekt\find_replace3  uvproj %PROJEKT%
del basis3.uvopt
del basis3.uvproj
rename basis3_1.* %PROJEKT%.*
rename basis3.* %PROJEKT%.*

C:\Keil_v5\UV4\Uv4.exe %PROJEKT%.uvproj

goto ende

REM Make requested directory the default directory
:doit
cd .\%PROJEKT%
CLS
ECHO Anlegen oder bearbeiten eines C-Projekts fuer Keil uVison
ECHO.
ECHO.
ECHO Projektname: %PROJEKT%
C:\Keil_v5\UV4\Uv4.exe %PROJEKT%.uvproj
goto ende

REM Just start Keil. The last project will be opened
:doit2
C:\Keil_v5\UV4\Uv4.exe
goto ende

:noname
echo Es wurde keine Projektname angegeben
pause
goto ende
:nodrive
echo Laufwerk oder Basisverzeicnis C:\TI_Labor nicht gefunden

REM We did our job
:ende
ECHO ...done
cd ..
