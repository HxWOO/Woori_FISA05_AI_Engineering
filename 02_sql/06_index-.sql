-- 6.index.sql

/*
1. db의 빠른 검색을 위한 색인 기능의 index 학습
    - primary key에는 기본적으로 자동 index로 설정됨 
	# PK로 만들어진 클러스터형 인덱스가 메인 인덱스가 됨
    - B-TREE 알고리즘 사용 
    - DB 자체적으로 빠른 검색 기능 부여
        이 빠른 검색 기능 - index
	- 사용자가 자주 사용하는 컬럼에 대해 보조 index 설정 가능  - 보조 인덱스는 UNIQUE, NOT NULL 함 
    - BUT, 어설프게 사용자 정의 index 설정시 오히려 검색 속도 다운
    - 데이터 셋의 15% 이상의 데이터들이 잦은 변경이 이뤄질 경우 index 설정 비추

2. 주의사항
    - index가 반영된 컬럼 데이터가 수시로 변경되는 데이터라면 index 적용은 오히려 부작용
    - 잘못하면 오히려 인덱스 관리를 위한 저장 공간이 더 필요해짐
    - WHERE 절에 많이 사용되는 열, 자주 사용하는 컬럼에 사용하는게 좋음, 중복된 데이터가 적은 컬럼에 사용 
    
3. 문법
    CREATE INDEX index_name
    ON table_name (column1, column2, ...);
*/

use fisa;
create database test;
use test;
-- 1. index용 검색 속도 확일을 위한 table 생성 
drop table if exists emp01;

-- 존재하는 table로 부터 복제시에는 제약조건은 미적용
create table emp01 as select * from fisa.emp;
desc emp01;

select * from emp01;
-- empno로 검색시에 빠른 검색이 가능하게 색인 기능 적용
# empno의 MUL: 비고유 인덱스의 일부임을 나타냅니다. 비고유 인덱스는 중복된 값을 허용하며, 검색 성능을 향상시키기 위해 사용
#  검색, 정렬, 범위 검색, 조인 등의 성능을 향상
create index idx_emp01_empno on emp01(empno);  -- 기능명_테이블명_컬럼명
desc emp01;
SELECT * FROM emp01;
SELECT * FROM fisa.emp;
-- drop index
alter table emp01 drop index idx_emp01_empno;

-- 코드 참고: <이것이 MYSQL이다>, 한빛출판사, 9장
DROP DATABASE IF EXISTS sqldb;
CREATE DATABASE sqldb;

USE sqldb;
CREATE TABLE usertbl 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  name    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr    CHAR(2) NOT NULL,
  mobile1   CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height    SMALLINT NULL, 
  mDate    DATE NULL 
);

-- <실습 1> --

USE sqldb;
CREATE TABLE  tbl1
    (   a INT PRIMARY KEY,
        b INT,
        c INT
    );

SHOW INDEX FROM tbl1;
/* 
1. Table  테이블명 표기
2. Non_unique  인덱스가 중복된 값이 가능하면 1 중복값이 허용되지 않는 UNIQUE INDEX이면 0을 표시함
3. Key_name  인덱스의 이름을 표시하며 인덱스가 해당 테이블의 기본키라면 PRIMARY로 표시함.
4. Seq_in_index  멀티컬럼이 인덱스인 경우 해당 필드의 순서를 표시함.
5. Column_name  해당 필드의 이름을 표시함.
6. Collation  인덱스에서 해당 필드가 정렬되는 방법을 표시함.
7. Cardinality  인덱스에 저장된 유일한 값들의 수를 표시함.
                (해당 컬럼의 중복된 수치. 중복도가 낮으면 카디널리티가 높다고 표현하고, 중복도가 높으면 카디널리티가 낮다고 표현)
8. Sub_part  인덱스 접두어.
9. Packed  키가 압축되는packed 방법.
10. Null  해당 필드가 NULL을 저장할 수 있으면 YES, 아니면 NO.
11. Index_type  인덱스가 어떤 형태로 구성되어 있는지 나타내며 MySQL은 대부분 B-tree 자료구조를 사용.
12. Comment  해당 필드를 설명하는 것이 아닌 인덱스에 관한 기타 정보.
13. Index_comment  인덱스에 관한 모든 기타 정보를 표시함.
*/

