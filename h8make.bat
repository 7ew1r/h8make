@echo off
set TERATERMFILEPATH="C:\Program Files (x86)\teraterm\ttermpro.exe"

rem --- option select ---
if "%1" == "" goto Main
if "%1" == "--save-temps" goto Main
if "%1" == "-m" goto MarToMot
if "%1" == "clean" goto Clean
if "%1" == "run" goto Main
if "%1" == "help" (goto help) else goto ErrorUnknownArgs

rem --- Option: help ---
:help
echo.
echo h8make clean : delete intermediate and motorola files (*.abs, *.obj, *.lis, *.mot)
echo h8make --save-temps : run h8make without deleting intermediate files (*.abs, *.obj, *.lis)
echo h8make -m : create *.mot from *.mar directly
echo h8make run [1-99] : make and run teraterm COM[1-99]
echo h8make help : show this help
goto END

rem --- Option: MarToMot ---
:MarToMot
for %%i in (*.mar) do ( a38h %%i )
for %%i in (*.obj) do ( l38h %%i )
for %%i in (*.abs) do ( c38h %%i )
for %%i in (*.abs) do ( del %%i )
for %%i in (*.obj) do ( del %%i )
for %%i in (*.lis) do ( del %%i )
goto END

rem --- Option: clean ---
:Clean
for %%i in (*.abs) do ( del %%i )
for %%i in (*.obj) do ( del %%i )
for %%i in (*.lis) do ( del %%i )
for %%i in (*.map) do ( del %%i )
for %%i in (*.mot) do ( del %%i )
goto END

rem --------------------
rem --- Main Routine ---
rem --------------------
:Main
rem --- Check Files ---
if not exist *.mar goto ErrorNoMar
if not exist *.sub goto ErrorNoSub
if not exist *.c goto ErrorNoC
set /a subFiles=0
for %%i in (*.sub) do ( if exist %%i (set /a subFiles=subFiles+1) )
if %subFiles% gtr 1 goto MultiSub

:Sub
rem --- clean ---
for %%i in (*.abs) do ( del %%i )
for %%i in (*.obj) do ( del %%i )
for %%i in (*.lis) do ( del %%i )
for %%i in (*.map) do ( del %%i )
for %%i in (*.mot) do ( del %%i )

rem --- Assemble Compile Link Convert ---
for %%i in (*.mar) do ( a38h %%i )
for %%i in (*.c) do ( call cl38h %%i )
for %%i in (*.sub) do ( call lk38h %%i )
for %%i in (*.abs) do ( c38h %%i )

rem --- Delete Intermediate Files ---
if not "%1" == "--save-temps" (
    for %%i in (*.abs) do ( del %%i )
    for %%i in (*.obj) do ( del %%i )
    for %%i in (*.lis) do ( del %%i )
)

if not exist *.mot goto ErrorNoMot

rem --- Launch TeraTerm ---
if not "%1" == "run" goto END

tasklist | find /i "ttermpro.exe"
if %errorlevel%==0 taskkill /F /IM ttermpro.exe
%TERATERMFILEPATH% /C=%2


goto END

rem -------------
rem --- ERROR ---
rem -------------
:ErrorUnknownArgs
echo.
echo *** ERROR: ILLEGAL OPTION PARAMETER ***
goto help

:MultiSub
echo *** NOTICE: Multiple sub files exist in current directory ***
echo Continue? (y/n)
set /p input=
if /i "%input%" == "y" (goto Sub)
if /i "%input%" == "n" (goto END) else goto MultiSub
goto MultiSub

:ErrorNoMar
echo *** ERROR: Do not exist (*.mar) file ***
goto END

:ErrorNoSub
echo *** ERROR: Do not exist (*.sub) file ***
goto END

:ErrorNoC
echo *** ERROR: Do not exist (*.c) file ***
goto END

:ErrorNoMot
echo *** ERROR: Did not create (*.mot) file ***
goto END

:END
