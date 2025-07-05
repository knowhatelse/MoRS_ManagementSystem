@echo off
echo Stopping MoRS Management System Docker containers...
echo.

docker-compose down

echo.
echo All containers stopped!
echo.
echo To remove all data (database, etc.), run: docker-compose down --volumes
