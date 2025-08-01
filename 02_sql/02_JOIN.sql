-- 2.join.sql

DROP DATABASE IF EXISTS fisa;
CREATE DATABASE fisa DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

USE fisa;

drop table IF EXISTs emp;
drop table IF EXISTs dept;
DROP TABLE IF EXISTS salgrade;

CREATE TABLE dept (
    deptno               int  NOT NULL ,
    dname                varchar(20),
    loc                  varchar(20),
    CONSTRAINT pk_dept PRIMARY KEY ( deptno )
 );
 
CREATE TABLE emp (
    empno                int  NOT NULL  AUTO_INCREMENT,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint ,
    hiredate             date,
    sal                  numeric(7,2),
    comm                 numeric(7,2),
    deptno               int,
    CONSTRAINT pk_emp PRIMARY KEY ( empno )
 );
 
CREATE TABLE salgrade
 ( 
	GRADE INT,
	LOSAL numeric(7,2),
	HISAL numeric(7,2) 
);

ALTER TABLE emp 
ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno ) REFERENCES dept( deptno ) 
ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 부서번호, 부서이름, 부서가 있는 지역 
insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');

desc dept;
desc emp;
desc salgrade;

-- STR_TO_DATE() : 단순 문자열을 날짜 형식의 타입으로 변환 
insert into emp values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp values( 7788, 'SCOTT', 'ANALYST', 7566, DATE_ADD(STR_TO_DATE('13-7-1987','%d-%m-%Y'), INTERVAL -85 DAY)  , 3000, null, 20);
insert into emp values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp values( 7876, 'ADAMS', 'CLERK', 7788, DATE_ADD(STR_TO_DATE('13-7-1987', '%d-%m-%Y'),INTERVAL -51 DAY), 1100, null, 20);
insert into emp values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);


INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

COMMIT;

SELECT * FROM DEPT;
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
/*
1. 조인이란?
	다수의 table간에  공통된 데이터를 기준으로 검색하는 명령어
	
	다수의 table이란?
		동일한 table을 논리적으로 다수의 table로 간주
			- self join
			- emp의 mgr 즉 상사의 사번으로 이름(ename) 검색
				: emp 하나의 table의 사원 table과 상사 table로 간주

		물리적으로 다른 table간의 조인
			- emp의 deptno라는 부서번호 dept의 부서번호를 기준으로 부서의 이름/위치 정보 검색
  
2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관되어 있음

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관되어 있음

  
3. table에 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요, 
	서로 다른 table간의 컬럼명이 중복된 경우,
	컬럼 구분을 위해 엔진에게 정확한 table 소속명을 알려줘야 함

	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. 동등 조인
		 = 동등비교 연산자 사용
		 : 사용 빈도 가장 높음
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자)

	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계

	4. outer 조인 
		: 조인시 조인 조건이 불충분해도 검색 가능하게 하는 조인 
		: 두개 이상의 테이블이 조인될때 
		특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 
		null값을 보유한 경우 검색되지 않는 문제를 해결하기 위해 사용되는 조인
*/		

SELECT * FROM DEPT; -- 부서 정보
SELECT * FROM EMP; -- 직원정보 
SELECT * FROM SALGRADE; -- 등급별 임금 MIN, MAX 값을 저장해둔 테이블 

-- 	1. 동등 조인
-- 		 = 동등비교 연산자 사용
-- 		 : 사용 빈도 가장 높음
-- 		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 
# JOIN을 사용하는 두가지 방법
# 1. JOIN ~ ON 키워드를 직접 사용
SELECT 
    *
FROM
    emp
        JOIN
    dept ON emp.deptno = dept.deptno; -- FROM 절에 ON key로 묶어준다

# 2. WHERE 절에 테이블명.컬럼명 = 테이블2명.컬럼명
SELECT *
FROM emp, dept 
WHERE emp.deptno = dept.deptno;  -- FROM 절에 작성한 각 테이블을 호출

SELECT 
    *
FROM
    emp AS e,
    dept d
WHERE
    e.deptno = d.deptno; -- 이 경우 반드시 붙여놓은 별칭 대로 불러줘야 함
# 1번은 FROM, 2번은 WHERE 절에서 JOIN이 이루어짐 

-- 조인하는 두 테이블에 중복된 컬럼명이 있으면 컬럼이 속한 테이블을 명시해주셔야 합니다
-- 출처를 명시해야 좋은 쿼리입니다.
SELECT
	e.empno, e.ename, e.mgr, d.deptno, d.dname, d.loc
FROM
	emp AS e,
	dept AS d
WHERE
	e.deptno=d.deptno;

-- 2. SMITH 의 이름(ename), 사번(empno), 근무지역(부서위치)(loc) 정보를 검색
SELECT 
    e.empno, e.ename, e.mgr, d.deptno, d.dname, d.loc
FROM
    emp AS e,
    dept AS d
WHERE
    e.ename = 'smith'
        AND e.deptno = d.deptno;

/* 	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자) */
SELECT 
    *
FROM
    emp AS e,
    salgrade AS s
WHERE
    e.sal BETWEEN s.losal AND s.hisal;

-- SMITH 씨의 GRADE를 출력해주시고
SELECT 
    e.ename, s.grade, e.sal, s.hisal, s.losal
FROM
    emp AS e,
    salgrade AS s
WHERE
    e.ename = 'SMITH'
        AND (e.sal BETWEEN s.losal AND s.hisal);

-- 부서번호 30인 사람들의 각 이름, GRADE와 SAL, 상한선, 하한선 출력해주세요
SELECT 
    e.deptno, e.ename, s.grade, e.sal, s.hisal, s.losal
FROM
	emp AS e,
    salgrade AS s
WHERE
    e.deptno = 30
        AND (e.sal BETWEEN s.losal AND s.hisal);
/*
	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계
*/
SELECT e1.ename as 상급자, e1.sal, e2.ename as 하급자, e2.sal
FROM emp as e1, emp as e2
WHERE e1.empno = e2.mgr;
-- 킹은 상사가 없어서(NULL) 검색에서 빠졌음

-- SMITH 직원의 매니저 이름 검색
-- emp e : 사원 table로 간주 / emp m : 상사 table로 간주
SELECT m.ename
FROM emp as e, emp as m
WHERE e.ename = 'SMITH' and e.mgr = m.empno;

-- 매니저 이름이 KING(m ename='KING')인 
-- 사원들의 이름(e ename)과 직무(e job) 검색
SELECT e.ename, e.job
FROM emp as e, emp as m
WHERE m.ename = 'KING' and e.mgr = m.empno;


/*
	4. outer 조인 
		: 조인시 조인 조건이 불충분해도 검색 가능하게 하는 조인 
		: 두개 이상의 테이블이 조인될때 
		특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 
		null값을 보유한 경우 검색되지 않는 문제를 해결하기 위해 사용되는 조인
*/

SELECT m.ename as 상급자, m.sal, e.ename as 하급자, e.sal
FROM emp as m RIGHT OUTER JOIN emp as e ON m.empno = e.mgr;
-- right outer join을 명시해서 king이 조인에 포함되었음

SELECT * FROM emp;


-- 40번부서에서 일하는 직원 
-- 사람의 눈은 왼쪽 -> 오른쪽으로 정보를 읽기 때문에 
SELECT d.deptno, e.ename 
FROM dept d LEFT OUTER JOIN emp e ON d.deptno=e.deptno;

