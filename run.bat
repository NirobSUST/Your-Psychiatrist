@echo off
setlocal

rem ---- Config ----
set HOST=127.0.0.1
set PORT=8000

rem ---- Check Python 3.11 ----
py -3.11 -V >nul 2>&1
if %errorlevel% neq 0 (
  echo ❌ Python 3.11 not found. Install it: https://www.python.org/downloads/release/python-3119/
  pause
  exit /b 1
)

rem ---- Create venv if missing ----
if not exist venv (
  py -3.11 -m venv venv
)

call venv\Scripts\activate

rem ---- Upgrade pip tooling ----
python -m pip install --upgrade pip setuptools wheel

rem ---- Install torch (CPU) ----
pip show torch >nul 2>&1
if %errorlevel% neq 0 (
  pip install torch --index-url https://download.pytorch.org/whl/cpu
)

rem ---- Install requirements ----
pip install -r api\requirements.txt

rem ---- Pull mistral if Ollama exists ----
where ollama >nul 2>&1
if %errorlevel%==0 (
  ollama pull mistral
)

rem ---- Start backend in background ----
echo 🚀 Starting backend (FastAPI) on port %PORT% ...
start "backend" cmd /k "call venv\Scripts\activate && uvicorn api.main:app --host 0.0.0.0 --port %PORT% --log-level debug"

rem ---- Wait a bit ----
timeout /t 10 >nul

rem ---- Start frontend ----
echo 🚀 Starting frontend (Streamlit)...
streamlit run app\streamlit_app.py --server.port=8501

endlocal
