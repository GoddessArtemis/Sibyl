@echo off
setlocal
    pushd test
        for /r %%i in (*.js) do set TESTS=%TESTS% "%%i"
        for /r %%i in (*.coffee) do set TESTS=%TESTS% "%%i"
    popd
    mocha --compilers coffee:coffee-script %TESTS%
endlocal