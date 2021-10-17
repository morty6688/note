@echo off
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f /ve /d "Windows Terminal Here"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f /v "Icon" /t REG_EXPAND_SZ /d "C:\icons\terminal.ico"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt\command" /f /ve /t REG_EXPAND_SZ /d "wt -d ."
pause
