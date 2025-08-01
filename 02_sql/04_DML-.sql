-- 4.DML.sql
/* 
- DML : Data Manupulation Language
            데이터 조작 언어
	   (select(DQL)/insert/update/delete 모두 다 DML)
	   - 이미 존재하는 table에 데이터 저장, 수정, 삭제, 검색 
	   - commit과 rollback(트랜잭션)이 적용되는 명령어
	   	insert/update/delete에만 적용
	   

1. insert sql문법
	1-1. 모든 칼럼에 데이터 저장시 
		insert into table명 values(데이터값1, ...)

	1-2.  특정 칼럼에만 데이터 저장시,
		명확하게 칼럼명 기술해야 할 경우 
		insert into table명 (칼럼명1, ...) values(칼럼과매핑될데이터1...)


2. update -> 특정 조건에 맞는 행을 찾아서 수정 
	2-1. 모든 table(다수의 row)의 데이터 한번에 수정
		- where조건문 없는 문장
		- update table명 set 칼럼명=수정데이타; -- job이라는 컬럼을 만들고 : 회사원, 연봉 컬럼에 모두 100만원을 올려주는 경우 

	2-2. 특정 row값만 수정하는 방법
		- where조건문으로 처리하는 문장
		- update table명 set 칼럼명=수정데이타[, 컬럼명2=수정데이터2,..] where 조건sql;
		
		
3. delete		
	- 존재하는 데이터 삭제
*/

USE fisa;

-- *** insert ****
-- 1. 칼럼명 기술없이 데이터 입력
-- table 자체가 생성시에 컬럼 순으로 데이터 값들도 설정해서 저장
INSERT INTO dept VALUES(99, '에듀', '상암');

-- 데이터 구조만 복제해서 새로 생성
-- empno, ename, deptno emp 테이블을 가지고오되 구조만 가져와 보세요.
CREATE TABLE emp01 SELECT empno, ename, deptno FROM emp;
SELECT * FROM emp01;
DESC emp01;  -- 다른 컬럼에 영향을 미치지 않는 조건들만 가져옴. (그래서 emp01의 empno는 not null)
DESC emp;

-- 2. 칼럼명 기술후 데이터 입력 
-- 저장하고자 하는 데이터의 순서를 컬럼명 명시하면서 변경 가능
INSERT INTO emp01 (ename, deptno) VALUES('김현우', 99);
SELECT * FROM emp01; -- mysql 자체적으로 int 자료형의 컬럼은 default가 0, 그래서 위의 insert문 결과로 empno는 0 이들어갔음

-- 하나의 table에 한번에 데이터 insert하기 
-- , 구분자로 () 표현을 적용해서 저장
INSERT INTO emp01 (ename,deptno) VALUES('짱구',99), ('짱아',99);
SELECT * FROM emp01;
-- null을 허용하는 컬럼에 값 미저장시 특정 컬럼만 명시해서 값 저장 가능
-- DEFALUT 값이 정해진 컬럼을 명시해서 값을 넣지 않으면 DEFAULT 값이 들어갑니다 
-- 3. 0으로 들어가는 부분들은 '일단 채워넣음'  
/* 제약조건 없는 table에 사원명과 부서번호만 저장시도 : 정상 저장
 * mysql의 empno라는 int타입의 컬럼값이 검색시 0으로 적용되어 있음
 * oracle db의 경우 널 / mysql은 타입에 맞는 즉 정수타입의 기본값으로 자동 저장  
*/

-- 4. 데이터만 삭제 - rollback으로 복구 불가
-- DELETE 명령어로 empno가 0인 사람들의 행만 삭제해주세요 
SELECT * FROM emp01 WHERE empno=0;
DELETE FROM emp01 WHERE empno=0;
SELECT * FROM emp01 WHERE empno=0;
# 한번에 다 삭제

-- *** update ***
-- 1. 테이블의 모든 행 변경 UPDATE 테이블명 SET 컬럼명=값
-- deptno값을 모두 50으로 변경
-- UPDATE 테이블명 SET 변경할컬럼=변경할값 WHERE 조건을탐색할컬럼=기존값;
UPDATE emp01 SET deptno=50;
SELECT * FROM emp01; # 조건을 걸지 않아서 모든 값에 대해 변경이 일어났음

