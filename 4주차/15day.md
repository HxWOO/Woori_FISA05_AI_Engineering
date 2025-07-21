# 📅 3주차 - 15일차

## 🗃️ SQL 마스터하기: 기본부터 고급 함수까지

오늘은 지난 시간에 이어 데이터베이스와 소통하는 언어, **SQL(Structured Query Language)** 에 대해 더 깊이 파고들었다.
 테이블을 만들고(DDL), 데이터를 넣고(DML), 원하는 정보를 조회하는(DQL) 다양한 방법을 실습했다

> ### 💡 SQL, 왜 중요할까?
> 데이터 분석은 결국 **데이터를 어떻게 가져오느냐**에 달려있다. SQL은 거대한 데이터 창고에서 원하는 재료를 정확하고 효율적으로 꺼내오는 가장 범용적인 도구이다

---

### 🏛️ SQL 명령어의 종류: DDL, DML, DQL

SQL 명령어는 크게 세 가지 역할로 나뉜다

| 종류 | 이름 | 역할 | 주요 명령어 |
| :--- | :--- | :--- | :--- |
| **DDL** | 데이터 **정의**어 | DB 객체(테이블 등)를 **생성, 수정, 삭제** | `CREATE`, `ALTER`, `DROP` |
| **DML** | 데이터 **조작**어 | 데이터를 **추가, 수정, 삭제** | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | 데이터 **질의**어 | 데이터를 **조회**하고 분석 | `SELECT` |

#### 📋 DDL 예시: 학생 정보 테이블 만들기

```sql
-- `mywork` 데이터베이스 사용
USE mywork;

-- 기존에 `students` 테이블이 있다면 삭제
DROP TABLE IF EXISTS students;

-- 새로운 `students` 테이블 생성
CREATE TABLE students (
    student_id VARCHAR(10) PRIMARY KEY, -- 기본 키 (중복 불가, NULL 불가)
    name VARCHAR(50) NOT NULL UNIQUE,  -- 이름 (NULL 불가, 중복 불가)
    grade TINYINT UNSIGNED NOT NULL CHECK (grade BETWEEN 1 AND 3), -- 학년 (1~3학년만)
    class_name VARCHAR(10) NOT NULL,   -- 반 이름
    gender ENUM('M', 'F') NOT NULL,     -- 성별 ('M' 또는 'F'만 가능)
    age TINYINT UNSIGNED DEFAULT 0,    -- 나이 (기본값 0)
    addmision_date DATE NOT NULL       -- 입학일
);
```

#### ➕ DML 예시: 학생 데이터 추가하기

```sql
-- 테이블에 새로운 학생 정보 추가
INSERT INTO students (student_id, name, grade, class_name, gender, addmision_date)
VALUES ('A100001', '신짱구', 3, '장미', 'M', '2025-07-21');
```

---

### 🔍 DQL(SELECT) 마스터하기: 원하는 데이터만 쏙쏙!

SQL 쿼리는 아래와 같은 순서로 실행

1.  **FROM**: 어떤 테이블에서 데이터를 가져올지 지정
2.  **WHERE**: 어떤 조건의 행을 필터링할지 지정
3.  **GROUP BY**: 특정 기준으로 데이터를 그룹화
4.  **HAVING**: 그룹화된 결과에 대한 조건을 지정
5.  **SELECT**: 어떤 열을 결과로 보여줄지 선택
6.  **ORDER BY**: 결과를 어떤 순서로 정렬할지 지정
7.  **LIMIT**: 결과의 개수를 제한

#### 🎯 조건부 조회 (WHERE)

```sql
-- 2000년 이후에 개봉한 SF 영화 조회
SELECT *
FROM movies
WHERE YEAR(release_date) >= 2000 AND genre = 'SF';

-- '범죄' 또는 '전쟁' 장르의 영화 조회
SELECT *
FROM movies
WHERE genre IN ('범죄', '전쟁');
```

#### 🔠 문자열 검색 (LIKE)

- `_`: 한 글자를 의미
- `%`: 0개 이상의 글자를 의미

```sql
-- '신'으로 시작하는 이름의 학생 조회
SELECT * FROM students WHERE name LIKE '신%';

-- '짱'이라는 단어가 포함된 이름의 학생 조회
SELECT * FROM students WHERE name LIKE '%짱%';
```

#### 📈 그룹화 및 집계 (GROUP BY, HAVING)

```sql
-- 장르별 평균 관객 수가 200만 명 이상인 장르만 조회
SELECT genre, AVG(audience)
FROM movies
GROUP BY genre
HAVING AVG(audience) >= 2000000;
```

---

### 🛠️ SQL을 더 강력하게 만드는 주요 함수들

#### 📝 문자열 함수

| 함수 | 설명 | 예시 |
| :--- | :--- | :--- |
| `CONCAT()` | 여러 문자열을 하나로 합침 | `CONCAT(title, '(', YEAR(release_date), ')')` |
| `LENGTH()` | 문자열의 바이트 길이를 반환 | `LENGTH('SQL')` → 3 |
| `CHAR_LENGTH()` | 문자열의 글자 수를 반환 | `CHAR_LENGTH('한글')` → 2 |
| `REPLACE()` | 특정 문자열을 다른 문자열로 변경 | `REPLACE('안녕하세요', '안녕', 'Hi')` |
| `SUBSTR()` | 문자열의 일부를 잘라냄 | `SUBSTR('ABCDEFG', 3, 2)` → 'CD' |

#### 📅 날짜 및 시간 함수

| 함수 | 설명 |
| :--- | :--- |
| `NOW()`, `CURDATE()` | 현재 날짜와 시간 또는 날짜를 반환 |
| `YEAR()`, `MONTH()`, `DAY()` | 날짜에서 연, 월, 일을 추출 |
| `DATE_FORMAT()` | 날짜를 원하는 형식의 문자열로 변환 |
| `STR_TO_DATE()` | 문자열을 날짜 형식으로 변환 |

#### 🔄 형 변환 및 흐름 제어 함수

- **`CAST(값 AS 타입)`**: 데이터를 다른 타입으로 변환
- **`IF(조건, 참일때, 거짓일때)`**: 간단한 조건에 따라 다른 값을 반환
- **`CASE ... WHEN ... THEN ... END`**: 복잡한 다중 조건에 따라 다른 값을 반환

```sql
-- 나이에 따라 세대를 구분하는 예시
SELECT name, age,
    CASE
        WHEN age BETWEEN 10 AND 19 THEN '10대'
        WHEN age BETWEEN 20 AND 29 THEN '20대'
        ELSE '기타'
    END AS age_group
FROM students;
```

---

### ✨ 오늘 배운 것 요약

- **DDL, DML, DQL**의 역할을 이해하고, `CREATE`, `INSERT`, `SELECT`를 자유롭게 사용할 수 있다
- `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`를 조합하여 **원하는 데이터를 정확하게 조회**하는 방법을 익혔다
- **문자열, 날짜, 형 변환, 흐름 제어 함수**를 활용하여 데이터를 가공하고 분석하는 능력을 길렀다
- SQL은 단순히 데이터를 꺼내는 것을 넘어, **데이터를 분석에 적합한 형태로 가공**하는 강력한 도구임을 깨달았다
