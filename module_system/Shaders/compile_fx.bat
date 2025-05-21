@echo off
set build="../../"

:start
@echo off && title Shader Compiling! && echo ^[working hard...^] ^[started at %time%^] && echo. 
start /b /wait /i /high /realtime fxc /D /nologo /D PS_2_X=ps_2_a /Tfx_2_0 /Fo%build%mb.fx shaders/mb_src.fx

echo. && echo Shader processing has ended at %time%.
echo Press any key to recompile. . .
title Waiting!
echo ___________________________________
pause>nul
goto :start