-- 7.view.sql
USE fisa;
SELECT * FROM emp;
/*
1. view 
	- 물리적으로는 미 존재, 단 논리적으로 존재
	- 하나 이상의 테이블을 조회한 결과 집합의 독립적인 데이터베이스 객체
	- 논리적(존재하는 table들에 종속적인 가상 table)

2. 개념
	- 보안을 고려해야 하는 table의 특정 컬럼값 은닉
	또는 여러개의 table의 조인된 데이터를 다수 활용을 해야 할 경우
	특정 컬럼 은닉, 다수 table 조인된 결과의 새로운 테이블 자체를 
	가상으로 db내에 생성시킬수 있는 기법 

3. 문법
	- create와 drop : create view/drop view
	- crud는 table과 동일
	
	CREATE VIEW view_name AS
	SELECT column1, column2, ...
	FROM table_name
	WHERE condition;
*/

-- ?? mysql 테이블 복사 -> 원본이 새로 생겨나는 개념

CREATE VIEW emp_ AS SELECT empno, ename, job, mgr, hiredate, deptno FROM emp;

SELECT * FROM emp_; -- 바로가기 

-- ?? 맨 마지막 행에 1800불 커미션은 안 받는 사람의 정보를 하나 넣어주세요
# 짱 mgr 100
-- emp에 삽입한 값이 바로 view에 반영되는지?
UPDATE emp SET mgr=100 WHERE ename='신짱구';
SELECT * FROM emp_;

-- view(사본)를 통해 emp(원본)을 변경되는지? 
-- view를 통해 table을 바꾸는 건 원칙적으로는 용납되지 않습니다. 
UPDATE emp_ SET mgr=999 WHERE ename='신짱구';
SELECT * FROM emp; -- 가능 

-- ?? 1. emp table과 dept table 기반으로 empno, ename, deptno, dname으로 view 생성
# emp_dept_v
CREATE VIEW emp_dept_v AS SELECT e.empno, e.ename, e.deptno, d.dname FROM emp e, dept d WHERE e.deptno=d.deptno;

SELECT * FROM emp_dept_v;
-- dept table의 SALES라는 데이터를 영업으로 변경 후 view 검색
UPDATE dept SET dname='영업' WHERE dname='SALES';

-- 새로운 값을 넣고 emp와 dept에 어떤 영향이 있는지 직접 확인해보세요 
SELECT * FROM emp_dept_v;
-- view는 가짜테이블 밖에서는 테이블인지 아닌지 알 수 없어요.
-- view에서도 값을 변경하거나 삭제하거나 추가할 수 있을까?

-- 순서대로 넣었어도 원본에 있는 컬럼 중 어디에 들어갈 지 적어두셔야 합니다.
-- 2개 이상의 테이블이 걸려있는 view에 대해서는  
DESC emp_dept_v; -- 눈으로는 확인할 수 없지만
UPDATE emp_dept_v SET deptno=10 WHERE deptno=30; -- 실제 테이블의 제약조건도 영향을 미칩니다.ALTER
INSERT INTO emp_dept_v VALUES (1111, '김연지', 20, 'RESEARCH');

-- view에 변경된 사항이 원본에 영향을 미칠까??
-- view에서 값을 변경할 수 있다면 원본의 제약조건의 영향을 받을까??


-- emp의 empno는 key성질을 여전히 유지할 수 있으므로
-- key preserved table이나, 
-- dept의 deptno는 더 이상 unique 성질을 유지하지 못해
-- key-preserved table이 아니게 됩니다. 
-- 즉 emp table에 속한 empno, ename, deptno만이 변경 가능해집니다. 
-- JOIN VIEW는 많이 사용됩니다. 
-- 값을 변경할 때 1개의 PK만 남게 되므로 1개 테이블의 값만 변경이 가능해진다.

-- 2. view 삭제 -- TABLE이랑 똑같네
DROP VIEW emp_;
DELETE FROM emp_dept_v WHERE deptno=10; -- 안됨
SELECT * FROM emp_dept_v;
TRUNCATE emp_dept_v; -- table을 날려버리는 명령어이므로 view에는 사용 불가

-- 1개의 테이블에서 유래한 VIEW는 어떻게 동작하는지 확인해보세요.
-- 3. ? emp table에서 comm을 제외한 emp01_v 라는 view 생성



-- ALLEN 이름을 한국어 알렌으로 변경
-- 월급도 100불 올려주시고 확인해보세요.

-- 알렌씨를 삭제도 해 주세요 



insert into  emp01_v values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 30);


-- 4. dept01_v에 crud : dep01_v와 dept01 table 변화 동시 검색
-- view만 수정해도 원본 table의 데이터가 동기화
-- *** DML은 view에 적용 가능, 원본 table에도 적용 
-- dept01_v에서 50번 부서, '교육', '상암' 
-- emp01_v에다가 여러분의 정보를 넣어주십시오 50번 



