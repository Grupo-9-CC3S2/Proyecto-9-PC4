#!/bin/bash
# se crea la carpeta backups
ruta_este_script="$(realpath "$0")"
carpeta_scripts="$(dirname "$ruta_este_script")"
raiz_proyecto="$(dirname "$carpeta_scripts")"
mkdir -p "$raiz_proyecto/backups"
# creacion de una copia de terraform.tfstate(con fecha como identificador) a backups
fecha_creacion="$(date +"%Y-%m-%d_%H-%M-%S")"
terraform_tfstate="$raiz_proyecto/iac/terraform.tfstate"
ruta_nuevo_backup="$raiz_proyecto/backups/tfstate_${fecha_creacion}.backup"
cp "$terraform_tfstate" "$ruta_nuevo_backup"