# OpenAPI 데이터를 활용한 ELK 스택 구축 프로젝트

## 📖 프로젝트 개요

이 프로젝트는 공공데이터포털의 '아파트 매매 실거래가' API를 사용하여 데이터를 수집하고, Elasticsearch에 적재한 뒤 Kibana를 통해 데이터를 분석하고 시각화하는 데이터 파이프라인을 구축하는 것을 목표로 합니다.

## 📂 프로젝트 구조

```
C:\...\ch_11\elk_pipeline\
├── .gitignore
├── docker-compose.yml  # Elasticsearch & Kibana 실행 환경
├── requirements.txt    # Python 라이브러리 목록
├── README.md           # 프로젝트 안내서
└── src\                # Python 소스 코드
    ├── __init__.py
    ├── config.py       # API 키 등 설정
    ├── fetch_data.py   # 데이터 수집
    ├── load_to_es.py   # 데이터 적재
    └── main.py         # 메인 실행 스크립트
```

## 🚀 실행 방법

### 1. API 키 설정

- `src/config.py` 파일을 열어 자신의 공공데이터포털 API 키를 `API_KEY` 변수에 입력합니다.

```python
# src/config.py
API_KEY = "여기에_발급받은_API_키를_입력하세요"
```

### 2. Docker 컨테이너 실행

- 터미널에서 현재 프로젝트 폴더(`elk_pipeline`)로 이동한 후, 아래 명령어를 실행하여 Elasticsearch와 Kibana를 시작합니다.

```bash
# Elasticsearch와 Kibana를 백그라운드에서 실행
docker-compose up -d

# 실행 중인 컨테이너 확인 (elasticsearch, kibana가 보여야 함)
docker ps
```

### 3. Python 환경 설정 및 실행

- 터미널에서 아래 명령어들을 순서대로 실행합니다.

```bash
# 1. 가상환경 생성 (최초 1회)
python -m venv venv

# 2. 가상환경 활성화
.\venv\Scripts\activate

# 3. 필요 라이브러리 설치
pip install -r requirements.txt

# 4. 메인 파이프라인 실행
python -m src.main
```

## ✅ 향후 과제 (TODO)

현재 코드는 API를 통해 XML 데이터를 가져오는 단계까지만 구현되어 있습니다. 다음 단계를 완성해야 합니다.

1.  **XML 데이터 파싱**: `fetch_data.py`가 반환한 XML 문자열을 파싱하여 개별 거래 데이터를 추출해야 합니다.
2.  **JSON 변환**: 추출한 데이터를 Elasticsearch에 적재할 수 있는 JSON 형식으로 변환하는 로직이 필요합니다. 이 로직은 `src/load_to_es.py` 파일의 `xml_to_json_generator` 같은 함수로 구현하는 것을 추천합니다.
3.  **파이프라인 연결**: `src/main.py` 파일의 주석 처리된 부분을 해제하고, 위에서 구현한 파싱 및 변환 로직을 연결하여 전체 데이터 파이프라인을 완성합니다.

## 🌐 서비스 접속 정보

- **Kibana**: [http://localhost:5601](http://localhost:5601)
- **Elasticsearch**: [http://localhost:9200](http://localhost:9200)

```