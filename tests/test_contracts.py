import json
import subprocess
import pytest
from jsonschema import validate, ValidationError

SCHEMA_PATH = "contracts/tf_output_schema.json"

@pytest.fixture(scope="module")
def tf_outputs():
    result = subprocess.run(
        ["terraform", "output", "-json"],
        cwd="iac",
        capture_output=True, text=True, check=True
    )
    raw = json.loads(result.stdout)
    return {k: v["value"] for k, v in raw.items()}

def test_outputs_contract(tf_outputs):
    # Cargamos el JSON Schema
    with open(SCHEMA_PATH) as f:
        schema = json.load(f)

    # Validamos los outputs reales contra el esquema
    try:
        validate(instance=tf_outputs, schema=schema)
    except ValidationError as e:
        pytest.fail(f"Contrato de outputs inválido: {e.message}")
