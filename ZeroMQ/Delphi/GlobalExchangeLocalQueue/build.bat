@echo off
del *.exe
del *.dcu
dcc32 receiver.dpr
dcc32 sender.dpr
start sender.exe
echo Press any key and 4 receiver will start... 
pause
start receiver.exe
start receiver.exe
start receiver.exe
start receiver.exe
