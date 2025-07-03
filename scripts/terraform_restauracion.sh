#!/bin/bash
# Actualizar terraform.tfstate a un estado anterior
ruta_este_script=$(realpath "$0")
carpeta_scripts=$(dirname "$ruta_este_script")
raiz_proyecto=$(dirname "$carpeta_scripts")
carpeta_backups="$raiz_proyecto/backups"
terraform_tfstate="$raiz_proyecto/iac/terraform.tfstate"
# lista de los archivos_backups que hay en la carpeta backups
archivos_backups=($(ls "$carpeta_backups"))
numero_backups=${#archivos_backups[@]}
# verificar si hay archivos backup
if [ "$numero_backups" -eq 0 ]; then
  echo "no se encontraron archivos backups"
  exit 1
fi
# menu de backups para escoger
echo "lista de backups"
for i in "${!archivos_backups[@]}"; do
  numero=$((i+1))
  echo "$numero- ${archivos_backups[$i]}"
done
# leer la opcion escogida
while true; do
  read -p "Escribe la opcion de un backup: " opcion
  # verificar que el valor ingresado sea valido
  if [[ "$opcion" =~ ^[0-9]+$ ]]; then
    if [ "$opcion" -ge 1 ]; then
      if [ "$opcion" -le "$numero_backups" ]; then
        break
      else
        echo "no existe esa opcion"
      fi
    else
      echo "no existe esa opcion"
    fi
  else
    echo "no existe esa opcion,ingresar un numero valido"
  fi
done

backup_escogido="${archivos_backups[$((opcion-1))]}"
ruta_backup_escogido="$carpeta_backups/$backup_escogido"
cp "$ruta_backup_escogido" "$terraform_tfstate"
echo "restauracion exitosa"