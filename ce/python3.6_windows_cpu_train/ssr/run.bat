@echo off
set models_dir=./../../models_repo
rem copy models files
xcopy "%models_dir%/PaddleRec/ssr/." . /s /e /y

.\.run_ce.bat
