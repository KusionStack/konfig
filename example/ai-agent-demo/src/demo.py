# Kusion AI agent RAG demo

# Import Libraries
# ----------------
import os

import boto3
from flask import Flask, request, jsonify
from langchain.chains import ConversationalRetrievalChain
from langchain.chains.conversation.memory import ConversationBufferWindowMemory
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.chat_models import ChatOpenAI
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import OpenSearchVectorSearch
from langchain_core.output_parsers import StrOutputParser
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

# Constants and API Keys
# ----------------------
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
RAG_ENABLED = os.getenv('RAG_ENABLED')
OPEN_SEARCH_ENDPOINT = os.getenv('OPEN_SEARCH_ENDPOINT')
OPEN_SEARCH_AK = os.getenv('OPEN_SEARCH_AK')
OPEN_SEARCH_SK = os.getenv('OPEN_SEARCH_SK')
OPEN_SEARCH_REGION = os.getenv('OPEN_SEARCH_REGION')
NVIDIA_PDF_PATH = "./nvidia-10q.pdf"
VECTOR_DB_DIRECTORY = "/tmp/vectordb"
GPT_MODEL_NAME = 'gpt-3.5-turbo'
CHUNK_SIZE = 700
CHUNK_OVERLAP = 50


# Function Definitions
# --------------------
def load_and_split_document(pdf_path):
    """Loads and splits the document into pages."""
    loader = PyPDFLoader(pdf_path)
    return loader.load_and_split()


def split_text_into_chunks(pages, chunk_size, chunk_overlap):
    """Splits text into smaller chunks for processing."""
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    return text_splitter.split_documents(pages)


def create_embeddings(api_key):
    """Creates embeddings from text."""
    return OpenAIEmbeddings(openai_api_key=api_key)


def setup_awsauth():
    service = "es"  # must set the service as 'es'
    region = OPEN_SEARCH_REGION
    ak = OPEN_SEARCH_AK
    sk = OPEN_SEARCH_SK
    credentials = boto3.Session(
        aws_access_key_id=ak, aws_secret_access_key=sk
    ).get_credentials()
    awsauth = AWS4Auth(ak, sk, region, service, session_token=credentials.token)
    return awsauth


def setup_client(awsauth, host_url):
    client = OpenSearch(
        hosts=[{'host': host_url, 'port': 443}],
        http_auth=awsauth,
        use_ssl=True,
        verify_certs=True,
        connection_class=RequestsHttpConnection,
        timeout=300
    )
    return client


def check_index_exists(client, index_name):
    if client.indices.exists(index=index_name):
        print("index exists")
        client.indices.delete(index=index_name)
        return True
    else:
        print("index does not exist")
        return False


def setup_vector_database(awsauth, documents, embeddings, host_url):
    """Sets up a vector database for storing embeddings."""
    service = "es"  # must set the service as 'es'
    region = OPEN_SEARCH_REGION
    ak = OPEN_SEARCH_AK
    sk = OPEN_SEARCH_SK
    credentials = boto3.Session(
        aws_access_key_id=ak, aws_secret_access_key=sk
    ).get_credentials()
    awsauth = AWS4Auth(ak, sk, region, service, session_token=credentials.token)
    return OpenSearchVectorSearch.from_documents(
        documents,
        embeddings,
        opensearch_url=host_url,
        http_auth=awsauth,
        timeout=300,
        use_ssl=True,
        verify_certs=True,
        connection_class=RequestsHttpConnection,
        index_name="test-index",
    )


def initialize_chat_model(api_key, model_name):
    """Initializes the chat model with specified AI model."""
    return ChatOpenAI(openai_api_key=api_key, model_name=model_name, temperature=0.0)


def create_retrieval_qa_chain(chat_model, vector_database):
    """Creates a retrieval QA chain combining model and database."""
    memory = ConversationBufferWindowMemory(memory_key='chat_history', k=5, return_messages=True)
    return ConversationalRetrievalChain.from_llm(
        chat_model,
        retriever=vector_database.as_retriever(),
        verbose=True,
        # return_generated_question=True,
        # return_source_documents=True,
        memory=memory)


def create_regular_qa_chain(chat_model):
    """Creates a regular QA chain combining model and database."""
    output_parser = StrOutputParser()
    regular_chain = chat_model | output_parser
    return regular_chain


def ask_question_and_get_answer(qa_chain, question):
    """Asks a question and retrieves the answer."""
    return qa_chain({"question": question})['answer']


# Main Execution Flow
# -------------------

app = Flask(__name__)


@app.route('/ask', methods=['POST'])
def ask():
    try:
        question = request.json.get('question')
        if not question:
            return jsonify({"error": "No question provided"}), 400
        if RAG_ENABLED == "true":
            response = ask_question_and_get_answer(qa_chain, question)
        else:
            response = regular_chain.invoke(question)
        return jsonify({"answer": response}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    """Main function to execute the RAG workflow."""
    chat_model = initialize_chat_model(OPENAI_API_KEY, GPT_MODEL_NAME)
    regular_chain = create_regular_qa_chain(chat_model)

    if RAG_ENABLED == "true":
        print("RAG is enabled")
        pages = load_and_split_document(NVIDIA_PDF_PATH)
        documents = split_text_into_chunks(pages, CHUNK_SIZE, CHUNK_OVERLAP)
        embeddings = create_embeddings(OPENAI_API_KEY)
        host = OPEN_SEARCH_ENDPOINT
        host_url = "https://" + host
        indexName = "test-index"

        awsauth = setup_awsauth()
        client = setup_client(awsauth, host)
        index_exists = check_index_exists(client, indexName)
        if not index_exists:
            vector_database = setup_vector_database(awsauth, documents, embeddings, host_url)
            print("index created")
        else:
            print("index exists, returning vector database object")
            vector_database = OpenSearchVectorSearch(
                host_url,
                indexName,
                embeddings,
                http_auth=awsauth,
                timeout=300,
                use_ssl=True,
                verify_certs=True,
                connection_class=RequestsHttpConnection,
            )
        qa_chain = create_retrieval_qa_chain(chat_model, vector_database)
    else:
        print("RAG is disabled")
    app.run(host='0.0.0.0', port=8888)