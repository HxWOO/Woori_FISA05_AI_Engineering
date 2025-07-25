/* 9. Partition

MySQL에서 테이블 파티션은 큰 테이블을 더 작은, 더 관리하기 쉬운 부분으로 나누는 방법입니다. 
이를 통해 쿼리 성능을 향상시키고 데이터 관리를 용이하게 할 수 있습니다. 파티션은 물리적으로는 하나의 테이블이지만, 논리적으로는 여러 개의 작은 테이블처럼 동작합니다.

주요 파티션 유형

- RANGE 파티션
    특정 범위의 값을 기준으로 데이터를 분할합니다.
    예: 날짜 범위, 숫자 범위 등.

- LIST 파티션
    특정 값 목록을 기준으로 데이터를 분할합니다.
    예: 특정 지역 코드, 상태 코드 등.

- HASH 파티션
    해시 함수를 사용하여 데이터를 균등하게 분할합니다.
    예: 특정 열의 해시 값을 기준으로 분할.

- KEY 파티션
    MySQL의 내부 해시 함수를 사용하여 데이터를 분할합니다.
    HASH 파티션과 유사하지만, MySQL이 해시 함수를 자동으로 선택합니다.


파티션의 장점
- 성능 향상: 특정 파티션만 스캔하여 쿼리 성능을 향상시킬 수 있습니다.
- 관리 용이성: 데이터 삭제, 백업, 복구 작업이 더 쉬워집니다.
- 병렬 처리: 여러 파티션에서 동시에 작업을 수행할 수 있습니다.

파티션의 단점
- 테이블 설계와 관리가 더 복잡해질 수 있습니다.
  파티션 키를 신중하게 선택해야 하며, 잘못된 선택은 성능 저하를 초래할 수 있습니다. 
- 외래 키 제약 조건을 사용할 수 없습니다. 
- 파티션된 테이블의 유지 관리가 더 복잡할 수 있습니다.
- 파티션된 테이블은 인덱스와 메타데이터를 각 파티션마다 유지해야 하므로 디스크 공간 사용이 증가할 수 있습니다.
*/ 

use fisa;
CREATE TABLE emp_p (
    empno INT NOT NULL AUTO_INCREMENT,
    ename VARCHAR(50),
    hiredate DATE,
    PRIMARY KEY (empno, hiredate)
)
PARTITION BY RANGE (YEAR(hiredate)) (
    PARTITION p0 VALUES LESS THAN (1980),
    PARTITION p1 VALUES LESS THAN (1982),
    PARTITION p2 VALUES LESS THAN (1984),
    PARTITION p3 VALUES LESS THAN (1986),
    PARTITION p4 VALUES LESS THAN (1988),
    PARTITION p5 VALUES LESS THAN MAXVALUE
) 
SELECT empno, ename, hiredate FROM emp;

SHOW CREATE TABLE emp_p;

SELECT 
    PARTITION_NAME, 
    PARTITION_ORDINAL_POSITION, 
    PARTITION_METHOD, 
    PARTITION_EXPRESSION, 
    PARTITION_DESCRIPTION 
FROM 
    INFORMATION_SCHEMA.PARTITIONS 
WHERE 
    TABLE_NAME = 'emp_p' 
    AND TABLE_SCHEMA = 'fisa';


EXPLAIN SELECT * FROM emp;
EXPLAIN SELECT ename FROM emp WHERE year(hiredate) = 1982;
EXPLAIN SELECT * FROM emp_p;
EXPLAIN SELECT ename FROM emp_p WHERE year(hiredate) = 1982;-- '1982-01-10 00:00:00'

-- 실습2
USE box_office;

CREATE TABLE movies_p AS
SELECT * FROM box_office.movies;

ALTER TABLE movies_p
    PARTITION BY RANGE(year(release_date)) (
        PARTITION p0 VALUES LESS THAN (2004),
        PARTITION p1 VALUES LESS THAN (2005),
        PARTITION p2 VALUES LESS THAN (2006),
        PARTITION p3 VALUES LESS THAN (2007),
        PARTITION p4 VALUES LESS THAN (2008),
        PARTITION p5 VALUES LESS THAN (2009),
        PARTITION p6 VALUES LESS THAN (2010),
        PARTITION p7 VALUES LESS THAN (2011),
        PARTITION p8 VALUES LESS THAN (2012),
        PARTITION p9 VALUES LESS THAN (2013),
        PARTITION p10 VALUES LESS THAN (2014),
        PARTITION p11 VALUES LESS THAN (2015),
        PARTITION p12 VALUES LESS THAN (2016),
        PARTITION p13 VALUES LESS THAN (2017),
        PARTITION p14 VALUES LESS THAN (2018),
        PARTITION p15 VALUES LESS THAN (2019),
        PARTITION p16 VALUES LESS THAN (MAXVALUE)  -- Catch-all partition
    );

-- 파티션 확인    
SELECT 
  TABLE_NAME,
  PARTITION_NAME,
  PARTITION_METHOD,
  PARTITION_DESCRIPTION,
  TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'box_office'
  AND TABLE_NAME = 'movies_p';    

-- 비효율적 쿼리 → 모두 조회해서 파티션 사용 안함
EXPLAIN SELECT title FROM movies_p WHERE year(release_date) BETWEEN 2014 AND 2017;

--  컬럼 그대로 비교 → 프루닝 성공
EXPLAIN SELECT title FROM movies_p WHERE release_date >= '2014-01-01' AND release_date < '2018-01-01'