-- 5. 모든 end user(클라이언트, 실제로 가장 마지막 단에서 데이터를 조회하게 되는 사용자들) 가 
-- 빈번히 사용하는 sql문장으로 "해당 직원의 모든 정보 검색"하기
-- 내 이름이 아니라 다른 직원 정보를 조회할 때도 보여줘야 할 것 같은 정보와
-- 그렇지 않은 정보를 구분해서 관리해보세요 


	
/* 윈도우 함수 - 익숙해지면 참 좋아요! 
 행과 행 간을 비교, 연산, 정의하기 위한 함수. -- 2019년, 2018년, 2020년 
 분석함수 또는 순위함수라고 부릅니다.
 다른 함수들처럼 중첩해서 사용할 수는 없지만 서브쿼리에서는 사용가능합니다.
 
SELECT WINDOW_FUNCTION(ARGUMENTS) OVER([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING 절])
FROM 테이블명;

순위 함수:	RANK, DENSE_RANK, ROW_NUMBER	 
   90     1
80 80     2      
   75     4 

3000
2000
1000
1800
1222
4000   3000

일반 집계 함수:	SUM, MAX, MIN, AVG, COUNT	
그룹 내 행 순서 함수: FIRST_VALUE, LAST_VALUE, LAG, LEAD
그룹 내 비율 함수:	RATIO_TO_REPROT, PERCENT_RANK, CUME_DIST, NTILE 등
*/
-- 용량이 아주 큰 DB를 만들어야 할 때 
-- PARTITION BY 라는 구문을 이용하면 80년생 이하는 사람은 emp01, 85년생 이하인 사람 emp02 
-- 논리적으로는 하나의 테이블이지만, 공간을 나누어서 저장을 하게 하는 경우도 있습니다 

# 1) RANK
-- ORDER BY를 포함한 쿼리문에서 특정 컬럼의 순위를 구하는 함수
-- PARTITION 내에서 순위를 구할 수도 있고 전체 데이터에 대한 순위를 구할 수도 있다. 
-- 동일한 값에 대해서는 같은 순위를 부여하며 중간 순위를 비운다.
SELECT job, ename, sal, RANK() OVER (PARTITION BY job ORDER BY sal DESC) AS 연봉순위 FROM emp; 
UPDATE emp SET job='SALESMAN' WHERE ename='신짱구';

 
/* 2) DENSE_RANK (밀집, 밀도)
1
2 2
3 

RANK와 작동법은 동일, 동일한 값에 대해서는 
같은 순위를 부여하고 중간 순위를 비우지 않는다. 
동일한 값이 있는 경우 순위는 1,1,2,3,3,4
*/


 /* 3) ROW_NUMBER
RANK, DENSE_RANK는 동일한 값에 대해 동일 순위를 부여하지만 
ROW_NUMBER은 동일한 값이어도 고유한 순위를 부여한다.
-- 'A1234' 이전에는 -> 1, 2, 3, 4, 5 -> PK를 임의로 만들어줄 때 사용한다 
*/


-- 겹치지 않는 번호를 부여해야 할 때, 순위별로 나눌 때도 사용을 하긴 합니다 
-- 순서는 먼저 테이블에 들어간 값이 우선 순위를 부여받습니다 


/* 윈도우 안에서 특정 값을 찾아내는 함수 
1) FIRST_VALUE
파티션별 윈도우에서 가장 먼저 나온 값을 구한다. MIN과 같음.
*/
use fisa;
SELECT job, ename, sal, LAST_VALUE(sal) OVER (PARTITION BY job ORDER BY sal) AS 젤덜받는사람 FROM emp; 
SELECT job, ename, sal, FIRST_VALUE(sal) OVER (PARTITION BY job ORDER BY sal  DESC) AS 젤더받는사람 FROM emp; 


/*
2) LAST_VALUE
파티션별 윈도우에서 가장 마지막에 나온 값을 구한다.
-- WINDOWING을 작성하지 않으면 의도한대로 나오지 않는 경우들이 종종 있습니다.

BETWEEN A AND B로 묶어서 사용합니다. 

UNBOUNDED PRECEDING : 현재 PARTION의 가장 첫행부터
UNBOUNDED FOLLOWING : 현재 PARTION의 가장 마지막행까지 
N PRECEDING : 위로 N행
N FOLLOWING : 다음으로 N행
CURRENT ROW : 현재행까지
*/
SELECT job, ename, sal, LAST_VALUE(sal) 
	OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 젤덜받는사람 FROM emp;  -- 보통 BETWEEN으로 windowing 많이 함 
SELECT job, ename, sal, FIRST_VALUE(sal) OVER (PARTITION BY job ORDER BY sal  DESC) AS 젤더받는사람 FROM emp; 


