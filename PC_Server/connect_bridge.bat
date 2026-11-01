@echo off
title Puente de Conexion TrinusVR (USB / Wi-Fi)
cls
echo =======================================================
echo     PUENTE DE CONEXION TRINUS VR - IPHONE 6 (iOS 12)
echo =======================================================
echo.
set /p IPHONE_IP="Ingresa la IP de tu iPhone 6 (ej. 192.168.1.150): "
echo.
echo [1] Probando conexion con el iPhone en %IPHONE_IP%...
ping -n 2 %IPHONE_IP% > nul

if %errorlevel% equ 0 (
    echo [OK] El iPhone esta alcanzable en la red.
) else (
    echo [!] ALERTA: No se pudo hacer ping al iPhone. Revisa que esten en el mismo Wi-Fi.
)

echo.
echo [2] Iniciando el servidor de giroscopio en Python...
python server.py
pause
