@echo off

set name=MyStrategy

if EXIST %name%.exe DEL /F /Q %name%.exe
if EXIST compilation.log DEL /F /Q compilation.log


for %%i in (*.o) do (
    DEL /F /Q %%i
)