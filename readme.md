Spire is an assembly program for Apple //
It draw text chars spiraling aroud the screen, in both way. 

Files :

spire5.s : assembly language source for Merlin 8 (or Merlin32.exe)
spire5A2.s : same, cleaned for Merlin 8 on Apple // : without extra spaces, ODOA replaced pby 0D (CRLF ==> CR)
doMerlin.bat : cmd bat to assemble with Merlin32.exe, add binary to an image disk and start Appplewin with this image disk. You must change pathes to make it work on your configuration.
spire5.po : the resulting image disk (copied grom another directory, with sprie5 binary added by Applecommander)

What you need :

Visual Studio Code, better with 2 plugins : Merlin32 plugin (for Syntax coloring), and Code Runner to run doMerlin.bat easily.
Applewin
Applecommander

