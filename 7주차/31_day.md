# 📜 ELK - Logstash & Filebeat 학습일지

## 🪵 Logstash

---

### ⚙️ 1. Logstash란?

- **정의**: 다양한 소스에서 로그 또는 이벤트 데이터를 수집, 처리 및 변환하여 다른 시스템으로 전송하는 오픈 소스 **데이터 처리 파이프라인** 도구입니다.
- **주요 기능**:
  - **데이터 수집**: 파일, 데이터베이스, 메시지 큐 등 다양한 소스에서 데이터 수집
  - **데이터 처리**: 필터 플러그인을 사용하여 데이터 파싱, 변환, 보강
  - **데이터 전송**: Elasticsearch, Kafka, S3 등 다양한 대상으로 데이터 전송

---

### 🧩 2. 주요 개념

Logstash의 파이프라인은 데이터 처리 과정을 정의하며, `input`, `filter`, `output` 세 단계로 구성됩니다.

#### 2.1. Input (입력)
- 데이터가 어디에서 오는지를 정의합니다.
- 예: `beats`, `file`, `jdbc`, `kafka`

#### 2.2. Filter (필터)
- 데이터를 가공하고 변환하는 중간 처리 단계입니다.
- 예:
  - `grok`: 정규표현식을 통해 비정형 데이터를 구조화합니다.
  - `mutate`: 필드 수정, 이름 변경, 타입 변환 등을 수행합니다.
  - `json`: JSON 형식의 텍스트를 파싱합니다.

#### 2.3. Output (출력)
- 처리된 데이터의 최종 목적지를 정의합니다.
- 예: `elasticsearch`, `stdout` (콘솔 출력), `file`

---

### 📝 3. 구성 예시

```conf
# sample.conf

input {
  beats {
    port => 5044
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  mutate {
    convert => { "response" => "integer" }
    convert => { "bytes" => "integer" }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "weblogs-%{+YYYY.MM.dd}"
  }
  stdout { codec => rubydebug }
}
```

---

## 📄 Filebeat

---

### ⚙️ 1. Filebeat란?

- **정의**: 서버에 에이전트로 설치되어 로그 파일을 수집하고, 이를 Logstash나 Elasticsearch로 전송하는 **경량 로그 수집기**입니다.
- **주요 특징**:
  - **경량성**: 시스템 리소스를 적게 소모하여 서버 부담을 최소화합니다.
  - **안정성**: 네트워크 문제 발생 시 데이터 전송을 보장하는 기능(At-Least-Once)을 제공합니다.
  - **모듈**: Apache, Nginx, MySQL 등 일반적인 로그 형식을 쉽게 수집하고 파싱할 수 있는 사전 구성된 모듈을 제공합니다.

---

### 📝 2. 구성 예시

```yaml
# filebeat.yml

filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
    - /var/log/apache2/access.log

# Logstash로 데이터 전송
output.logstash:
  hosts: ["localhost:5044"]

# 또는 Elasticsearch로 직접 전송
# output.elasticsearch:
#   hosts: ["localhost:9200"]
```

---

### 🔬 4. 실습: 2개 서버 로그 통합하기

두 개의 다른 서버에서 생성되는 로그를 각각의 파이프라인을 통해 수집하고 처리하는 실습입니다.

#### 🏦 Server 1: 입금/출금 서버 (FastAPI)

- **역할**: 입금(deposit) 및 출금(withdraw) API 요청을 처리하고 로그를 생성합니다.
- **구현**: Python의 FastAPI 프레임워크를 사용합니다.

##### 1. FastAPI 서버 코드 (`fastapi_server.py`)

```python
# server1 폴더에 저장 후 실행
# pip install fastapi uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/deposit/{amount}")
async def deposit(amount: int):
    return f"{amount}원 입금"

@app.get("/withdraw/{amount}")
async def withdraw(amount: int):
    return f"{amount}원 출금"
```

##### 2. 서버 실행 및 로그 생성

- 아래 명령어로 서버를 실행하면 `server1.log` 파일에 로그가 기록됩니다.

```powershell
$ uvicorn fastapi_server:app --log-level info > "server1.log"
```

##### 3. Logstash 파이프라인 (`logstash-pipeline-server1.conf`)

