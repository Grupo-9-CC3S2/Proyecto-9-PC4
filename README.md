# Proyecto-9-PC4 - Herramienta de detección de drift de infraestructura local

**Integrantes**
- Daren Adiel Herrera Romo (scptx0)
- Renzo Quispe Villena (RenzoQuispe)
- Andre Sanchez Vega (AndreSanchezVega)

## Videos grupales

### Sprint 1
- [Video de sprint 1](https://drive.google.com/file/d/14cMcmKsz_NaZp_sZvqZ7fk6zKWZYs5da/view?usp=drive_link)
### Sprint 2
- [Video Daren](https://github.com/scptx0/PC4-DS/blob/main/videos/sprint2-daren-pc4.mp4)
- [Video Renzo](https://github.com/RenzoQuispe/Proyecto-9-Personal/blob/main/videos/sprint2-RenzoQuispe.mp4)
### Sprint 3
- [Video Daren](https://github.com/scptx0/PC4-DS/blob/main/videos/sprint3-daren-pc4.mp4)
- [Video Renzo](https://github.com/RenzoQuispe/Proyecto-9-Personal/blob/main/videos/sprint3-RenzoQuispe.mp4)
### Video final
- [Video final](https://unipe-my.sharepoint.com/:v:/g/personal/daren_herrera_r_uni_pe/ERCDE2PowohKvtTx7Oim5qgBQVyTY3S8VL9Cyl8mzfdvAg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=p5oZVr)

## Descripción general del proyecto

Este proyecto consiste en crear una herramienta que detecte "drift" (desviación) entre el estado deseado de la infraestructura definido en Terraform y el estado real de los recursos en un entorno local (simulado con Docker/Kubernetes).

## Descripción de scripts

`state_comparador.py`
- Lee el archivo con la infraestructura deseada `terraform.tfstate`.
- Obtiene el estado real de la infraestructura con `kubectl get -o json`.
- Compara los estados y detecta si hay drift o no.
- Imprime una tabla ASCII con la comparación.

`drift_remediation.sh`
- Remedia el drift generado con `terraform apply`
- Luego de la remediación, verifica si aún hay drift

`pipeline.sh`
- Despliega la infraestructura deseada en el clúster de kubernetes local
- Genera un drift manual (número de replicas)
- Ejecuta el comparador de estados (`state_comparador.py`)
- Si se detecta drift, se remedia con `drift_remediation.sh`.

## Requisitos técnicos

| Herramientas | Versión       |
|--------------|---------------|
| Python       | >= 3.10       |
| Terraform    | 1.12.1        |
| Bash         | >= 5.1.16     |
|   kubectl    | >= 1.33       |

## ¿Cómo usar el proyecto?

1. Clonar el repositorio e inicializar el proyecto

```bash
git clone https://github.com/Grupo-9-CC3S2/Proyecto-9-PC4.git
# Instalar dependencias
pip install -r requirements.txt
# Inicializar minikube (herramienta local de k8s)
minikube start
# Configuración de terraform
cd iac
terraform init
terraform apply -auto-approve
# verificar el estado de los recursos creados por terraform
kubectl get deployments
kubectl get pods
kubectl get svc
```

2. Usar los scripts
    - Si solo se quiere usar el comparador de estados:

        ```bash
        cd scripts
        python state_comparador.py
        ```
    - Si se quiere visualizar el pipeline de generación y remediación de drift automático:

        ```bash
        cd scripts
        chmod +x pipeline.sh
        ./pipeline.sh
        # o tambien bash pipeline.sh
        ```

### Ejecucion de pruebas y cobertura
#### Pruebas unitarias
```markdown
git clone https://github.com/Grupo-9-CC3S2/Proyecto-9-PC4.git
cd Proyecto-9-Personal
python3 -m venv venv
source venv/bin/activate
pip install pytest pytest-cov prettytable
pytest --cov=scripts -v
```

#### Chaos testing minimal
```markdown
git clone https://github.com/Grupo-9-CC3S2/Proyecto-9-PC4.git
cd Proyecto-9-Personal
# tener creado los recursos
cd iac
terraform init
terraform apply
# chaos testing minimal
cd ..
chmod +x scripts/chaos_test.sh
./scripts/chaos_test.sh 
```

prueba