-- 누적합 계산
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    SUM(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sal
FROM 
    emp;

-- 이동평균 계산: 현재 행과 이전 두 행의 평균
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    AVG(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM 
    emp;

-- 특정 범위 내의 합계: 현재 행과 다음 두 행의 합계
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    SUM(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS range_sum
FROM 
    emp;

-- 누적합 계산
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    SUM(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sal
FROM 
    emp;

-- 이동평균 계산: 현재 행과 이전 두 행의 평균
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    AVG(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM 
    emp;

-- 특정 범위 내의 합계: 현재 행과 다음 두 행의 합계
SELECT 
    empno,
    ename, 
    job, 
    sal, 
    SUM(sal) OVER (PARTITION BY job ORDER BY sal DESC ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS range_sum
FROM 
    emp;


-- 3) LAG
-- 이전 몇 번째 행의 값을 가져오는 함수. 인자를 최대 3개까지 가진다.
-- 두번째 인자는 몇 번째 앞의 행을 가져올지 결정하는 것이며 DEFAULT값은 1이다. 
-- 세번째 인자는 가져올 행이 없을 경우 DEFAULT값을 지정해준다.

-- 4) LEAD
-- 이후 몇 번째 행의 값을 가져오는 함수로 LAG와 마찬가지로 인자를 최대 3개까지 갖는다. */
-- LAG / LEAD : 2번째 인자로는 지금 기준으로 몇개 밀려난 순서에서 값을 가지고 올 것인지를 정해줍니다 
-- LAG / LEAD : NULL인 경우 들어갈 디폴트값이 세번째 인자로 

-- box_office.movies에서 상영관(screens)이 가장 많은 순서대로 
-- 연도별로(YEAR(release_date)) RANK를 매겨주시고, 
-- 가장 많이 상영관을 차지한 영화의 상영관수를 최다상영관수라는 컬럼에 함께 출력해주세요..
-- screeens나 year이 NULL인 값은 제외 
-- 전체 년도는 최근게 앞으로 (DESC) 
use box_office;
SELECT TITLE, YEAR(release_date), screens, RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY screens DESC) as 상영관순위,
		FIRST_VALUE(screens) OVER (PARTITION BY YEAR(release_date) ORDER BY screens DESC) as 최다상영관수
FROM movies
WHERE release_date IS NOT NULL OR screens IS NOT NULL
ORDER BY YEAR(release_date) DESC, screens DESC;


/* 4. 그룹 내 비율 함수
-- 백분위 PERCENT_RANK, 누적비율 CUME_DIST, 상위에서 몇번째-NTILE  
*/

-- 최대값 기준으로 현재 행의 값이 몇 퍼센트 백분위인지 
-- 부서별로 직원들이 최대임금 대비 몇퍼센트 정도 임금을 받고 있는지
use fisa;
SELECT * FROM emp;

SELECT deptno, job, ename, sal, round(sal/MAX(sal) OVER (PARTITION BY deptno ORDER BY deptno) * 100, 2) as '부서별 최대임금 대비 비율(%)'
FROM emp
ORDER BY deptno, sal;

-- 누적비율 CUME_DIST


-- NTILE : 전체 데이터를 특정 기준으로 N개의 그룹으로 나눌 때 
-- 구간을 나누는 bin 처럼 작동함

/* 일반 집계 함수:	SUM, MAX, MIN, AVG, COUNT	
순위 함수: RANK 1 1 3, DENSE_RANK 1 1 2, ROW_NUMBER
그룹 내 행 순서 함수: FIRST_VALUE, LAST_VALUE, LAG, LEAD
그룹 내 비율 함수:	PERCENT_RANK, CUME_DIST, NTILE 등
*/
-- 현재 회사에서 2번째로 돈을 많이 받는 사람은 누구일까요?
SELECT e.deptno, e.job, e.ename, e.sal, e.월급순위
FROM (SELECT deptno, job, ename, sal, RANK() OVER( ORDER BY sal DESC) as '월급순위'
FROM emp) as e
WHERE e.월급순위=2;

-- 부서별로 돈을 가장 적게 받는 사람
SELECT e.deptno, e.job, e.ename, e.sal, e.월급낮은순
FROM (SELECT deptno, job, ename, sal, RANK() OVER(PARTITION BY deptno ORDER BY sal ASC) as '월급낮은순'
FROM emp) as e
WHERE e.월급낮은순=1;

-- 부서별로 가장 돈을 많이 받는 사람만 확인할 수 있게 쿼리로 만들어서 결과를 출력해주세요
SELECT e.deptno, e.job, e.ename, e.sal, e.월급순
FROM (SELECT deptno, job, ename, sal, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) as '월급순'
FROM emp) as e
WHERE e.월급순=1;



-- 부서별로 가장 돈을 많이 받는 사람을 'MAXIMUM'이라는 컬럼에 별도로 출력해주세요 

WITH e2 as 
(SELECT e.deptno, e.job, e.ename, e.sal, e.월급순 
	FROM (SELECT deptno, job, ename, sal, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC, ename) as '월급순'
						FROM emp) as e 
                        WHERE e.월급순=1)
SELECT e1.deptno, e1.job, e1.ename, e1.sal, e2.ename as MAXIMUM
FROM emp e1, e2
WHERE e1.deptno = e2.deptno;

SELECT deptno, job, ename, sal, FIRST_VALUE(sal) OVER(PARTITION BY deptno ORDER BY sal ASC) as MAXIMUM
FROM emp;
