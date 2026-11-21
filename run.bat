@echo off
setlocal
title Phishing Email Detection App

:: Always run from the project folder
cd /d "%~dp0"

echo.
echo ==========================================
echo    PHISHING EMAIL DETECTION APP
echo ==========================================
echo.

:: --------------------------------------------------
:: 1. Check whether Python is installed
:: --------------------------------------------------
where py >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python was not found.
    echo.
    echo Please install Python 3.10 or newer and make sure
    echo "Add Python to PATH" is enabled during installation.
    echo.
    pause
    exit /b 1
)

:: --------------------------------------------------
:: 2. Create virtual environment if it doesn't exist
:: --------------------------------------------------
if not exist ".venv\Scripts\python.exe" (
    echo [1/4] Creating virtual environment...
    py -3 -m venv .venv

    if %errorlevel% neq 0 (
        echo.
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
) else (
    echo [1/4] Virtual environment already exists.
)

:: --------------------------------------------------
:: 3. Upgrade pip only if necessary + install packages
:: --------------------------------------------------
echo.
echo [2/4] Checking required packages...

".venv\Scripts\python.exe" -m pip install --upgrade pip
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Could not upgrade pip.
    pause
    exit /b 1
)

".venv\Scripts\python.exe" -m pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to install required packages.
    echo Check requirements.txt and your internet connection.
    pause
    exit /b 1
)

:: --------------------------------------------------
:: 4. Train model
:: --------------------------------------------------
echo.
echo [3/4] Training / preparing the model...
echo.

".venv\Scripts\python.exe" model_training.py
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Model training failed.
    echo Check the error above.
    pause
    exit /b 1
)

:: --------------------------------------------------
:: 5. Start Streamlit
:: --------------------------------------------------
echo.
echo [4/4] Starting the application...
echo.
echo ==========================================
echo    APP IS STARTING
echo    Browser: http://localhost:8501
echo ==========================================
echo.

".venv\Scripts\python.exe" -m streamlit run app.py

:: --------------------------------------------------
:: If Streamlit stops/crashes
:: --------------------------------------------------
echo.
echo ==========================================
echo    APPLICATION STOPPED
echo ==========================================
pause