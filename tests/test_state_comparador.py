import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from scripts.state_comparador import comparar, cargar_tfstate, obtener_estado_deseado, obtener_estado_real, NOMBRE_DEPLOYMENT, NOMBRE_SERVICE
import json
import pytest
from unittest.mock import patch, Mock
# tests para "comparar" de state_comparador
@pytest.mark.parametrize(
    "estado_deseado, estado_real, resultado_drift_esperado",
    [
        # caso sin drift
        (
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            False
        ),

        # drift solo en replicas
        (
            {
                "deployment": {
                    "replicas": 4,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            True
        ),

        # drift en service port
        (
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 8080,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            True
        ),

        # drift en varios atributos
        (
            {
                "deployment": {
                    "replicas": 5,
                    "image": "nginx:1.26",
                    "container_port": 8080,
                    "container_name": "web-contenedor-2"
                },
                "service": {
                    "port": 8080,
                    "target_port": 8080,
                    "type": "LoadBalancer"
                }
            },
            {
                "deployment": {
                    "replicas": 3,
                    "image": "nginx:1.25",
                    "container_port": 80,
                    "container_name": "web-contenedor"
                },
                "service": {
                    "port": 80,
                    "target_port": 80,
                    "type": "ClusterIP"
                }
            },
            True
        )
    ]
)
def test_comparar(estado_deseado, estado_real, resultado_drift_esperado):
    drift = comparar(estado_deseado, estado_real)
    assert drift == resultado_drift_esperado
