@echo off
setlocal enabledelayedexpansion

set "NODE_EXE=C:\Program Files\Huawei\DevEco Studio\tools\node\node.exe"
set "HVIGORW_JS=C:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.js"

"%NODE_EXE%" "%HVIGORW_JS%" %*
