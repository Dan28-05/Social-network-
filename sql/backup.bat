@echo off
chcp 65001 > nul
echo ========================================================
echo   TIỆN ÍCH BACKUP CSDL SQL SERVER (QNU_Confesstion)
echo ========================================================
echo.
echo Đang sao lưu toàn bộ dữ liệu (kèm ảnh upload trong DB)...

docker exec sqlserver-instagram /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -C -Q "BACKUP DATABASE InstagramDB TO DISK = '/tmp/InstagramDB.bak' WITH FORMAT, INIT;"

if %ERRORLEVEL% EQU 0 (
    docker cp sqlserver-instagram:/tmp/InstagramDB.bak "%~dp0InstagramDB.bak"
    echo.
    echo [THÀNH CÔNG] File backup đã được lưu tại:
    echo   %~dp0InstagramDB.bak
    echo.
    echo Bạn có thể commit và push file này lên GitHub bất cứ lúc nào!
) else (
    echo.
    echo [LỖI] Không thể tạo backup. Vui lòng kiểm tra Docker container SQL Server!
)

echo.
pause
