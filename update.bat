@echo off
@REM set /p message=please input commit message: 
git pull
@REM git cmp %message%
git cmp "update"
echo update successfully
pause
