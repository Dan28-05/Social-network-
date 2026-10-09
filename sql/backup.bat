@echo off
echo ========================================================
echo   BACKUP DATABASE SQL SERVER - QNU_Confesstion
echo ========================================================
echo.
echo Dang sao luu du lieu SQL Server sang file .bak...

docker exec sqlserver-instagram /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -C -Q "BACKUP DATABASE InstagramDB TO DISK = '/tmp/InstagramDB.bak' WITH FORMAT, INIT;"

docker cp sqlserver-instagram:/tmp/InstagramDB.bak "%~dp0InstagramDB.bak"

echo.
echo [THANH CONG] Da luu file backup tai:
echo %~dp0InstagramDB.bak
echo.
pause
