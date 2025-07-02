#!/bin/bash
PYTHON="python"
DIR_RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
DIR_IAC="${DIR_RAIZ}/iac"
DIR_SCRIPTS="${DIR_RAIZ}/scripts"

# Se despliega localmente la infraestructura
(
    cd $DIR_IAC
    echo "Inicializando y aplicando infraestuctura definida en los archivos de terraform..."
    terraform init > /dev/null
    terraform apply -auto-approve > /dev/null
)

# Se genera un drift manualmente
echo "Generando drift..."
kubectl scale deployment nginx-deployment --replicas=5 > /dev/null

# Se verifica si hay drift o no
cd "$DIR_SCRIPTS"
echo "Ejecutando comparador de estados..."
$PYTHON state_comparador.py
if [ $? -ne 0 ]; then
    echo "Se ha detectado drift. Iniciando remediación..."
    echo ""
    bash "${DIR_SCRIPTS}/drift_remediation.sh"
    exit 1
else    
    echo "No se ha detectado drift".
    exit 0
fi
