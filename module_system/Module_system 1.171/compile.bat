:init
@echo off

python compile.py tag %1 %2 %3 %4 %5 %6 %7 %8 %9
echo Hit any key to recompile!
pause>nul
goto :init