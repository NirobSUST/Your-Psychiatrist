#!/bin/bash
# run.sh - start backend (FastAPI), frontend (Streamlit), and ensure Ollama models are ready

# Exit immediately if a command fails
set -e

# --- Check Ollama ---
if ! command -v ollama &> /dev/null
then
    echo "❌ Ollama is not installed. Please install it first: https://ollama.com/download"
    exit 1
fi

# Make sure Ollama is running (try to ping it)
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "⚠️ Ollama does not seem to be running. Starting it in background..."
    ollama serve &
    sleep 3
fi

# --- Pull required models ---
echo "🔽 Ensuring mistral model is available..."
ollama pull mistral

# (optional) also pull embeddings model if you plan to use it
# echo "🔽 Ensuring nomic-embed-text model is available..."
# ollama pull nomic-embed-text

# --- Python environment setup ---
if [ ! -d "venv" ]; then
  echo "Creating virtual environment..."
  python -m venv venv
fi

source venv/bin/activate

pip install -r api/requirements.txt

# --- Start backend ---
echo "🚀 Starting backend (FastAPI)..."
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

# --- Start frontend ---
echo "🚀 Starting frontend (Streamlit)..."
streamlit run app/streamlit_app.py --server.port=8501

# --- Cleanup ---
trap "kill $BACKEND_PID" EXIT
