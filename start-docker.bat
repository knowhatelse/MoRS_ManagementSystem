@echo off
echo Starting MoRS Management System with Docker...
echo.

echo Checking Docker status...
docker --version
if %ERRORLEVEL% neq 0 (
    echo Docker is not running or installed!
    pause
    exit /b 1
)

echo.
echo Stopping any existing containers...
docker-compose down

echo.
echo Building and starting all services...
docker-compose up --build -d

echo.
echo MoRS Management System is now running!
echo.
echo Available services:
echo    API: http://localhost:5000
echo    RabbitMQ Management: http://localhost:15672 (user: mors_user, pass: mors_password123)
echo    SQL Server: localhost:1433 (user: SA, pass: MoRS_Database123!)
echo.
echo You can now run the MoRS Management System desktop and mobile apps!
echo.
echo To stop all services, run: .\stop-docker.bat
