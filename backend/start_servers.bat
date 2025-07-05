@echo off
echo Starting Verdex Backend and Frontend Servers...
echo.

echo Starting Laravel Backend Server...
echo Backend will be available at: http://192.168.37.101:8000
echo.
start "Laravel Backend" cmd /k "cd /d D:\Dev\Verdex\backend && php artisan serve --host=192.168.37.101 --port=8000"

echo Waiting 3 seconds for backend to start...
timeout /t 3 /nobreak > nul

echo.
echo Starting Frontend Development Server...
echo Frontend will be available at: http://192.168.37.101:3000
echo.
start "Frontend Dev Server" cmd /k "cd /d D:\Dev\Verdex\backend && npm run dev -- --host 192.168.37.101"

echo.
echo Both servers are starting...
echo Backend: http://192.168.37.101:8000
echo Frontend: http://192.168.37.101:3000
echo.
echo Press any key to close this window...
pause > nul 