UPDATE emp01 SET deptno=deptno+1;
SELECT * FROM emp01;

INSERT INTO emp01 (ename, deptno) VALUES ('김현우', 99);
SELECT * FROM emp01;
UPDATE emp01 SET deptno=10 WHERE deptno=51;
SELECT * FROM emp01;
# SET으로 몇개든 한번에 변경 가능


SELECT @@autocommit;
SET @@autocommit = 0;
# 트랜잭션 단위로 commit을 작성할 때까지 실제 db에는 반영하지 않음
-- delete, update, insert 문은 commit 
INSERT INTO emp01 VALUES (1, '신짱구', 10);
SELECT * FROM emp01;  # 우리 세션엔 반영된것처럼 보이지만 아직 db엔 적용되진 않은 상태
COMMIT;  # 이제 db에 적용 

START TRANSACTION; 
INSERT INTO emp01 VALUES (1, '신짱구', 10);
SAVEPOINT sp1; 
UPDATE emp01 SET empno=3 WHERE empno=1;
SAVEPOINT sp2;
DELETE FROM emp01 WHERE empno=3;
SAVEPOINT sp3; 
ROLLBACK TO SAVEPOINT sp2;  # 세이브 포인트 까지만 무효
ROLLBACK;  # 트랜잭션 전체 무효 
SELECT * FROM emp01;
COMMIT;  -- commit 후에는 rollback이 적용 불가합니다.
-- emp01의 10인 사람을 하나 insert 해주시고 rollback이 적용되는지 확인해보세요 

SET @@autocommit=1;
-- 10번 부서 번호를 50으로 변경
# drop vs truncate
# DROP TABLE은 테이블 자체를 삭제
# TRUNCATE TABLE은 구조만 남겨놓고 행을 모두 삭제
TRUNCATE TABLE emp01;
select * from emp01;

DROP TABLE emp01;
select * from emp01; # drop 이후엔 emp01이 아예 사라진 모습

CREATE TABLE emp01 SELECT empno, ename, hiredate, sal FROM emp;
DELETE FROM emp01;  # DELETE FROM 테이블 은 TRUNCATE 와 결과가 똑깥음
# 그런데 DELETE는 한행 한행 확인하며 날림 (commit 시 반영), TRUNCATE는 바로 날림. (commit 과 무관하게 날림)


#      테이블      변경할 컬럼=변경할 값     조건이 되는 컬럼=기존의 값 
-- 2. ? emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
DROP TABLE emp01;
select * from emp01; # drop 이후엔 emp01이 아예 사라진 모습
CREATE TABLE emp01 SELECT empno, ename, hiredate, sal FROM emp WHERE 1=0;  # 이런식으로 구조만 기존에 있던 테이블을 바꿔 오기도 함
CREATE TABLE emp01 SELECT empno, ename, hiredate, sal FROM emp;
SELECT * FROM emp01;
#2
UPDATE emp01 SET sal=sal*1.1;
SELECT * FROM emp01;

-- ? 3. emp01의 모든 사원의 입사일을 오늘로 바꿔주세요
select now(), sleep(2), now(); -- 명령문이 실행될 때 한번만 시간을 기록합니다 
select sysdate(), sleep(2), sysdate(); -- 함수가 실행되는 순간의 시간을 기록합니다 
SELECT * FROM emp01;
UPDATE emp01 SET hiredate=DATE(now());
SELECT * FROM emp01;

-- 4. 급여가 3000이상(where sal >= 3000)인 사원의 급여만 10%인상
SELECT * FROM emp01;
UPDATE emp01 SET sal=sal*1.1 WHERE sal >=3000;
SELECT * FROM emp01;

-- 5. emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500달러 삭감 
SELECT * FROM emp01;
UPDATE emp01 SET sal=sal-500 WHERE sal>=1000;
SELECT * FROM emp01;

-- 6. emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
-- 서브쿼리 사용
SELECT * FROM emp01;
UPDATE emp01 SET sal=sal+1000 WHERE empno IN (SELECT e.empno FROM emp e, dept d WHERE e.deptno=d.deptno and d.loc='DALLAS');
SELECT * FROM emp01;


