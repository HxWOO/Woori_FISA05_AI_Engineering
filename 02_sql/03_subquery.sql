# 3. Subquery

USE fisa;
-- join으로도 다 할 수 있음
-- 먼저 조건에 맞는 값을 추려서 다른 테이블과 비교하기 때문에 속도면에서 우월합니다. (최적화가 되어있지 않았을 때 기준)


-- 1. 스칼라 서브쿼리 : 결과가 하나의 값으로 도출
-- 내부쿼리(10) -> 외부쿼리(emp에서 찾습니다) 동작
-- 내부쿼리에서는 외부쿼리의 FROM 절에 사용한 테이블을 참조할 수 있다

SELECT e.ename, (SELECT e.deptno, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno)
FROM emp e;  # 이거 안됨
-- 외부쿼리에서는 내부쿼리에서 사용한 테이블을 참조할 수 없다
-- SELECT 절에는 스칼라 서브쿼리만 쓸 수 있습니다. 

-- 가장 emp 테이블에서 월급을 조금 받는 사람 
SELECT empno, ename, sal, job
FROM emp
WHERE sal = (SELECT min(emp.sal) from emp);

-- 꼭 스칼라값이 아니어도 서브쿼리의 결과를 메인쿼리에 사용할 수 있습니다. (갯수가 맞으면)
SELECT ename, sal FROM emp WHERE (ename, sal)=(SELECT ename, sal FROM emp LIMIT 1);

-- 부서가 accounting인 사람의 이름과 deptno를 emp, dept를 조인해서 확인해주세요.
SELECT e.ename, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno AND d.dname='accounting';

# 서브 쿼리 사용 1
SELECT ename, deptno
FROM emp
WHERE deptno = (SELECT deptno FROM dept WHERE dname='accounting');

# 서브 쿼리 사용 2 
SELECT e.ename, e.deptno
FROM emp e, (SELECT deptno FROM dept WHERE dname='accounting') d
WHERE e.deptno = d.deptno;


# 중복되는 서브쿼리를 맨 앞에 WITH 문으로 작성해 놓으면 몇번이고 별칭으로 불러 쓸 수 있습니다.

-- 2. FROM 절에서의 서브쿼리
-- 파생(derived) 서브쿼리
-- 꼭 별칭을 붙여서 외부 쿼리문에서는 별칭으로 사용합니다.
-- 서브쿼리가 반환하는 결과 집합을 하나의 테이블처럼 사용하는 쿼리문
-- 서브쿼리 안에서 사용해도 된다 
-- FROM -> WHERE -> SELECT 


 -- join으로 해결
 -- emp 테이블에서 SMITH 직원명 검색해서
SELECT e.ename, d.dname
FROM dept d, (SELECT ename, deptno FROM emp WHERE ename='SMITH') as e
WHERE e.deptno = d.deptno;
 -- 어떤 부서인지 dept 테이블에서 찾아서 출력하기
 
-- 직군이 MANAGER인 사람의 부서명, 부서이름, 이름, 직군을 출력해 주세요.
SELECT ename, job FROM emp WHERE job='MANAGER';

SELECT d.deptno, d.dname, f.ename, f.job
FROM (SELECT ename, job, deptno FROM emp WHERE job='MANAGER') f, dept d
WHERE f.deptno=d.deptno;

-- 메인쿼리 안에서 사용하는 서브쿼리의 쿼리문이 길어지면 또는 같은 쿼리를 여러 군데에 쓰게 되면 
-- with 구문으로 맨 위로 빼서 가독성을 높일 수 있습니다. common table expression / cte
-- CTE 에서는 limit을 사용 가능함, 서브쿼리에서는 limit을 사용하지 못하지만 
WITH f AS (
	SELECT ename, job, deptno 
    FROM emp 
    WHERE job='MANAGER'
    ),
 g AS  (
	SELECT ename, job, deptno 
    FROM emp 
    WHERE job='MANAGER'
    ) 
SELECT d.deptno, d.dname, f.ename
FROM f, dept d
WHERE f.deptno=d.deptno;


-- 3. WHERE절의 서브쿼리
-- - 특정 데이터를 걸러내기 위한 일반 조건이나 조회 조건을 기술 
-- 비교 연산자 또는 ANY(~ 중 하나), SOME(하나라도 있으면), ALL(모두) 연산자를 사용하기도 함

-- subquery로 해결: SMITH 씨와 같은 부서에서 일하는 직원을 찾아주세요. SMITH씨는 빼고 
SELECT e.ename, e.deptno
FROM emp e
WHERE e.deptno=(SELECT e.deptno FROM emp e WHERE e.ename='SMITH') AND e.ename NOT LIKE 'SMITH';


-- SMITH씨와 동일한 RESEARCH 부서 가진 모든 사원의 이름을 출력해보세요
SELECT e.ename 
FROM emp e
WHERE e.deptno=(SELECT e.deptno FROM emp e WHERE e.ename='SMITH') AND e.ename NOT LIKE 'SMITH';

select * from emp;
-- (SMITH 씨랑 급여)가 같거나 더 많은 사원명과 급여를 검색해주세요
SELECT e.sal FROM emp e WHERE e.ename='SMITH';
SELECT e.ename, e.sal
FROM emp e 
WHERE e.sal >= (SELECT e.sal FROM emp e WHERE e.ename='SMITH') AND ename NOT LIKE 'SMITH';


select * from dept;


-- 얘는 왜 이럴까요? 
SELECT ename, sal, deptno FROM emp
WHERE deptno IN (SELECT -- (10, 20) 
    deptno
FROM
    emp 
WHERE
    sal >= 3000 AND deptno IN (10 , 20)); 


-- ANY, SOME, ALL 이라는 조건을 사용해서 여러개의 결과값과 비교를 할 수도 있습니다.
-- deptno가 20번인 부서의 사람들 중 누구보다라도 많은 임금을 받는 모든 사람
-- ALL : 서브쿼리의 결과값 모두 만족해야 참 / 하나 이상의 값으로 비교연산자 
SELECT e.ename, e.sal, e.deptno
FROM emp e 
WHERE e.sal > ALL (SELECT e.sal FROM emp e WHERE e.deptno=20);

SELECT e.ename, e.sal, e.deptno
FROM emp e 
WHERE e.sal > (SELECT max(e.sal) FROM emp e WHERE e.deptno=20);
-- ANY, SOME : 서브쿼리의 결과값 중 하나라도 만족하면 참

-- deptno가 20번인 부서의 사람 각자 보다 많은 임금을 받는 모든 사람
SELECT e.ename, e.sal, e.deptno
FROM emp e 
WHERE e.sal > ANY (SELECT e.sal FROM emp e WHERE e.deptno=20);
SELECT e.ename, e.sal, e.deptno

FROM emp e 
WHERE e.sal > (SELECT MIN(e.sal) FROM emp e WHERE e.deptno=20);

-- 금여가 3000불 이상인 사원이 소속된 부서 (10, 20) 에 속한 사원이름, 급여 검색
SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE e.deptno IN (SELECT e.deptno FROM emp e WHERE e.sal >= 3000);


-- EXISTS 연산자는 메인쿼리 테이블의 값 중에서 서브쿼리의 결과 집합에, isEmpty() 같은 역할 
-- 존재하는 건이 있는지를 확인하는 역할: True / False 로 확인해서 True이면 결과를 리턴 
-- EXISTS                  
-- 서브쿼리의 결과값이 존재하면 참

SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE (e.sal, e.deptno) IN (SELECT max(sal), deptno FROM emp GROUP BY deptno);
-- 각 부서별로 SAL가 가장 높은 사람은 누구일까요? 
-- 서브쿼리에 group by를 사용할 수 있습니다 
-- 이를 통해 group by로는 볼 수 없던 행별 정보를 서브쿼리로 추출한 테이블로 필터링해서 꺼낼 수 있다 


-- IN 연산자는 여러개 컬럼의 값을 비교해서 꺼낼 수 있습니다
-- 단 순서가 맞아야 합니다 


-- job이 매니저인 사람이 어느 부서에만 있는지 서브쿼리를 통해 확인해보세요 
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (SELECT deptno
				FROM emp
				WHERE job='MANAGER');

-- 실습
-- 2018년에 가장 많은 매출을 기록한 영화보다 더 많은 매출을 기록한 2019년도 영화를 검색해주세요    
use box_office;
SELECT m.title
FROM movies m
WHERE YEAR(m.release_date) = 2019 AND m.revenue > (SELECT max(revenue) FROM movies WHERE YEAR(release_date)=2018);

-- 2019년에 개봉한 국가의 영화 중 2018년에는 개봉하지 않았던 국가의 영화의 국가명, 영화명, 감독을 검색해주세요
SELECT country, title, director
FROM movies
WHERE YEAR(release_date)=2019 AND NOT country IN (SELECT DISTINCT country FROM movies WHERE YEAR(release_date)=2018);

SELECT country, title, director 
FROM movies 
WHERE year(release_date) = 2019 AND NOT EXISTS
		(SELECT DISTINCT m.country FROM movies m WHERE year(m.release_date) = 2018
			AND m.country = movies.country);
# IN과 EXIST의 속도차이 때문에 훨씬더 빨라짐 
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT
-- 서브쿼리는 뭔가 임시로 필요한만큼만 실행이라 마지막인 LIMIT 까지 못가고, CTE는 확정 후 이용하는거라 가능하다?같은 느낌인듯
-- 행이 많으면 속도가 느려지기 때문에 가장 행을 앞단에서 줄일 수 있는 순서
-- 테이블은 메인쿼리에서 먼저 가져옵니다 
-- 여기에 더해서 서브쿼리가 먼저 동작하기 때문에 서브쿼리를 최대한 간소한 결과가 나오도록 작성해주시면 좋습니다 

                       
-- 어차피 동작도 서브쿼리부터 하고, 서브쿼리가 길어서 뭘 하는지 안 보인다면 
-- 따로 빼줘도 좋지 않을까요 
-- CTE, Common Table Expression FROM 절에서는 사용하기 위한 파생 테이블의 별명을 붙여서 사용할 수 있습니다 

 

# 두 개 속도 비교
-- cte: 2019년에 개봉한 영화 중에서 각 장르별로 관객 수가 가장 많거나 가장 적은 영화를 조회하기 
WITH stats AS (
    SELECT 
        movie_type, 
        MAX(audience) AS max_aud, 
        MIN(audience) AS min_aud
    FROM movies
    WHERE YEAR(release_date) = 2019
    GROUP BY movie_type
)
SELECT m.*
FROM movies m
JOIN stats s
  ON m.movie_type = s.movie_type
WHERE (m.audience = s.max_aud OR m.audience = s.min_aud)
  AND YEAR(m.release_date) = 2019;

-- subquery: 2019년에 개봉한 영화 중에서 각 장르별로 관객 수가 가장 많거나 가장 적은 영화를 조회하기 
SELECT *
FROM movies m
WHERE YEAR(m.release_date) = 2019
  AND (
    m.audience = (
      SELECT MAX(audience)
      FROM movies
      WHERE movie_type = m.movie_type AND YEAR(release_date) = 2019
    )
    OR
    m.audience = (
      SELECT MIN(audience)
      FROM movies
      WHERE movie_type = m.movie_type AND YEAR(release_date) = 2019
    )
  );

--   CTE 방식(첫 번째 쿼리)은
-- 집계 결과(stats)를 한 번만 계산해서 메모리에 올려놓고,
-- movies 테이블과 조인하여 결과를 빠르게 가져옵니다.

-- 서브쿼리 방식(두 번째 쿼리)은
-- movies 테이블의 각 행마다
-- MAX(audience), MIN(audience) 값을 다시 계산(서브쿼리 실행)합니다.
-- 즉, 행 수만큼 반복적으로 집계 쿼리가 실행되어 비효율적입니다.
-- 따라서 CTE 방식이 성능상 더 유리합니다.

-- 조인 review
-- 1. 조인을 사용해서 뉴욕('NEW YORK')에 근무하는 사원의 이름(ename)과 급여(sal)를 검색 
USE fisa;
SELECT ename, sal, loc
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.loc = 'NEW YORK';

-- 2. 사원(emp) 테이블의 부서 번호(deptno)로 
-- 부서 테이블(dept)을 참조하여 사원명(ename), 부서번호(deptno),
-- 부서의 이름(dname) 검색
SELECT e.ename, e.deptno, d.dname
FROM emp e
RIGHT JOIN dept d ON e.deptno = d.deptno;

-- *** self 조인 ***
-- 3. SMITH와 동일한 부서에서 근무하는 사원의 이름 검색
-- 단, SMITH 이름은 제외하면서 검색
SELECT e1.ename
FROM emp e1
INNER JOIN emp e2 on e2.ename='SMITH' AND e1.deptno=e2.deptno
WHERE NOT e1.ename='SMITH';


-- *** outer join ***
/* 두 개 이상의 테이블을 조인할 때 
emp m의 deptno는 참조되는 컬럼(PK)
emp d의 deptno는 참조하는 컬럼(외래키, FK)의 역할을 하게 됩니다
*/ 
-- 4. 모든 사원명, 매니저 명 검색,  
-- INNER JOIN은 두 테이블 컬럼에 모두 있어야만 출력. 
-- NULL인 값은 조회하지 않습니다 
SELECT e.ename as 사원명, m.ename as 매니저
FROM emp e
LEFT JOIN emp m ON e.mgr = m.empno;

