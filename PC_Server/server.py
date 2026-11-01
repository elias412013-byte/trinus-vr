import socket
import pyautogui

# Configuración del servidor UDP en la PC
UDP_IP = "0.0.0.0"  # Escucha peticiones de cualquier interfaz de la red
UDP_PORT = 8080

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

print(f"[*] Servidor TrinusVR escuchando en el puerto {UDP_PORT}...")
print("[*] Listo para recibir datos del giroscopio del iPhone...")

pyautogui.FAILSAFE = False

while True:
    data, addr = sock.recvfrom(1024)
    try:
        raw_data = data.decode('utf-8')
        pitch, roll, yaw = map(float, raw_data.split(','))
        
        # Mapeo de giroscopio a movimiento del mouse / cámara
        sensitivity = 400
        move_x = int(yaw * sensitivity)
        move_y = int(pitch * sensitivity)
        
        pyautogui.moveRel(move_x, move_y, _pause=False)
    except Exception as e:
        pass
