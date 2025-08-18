# 📜 Elasticsearch 인덱스 운영과 Python 연동

## 🔍 오늘의 학습 주제

오늘은 Elasticsearch의 핵심 기능인 **인덱스(Index)를 효율적으로 운영하는 전략**과 **Python을 사용해 Elasticsearch에 접근하고 데이터를 다루는 방법**에 대해 학습했습니다. 대규모 데이터를 안정적으로 관리하기 위한 필수적인 내용들을 익혔습니다.

> ### 💡 인덱스 운영 및 자동화, 왜 중요할까?
> 데이터가 끊임없이 쌓이는 환경에서 수동으로 인덱스를 관리하는 것은 비효율적이고 실수를 유발하기 쉽습니다. **인덱스 템플릿, ILM(인덱스 생명 주기 관리), 데이터 스트림**과 같은 기능을 활용하면 운영을 자동화하고, 데이터의 상태(Hot, Warm, Cold)에 따라 저장 비용을 최적화할 수 있습니다. 또한, Python 연동을 통해 데이터 처리 파이프라인을 구축하고 애플리케이션과 쉽게 통합할 수 있습니다.

---

### 📚 1. 인덱스 운영 전략

유사한 구조의 인덱스를 효율적으로 관리하고, 데이터 검색의 유연성을 높이기 위한 다양한 전략을 학습했습니다.

#### 1.1. 인덱스 템플릿 (Index Template)

- **개념**: 특정 패턴의 이름을 가진 인덱스가 생성될 때, 미리 정의된 설정(샤드 수, 레플리카, 매핑 등)을 자동으로 적용하는 기능입니다.
- **사용법**: `_index_template` API를 사용하여 패턴과 적용할 설정을 정의합니다.

```json
PUT _index_template/my_template
{
  "index_patterns": ["pattern_test_index-*"],
  "priority": 1,
  "template": {
    "settings": {
      "number_of_shards": 2,
      "number_of_replicas": 2
    },
    "mappings": {
      "properties": {
        "myTextField": {
          "type": "text"
        }
      }
    }
  }
}
```

#### 1.2. 컴포넌트 템플릿 (Component Template)

- **개념**: 여러 인덱스 템플릿에서 중복되는 설정(매핑, 세팅 등)을 별도의 '컴포넌트'로 분리하여 재사용하는 기능입니다.
- **장점**: 중복을 제거하여 템플릿 관리가 훨씬 간결해집니다.

```json
# 1. 재사용할 매핑과 설정을 컴포넌트로 정의
PUT _component_template/timestamp_mappings
{
  "template": { "mappings": { "properties": { "timestamp": { "type": "date" }}}}
}

PUT _component_template/my_shard_settings
{
  "template": { "settings": { "number_of_shards": 2, "number_of_replicas": 2 }}
}

# 2. 인덱스 템플릿에서 `composed_of`로 컴포넌트들을 조합
PUT _index_template/my_template2
{
  "index_patterns": ["timestamp_index-*"],
  "composed_of": ["timestamp_mappings", "my_shard_settings"]
}
```

#### 1.3. 인덱스 별칭 (Alias)

- **개념**: 하나 이상의 인덱스에 대한 가상의 이름(포인터)입니다. SQL의 `VIEW`와 유사한 역할을 합니다.
- **주요 활용법**:
  - **인덱스 그룹화**: 여러 인덱스를 하나의 별칭으로 묶어 동시에 검색할 수 있습니다.
  - **인덱스 추상화**: 실제 인덱스 이름이 변경되어도, 애플리케이션은 별칭을 바라보므로 코드 수정이 필요 없습니다.
  - **필터링**: 특정 조건에 맞는 데이터만 보이도록 필터가 적용된 별칭을 만들 수 있습니다.

```json
POST _aliases
{
  "actions": [
    { "add": { "index": "banksalad-user01", "alias": "logs_all" } },
    { "add": { "index": "banksalad-user02", "alias": "logs_all" } }
  ]
}
```

