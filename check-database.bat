@echo off
echo MoRS Management System Database Status
echo.

echo Checking Docker containers...
docker-compose ps

echo.
echo Checking Docker volumes...
docker volume ls | findstr mors_managementsystem

echo.
echo Database connection test...
docker exec -it mors-database /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "MoRS_Database123!" -Q "SELECT name FROM sys.databases WHERE name = 'IB200154';" -C 2>nul
if %ERRORLEVEL% equ 0 (
    echo Database is accessible
) else (
    echo Database is not accessible or containers not running
)

echo.
echo Checking for users in database...
docker exec -it mors-database /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "MoRS_Database123!" -Q "USE IB200154; SELECT COUNT(*) as UserCount FROM AspNetUsers;" -C 2>nul

echo.
pause