CREATE TABLE  tbl2
    (   a INT PRIMARY KEY, 
        b INT UNIQUE,
        c INT UNIQUE,
        d INT
    );
SHOW INDEX FROM tbl2;

CREATE TABLE  tbl3
    (   a INT UNIQUE,
        b INT UNIQUE,
        c INT UNIQUE,
        d INT
    );
SHOW INDEX FROM tbl3;

CREATE TABLE  tbl4
    (   a INT UNIQUE NOT NULL,
        b INT UNIQUE,
        c INT UNIQUE,
        d INT
    );
SHOW INDEX FROM tbl4;

CREATE TABLE  tbl5
    (   a INT UNIQUE NOT NULL,
        b INT UNIQUE ,
        c INT UNIQUE,
        d INT PRIMARY KEY
    );
SHOW INDEX FROM tbl5;

CREATE DATABASE IF NOT EXISTS sqldb;
USE sqldb;
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl 
( userID  char(8) NOT NULL PRIMARY KEY, 
  name    varchar(10) NOT NULL,
  birthYear   int NOT NULL,
  addr    nchar(2) NOT NULL 
 );


INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울');
SELECT * FROM usertbl; -- 넣은 순서 아니라 userID 정렬 순

ALTER TABLE usertbl DROP PRIMARY KEY ;
ALTER TABLE usertbl 
    ADD CONSTRAINT pk_name PRIMARY KEY(name);
SELECT * FROM usertbl;

-- </실습 1> --

CREATE DATABASE IF NOT EXISTS sqldb;
USE sqldb;
DROP TABLE IF EXISTS clustertbl;
CREATE TABLE clustertbl -- Cluster Index를 가진 테이블 생성
( userID  CHAR(8) ,
  name    VARCHAR(10) 
);
INSERT INTO clustertbl VALUES('LSG', '이승기');
INSERT INTO clustertbl VALUES('KBS', '김범수');
INSERT INTO clustertbl VALUES('KKH', '김경호');
INSERT INTO clustertbl VALUES('JYP', '조용필');
INSERT INTO clustertbl VALUES('SSK', '성시경');
INSERT INTO clustertbl VALUES('LJB', '임재범');
INSERT INTO clustertbl VALUES('YJS', '윤종신');
INSERT INTO clustertbl VALUES('EJW', '은지원');
INSERT INTO clustertbl VALUES('JKW', '조관우');
INSERT INTO clustertbl VALUES('BBK', '바비킴');

SELECT * FROM clustertbl; -- 입력한 순서대로 값이 들어갑니다

ALTER TABLE clustertbl
    ADD CONSTRAINT PK_clustertbl_userID
        PRIMARY KEY (userID);

SELECT * FROM clustertbl;  -- PK가 걸린 ID의 ABCD 순으로 정렬됩니다 (클러스터 인덱스 설정됨)


DROP TABLE IF EXISTS secondarytbl;
CREATE TABLE secondarytbl -- Secondary Table 약자
( userID  CHAR(8),
  name    VARCHAR(10)
);
INSERT INTO secondarytbl VALUES('LSG', '이승기');
INSERT INTO secondarytbl VALUES('KBS', '김범수');
INSERT INTO secondarytbl VALUES('KKH', '김경호');
INSERT INTO secondarytbl VALUES('JYP', '조용필');
INSERT INTO secondarytbl VALUES('SSK', '성시경');
INSERT INTO secondarytbl VALUES('LJB', '임재범');
INSERT INTO secondarytbl VALUES('YJS', '윤종신');
INSERT INTO secondarytbl VALUES('EJW', '은지원');
INSERT INTO secondarytbl VALUES('JKW', '조관우');
INSERT INTO secondarytbl VALUES('BBK', '바비킴');


ALTER TABLE secondarytbl
    ADD CONSTRAINT UK_secondarytbl_userID
        UNIQUE (userID); -- UNIQUE가 걸리면 보조 인덱스가 자동 생성됩니다

SELECT * FROM secondarytbl;

INSERT INTO clustertbl VALUES('FNT', '푸니타');
INSERT INTO clustertbl VALUES('KAI', '카아이');

INSERT INTO secondarytbl VALUES('FNT', '푸니타');
INSERT INTO secondarytbl VALUES('KAI', '카아이');

