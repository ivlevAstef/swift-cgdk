@echo off

set name=MyStrategy

if not exist %name%.swift (
    echo Unable to find %name%.swift > compilation.log
    exit 1
)

call clean.bat

:: Compilation cpp socket to *.o

set COMPILER_GCC_PATH="
set COMPILER_SWIFT_PATH="

if "%SWIFT_HOME%" neq "" (
    if exist "%SWIFT_HOME%\mingw64\bin\g++.exe" (
        set COMPILER_GCC_PATH="%SWIFT_HOME%\mingw64\bin\"
    )
    :: в принципе он всеравно должен найтись и без пути
    if exist "%SWIFT_HOME%\Swift\usr\bin\swiftc.exe" (
        set COMPILER_SWIFT_PATH="%SWIFT_HOME%\Swift\usr\bin\"
    }
)

SetLocal EnableDelayedExpansion EnableExtensions

set CPP_FILES=

for %%i in (csimplesocket\*.cpp) do (
    set CPP_FILES=!CPP_FILES! %%i
)

call "%COMPILER_GCC_PATH:"=%g++" -c -std=c++14 -static -fno-optimize-sibling-calls -fno-strict-aliasing -DWIN32 -lm -s -x c++ -Wl,--stack=268435456 -O2 -Wall -Wtype-limits -Wno-unknown-pragmas !CPP_FILES! -lws2_32 -lwsock32 2>compilation.log

:: Compilation swift code

set FILES=

for %%i in (*.swift) do (
	set FILES=!FILES! %%i
)

for %%i in (model\*.swift) do (
	set FILES=!FILES! %%i
)

for %%i in (csimplesocket\*.swift) do (
	set FILES=!FILES! %%i
)

for %%i in (*.o) do (
	set FILES=!FILES! %%i
)

call "%COMPILER_SWIFT_PATH:"=%swiftc" !FILES! -L ./csimplesocket/ -lstdc++ -Ounchecked -lws2_32 -o %name%.exe -Xlinker --allow-multiple-definition -Xlinker --subsystem -Xlinker windows -Xlinker -O2 2>compilation.log