---

### 🔄 2. ILM (인덱스 생명 주기 관리)

시간이 지남에 따라 데이터의 가치와 사용 빈도가 달라지는 시계열(Time-series) 데이터를 효과적으로 관리하기 위한 정책입니다.

| 데이터 상태 | 특징 | 설명 |
| :--- | :--- | :--- |
| **Hot** | Fastest Hardware | 데이터가 활발하게 색인되고 검색되는 단계 |
| **Warm** | Fast Hardware | 데이터 업데이트는 없지만, 여전히 검색이 발생하는 단계 |
| **Cold** | Average Hardware | 검색 빈도가 낮아지고, 하드웨어 비용을 절감하는 단계 |
| **Frozen** | Slow Hardware | 거의 검색되지 않지만, 보관은 필요한 데이터를 저장하는 단계 |
| **Delete** | - | 설정된 기간이 지나면 데이터를 완전히 삭제하는 단계 |

- **데이터 스트림(Data Stream)**: ILM과 함께 사용되며, 시계열 데이터의 색인과 관리를 단순화하는 기능입니다. 쓰기 작업은 항상 최신 인덱스로 자동 라우팅됩니다.

---

### 🐍 3. Python으로 Elasticsearch 다루기

Python 라이브러리를 사용하여 Elasticsearch 클러스터와 상호작용하는 방법을 학습했습니다.

#### 3.1. `eland` 라이브러리

- **특징**: Elasticsearch 인덱스를 **Pandas DataFrame처럼** 다룰 수 있게 해주는 라이브러리입니다. 대규모 데이터 분석에 유용합니다.

```python
import eland as ed

# ES 인덱스를 DataFrame으로 로드
df = ed.DataFrame(es_client="http://localhost:9200",
    es_index_pattern="kibana_sample_data_flights")

print(df.head())
```

#### 3.2. `elasticsearch-dsl` 라이브러리

- **특징**: Python 객체를 다루듯 직관적으로 Elasticsearch 쿼리를 작성하고 실행할 수 있습니다.

```python
from elasticsearch import Elasticsearch
from elasticsearch_dsl import Search

client = Elasticsearch('http://localhost:9200')

def search_index(index_name, field_name, match_name):
    s = Search(index=index_name).using(client).query("multi_match", fields=field_name, query=match_name)
    response = s.execute()
    return response
```

#### 3.3. `helpers.bulk` API

- **특징**: 대량의 문서를 Elasticsearch에 빠르고 효율적으로 색인(insert)할 때 사용합니다.

```python
from elasticsearch import Elasticsearch, helpers
import pandas as pd

# ... (데이터를 DataFrame으로 준비) ...
df = get_stock_info()
json_records = df.to_dict(orient='records')

es = Elasticsearch("http://localhost:9200")
action_list = []
for row in json_records:
    record = {
        '_op_type': 'index',
        '_index': 'stock_info',
        '_source': row
    }
    action_list.append(record)

# Bulk API를 사용하여 대량 색인
helpers.bulk(es, action_list)
```

---

### ✨ 오늘 배운 것 요약

- **인덱스 템플릿**: 정해진 패턴의 인덱스에 설정을 자동 적용하여 일관성을 유지한다.
- **컴포넌트 템플릿**: 중복되는 설정을 분리하고 재사용하여 관리를 용이하게 한다.
- **Alias(별칭)**: 인덱스를 추상화하고 여러 인덱스를 묶거나 필터링하여 검색 유연성을 높인다.
- **ILM & 데이터 스트림**: 데이터의 생명 주기를 관리하여 저장 비용을 최적화하고 시계열 데이터 관리를 자동화한다.
- **Python 연동**: `eland`, `elasticsearch-dsl`, `helpers.bulk` 등을 사용하여 Python 환경에서 데이터를 분석하고 처리할 수 있다.

---