@echo off
echo --------------- Variables ---------------
Set PRG=spire5
Set ProjectFolder=F:\Bruno\Dev\AppleWin\Projets\Spire

Set MyAppleFolder=F:\Bruno\Dev\AppleWin
Set APPLEWIN=%MyAppleFolder%\AppleWin\Applewin.exe
Set MERLIN32ROOT=%MyAppleFolder%\Merlin32_v1.0
Set MERLIN32LIBS=%MERLIN32ROOT%\Library
Set MERLIN32WIN=%MERLIN32ROOT%\Windows
Set MERLIN32EXE=%MERLIN32WIN%\merlin32.exe
Set APPLECOMMANDER=%MyAppleFolder%\Utilitaires\AppleCommander-win64-1.6.0.jar
rem Set ACJAR=java.exe -jar %APPLECOMMANDER%    ; avec ""
Set ACJAR=java.exe -jar %APPLECOMMANDER%
echo %ACJAR%

echo --------------- debut Merlin ---------------
%MERLIN32EXE% -V %MERLIN32LIBS% %ProjectFolder%\%PRG%.s
echo --------------- fin Merlin ---------------

copy /Y %MyAppleFolder%\AA.po %ProjectFolder%\%PRG%.po
rem %ACJAR:"=% -p %PRG%.po %PRG% bin 24576 < %PRG%  ; suppression des "
echo --------------- Debut Applecommander ---------------
%ACJAR% -p %PRG%.po %PRG% bin 16384 < %PRG%
echo --------------- fin Applecommander ---------------
echo --------------- Debut Applewin ---------------
%APPLEWIN% -d1 %PRG%.po
echo --------------- Fin Applewin ---------------