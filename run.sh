#!/usr/bin/env bash
# Linux / macOS launcher
set -euo pipefail
cd "$(dirname "$0")"
PYTHON_BIN=${PYTHON_BIN:-python3}
[ -d .venv ] || "$PYTHON_BIN" -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate
python -m pip install --quiet --upgrade pip
pip install --quiet -r requirements.txt
python model_training.py
streamlit run app.py
