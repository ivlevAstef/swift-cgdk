@echo off

set name=MyStrategy

if not exist %name%.swift (
    echo Unable to find %name%.swift > compilation.log
    exit 1
)

call clean.bat

:: Compilation cpp socket to *.o

set COMPILER_PATH="

if "%GCC6_HOME%" neq "" (
    if exist "%GCC6_HOME%\bin\g++.exe" (
        set COMPILER_PATH="%GCC6_HOME%\bin\"
    )
)

SetLocal EnableDelayedExpansion EnableExtensions

set CPP_FILES=

for %%i in (csimplesocket\*.cpp) do (
    set CPP_FILES=!CPP_FILES! %%i
)

call "%COMPILER_PATH:"=%g++" -c -std=c++14 -static -fno-optimize-sibling-calls -fno-strict-aliasing -DWIN32 -lm -s -x c++ -Wl,--stack=268435456 -O2 -Wall -Wtype-limits -Wno-unknown-pragmas !CPP_FILES! -lws2_32 -lwsock32 2>compilation.log

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

swiftc !FILES! -L ./csimplesocket/ -lstdc++ -Ounchecked -lws2_32 -o %name%.exe -Xlinker --allow-multiple-definition -Xlinker --subsystem -Xlinker windows 2>compilation.log