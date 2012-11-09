set PHP_INSTALL_DIR=C:\php
set PATH=%PHP_INSTALL_DIR%\SDK;%PHP_INSTALL_DIR%;%PATH%
set LIB=%PHP_INSTALL_DIR%\SDK\lib;%LIB%
set PHPRC=%PHP_INSTALL_DIR%\php.ini

del /Q CMakeCache.txt
rmdir /Q /S CMakeFiles
rmdir /Q /S Debug 
rmdir /Q /S Debug
rmdir /Q /S RelWithDebInfo
rmdir /Q /S php_nuodb.dir
del /Q CMakeCache.txt
del /Q cmake_install.cmake
del /Q NuoPhpPdo.suo
REM cmake -G "Visual Studio 9 2008" -D NUODB_REMOTE_DLL=%NUODEVO%/Remote/Debug/NuoRemote.dll -D NUODB_INCLUDE_DIR=%NUODEVO%/Remote -D NUODB_LIB_DIR=%NUODEVO%/Remote/Debug -D NUODB_REMOTE_LIBRARY=%NUODEVO%/Remote/Debug/NuoRemote.lib -D PHP_ROOT=%PHP_INSTALL_DIR% -D PHP_INCLUDE_DIR=%PHP_INSTALL_DIR%/SDK/include .
cmake -G "Visual Studio 9 2008" -D NUODB_REMOTE_DLL="C:\Program Files\NuoDB\bin\NuoRemote.vc9.dll" -D NUODB_INCLUDE_DIR="C:\Program Files\NuoDB\include" -D NUODB_LIB_DIR="C:\Program Files\NuoDB\lib" -D NUODB_REMOTE_LIBRARY="C:\Program Files\NuoDB\lib\NuoRemote.vc9.lib" -D PHP_ROOT=%PHP_INSTALL_DIR% -D PHP_INCLUDE_DIR=%PHP_INSTALL_DIR%/SDK/include .
devenv NuoPhpPdo.sln /build Debug /project NuoPhpPdo
devenv NuoPhpPdo.sln /build RelWithDebInfo /project NuoPhpPdo
copy /Y Debug\*.* %PHP_INSTALL_DIR%\debug
copy /Y RelWithDebInfo\*.* %PHP_INSTALL_DIR%
REM copy /Y "%NUODEVO%\Remote\Debug\NuoRemote.dll" %PHP_INSTALL_DIR%\debug
REM copy /Y "%NUODEVO%\Remote\RelWithDebInfo\NuoRemote.dll" %PHP_INSTALL_DIR%
copy /Y "C:\Program Files\NuoDB\bin\NuoRemote.vc9.dll" %PHP_INSTALL_DIR%\debug
copy /Y "C:\Program Files\NuoDB\bin\NuoRemote.vc9.dll" %PHP_INSTALL_DIR%
php tests\simple.php

