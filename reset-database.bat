@echo off
echo Resetting MoRS Management System Database...
echo.

echo WARNING: This will completely delete all database data!
echo This action cannot be undone!
echo.
set /p confirm="Are you sure you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
echo Stopping all containers...
docker-compose down

echo.
echo Removing database volume...
docker volume rm mors_managementsystem_mors_database_data 2>nul
if %ERRORLEVEL% equ 0 (
    echo Database volume removed successfully!
) else (
    echo Database volume may not exist or already removed.
)

echo.
echo Starting system with fresh database...
docker-compose up --build -d

echo.
echo Database reset complete!
echo.
echo What happened:
echo    Old database completely deleted
echo    New database created automatically
echo    Latest migrations applied
echo    Fresh data seeded
echo.
echo Available services:
echo    API: http://localhost:5000
echo    RabbitMQ Management: http://localhost:15672 (user: mors_user, pass: mors_password123)
echo    SQL Server: localhost:1433 (user: SA, pass: MoRS_Database123!)
echo.
