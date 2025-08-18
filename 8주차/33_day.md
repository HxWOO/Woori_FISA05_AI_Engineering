# 🤖 Elasticsearch와 로컬 LLM(Qwen3)을 활용한 RAG 시스템 구축

## 🚀 오늘의 학습 목표

오늘은 **Elasticsearch를 벡터 데이터베이스로 활용**하고, **LM Studio**를 통해 로컬 환경에서 **Qwen3 언어 모델과 임베딩 모델을 직접 서빙**하여 완전한 **RAG(검색 증강 생성) 시스템**을 구축하는 과정을 학습했습니다. 외부 API 없이 내 컴퓨터 안에서 데이터 색인부터 LLM 답변 생성까지의 전 과정을 통제하는 강력한 시스템을 만드는 것이 목표였습니다.

> ### 💡 왜 로컬 RAG 시스템일까?
> ChatGPT 같은 외부 API를 사용하는 것은 편리하지만, 데이터 보안에 대한 우려나 비용 문제가 발생할 수 있습니다. LM Studio와 같은 도구를 사용하면, 강력한 오픈소스 LLM을 내 컴퓨터에서 직접 실행하고 제어할 수 있습니다. 이를 통해 **데이터 유출 걱정 없이 민감한 정보를 다루고, API 비용 없이 마음껏 실험**할 수 있는 환경을 구축할 수 있습니다.

---

### 📚 1. Elasticsearch, 벡터 DB로 변신시키기

먼저, 일반적인 검색 엔진인 Elasticsearch에 벡터 검색 기능을 추가하여 '하이브리드' 데이터베이스로 만드는 작업을 진행했습니다.

1.  **데이터 수집**: 한국거래소(KRX)에서 상장회사 정보를 `pandas`로 불러왔습니다.
2.  **데이터 가공**: 검색 품질을 높이기 위해 `업종`, `주요제품`, `지역` 등 여러 컬럼의 텍스트를 하나의 `설명` 필드로 통합했습니다.
3.  **인덱스 매핑**: `dense_vector` 타입을 사용하여 벡터 데이터를 저장할 수 있는 인덱스를 설계했습니다.
    -   **임베딩 모델**: LM Studio를 통해 서빙한 **Qwen3 임베딩 모델**을 사용했으며, 이 모델의 벡터 차원수인 **2560**에 맞춰 `dims`를 설정했습니다.

```json
// Elasticsearch 인덱스 매핑
{
  "mappings": {
    "properties": {
      "text_embedding": 
        {
          "type": "dense_vector", 
          "dims": 2560, 
          "index": true 
        },
      "홈페이지" : { "type" : "keyword" }
    }
  }
}
```

---

### 🖥️ 2. LM Studio로 나만의 AI 모델 서버 구축하기

LM Studio를 사용하여 로컬 환경에 OpenAI와 유사한 API 엔드포인트를 생성하고, 모델을 서빙했습니다.

-   **LLM (생성 모델)**: `Qwen/qwen3-4b-2507`
-   **임베딩 모델**: `Qwen/Qwen3-Embedding-4B-GGUF`
-   **API 엔드포인트**: `http://localhost:1234/v1`

이렇게 설정함으로써, `openai` 라이브러리를 그대로 사용하면서도 실제 요청은 내 컴퓨터의 LM Studio로 보낼 수 있었습니다.

```python
from openai import OpenAI

# LM Studio 서버에 연결하기 위한 클라이언트 설정
client = OpenAI(base_url="http://localhost:1234/v1", api_key="lm-studio")

# 임베딩 생성 함수
def get_embedding(text, model="model-identifier"):
   text = text.replace("\n", " ")
   return client.embeddings.create(input = [text], model=model).data[0].embedding
```

---

### ⚙️ 3. 하이브리드 검색과 RAG 파이프라인 구축

사용자의 질문에 가장 정확한 답변을 제공하기 위해, 질문의 길이에 따라 두 가지 검색 방식을 조합하는 **하이브리드 검색** 전략을 사용했습니다.

1.  **짧은 질문 (5단어 이하)**: **키워드 기반 검색 (Lexical Search)**
    -   `match` 쿼리를 사용하여 `업종`이나 `회사명` 필드에서 정확한 키워드로 검색합니다.
2.  **긴 질문 (5단어 초과)**: **의미 기반 검색 (Semantic Search)**
    -   질문을 임베딩 벡터로 변환한 후, Elasticsearch의 `knn` API를 사용하여 가장 유사한 의미를 가진 문서를 벡터 공간에서 검색합니다.

검색된 결과(회사 정보)는 LLM에게 전달할 **컨텍스트(Context)** 로 활용되며, 최종적으로 아래와 같은 프롬프트를 구성하여 **Qwen3 모델**에 질문과 함께 전달합니다.

```python
# RAG 파이프라인 핵심 로직
def rag_search_and_answer(query_text):
    # 1. (Retrieve) 질문 길이에 따라 lexical 또는 semantic 검색 수행
    if len(query_text.split()) > 5:
        retrieved_docs = search_by_semantic(query_text)
        search_type = "의미론적(Semantic)"
    else:
        retrieved_docs = search_by_lexical(query_text)
        search_type = "어휘적(Lexical)"
    
    # 2. (Augment) 검색된 정보를 바탕으로 LLM에게 전달할 프롬프트 생성
    context = ", ".join(retrieved_docs)
    prompt = f"""RAG result ---   
    회사 목록: {context}
    
    질문: {query_text}
    답변:
    """
    
    # 3. (Generate) 프롬프트를 LLM에 보내 최종 답변 생성
    response = client.chat.completions.create(...) 
    return response.choices[0].message.content
```

---

### ✨ 오늘 배운 것 요약

-   **Elasticsearch를 벡터 DB로 활용**: `dense_vector` 필드를 사용하여 텍스트와 벡터 데이터를 함께 저장하는 하이브리드 DB를 구축했습니다.
-   **LM Studio를 이용한 로컬 모델 서빙**: Qwen3 LLM과 임베딩 모델을 로컬에서 직접 서빙하고, OpenAI 라이브러리를 통해 쉽게 연동했습니다.
-   **하이브리드 검색 전략**: 사용자의 질문에 따라 키워드 검색과 의미 검색을 동적으로 전환하여 검색 정확도를 높이는 RAG 파이프라인을 설계했습니다.
-   **End-to-End RAG 구현**: 데이터 수집부터 전처리, 임베딩, 인덱싱, 검색, 그리고 LLM을 통한 답변 생성까지 RAG의 전 과정을 직접 구현하며 전체 흐름을 완벽히 이해했습니다.
-   **Streamlit을 활용한 UI**: 최종적으로 Streamlit을 이용해 사용자가 직접 질문하고 답변을 확인할 수 있는 웹 애플리케이션까지 완성했습니다.

---
