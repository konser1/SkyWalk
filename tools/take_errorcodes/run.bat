@echo off

echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo ��ȷ�����¼���Ի�����Ҫ��
echo 	1. ������������Python������
echo 	2. .ssh/config����������������
echo 	3. Python��װ��xlrd�Ĳ�� deps/Python/
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set PROTOCOL=tmp_protocol
set XLS_FILE=messageBox.xlsm
set SVNHOST=https://svn.wekeystudio.local/repos/bleach/data

rem ��������
set HOSTALIAS=git.wekeystudio.com
set DEFAULT=develop

set /p branch=�����ļ���֧(%DEFAULT%):
set /p hostalias=��������(%HOSTALIAS%):

if "%branch%" == "" set branch=%DEFAULT%
if "%hostalias%" == "" set hostalias=%HOSTALIAS%

echo ��ȡ���µ�Э��(��������) ...
rd /S /Q %PROTOCOL%
git archive --format=zip --remote=%hostalias%:bleach/protocol.git --prefix=%PROTOCOL%/ --output=%PROTOCOL%.zip develop
7z.exe x %PROTOCOL%.zip

echo �����������ļ�%XLS_FILE% ...
del /S /Q new_errorcode.csv
svn.exe export %SVNHOST%/%branch%/%XLS_FILE% ./

echo �����µĴ��������� ...
C:\Python\python.exe take_errorcode.py %PROTOCOL% %XLS_FILE%

del /S /Q %XLS_FILE%
RD /S /Q %PROTOCOL%
del /S /Q %PROTOCOL%.zip

pause
