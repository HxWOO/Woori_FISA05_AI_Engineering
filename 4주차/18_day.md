# 📅 4주차 - 18일차

## 🚀 SQL 고급 기능: 스토어드 프로시저, 트리거, 파티션

오늘은 데이터베이스의 자동화와 성능 최적화를 위한 고급 기능들을 학습했다. **스토어드 프로시저(Stored Procedure)** 와 **트리거(Trigger)** 를 이용해 반복적인 작업을 효율적으로 처리하고, **파티션(Partition)** 을 통해 대용량 테이블의 성능을 극대화하는 방법을 익혔다.

> ### 💡 왜 이 기능들이 필요할까?
> 애플리케이션이 복잡해지고 데이터가 많아질수록, 데이터베이스의 역할은 더욱 중요해진다. 스토어드 프로시저와 트리거는 DB 자체에 로직을 부여하여 **성능을 개선**하고 **개발을 분업화**하며, 파티션은 **대용량 데이터**를 효과적으로 관리하는 핵심 열쇠다.

---

### ⚙️ 1. 스토어드 프로시저 (Stored Procedure)

- **스토어드 프로시저**는 자주 사용하는 여러 SQL문을 하나로 묶어 함수처럼 만들어 놓은 것이다.
- `CALL` 명령어를 통해 간단히 호출할 수 있으며, 복잡한 로직을 서버 단에서 한 번에 처리할 수 있다.

| 장점 | 설명 |
| :--- | :--- |
| **성능 향상** | 여러 쿼리를 한 번의 네트워크 요청으로 처리하여 소요 시간을 줄인다. |
| **모듈화/재사용** | 공통 기능을 프로시저로 만들어두면 여러 곳에서 재사용하기 편하다. |
| **개발 분업** | DB 개발자는 프로시저를 만들고, 앱 개발자는 이를 호출하여 사용하는 방식으로 역할을 나눌 수 있다. |
| **보안 강화** | 사용자에게 테이블 접근 권한 대신 프로시저 실행 권한만 부여하여 데이터 접근을 제어할 수 있다. |

#### 📋 스토어드 프로시저 예시

- `DELIMITER`를 사용해 쿼리의 끝을 명시하고, `BEGIN`과 `END` 사이에 로직을 작성한다.

```sql
-- 특정 연도 이전에 입사한 직원 수를 계산하는 프로시저
DELIMITER //

CREATE PROCEDURE employees_hireyear(OUT employee_count INT)
BEGIN
  SELECT COUNT(*) INTO employee_count
  FROM fisa.emp
  WHERE YEAR(hiredate) < 1982;
END //

DELIMITER ;

-- 프로시저 호출 및 결과 확인
CALL employees_hireyear(@count);
SELECT @count;
```

---

### 🔫 2. 트리거 (Trigger)

- **트리거**는 특정 테이블에 `INSERT`, `UPDATE`, `DELETE` 같은 이벤트가 발생했을 때 **자동으로 실행**되는 특수한 종류의 프로시저다.
- 데이터 변경이 일어날 때 연관된 작업을 자동으로 처리하고 싶을 때 사용한다. (예: 데이터 변경 시 백업 테이블에 기록)

| 주요 속성 | 설명 |
| :--- | :--- |
| **이벤트** | `INSERT`, `UPDATE`, `DELETE` 중 어떤 작업에 반응할지 결정 |
| **시점** | `BEFORE` (이벤트 발생 전) 또는 `AFTER` (이벤트 발생 후) |
| **`OLD` vs `NEW`** | `UPDATE`나 `DELETE` 시, `OLD`는 변경 전 데이터를, `NEW`는 변경 후 데이터를 가리킨다. |

#### 📋 트리거 예시

- 주문 데이터가 삭제될 때, 해당 내용을 백업 테이블에 자동으로 저장하는 트리거

```sql
-- 주문이 삭제될 때 메시지를 설정하는 간단한 트리거
DELIMITER //

CREATE TRIGGER test_trg
    AFTER DELETE
    ON orders FOR EACH ROW
BEGIN
    SET @msg = '주문 정보가 삭제되었습니다.';
END //

DELIMITER ;

-- 주문 삭제 시 트리거가 자동으로 동작한다.
DELETE FROM market.orders WHERE order_id = 3;
SELECT @msg; -- '주문 정보가 삭제되었습니다.' 메시지가 출력됨
```

---

### 🗂️ 3. 파티션 (Partition)

- **파티션**은 거대한 테이블을 논리적으로 더 작고 관리하기 쉬운 조각(파티션)으로 나누는 기술이다.
- 물리적으로는 하나의 테이블이지만, 특정 조건(예: 날짜 범위)에 따라 데이터를 분산 저장하여 **쿼리 성능을 향상**시킨다.

| 파티션 유형 | 설명 |
| :--- | :--- |
| **`RANGE`** | 날짜나 숫자처럼 **연속적인 범위**를 기준으로 분할 (예: 연도별, 월별) |
| **`LIST`** | 특정 **값 목록**을 기준으로 분할 (예: 국가 코드, 부서 코드) |
| **`HASH` / `KEY`** | 해시 함수를 이용해 데이터를 **균등하게 분할** |

#### 📋 파티션 예시

- 입사 연도를 기준으로 사원 테이블(`emp`)을 파티셔닝하기

```sql
-- 입사 연도(hiredate)를 기준으로 RANGE 파티션 생성
CREATE TABLE emp_p (
    empno INT NOT NULL,
    ename VARCHAR(50),
    hiredate DATE,
    PRIMARY KEY (empno, hiredate)
)
PARTITION BY RANGE (YEAR(hiredate)) (
    PARTITION p0 VALUES LESS THAN (1982),
    PARTITION p1 VALUES LESS THAN (1984),
    PARTITION p2 VALUES LESS THAN (1986),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

-- 1982년 입사자 조회 시, p1 파티션만 스캔하여 성능 향상
EXPLAIN SELECT ename FROM emp_p WHERE YEAR(hiredate) = 1982;
```

> **파티션 프루닝(Partition Pruning)**: 쿼리 조건에 따라 불필요한 파티션을 제외하고 필요한 파티션만 스캔하는 최적화 기술. `WHERE` 절의 조건이 파티션 키와 잘 맞아야 효과적이다.

---

### ✨ 오늘 배운 것 요약

- **스토어드 프로시저**를 사용하면 복잡한 SQL 로직을 **캡슐화**하고 **성능을 최적화**할 수 있다.
- **트리거**는 데이터 변경 이벤트를 감지하여 관련된 작업을 **자동화**하는 강력한 도구다.
- **파티션**은 대용량 테이블을 논리적으로 분할하여 **관리 용이성**과 **쿼리 성능**을 크게 향상시킨다.
- 이 세 가지 고급 기능을 잘 활용하면, 더 안정적이고 확장 가능한 고성능 데이터베이스 시스템을 구축할 수 있다.
