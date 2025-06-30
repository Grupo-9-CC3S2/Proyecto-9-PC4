#!/bin/bash
PYTHON="python"
DIR_RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
DIR_IAC="${DIR_RAIZ}/iac"
DIR_SCRIPTS="${DIR_RAIZ}/scripts"

# Remediación con terraform apply
cd "$DIR_IAC"
terraform apply -auto-approve > /dev/null

echo "Remediación realizada. Verificando nuevamente..."
# Se verifica nuevamente con el script comparador
cd "$DIR_SCRIPTS"
$PYTHON state_comparador.py
if [ $? -ne 0 ]; then
    echo "No se pudo remediar el drift correctamente. "
    exit 1
else
    echo "Drift remediado exitosamente."
    exit 0
fi