- `Filebeat`로부터 `5045` 포트로 로그를 받아 `grok` 필터로 파싱한 후, `server1-` 인덱스에 저장합니다.

```conf
input {
  beats {
    port => 5045
  }
}

filter {
  grok {
    match => {
      "message" => "%{LOGLEVEL:log_level}:\s+%{IP:client_ip}:%{NUMBER:client_port} - \"%{WORD:http_method} %{URIPATH:request_path} HTTP/%{NUMBER:http_version}\" %{NUMBER:response_code} %{WORD:status_message}"
    }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "server1-%{+YYYY.MM.dd}"
  }
}
```

---

#### 💻 Server 2: 로그인/로그아웃 서버 (Flask)

- **역할**: 로그인(hello) 및 로그아웃(bye) API 요청을 처리하고 로그를 생성합니다.
- **구현**: Python의 Flask 프레임워크를 사용합니다.

##### 1. Flask 서버 코드 (`flask_server.py`)

```python
# server2 폴더에 저장 후 실행
# pip install flask
from flask import Flask

app = Flask(__name__)

@app.route('/hello')
def hello():
    return 'hello world!'

@app.route('/bye')
def bye():
    return 'bye world!'

if __name__ == '__main__':
    app.run(debug=True)
```

##### 2. 서버 실행 및 로그 생성

- 아래 명령어로 서버를 실행하면 `server2.log` 파일에 로그가 기록됩니다.

```powershell
$ python flask_server.py 2> "server2.log"
```

##### 3. Logstash 파이프라인 (`logstash-pipeline-server2.conf`)

- `Filebeat`로부터 `5044` 포트로 로그를 받아 `grok` 필터로 파싱한 후, `server2-` 인덱스에 저장합니다.

```conf
input {
  beats {
    port => 5044
  }
}

filter {
  grok {
    match => {
      "message" => "%{LOGLEVEL:log_level}:\s+%{IP:client_ip}:%{NUMBER:client_port} - \"%{WORD:http_method} %{URIPATH:request_path} HTTP/%{NUMBER:http_version}\" %{NUMBER:response_code} %{GREEDYDATA:status_message}"
    }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "server2-%{+YYYY.MM.dd}"
  }
}
```

---

#### 🛠️ 다중 파이프라인 관리

Logstash가 여러 파이프라인을 동시에 실행하도록 `pipelines.yml` 파일을 설정합니다.

- **`pipelines.yml` 설정**: 각 파이프라인의 ID, Worker 수, 배치 크기 및 설정 파일 경로를 지정합니다.

```yaml
# pipelines.yaml

- pipeline.id: server1
  pipeline.workers: 1
  pipeline.batch.size: 1
  path.config: C:\devs\ITStudy\05_elk\logstash\config\logstash-pipeline-server1.conf

- pipeline.id: server2
  pipeline.workers: 1
  pipeline.batch.size: 1
  path.config: C:\devs\ITStudy\05_elk\logstash\config\logstash-pipeline-server2.conf
```

> 💡 **핵심**: 이 구성을 통해 각기 다른 종류의 로그를 별도의 파이프라인에서 독립적으로 처리할 수 있어, 관리 효율성과 확장성을 크게 향상할 수 있습니다.

---

### ✨ 요약: Logstash와 Filebeat 연동

1.  **Filebeat (수집)**: 각 서버에서 `Filebeat`가 로그 파일(`access.log`, `error.log` 등)을 실시간으로 감시하고 수집합니다.
2.  **전송**: `Filebeat`는 수집된 로그를 경량 프로토콜을 통해 `Logstash`로 안전하게 전송합니다.
3.  **Logstash (처리)**: `Logstash`는 `beats` 입력 플러그인을 통해 여러 `Filebeat`로부터 로그를 수신합니다.
4.  **정제 및 보강**: `filter` 플러그인을 사용하여 수신된 로그를 정제하고, 필요한 정보를 추가하여 구조화합니다.
5.  **저장 및 분석**: 최종적으로 처리된 데이터를 `Elasticsearch`에 인덱싱하여 저장하고, 사용자는 `Kibana`를 통해 이를 시각화하고 분석합니다.

> 이 구조를 통해 **중앙 집중식 로그 관리 시스템**을 효율적으로 구축하고, 데이터 파이프라인의 부하를 분산시킬 수 있습니다.
