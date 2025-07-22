SHOW DATABASES; -- 현재 DB의 스키마명을 확인할 수 있는 명령어 
USE box_office;
SHOW TABLES;
DESC movies; -- 테이블의 구조를 묘사하는 명령어;


-- 1) 2019년 1분기(QUARTER 함수 사용) 개봉 영화 중 
-- 2) 관객수가 10만 이상인 영화의 
-- GROUP BY 3) 월별, 4) 영화 유형별 5) 관객 소계를 구하는 쿼리 */
-- GROUPING() 함수는 WITH ROLLUP과 함께 쓰여서 해당 행이 WITH ROLLUP의 결과이면 1, 그렇지 않으면 NULL 을 반환 
SELECT MONTH(release_date), IF(GROUPING(movie_type)=1, '소계', movie_type), SUM(audience)
FROM movies
WHERE (year(release_date) = 2019 AND QUARTER(release_date) = 1) 
--	  AND audience >= 100000
GROUP BY MONTH(release_date), movie_type
WITH ROLLUP; -- GROUP BY 절에 적혀있는 행들 또는 집계함수만 새로운 SELECT 절로 사용 가능 

# 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
SET @@sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SELECT @@sql_mode;

-- GROUPING() 함수는 WITH ROLLUP과 함께 쓰여서 해당 행이 WITH ROLLUP의 결과이면 1, 그렇지 않으면 NULL 을 반환 
SELECT MONTH(release_date), 
	CASE 
		WHEN GROUPING(movie_type)=1 AND GROUPING(MONTH(release_date)) = 1 THEN '총계'
		WHEN GROUPING(movie_type)=1 THEN '소계'
		ELSE movie_type
	END 영화유형, 
    SUM(audience)
FROM movies
WHERE (year(release_date) = 2019 AND QUARTER(release_date) = 1) 
--	  AND audience >= 100000
GROUP BY MONTH(release_date), movie_type
WITH ROLLUP; -- GROUP BY 절에 적혀있는 행들 또는 집계함수만 새로운 SELECT 절로 사용 가능 

SELECT 
	MONTH(release_date) AS 월, movie_type AS 영화유형, SUM(audience) AS 총관객수,
    IF(MONTH(release_date) <= 6, '상반기', '하반기') AS 반기
FROM movies
WHERE 
	YEAR(release_date) = 2019
    AND revenue >= 10000000
GROUP BY 
	MONTH(release_date), movie_type, IF(MONTH(release_date) <= 6, '상반기', '하반기')
ORDER BY MONTH(release_date); -- 월, MONTH(release_date), 1

# 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
SET @@sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SELECT @@sql_mode;

/* 2.  
    1) 2019년 개봉 영화 중 2) 매출액이 천만 원 이상인 영화의 
    GROUP BY 1) 월별(MONTH), 2) 영화 유형별 관객 소계를 구하되
	IF - 7월 1일 전에 개봉한 영화이면 상반기,
	     7월 1일 이후에 개봉한 영화이면 하반기라고 함께 출력하는 쿼리 */
SELECT 
	MONTH(release_date) AS 월, movie_type AS 영화유형, SUM(audience) AS 총관객수,
    IF(MONTH(release_date) <= 6, '상반기', '하반기') AS 반기
FROM movies
WHERE 
	YEAR(release_date) = 2019
    AND revenue >= 10000000
GROUP BY 
	MONTH(release_date), movie_type, IF(MONTH(release_date) <= 6, '상반기', '하반기')
HAVING 월 < 7
ORDER BY MONTH(release_date)
LIMIT 2 OFFSET 3; -- 월, MONTH(release_date), 1
-- LIMIT 개수 OFFSET 건너뛰는 개수  -- PAGENATION에 많이 이용된다.

/* 3. 부제가 있는 영화 찾기 ':' 2015년 이후의 개봉영화 중에서 
부제가 달려있는 영화의 개수 세어보기 */
SELECT count(*) 
FROM movies
WHERE title LIKE '%:%' AND YEAR(release_date) >= 2015
ORDER BY release_date;

-- 3.2.1 비율로 표현해보기
SELECT count(*) AS 전체개볼편수, IF(title LIKE '%:%', '유', '무' ) AS 부제유무
FROM movies
WHERE YEAR(release_date) >= 2015
GROUP BY IF(title LIKE '%:%', '유', '무' )
WITH ROLLUP;
-- count에는 group by가 포함된거임
-- 3.2.2 비율로 표현해보기
SELECT count(*) AS 전체개봉편수, SUM(IF(title LIKE '%:%', 1, 0)) AS 부제있는편수,
		ROUND(SUM(IF(title LIKE '%:%', 1, 0))/count(*) *100, 2) AS 비율
FROM movies
WHERE YEAR(release_date) >= 2015
ORDER BY release_date;

/* 4. 감독이 두 명 이상이면 슬래시(/)로 이어져 있습니다(예, ‘홍길동/김감독’). 감독이 1명이면 그대로, 
   두 명 이상이면 / 대신 , 값으로 대체해(예, ‘홍길동,김감독’) 출력하는 쿼리를 작성해 보세요. */
SELECT REPLACE(director, '/', ',') as 감독명 
FROM box_office.movies;
