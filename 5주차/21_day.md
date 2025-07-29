# 📅 5주차 - 21일차

## 🐳 Docker 심화: 데이터 관리와 나만의 이미지 만들기

어제 Docker의 기본을 맛보았다면, 오늘은 컨테이너의 데이터를 영구적으로 저장하는 **마운트(Mount)** 개념을 익히고, **Dockerfile**을 사용해 나만의 커스텀 이미지를 만드는 방법을 학습했다. 드디어 '나만의 환경'을 코드로 정의하고 배포할 수 있게 된 것이다!

> ### 💡 데이터는 컨테이너 밖에, 안전하게!
> 컨테이너는 언제든 사라질 수 있는 일회성 존재다. 하지만 그 안에서 생성된 중요한 데이터까지 함께 사라지게 둘 순 없다. **마운트**는 컨테이너의 데이터를 호스트 컴퓨터에 연결하여 **데이터의 영속성(Data Persistency)** 을 보장하는 핵심 기술이다. 이제 컨테이너를 마음껏 삭제하고 새로 만들어도 데이터는 안전하다.

---

### 📂 컨테이너에 데이터 공급하기: `cp` vs. `mount`

컨테이너와 호스트 간에 데이터를 주고받는 방법은 크게 두 가지가 있다. 각기 다른 상황에 유용하게 사용된다.

| 구분 | **파일 복사 (`docker cp`)** | **바인드 마운트 (`-v` 또는 `--mount`)** |
| :--- | :--- | :--- |
| **개념** | 호스트와 컨테이너 간의 **일회성 파일 전송** | 호스트의 디렉토리를 컨테이너에 **실시간으로 연결(동기화)** |
| **특징** | - 간단하고 직관적<br>- 원본과 사본이 별개로 존재 | - 호스트에서 수정하면 즉시 컨테이너에 반영<br>- 컨테이너가 삭제돼도 데이터는 호스트에 남음 |
| **용도** | 간단한 설정 파일 주입, 로그 파일 백업 등 | 소스 코드 개발, 데이터베이스 저장소 등 |

---

### 🛠️ 실습 1: `docker cp`로 파일 주고받기

`nginx` 컨테이너를 만들어 호스트와 파일을 복사하는 간단한 실습을 진행했다.

#### 1. 호스트 → 컨테이너로 복사

```bash
# 1. 테스트용 nginx 컨테이너 실행
$ docker run --name nginx-cp-test -d -p 8081:80 nginx

# 2. 호스트에 테스트 파일 생성
$ echo 'Hello from Host!' > host_file.txt

# 3. 파일을 컨테이너의 웹 루트 디렉토리로 복사
$ docker cp host_file.txt nginx-cp-test:/usr/share/nginx/html

# 4. 컨테이너 내부에서 파일 확인
$ docker exec nginx-cp-test cat /usr/share/nginx/html/host_file.txt
Hello from Host!
```

#### 2. 컨테이너 → 호스트로 복사

```bash
# 1. 컨테이너 내부에서 파일 생성
$ docker exec nginx-cp-test sh -c "echo 'Hello from Container!' > /container_file.txt"

# 2. 컨테이너의 파일을 호스트의 현재 경로로 복사
$ docker cp nginx-cp-test:/container_file.txt .

# 3. 호스트에서 파일 내용 확인
$ cat container_file.txt
Hello from Container!
```

---

### 🔗 실습 2: 바인드 마운트로 실시간 개발 환경 구축

이번에는 호스트의 `bindstorage` 디렉토리를 `nginx` 컨테이너의 웹 루트와 연결하여, 호스트에서의 코드 수정이 즉시 웹 서버에 반영되는 것을 확인했다.

```bash
# 1. 호스트에 마운트할 디렉토리 생성
$ mkdir bindstorage
$ cd bindstorage

# 2. index.html 파일 생성
$ echo '<h1>Real-time Sync!</h1>' > index.html

# 3. 바인드 마운트 옵션을 사용하여 컨테이너 실행
$ docker run --name nginx-mount-test -d -p 8082:80 -v $(pwd):/usr/share/nginx/html nginx
```

> 이제 호스트에서 `index.html` 파일을 수정하고 웹 브라우저(`http://localhost:8082`)를 새로고침하면, 컨테이너를 재시작할 필요 없이 변경사항이 바로 적용된다. 이건 진짜 편하다 :smile:

---

### 📜 실습 3: `Dockerfile`로 나만의 이미지 만들기

드디어 Docker의 꽃, **Dockerfile**을 작성해 나만의 이미지를 빌드해보았다. `Dockerfile`은 이미지 생성 과정을 코드로 명확히 정의하여, 누가 어디서 빌드하든 동일한 환경을 보장한다.

#### Dockerfile 기본 구조

| 명령어 | 설명 |
| :--- | :--- |
| **`FROM`** | 만들 이미지의 바탕이 될 베이스 이미지를 지정한다. |
| **`WORKDIR`** | 이후 명령어들이 실행될 컨테이너 안의 작업 디렉토리를 설정한다. |
| **`COPY`** | 호스트의 파일이나 디렉토리를 이미지 안으로 복사한다. |
| **`RUN`** | 이미지 빌드 과정에서 실행할 셸 명령어를 정의한다. (e.g., `pip install ...`) |
| **`EXPOSE`** | 컨테이너가 외부에 노출할 포트를 선언한다. |
| **`CMD`** | 컨테이너가 시작될 때 실행될 기본 명령어를 지정한다. |

#### Streamlit 앱 이미지 빌드 예시

이전에 만들었던 데이터 분석 Streamlit 앱을 Docker 이미지로 만드는 `Dockerfile`이다.

```dockerfile
# 1. 베이스 이미지: Python 3.12 환경으로 시작
FROM python:3.12

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 의존성 설치 (소스코드보다 먼저 COPY하여 캐시 효율 극대화)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. 소스코드 복사
COPY . .

# 5. 포트 노출
EXPOSE 8501

# 6. 앱 실행 명령어
CMD ["streamlit", "run", "app.py"]
```

> 위 `Dockerfile`과 `.dockerignore` 파일을 프로젝트 루트에 두고 `docker build -t my-streamlit-app .` 명령을 실행하면, 모든 의존성이 설치된 나만의 앱 이미지가 뚝딱 만들어진다. 이제 이 이미지 파일 하나만 있으면 어디서든 내 앱을 동일하게 실행할 수 있다!

---

### ✨ 오늘 배운 것 요약

- **`docker cp`** 와 **바인드 마운트**의 차이점을 이해하고, 각각의 용도에 맞게 데이터를 다루는 방법을 익혔다.
- 특히 **바인드 마운트**를 통해 호스트와 컨테이너 간의 **실시간 동기화** 개발 환경을 구축할 수 있음을 확인했다.
- **`Dockerfile`** 의 핵심 명령어(`FROM`, `COPY`, `RUN`, `CMD` 등)를 학습하고, 이를 통해 **재현 가능하고 이식성 높은 나만의 커스텀 이미지를 빌드**하는 방법을 실습했다.
- 이제 나는 내가 만든 애플리케이션을 **환경에 구애받지 않고 어디서든 동일하게 실행**할 수 있는 강력한 무기를 손에 넣었다:gun: