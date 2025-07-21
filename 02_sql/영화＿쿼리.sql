USE box_office;

SELECT * FROM movies;
-- 2. 2024년 혹은 2025년에 제작된 영화
-- WHERE 컬럼명 조건; 
SELECT 
    *
FROM
    movies
WHERE
    releASE_date >= '2024-01-01 00:00:00';
   
-- WHERE 조건명 ORDER BY 정렬하려는 기준컬럼 ASC/DESC LIMIT 개수 
SELECT 
    seq_id, title, release_date, genre
FROM
    moVIES
WHERE
    relEase_daTe >= '2024-01-01 00:00:00'
ORDER BY 3
LIMIT 5; -- ASC가 디폴트값 , SELECT 뒤의 컬럼 순서대로 몇번째인지로 대체 가능 


/* GEnRe가 미정 또는 기타인 컬럼만 select해보세요. 
AND && / OR || / NOT !
*/

-- SELECT genre, title FROM movies WHERE genre='기타' || '미정';  -- '미정'은 보지도 않고 '기타'만 출력됨 
SELECT genre, title FROM movies WHERE genre='기타' || genre='미정'; 

-- 어차피 모든 열의 정보를 행단위로 삭제하므로 DELETE FROM 으로 시작 
DELETE FROM movies WHERE genre='기타' or genre='미정'; 

select *
from movies
where title='천년여우';

select *
from movies
where title like '%여우%';

select *
from movies
where title like '_여우';

-- 여우가 들어가고 비가 들어가는 영화
select *
from movies
where (title like '%여우%') and (title like '%비%');

-- 여우나 비가 안 들어가는 영화 
select *
from movies
where not (title like '%여우%') and not (title like '%비%');

select country from movies;

select distinct country from movies;

select distinct count(genre) from movies;  -- 행 개수 세고 구분하기 때문에, 전체 행을 리턴함
select count(distinct genre) from movies;  -- 장르 구분 후 카운트

select count(distinct genre) as 장르수 from movies;  -- AS로 컬럼명 직접 지정가능
-- AS 생략 가능. 하지만 적어주는 게 원칙. 
SELECT count(DISTINCT genre) 장르수 FROM movies; 
-- 공백이 들어간 컬럼명은 ` `으로 감싸서 작성할 수 있습니다. - 권장되는 건 아닙니다. 
SELECT count(DISTINCT genre) AS `장르        수   임` FROM movies; 

SELECT DISTINCT rating AS 장르수 FROM movies;
-- 문자열 정렬은 collation 설정을 따른다 

-- 각 연도별 만들어진 영화의 총 편수를 각각 집계 
SELECT 
    YEAR(release_date), COUNT(release_date)
FROM
    movies
WHERE release_date IS NOT NULL
GROUP BY YEAR(release_date)
ORDER BY 1;


SELECT 
    YEAR(release_date), COUNT(release_date)
FROM
    movies
WHERE release_date IS NOT NULL
GROUP BY YEAR(release_date)
HAVING COUNT(release_date) >= 300  -- group by 결과로 나온 임시 테이블에 조건을 걸때
ORDER BY 1;

-- 1.FROM > 2.WHERE > 3.GROUP BY > ...

show columns from movies;

-- 각 연도별 영화의 통 관객수
select year(release_date) as 년도, sum(audience) as 총관객
from movies
where release_date is not null
group by year(release_date)
order by 1;

-- 각 연도별 평균 관객수
select year(release_date) as 년도, avg(audience) as 평균관객
from movies
where release_date is not null
group by year(release_date)
order by 1;
-- group by 한 결과는 기준대로 새롭게 만들어진 테이블리알 원본 테이블의 한 행의 정보를 해결하는건 불가능
-- 특정 결과를 행단위로 보고 싶다면 join해서 기존 테이블과 확인함

select *
from movies
where audience = 11913725;

-- 1. 2018년 개봉한 한국 영화 조회하기    문자,숫자,날짜 
SELECT 
    seq_id, title, release_date
FROM
    movies
WHERE
    release_date BETWEEN '2018-01-01' AND '2018-12-31' 
ORDER BY release_date; 

SELECT 
    seq_id, title, release_date
FROM
    movies
WHERE
    release_date LIKE '2018%' 
ORDER BY release_date; 

-- 2. 2019년 개봉 영화 중 관객수가 500만 명 이상인 영화 조회하기
select title, audience, release_date
from movies
where year(release_date)=2019 and audience>5000000
order by audience DESC;


-- 3. 2019년 개봉 영화 중 관객수가 500만 명 이상이거나 매출액이 400억 원 이상인 영화 조회하기
select title, audience, revenue, release_date
from movies
where year(release_date)=2019 and (audience>5000000 or revenue > 40000000000)
order by audience DESC;

-- 4. 한국영화 4대 제작사(롯데, 쇼박스, NEW, 씨제이)가 만든 2024년에 개봉된 영화를 조회하기.
select title, audience, revenue, release_date, production
from movies
where year(release_date)=2024 and (production like '롯데%' or production like '%쇼박스' or production like '%NEW%' or production like '씨제이%')
order by distributor DESC;

select *
from movies;
-- 위 데이터를 “특이사항”이라는 열 이름으로 출력하기.
-- - 한국영화 4대 제작사(롯데, 쇼박스, NEW, 씨제이)가 만든 2024년에 개봉된 영화를 조회하기.




-- 간단한 조건 IF(조건, 참일때 값, 거짓일 때 값) 
SELECT year(release_date), title, director, 
	 production, screens, revenue, audience, IF(production RLIKE '씨제이', 1, NULL) AS 추가한행
FROM movies 
WHERE (year(release_date) = 2024)
	AND (production RLIKE '롯데|쇼박스|스튜디오앤뉴|씨제이이엔엠') -- ㅡMYSQL의 OR은 || 이지만 RLIKE 안에서는 정규식 패턴의 | 이라 1개
ORDER BY screens DESC;


SELECT year(release_date), title, director, 
	 production, NULLIF(production, production RLIKE '씨제이') AS 추가한행
FROM movies 
WHERE (year(release_date) = 2024)
	AND (production RLIKE '롯데|쇼박스|스튜디오앤뉴|씨제이이엔엠') -- ㅡMYSQL의 OR은 || 이지만 RLIKE 안에서는 정규식 패턴의 | 이라 1개
ORDER BY screens DESC;


