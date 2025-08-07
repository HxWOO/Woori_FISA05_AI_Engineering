# 📅 2025년 8월 7일

## 🗺️ Elasticsearch 심화 학습: 검색과 텍스트 분석

오늘은 Elasticsearch의 핵심 기능인 검색 API와 텍스트 분석(Text Analysis)에 대해 깊이 있게 학습했다. Query DSL을 활용한 정교한 검색 방법을 익혔고, 한글 분석 플러그인 nori를 통해 한국어 처리의 원리를 파악하는 데 중점을 두었다.

> ### 💡 검색과 분석, 왜 중요할까?
> Elasticsearch의 강력함은 단순히 데이터를 저장하는 것을 넘어, 비정형 텍스트 데이터 속에서 의미 있는 결과를 빠르고 정확하게 찾아내는 능력에 있다는 것을 다시 한번 느꼈다. 특히, 사용자의 의도를 파악하는 자연어 검색과 데이터의 특성에 맞는 분석기를 적용하는 것이 검색 품질을 결정하는 핵심 요소임을 배웠다.

---

### ✍️ 1. 검색 API와 Query DSL

Elasticsearch에는 `URI 검색`과 `Request Body 검색` 두 가지 방식이 있다는 것을 배웠다. 복잡하고 구조화된 검색이 가능한 **Request Body 검색(Query DSL)** 이 왜 현업에서 선호되는지 이해할 수 있었다.

#### **Query DSL (Domain Specific Language)**

JSON 형식으로 다양한 쿼리를 조합하여 정교한 검색 조건을 만드는 방법을 실습했다.

- **`match` 쿼리**: Full-text 검색에 사용되는 가장 기본적인 쿼리 
    ```json
    // "hobby" 필드에서 "책보기"라는 단어가 포함된 문서 검색을 실습했다.
    GET my-index/_search
    {
      "query": {
        "match": {
          "hobby" : "책보기"
        }
      }
    }
    ```

- **`term` 쿼리**: 분석을 거치지 않는 정확한 값(Exact Value)을 검색할 수 있다

- **`bool` 쿼리**: 여러 쿼리 조건을 조합하여 복잡한 검색을 수행할 수 있다
    | 절 | 내가 이해한 역할 |
    | :--- | :--- |
    | `must` | **AND** 조건. 모든 조건이 일치해야 하는 경우에 사용 |
    | `must_not` | **NOT** 조건. 특정 조건이 일치하지 않아야 할 때 유용 |
    | `should` | **OR** 조건. 필수 조건은 아니지만, 맞으면 점수를 더 주는 방식 |
    | `filter` | `must`와 비슷하지만, 점수 계산을 건너뛰어 빠르다 |

    ```json
    // state가 "PA" 이면서, address에 "Avenue"가 포함되지 않은 사람을 검색하는 bool 쿼리를 작성해봤다.
    GET test/_search
    {
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "state": "PA"
              }
            }
          ],
          "must_not": [
            {
              "match": {
                "address": "Avenue"
              }
            }
          ]
        }
      }
    }
    ```

---

### 🔬 2. 텍스트 분석 (Text Analysis)

`text` 타입의 필드가 색인될 때, **분석기(Analyzer)** 를 통해 데이터가 가공되어 역인덱스에 저장되는 과정을 배웠다. 이 과정 덕분에 빠르고 유연한 검색이 가능하다

분석기는 **①캐릭터 필터 → ②토크나이저 → ③토큰 필터** 순서로 동작한다는 것을 배웠다.

![분석기 동작 과정](./img/Untitled%205.png)

#### **1. 캐릭터 필터 (Character Filter)**
- HTML 태그를 제거하는 등 텍스트를 정제하는 역할을 한다
    ```json
    // HTML 태그(<p>, <b>)를 제거하고 순수 텍스트만 추출하는 실습을 진행했다.
    POST _analyze
    {
      "char_filter": ["html_strip"],
      "text": "<p>I&apos;m so <b>happy</b>!</p>"
    }
    ```

#### **2. 토크나이저 (Tokenizer)**
- 정제된 텍스트를 **토큰(Token)** 이라는 작은 단위로 분리한다
    ```json
    // "Hello, World!"를 "Hello", "World" 두 개의 토큰으로 분리해보았다.
    POST _analyze
    {
      "tokenizer": "standard",
      "text": "Hello, World!"
    }
    ```

#### **3. 토큰 필터 (Token Filter)**
- 분리된 토큰을 소문자로 변환하거나 불용어를 제거하는 등 추가 가공할 수 있다
    ```json
    // 토큰을 소문자로 변환하고, 불용어를 제거하는 예시를 실습했다.
    POST _analyze
    {
      "tokenizer": "standard",
      "filter": [ "lowercase", "stop" ],
      "text": "This is a sample sentence."
    }
    ```

---

### 🇰🇷 3. 한글 형태소 분석 (nori 플러그인)

한글은 조사가 붙는 등 복잡한 특성 때문에 `nori`와 같은 형태소 분석기가 필수적이다

- **`nori_tokenizer`**: 문장을 의미있는 최소 단위인 **형태소**로 분리하는 토크나이져
    ```json
    // "안녕하세요. 날씨가 덥네요."를 형태소 단위로 분석
    GET _analyze
    {
      "tokenizer" : "nori_tokenizer",
      "text": "안녕하세요. 오늘 저녁 날씨가 덥다고 하네요. 아이 참. !!!!!",
      "explain" : true
    }
    ```
- **사용자 사전**: `config/userdic_ko.txt`에 단어를 추가하여 분석 정확도를 높일 수 있다.

---

### 🏷️ 4. 노멀라이저 (Normalizer)

`keyword` 타입 필드를 정규화해야 할 때 **노멀라이저**를 사용한다

```json
// "Håppy Wørld!!"를 대문자 "HAPPY WORLD!!"로 정규화하는 예시
PUT normalizer_test
{
  "settings": {
    "analysis": {
      "normalizer": {
        "my_normalizer": {
          "type": "custom",
          "filter": [ "asciifolding", "uppercase" ]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "myNormalizerKeyword": {
        "type": "keyword",
        "normalizer": "my_normalizer"
      }
    }
  }
}
```

---

### ✨ 오늘 배운 것 요약

- **Query DSL**: `match`, `bool` 등 다양한 쿼리를 조합하여 정교한 검색 조건을 만드는 방법을 익혔다.
- **텍스트 분석**: 분석기의 3단계(캐릭터 필터, 토크나이저, 토큰 필터) 동작 원리를 이해했다.
- **한글 분석**: `nori` 플러그인을 사용하여 한글 형태소를 분석하고, 사용자 사전을 활용하는 법을 배웠다.
- **노멀라이저**: `keyword` 필드에 적용하여 데이터를 일관성 있게 정규화하는 방법을 학습했다.
