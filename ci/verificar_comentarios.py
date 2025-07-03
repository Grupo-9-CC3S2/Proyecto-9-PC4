import subprocess
import sys
from langdetect import detect

# Se obtienen los archivos que cambiaron con respecto a la rama develop del repositorio remoto
archivos = subprocess.check_output(["git", "diff", "--name-only", "origin/develop"]).decode().splitlines()

extensiones_validas = ('.py', '.sh', '.yaml')
fallo = False

for archivo in archivos:
    if archivo.endswith(extensiones_validas):
        try:
            with open(archivo, encoding='utf-8') as f:
                comentarios = [linea.strip() for linea in f if linea.strip().startswith(('#', '//'))]
            if not comentarios:
                print(f"No hay comentarios en {archivo}")
                fallo = True
            elif not any(detect(com) == 'es' for com in comentarios):
                print(f"Los comentarios no están en español en {archivo}")
                fallo = True
        except Exception as e:
            print(f"Error al leer {archivo}: {e}")
            fallo = True

if fallo:
    sys.exit(1)

print ("Los archivos contienen comentarios y están en español.")