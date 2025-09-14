from langchain_community.chat_models import ChatOllama
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_history_aware_retriever, create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from .chroma_utils import get_vectorstore

retriever = get_vectorstore().as_retriever(search_kwargs={"k": 2})
output_parser = StrOutputParser()

contextualize_q_system_prompt = (
    "Given a chat history and the latest user question which might reference context, "
    "formulate a standalone question. Do NOT answerâ€”just reformulate."
)
contextualize_q_prompt = ChatPromptTemplate.from_messages([
    ("system", contextualize_q_system_prompt),
    MessagesPlaceholder("chat_history"),
    ("human", "{input}"),
])

qa_prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful AI assistant. Use the following context to answer."),
    ("system", "Context: {context}"),
    MessagesPlaceholder("chat_history"),
    ("human", "{input}")
])

def _model_name_or_fallback(model: str) -> str:
    # If someone passes 'gpt-4o' etc., we still use local mistral
    return "mistral"

def get_rag_chain(model="mistral"):
    llm = ChatOllama(model=_model_name_or_fallback(model), temperature=0.2)
    history_aware_retriever = create_history_aware_retriever(llm, retriever, contextualize_q_prompt)
    question_answer_chain = create_stuff_documents_chain(llm, qa_prompt)
    return create_retrieval_chain(history_aware_retriever, question_answer_chain)