SELECT * FROM clustertbl;
SELECT * FROM secondarytbl;
DESC secondarytbl;

-- <실습 2> --
DROP TABLE IF EXISTS mixedtbl;
CREATE TABLE mixedtbl
( userID  CHAR(8) NOT NULL ,
  name    VARCHAR(10) NOT NULL,
  addr     char(2)
);
INSERT INTO mixedtbl VALUES('LSG', '이승기', '서울');
INSERT INTO mixedtbl VALUES('KBS', '김범수', '경남');
INSERT INTO mixedtbl VALUES('KKH', '김경호', '전남');
INSERT INTO mixedtbl VALUES('JYP', '조용필',  '경기');
INSERT INTO mixedtbl VALUES('SSK', '성시경', '서울');
INSERT INTO mixedtbl VALUES('LJB', '임재범',  '서울');
INSERT INTO mixedtbl VALUES('YJS', '윤종신',  '경남');
INSERT INTO mixedtbl VALUES('EJW', '은지원', '경북');
INSERT INTO mixedtbl VALUES('JKW', '조관우', '경기');
INSERT INTO mixedtbl VALUES('BBK', '바비킴',  '서울');


ALTER TABLE mixedtbl
    ADD CONSTRAINT PK_mixedtbl_userID
        PRIMARY KEY (userID);

ALTER TABLE mixedtbl
    ADD CONSTRAINT UK_mixedtbl_name
        UNIQUE (name) ;
# Primary 키는 이름 지어도 Primary
SHOW INDEX FROM mixedtbl;

SELECT addr FROM mixedtbl WHERE name = '임재범';
SELECT addr FROM mixedtbl WHERE userID = 'LJB';
SELECT addr FROM mixedtbl WHERE addr = '서울' AND userID='LJB';  # userID에 인덱스 걸려있어서 순서 상관없이 빠르게 접근했음
SELECT addr FROM mixedtbl WHERE addr = '서울';  # index 안 걸려있어서 테이블 전체 돌 수 밖에 없었음 
-- </실습 2> --


-- <실습 3> --
USE sqldb;
SELECT * FROM usertbl;

USE sqldb;
SHOW INDEX FROM usertbl;

SHOW TABLE STATUS LIKE 'usertbl';

CREATE INDEX idx_usertbl_addr 
   ON usertbl (addr);
   
SHOW INDEX FROM usertbl;

SHOW TABLE STATUS LIKE 'usertbl';

ANALYZE TABLE usertbl;
SHOW TABLE STATUS LIKE 'usertbl';

CREATE UNIQUE INDEX idx_usertbl_birtyYear
    ON usertbl (birthYear);

CREATE UNIQUE INDEX idx_usertbl_name
    ON usertbl (name);

SHOW INDEX FROM usertbl;

INSERT INTO usertbl VALUES('GPS', '김범수', 1983, '미국', NULL  , NULL  , 162, NULL);

CREATE INDEX idx_usertbl_name_birthYear
    ON usertbl (name,birthYear);
DROP INDEX idx_usertbl_name ON usertbl;

SHOW INDEX FROM usertbl;

SELECT * FROM usertbl WHERE name = '윤종신' and birthYear = '1969';

CREATE INDEX idx_usertbl_mobile1
    ON usertbl (mobile1);

SELECT * FROM usertbl WHERE mobile1 = '011';

SHOW INDEX FROM usertbl;

DROP INDEX idx_usertbl_addr ON usertbl;
DROP INDEX idx_usertbl_name_birthYear ON usertbl;
DROP INDEX idx_usertbl_mobile1 ON usertbl;

ALTER TABLE usertbl DROP INDEX idx_usertbl_addr;
ALTER TABLE usertbl DROP INDEX idx_usertbl_name_birthYear;
ALTER TABLE usertbl DROP INDEX idx_usertbl_mobile1;

ALTER TABLE usertbl DROP PRIMARY KEY;

SELECT table_name, constraint_name
    FROM information_schema.referential_constraints
    WHERE constraint_schema = 'sqldb';

ALTER TABLE buyTbl DROP FOREIGN KEY buytbl_ibfk_1;
ALTER TABLE usertbl DROP PRIMARY KEY;

-- </실습 3> --