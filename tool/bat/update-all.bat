@echo off

echo ====== cd note ==========
cd note
git pull
git cmp "update"
echo ====== note update successfully ==========
echo(

echo ====== cd part-time ======
cd ..
cd part-time
git pull
git cmp "update"
echo ====== part-time update successfully ======
echo(

echo ====== cd practice ======
cd ..
cd practice
git pull
git cmp "update"
echo ====== practice update successfully ======
echo(

echo ====== cd waffle ========
cd ..
cd waffle
git pull
git cmp "update"
echo ====== waffle update successfully ========
echo(

pause