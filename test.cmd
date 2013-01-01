@echo off
setlocal enabledelayedexpansion
    set tests=
    pushd test
        for /r %%i in (*.js) do set tests=!tests! "%%i"
        for /r %%i in (*.coffee) do set tests=!tests! "%%i"
    popd
    mocha --compilers coffee:coffee-script %tests%
endlocal