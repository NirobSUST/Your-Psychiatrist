# 🧠 Your Psychiatrist – RAG Chatbot

A local **Retrieval-Augmented Generation (RAG)** chatbot built with:

- **FastAPI** (backend API)
- **Streamlit** (frontend UI)
- **LangChain** (retriever + chains)
- **ChromaDB** (vector store for document search)
- **HuggingFace MiniLM** (free sentence embeddings)
- **Ollama + Mistral** (local LLM, no API costs)

Upload your documents (PDF, DOCX, HTML) and chat with them using a free, privacy-friendly, fully local AI.

---

## 🚀 Features

- **Chat with your documents**: Upload and query knowledge from PDFs, Word docs, or HTML.
- **Local embeddings**: Uses [sentence-transformers/all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2).
- **Local LLM**: Runs [Mistral](https://ollama.com/library/mistral) via [Ollama](https://ollama.com/).
- **History-aware retrieval**: Maintains conversation context across turns.
- **Database-backed**: Logs chat history & manages documents with SQLite.
- **Full stack**: FastAPI backend + Streamlit frontend.

---

## 📂 Project Structure

```
Your-Psychiatrist/
├── api/
│   ├── main.py              # FastAPI entrypoint
│   ├── langchain_utils.py   # RAG chain builder
│   ├── chroma_utils.py      # Chroma vector store + embeddings
│   ├── db_utils.py          # SQLite helper functions
│   ├── pydantic_models.py   # Request/response schemas
│   └── requirements.txt     # Python dependencies
├── app/
│   └── streamlit_app.py     # Streamlit frontend
├── chroma_db/               # Persistent Chroma database
├── rag_app.db               # SQLite database
├── run_all.bat              # Windows launcher (backend + frontend)
├── run.sh                   # Linux/Mac launcher (backend + frontend)
└── README.md
```

---

## ⚙️ Requirements

- [Python 3.11](https://www.python.org/downloads/release/python-3119/)  
- [Ollama](https://ollama.com/download) (for local LLMs)  
- Git, pip, and virtualenv recommended

---

## 🔧 Installation

### 1. Clone the repo
```bash
git clone https://github.com/yourusername/your-psychiatrist.git
cd your-psychiatrist
```

### 2. Create a virtual environment (Python 3.11)
```bash
py -3.11 -m venv venv
.\venv\Scripts\activate     # Windows
source venv/bin/activate    # Linux/Mac
```

### 3. Install dependencies
```bash
pip install --upgrade pip setuptools wheel
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install -r api/requirements.txt
```

### 4. Install Ollama models
```bash
ollama pull mistral
```

Optional: for embeddings via Ollama instead of HuggingFace
```bash
ollama pull nomic-embed-text
```

---

## ▶️ Running the App

### Windows
```bash
.\run.bat
```

This will:
1. Start **FastAPI** backend → [http://localhost:8000/docs](http://localhost:8000/docs)  
2. Start **Streamlit** frontend → [http://localhost:8501](http://localhost:8501)

---

## 📖 Usage

1. Go to [http://localhost:8501](http://localhost:8501).  
2. Upload a document (PDF, DOCX, or HTML).  
3. Ask questions in the chat panel.  
4. The chatbot retrieves relevant document chunks and responds with context-aware answers.  

---

## 🛠️ Development Notes

- Default model = **Mistral** via Ollama.  
- Default embeddings = **MiniLM** from HuggingFace.  
- Database: `rag_app.db` (SQLite).  
- Vector store: persisted in `./chroma_db`.  
- File uploads allowed: `.pdf`, `.docx`, `.html`.  

---

## ⚠️ Known Issues

- First run may take time (downloads models).  
- HuggingFace’s `HuggingFaceEmbeddings` shows a **deprecation warning**; future versions should migrate to `langchain-huggingface`.  
- For large documents, embedding and indexing can be slow.  

---

## 📜 License

MIT License.  
Free to use, modify, and share.

---

## 🙏 Acknowledgements

- [LangChain](https://www.langchain.com/)  
- [Chroma](https://www.trychroma.com/)  
- [Ollama](https://ollama.com/)  
- [Sentence Transformers](https://www.sbert.net/)  
- [FastAPI](https://fastapi.tiangolo.com/)  
- [Streamlit](https://streamlit.io/)  
