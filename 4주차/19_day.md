# 📅 4주차 - 19일차

## 🚀 데이터베이스 연동 및 고급 SQL 활용

오늘은 데이터베이스 설계의 핵심인 **정규화(Normalization)** 를 복습하고, 이를 기반으로 **ERD(Entity-Relationship Diagram)** 를 설계하는 실습을 진행했다
또한, Python 환경에서 `pymysql` 라이브러리를 사용하여 MySQL 데이터베이스에 연결하고, `pandas` 및 `SQLAlchemy`와 연동하여 데이터를 처리하는 방법을 학습했다
마지막으로, **스토어드 프로시저, 함수, 트리거**와 같은 고급 SQL 기능을 심도 있게 다루었다

> ### 💡 왜 이 내용들이 중요할까?
> 잘 설계된 데이터베이스는 데이터의 무결성을 보장하고 중복을 최소화하여 시스템의 안정성과 효율성을 높입니다. 또한, Python과 같은 프로그래밍 언어와 DB를 연동하는 능력은 백엔드 개발의 필수 요소이며, 고급 SQL 기능은 복잡한 로직을 DB단에서 처리하여 성능을 최적화하고 개발을 효율적으로 만들어줍니다.

---

### 🗂️ 1. 데이터베이스 정규화와 ERD 설계

- **정규화(Normalization)** 는 데이터의 중복을 최소화하고 데이터 무결성을 보장하기 위해 테이블을 구조화하는 과정이다.
- 영화 데이터베이스 예제를 통해, 중복이 많은 테이블을 여러 개의 정규화된 테이블로 분리하고, **다대다(N:M)** 관계를 표현하기 위해 **연결 테이블(Junction Table)** 을 생성하는 실습을 진행했다.

#### 📋 ERD 설계 및 구현 예시

- 기존의 단일 테이블 구조를 `movies`, `productions`, `distributors`, `importers` 등의 테이블로 분리했습니다.
- `movie_production`, `movie_distributor`와 같은 연결 테이블을 사용하여 영화와 다른 엔티티 간의 관계를 설정했습니다.

```sql
-- 정규화된 영화 테이블 생성
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title TEXT,
    release_date DATE,
    audience BIGINT
);

-- 제작사 테이블
CREATE TABLE productions (
    production_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

-- 영화-제작사 연결 테이블 (N:M 관계)
CREATE TABLE movie_production (
    movie_id INT,
    production_id INT,
    PRIMARY KEY (movie_id, production_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (production_id) REFERENCES productions(production_id)
);
```

---

### 🐍 2. Python과 MySQL 연동 (`pymysql`, `pandas`, `SQLAlchemy`)

- Python에서 MySQL 데이터베이스를 제어하기 위한 다양한 방법을 학습했다

| 라이브러리 | 주요 역할 |
| :--- | :--- |
| **`pymysql`** | Python에서 MySQL에 직접 연결하고 SQL 쿼리를 실행하는 기본적인 DB-API 라이브러리 |
| **`pandas`** | `read_sql` 함수를 통해 SQL 조회 결과를 손쉽게 DataFrame으로 변환하고, `to_sql` 메서드로 DataFrame을 DB 테이블에 저장할 수 있음 |
| **`SQLAlchemy`** | Python의 대표적인 ORM(Object Relational Mapper)으로, `create_engine`을 통해 DB 연결을 관리하며 `pandas`와 함께 효율적인 데이터 처리를 지원 |

#### 📋 Python-MySQL 연동 코드 예시

- `pandas`와 `SQLAlchemy`를 이용해 엑셀 파일 데이터를 DB에 적재하는 과정

```python
import pandas as pd
from sqlalchemy import create_engine

# 1. 데이터베이스 엔진 생성
engine = create_engine("mysql+pymysql://user:password@host/db_name")

# 2. 엑셀 파일 읽어와 DataFrame 생성
movie_df = pd.read_excel('data/KOBIS_개봉일람.xlsx')

# 3. DataFrame을 DB 테이블에 저장
movie_df.to_sql(name='movies', con=engine, if_exists='append', index=False)
```

---

### ⚙️ 3. 고급 SQL 기능: 프로시저, 함수, 트리거

- 데이터베이스의 활용도를 높이는 고급 기능들

- **스토어드 프로시저 (Stored Procedure)**: 자주 사용하는 SQL 쿼리 묶음을 서버에 저장하고 `CALL`로 호출하여 사용함. 복잡한 로직을 서버 단에서 처리하여 성능을 개선하고 코드의 재사용성을 높인다.

- **사용자 정의 함수 (User-Defined Function)**: 특정 계산을 수행하고 단일 값을 반환하는 객체로, `SELECT` 문 등 쿼리 내에서 직접 호출하여 사용할 수 있다.

- **트리거 (Trigger)**: `INSERT`, `UPDATE`, `DELETE`와 같은 DML 이벤트가 발생했을 때 자동으로 실행되는 코드로, 데이터 무결성 유지나 감사 로그 기록에 유용

#### 📋 고급 SQL 예시 (트리거)

- 주문 데이터가 삭제될 때, 해당 내용을 백업 테이블에 자동으로 저장하는 트리거

```sql
DELIMITER //
CREATE TRIGGER backtable_update_trg
    AFTER DELETE ON orders FOR EACH ROW
BEGIN
    INSERT INTO backup_order (order_id, customer_id, product_id, order_date, cancel_date, quantity)
    VALUES (OLD.order_id, OLD.customer_id, OLD.product_id, OLD.order_date, NOW(), OLD.quantity);
END //
DELIMITER ;

-- orders 테이블에서 데이터 삭제 시 트리거가 자동으로 동작하여 backup_order에 기록됩니다.
DELETE FROM orders WHERE order_id = 2;
```

---

### ✨ 오늘 배운 것 요약

- **데이터베이스 정규화**는 데이터의 일관성과 무결성을 지키는 첫걸음이다.
- **Python (`pandas`, `SQLAlchemy`)** 을 활용하면 데이터베이스와 상호작용하며 데이터를 효율적으로 처리할 수 있다.
- **고급 SQL 기능(프로시저, 함수, 트리거)** 을 사용하면 데이터베이스 자체의 능력을 극대화하여 더 안정적이고 고도화된 애플리케이션을 구축할 수 있다.