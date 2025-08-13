# 베이스 이미지로 공식 Python 3.9 slim 버전을 사용합니다.
FROM python:3.9-slim

# 컨테이너 내 작업 디렉토리를 설정합니다.
WORKDIR /app

# requirements.txt를 먼저 복사하고 라이브러리를 설치합니다.
# (코드 변경 시 라이브러리를 다시 설치하지 않도록 레이어를 분리합니다.)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# src 디렉토리의 모든 코드를 컨테이너의 /app/src 디렉토리로 복사합니다.
COPY ./src /app/src

# 컨테이너가 시작될 때 실행할 기본 명령어를 설정합니다.
CMD ["python", "-m", "src.main"]
