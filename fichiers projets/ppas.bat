@echo off
SET THEFILE=D:\Formation à distance\Rija\UTB\M1\Lazarus Delphi\TD à rendre\Evaluation_finale\calculateur.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.2.2\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o "D:\Formation à distance\Rija\UTB\M1\Lazarus Delphi\TD à rendre\Evaluation_finale\calculateur.exe" "D:\Formation à distance\Rija\UTB\M1\Lazarus Delphi\TD à rendre\Evaluation_finale\link5072.res"
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
