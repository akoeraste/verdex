@echo off
setlocal enabledelayedexpansion

REM Verdex App Test Runner Script for Windows
REM This script runs all tests in the proper order and generates a comprehensive report

echo 🚀 Verdex App Test Suite
echo ==========================
echo.

REM Check prerequisites
echo [INFO] Checking prerequisites...

where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

where dart >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Dart is not installed or not in PATH
    exit /b 1
)

echo [SUCCESS] Prerequisites check passed

REM Get Flutter version
for /f "tokens=*" %%i in ('flutter --version ^| findstr /n "^" ^| findstr "^1:"') do set FLUTTER_VERSION=%%i
echo [INFO] Using %FLUTTER_VERSION%

REM Change to the frontend directory
cd /d "%~dp0"

REM Clean and get dependencies
echo [INFO] Getting dependencies...
flutter clean
flutter pub get

REM Generate mocks if needed
echo [INFO] Generating mock files...
flutter packages pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [WARNING] Mock generation failed, continuing...
)

REM Initialize test results
set total_tests=0
set passed_tests=0

REM Function to run test category
:run_test_category
set category=%1
set test_path=%2
set description=%3

echo [INFO] Running %description%...
flutter test "%test_path%" --reporter=compact
if %errorlevel% equ 0 (
    set /a passed_tests+=1
    echo [SUCCESS] %description% completed successfully
) else (
    echo [ERROR] %description% failed
)
set /a total_tests+=1
echo.
goto :eof

REM Run all test categories
echo 📋 Running Test Categories
echo ==========================

REM Unit Tests
call :run_test_category "unit_tests" "test/services/" "Service Unit Tests"
call :run_test_category "unit_utils" "test/unit/" "Utility Unit Tests"

REM Widget Tests
call :run_test_category "widget_screens" "test/screens/" "Screen Widget Tests"
call :run_test_category "widget_components" "test/widgets/" "Component Widget Tests"

REM Integration Tests
call :run_test_category "integration_tests" "test/integration/" "Integration Tests"

REM Specialized Tests
call :run_test_category "performance_tests" "test/performance/" "Performance Tests"
call :run_test_category "security_tests" "test/security/" "Security Tests"
call :run_test_category "accessibility_tests" "test/accessibility/" "Accessibility Tests"

REM Generate test report
echo 📊 Test Report
echo ==============

REM Calculate success rate
if %total_tests% equ 0 (
    set success_rate=0
) else (
    set /a success_rate=(%passed_tests% * 100) / %total_tests%
)

echo.
echo 📈 Summary
echo ==========
echo Total test categories: %total_tests%
echo Passed: %passed_tests%
set /a failed_tests=%total_tests% - %passed_tests%
echo Failed: %failed_tests%
echo Success rate: %success_rate%%%

REM Final status
echo.
if %passed_tests% equ %total_tests% (
    echo 🎉 All tests passed! The app is ready for production.
    exit /b 0
) else (
    echo ⚠️  Some tests failed. Please review and fix the issues.
    exit /b 1
) 