-- JOIN 테이블명 ON 공통키컬럼
-- emp / emp01 : empno / ename 
-- emp / dept : deptno 
SELECT * FROM emp e JOIN emp01 e01 ON e.empno=e01.empno
					JOIN dept d ON d.deptno=e.deptno;

-- UPDATE 구문에서는 JOIN이 UPDATE 테이블명 JOIN 중복컬럼명 SET 컬럼=변경할값  
UPDATE emp01 e01 JOIN emp e ON e.empno=e01.empno
				JOIN dept d ON d.deptno=e.deptno
SET e01.sal = e01.sal+1000;

DESC emp;
-- deptno 컬럼을 만들고, 테이블의 정보는 emp 테이블에서 가져와서 넣을 겁니다
-- 이미 만들어진 테이블에 변경사항이 있을 때는 ALTER
-- ALTER TABLE 테이블명 변경사항 변경할컬럼 컬럼명 자료형  
-- ALTER TABLE emp01 DROP COLUMN deptno;
ALTER TABLE emp01 ADD COLUMN deptno INT;
SELECT * FROM emp01;

-- emp01와 emp / empno로 join -> 각 컬럼에 deptno 추가
UPDATE emp01 e01 JOIN emp e ON e.empno=e01.empno SET e01.deptno=e.deptno;
-- emp와 dept를 서브쿼리를 통해 연결해서 emp의 부서원정보는 모두 조회하되, 
-- loc이 같이 출력되도록 쿼리문을 작성해주세요


-- deptno 테이블을 만들고, 테이블의 정보는 emp 테이블에서 가져와서 넣을 겁니다
-- emp와 dept를 서브쿼리를 통해 연결해서 emp의 부서원정보는 모두 조회되되, 
-- loc이 같이 출력되도록 쿼리문을 작성해주세요

-- 7. emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
-- 두개 이상의 칼럼값 동시 수정


-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
# truncate(복구 x, 빠름) , DELETE FROM(부하, 한행씩 삭제)

-- 9. 특정 row 삭제(where 조건식 기준)
-- deptno가 30번 부서의 모든 사원들 삭제
DELETE FROM emp01 WHERE deptno=30;
SELECT * FROM emp01;

-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
-- comm이 없어서 
DELETE FROM emp01 
WHERE empno IN (SELECT empno FROM emp WHERE comm IS NULL);
SELECT * FROM emp01;

-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제



-- 12. emp01 table에서 부서명이 RESEARCH 부서(dept table의 dname)에 소속된 사원 삭제 
-- 서브쿼리 활용


-- 13. table 전체 내용 삭제
DROP TABLE emp01;

-- 중복되는 값을 여러번 받을 때는 만약에 테이블에 똑같은 값이 있다 -> 어떻게 바꿔주세요
CREATE TABLE people(
	name VARCHAR(10) PRIMARY KEY,
    age INT UNIQUE
    );

INSERT INTO people VALUES ('김현우', 26);
SELECT * FROM people;
INSERT INTO people VALUES ('김현우', 26);  # pk가 중복되어 오류 

-- 같은 값을 가진 행이 있음? 행을 변경, 없음? 행을 삽입 (딕셔너리의 키 처럼)
# UPSERT 사용 
# UPSERT 로직은 아래처럼 사용
/* INSERT와 UPDATE를 동시에 처리
조건을 확인해 이미 대상 테이블에 값이 있으면 수정하고 없으면 입력하는 방법입니다.
INSERT INTO 테이블명 (칼럼1, 칼럼2, ...)
VALUES 절(또는 SELECT 문)
    ON DUPLICATE KEY UPDATE 칼럼 = 값1, 값2, ... ;
ON DUPLICATE KEY UPDATE 구문을 추가하면
충돌이 발생하는 로우에서는 신규로 값을 입력하는 것이 아니라 기존에 저장된 값을 변경합니다.
*/



-- 아래 구문은 4번 정도 반복해보세요
INSERT INTO people (name, age) VALUES ('김현우', 26)
ON DUPLICATE KEY UPDATE  -- ON DUPLICATE KEY가 의미하는 것은 실제로 UNIQUE가 걸려있는 COLUMN에서의 DUPLICATE를 의미합니다
  name = '김현우',
  age = age + 1;
 
SELECT * FROM people;