-- 5. 모든 사원명(KING포함), 매니저 명 검색, 
-- 단 매니저가 없는 사원(KING)도 검색되어야 함
SELECT e.ename as 사원명, m.ename as 매니저
FROM emp e
LEFT JOIN emp m ON e.mgr = m.empno;
-- LEFT JOIN 사용

-- RIGHT JOIN 사용
SELECT e.ename as 사원명, m.ename as 매니저
FROM emp m
RIGHT JOIN emp e ON e.mgr = m.empno;

-- 6. 모든 직원명(ename), 부서번호(deptno), 부서명(dname) 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join 이용해서 40번 부서의 부서 이름도 검색하기 
SELECT e.ename, d.deptno, d.dname
FROM emp e
RIGHT JOIN dept d ON e.deptno = d.deptno;


-- SQL의 동작순서: FROM -> WHERE -> (GROUP BY -> HAVING) -> SELECT -> ORDER BY -> LIMIT 
-- 7. 모든 부서번호가 검색(40)이 되어야 하며 급여가 3000이상(sal >= 3000)인 사원의 정보 검색
-- 특정 부서에 소속된 직원이 없을 경우 사원 정보는 검색되지 않아도 됨
-- 검색 컬럼 : deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
SELECT d.deptno, d.dname, d.loc, e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm
FROM dept d
LEFT JOIN (SELECT e.deptno, e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm FROM emp e WHERE e.sal >= 3000) e 
		ON d.deptno = e.deptno;
/*

검색 결과 예시

+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
| deptno | dname      | loc      | empno | ename | job       | mgr  | hiredate   | sal     | comm |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
|     10 | ACCOUNTING | NEW YORK |  7839 | KING  | PRESIDENT | NULL | 1981-11-17 | 5000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7788 | SCOTT | ANALYST   | 7566 | 1987-04-19 | 3000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7902 | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00 | NULL |
|     30 | SALES      | CHICAGO  |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
|     40 | OPERATIONS | BOSTON   |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
*/


-- 8. 세일즈 부서는 sal + comm 이 실제 월급입니다
-- sal + comm 이 2000불 이상인 모든 직원을 검색해 출력해 주세요
SELECT *
FROM emp e
INNER JOIN dept d ON d.dname='SALES' AND d.deptno = e.deptno
WHERE (e.sal+IF(e.comm, e.comm, 0)) >= 2000;
# comm이 없음 0으로 계산

## SQL 실행순서
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT
-- 10. 모든 부서의 정보와 함께 커미션이 있는 직원들의 커미션과 이름을 조회해 보세요.
SELECT d.deptno, d.dname, d.loc, e.ename, e.comm
FROM dept d
JOIN emp e ON IF(e.comm, 1, 0) AND e.deptno = d.deptno;

-- 11. 각 관리자의 부하직원수와 부하직원들의 평균연봉을 구해 보세요.
SELECT mgr, count(*) as 부하직원수, round(avg(sal)) as 평균연봉
FROM emp
GROUP BY mgr;

# Sub-Query 
# Sub-Query REVIEW 

# from 절에서의 서브쿼리
-- 12. emp 테이블에서 급여가 2000이 넘는 사람들의 이름과 부서번호, 부서이름, 지역 조회해 보세요.
SELECT e.ename, d.deptno, d.dname, d.loc
FROM (SELECT ename, deptno FROM emp WHERE sal > 2000) e
JOIN dept d ON e.deptno = d.deptno
ORDER BY deptno;

-- 13. emp 테이블에서 커미션이 있는 사람들의 이름과 부서번호, 부서이름, 지역을 조회해 보세요.
SELECT e.ename, d.deptno, d.dname, d.loc
FROM (SELECT ename, deptno FROM emp WHERE IF(comm, 1, 0)) e
JOIN dept d ON e.deptno = d.deptno
ORDER BY deptno;

-- join 절에서의 서브쿼리

-- 14. 모든 부서의 부서이름과, 지역, 부서내의 평균 급여를 조회해 보세요.
SELECT d.deptno, d.dname, d.loc, round(avgsal) as 평균급여
FROM (SELECT deptno, avg(sal) as avgsal FROM emp GROUP BY deptno) e
JOIN dept d ON e.deptno = d.deptno
ORDER BY deptno;


