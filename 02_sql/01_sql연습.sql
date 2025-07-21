
# 명령어는 대문자로 작성, 테이블/DB명/컬럼명 같은 변수명은 소문자로 작성합니다
# MySQL은 DB명/테이블명/컬럼명 등에 대소문자를 구분하지 않으나 설정에 따라 다를 수 있습니다.
# MySQL에서도 컬럼명, 테이블명은 snake_case, DB명은 PascalCase, snake_case
-- 테이블(복수)은 데이터 튜플(단수)을 모아두는 장소
-- workbench의 단축키
-- Ctrl(cmd) + Enter : 쿼리 실행
-- Ctrl(cmd) + Shift + Enter : 쿼리 실행 후 결과창으로 이동
-- Shift + Enter : 커서가 있는 줄까지의 모든 쿼리 실행
-- Ctrl(cmd) + / : 주석 토글
-- Ctrl(cmd) + B : 쿼리 인덴트 정렬

##### DDL, Data Definition Language: 데이터 구조 정의 (테이블, 스키마 생성/변경 등) ####
-- 스키마 > 테이블 > 행을 삽입 
CREATE database IF NOT EXISTS fisa;
DROP database IF EXISTS fia;

# MySQL에서도 컬럼명, 테이블명은 snake_case, DB명은 PascalCase, snake_case
CREATE database IF NOT EXISTS mywork; 
USE mywork; -- 커서를 mywork에 위치시킴
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    id TINYINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL,
    gender ENUM('man', 'woman') NOT NULL,
    birth DATE NOT NULL,
    english TINYINT NOT NULL,
    math TINYINT NOT NULL,
    korean TINYINT NOT NULL,
    PRIMARY KEY (id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

#### DML, Data Manipulation Language : 데이터 조작 (삽입, 수정, 삭제 등)
-- 삽입(Create): INSERT INTO 테이블명 (컬럼명 ...) VALUES (실제값들...);

-- 모든 컬럼에 값을 넣을 때면 (컬럼명) 생략 가능 

-- auto increment 제약조건이 달린 컬럼은 생략하면 이전값+1이 들어갑니다. 

-- id 컬럼에 5을 넣고 값을 넣고

-- id 컬럼 생략하고 고대로 돌리면 다음 숫자인　６번을 부여받습니다．

SELECT * FROM students;

-- NOT NULL 제약조건이 걸린 컬럼에 NULL이 들어가면 무결성을 유지하기 위해 값을 넣지 않습니다.

-- 한 행 한 행 넣지않고 한번에 집어넣는 방법도 있습니다.

-- INSERT INTO DB명.테이블명 (컬럼명) VALUES (실제값);

-- VARCHAR에 지정한 값보다 큰 값은 들어가지 않음 

/* SQL의 실행 순서
1. FROM → 데이터를 가져옴.
2. WHERE → 행을 필터링.
3. GROUP BY → 데이터를 그룹화.
4. HAVING → 그룹을 필터링.
5. SELECT → 결과를 반환.
6. ORDER BY → 결과 정렬.
7. LIMIT → 결과 제한.
*/

-- 1. 모든 값 

-- 와일드카드는 웬만하면 실무에서 사용하지 않는 것이 좋습니다

-- 2. 2024년 혹은 2025년에 제작된 영화

-- 3. 문자열   
/* _ 언더바 하나당 글자 하나, %는 0개 이상의 글자
    RLIKE, REGEXP는 정규표현식으로 검색하는 명령어
*/
-- -1. '천년여우'라는 title을 가진 영화를 모두 찾고 싶어요(완전일치).

-- -2. ~~라는 단어가 어디든 들어가는 영화를 모두 찾고 싶어요(일부일치).

-- -3. 글자수 따져서 일치하는 _ 언더바 하나당 글자 하나

-- -4. 글자수가 0개이상 몇개라도 일치한 % - 몇글자이든 상관없이

-- -5. ~~로 시작하는

-- -6. ~~로 끝나는

-- -7. ~~라는 단어가 어디든 들어가는

-- -8. 리스트에 있는 단어와 완전히 일치  IN (값1, 값2) 

-- -9. 리스트에 있는 단어와 일부 일치
--    (A나 B라는 단어가 들어간 영화 전부) 

-- 10. 등호 연산자가 = / 논리연산자 && || !
     -- 여우가 들어가고 비가 들어가는 영화

     -- 여우나 비가 안 들어가는 영화

     -- 여우나 비가 들어가는 영화

-- 2018년 개봉한 한국 영화 조회하기

-- 현재 movies 테이블은 몇개 대표국가의 영화를 다루고 있는 걸까요?

-- 문자열 정렬은 collation 설정을 따른다 

######################### SQL 연습문제 #########################
-- 1.FROM > 2.WHERE > 3.GROUP BY > 4.HAVING > 5.SELECT > 6.ORDER BY > 7. LIMIT 
-- group by: 원본은 그대로 두고, 원본테이블에 없는 값을 계산해 냅니다 

-- group by의 결과에서 조건을 만족하는 값만 조회 

-- 1. 2018년 개봉한 한국 영화 조회하기

-- 2. 2019년 개봉 영화 중 관객수가 500만 명 이상인 영화 조회하기

-- 3. 2019년 개봉 영화 중 관객수가 500만 명 이상이거나 매출액이 400억 원 이상인 영화 조회하기


-- 4. 한국영화 4대 제작사(롯데, 쇼박스, NEW, 씨제이)가 만든 2024년에 개봉된 영화를 조회하기.
-- 위 데이터를 “특이사항”이라는 열 이름으로 출력하기.
-- - 한국영화 4대 제작사(롯데, 쇼박스, NEW, 씨제이)가 만든 2024년에 개봉된 영화를 조회하기.
-- IF(조건, 참일때, 거짓일때)

-- 집계함수: GROUP BY - MAX / MIN / AVG / SUM / COUNT / STD / VARIANCE ...    
# 5. movies 데이터에서 연도별로 개봉한 영화의 편수를 집계해서 출력해주세요

/* 6. movies 데이터에서 2019년 개봉 영화의 유형별 최대, 최소 관객수와 
전체 관객수를 집계해주세요. */


############################################# SQL 함수 #############################################
-- SQL함수 : 진짜 많아요. 쓰시게 되는 것만 쓰게 될 거, 똑같은 동작을 하는 여러개 함수 
-- RDBMS 종류마다 쓰는 함수명을 다 넣어놓은 경우도 있습니다  
SELECT CHAR_LENGTH('SQL'), LENGTH('SQL'), CHAR_LENGTH('홍길동🤣'), LENGTH('홍길동🤣'); 
# SQL에서 한글 1글자 : 3바이트, 이모지 등 특수문자 1글자: 4바이트 LENGTH로 확인 

SELECT CONCAT('This', 'Is', 'MySQL', '.') AS CONCAT1, 
       CONCAT('SQL', NULL, 'Books') AS CONCAT2, # NULL과 문자열을 연결하면 그 결과는 NULL
       CONCAT_WS('/', 'This', 'Is', 'MySQL') AS CONCAT_WS; 
		# CONCAT_WS() 함수는 구분자인 첫 번째 매개변수가 콤마(,)이므로 두 번째부터 네 번째 매개변수를 연결하면서 그 사이에 구분자 콤마 기입

-- SQL은 언어가 거의 유사합니다. 회사마다 사용하는 서버의 종류도 다양합니다. 
-- 문법이나 함수명이 여러 서버에서 혼용할 수 있도록 
SELECT FORMAT(123456789.123656, 3) fmt, -- FORMAT(숫자를 3개씩 끊어서 ,로 출력, 소수점이후 N번째 자리까지 반올림 출력)
       FORMAT(123456789.123656, 0) fmt1,
       INSTR('ThisIsSQL', 'sql') instring, -- index string, MySQL은 1부터 시작, 대소문자 구분 없음 
       INSTR(BINARY 'ThisIsSQL', 'sql') instring, -- BINARY 사용시 대소문자 구분
       LOCATE('my', 'TheMyDBMSMySQL') locates, -- 'TheMyDBMSMySQL'에서 'my'를 찾아줘 5번째인덱스 이후에서 
       POSITION('my' IN 'TheMyDBMSMySQL') pos; -- LOCATE('my', 'TheMyDBMSMySQL', 1) 과 같은 동작

       
SELECT LOWER('ABcD'), LCASE('ABcD'),
       UPPER('abcD'), UCASE('abcD');
       
SELECT REPEAT(1234, 3),
       REPLACE('생일 축하해 철수야', '철수', '영희') REP,
       REVERSE(1234);

# SUBSTR() 함수는 첫 번째 매개변수 str의 문자열에서 두 번째 매개변수 pos로 지정된 위치부터 세 번째 매개변수 len만큼 잘라 반환합니다.
-- len은 생략 가능하며, 생략하면 str의 오른쪽 끝까지 잘라냅니다. 또한 pos 값에 음수도 넣을 수 있는데, 이때는 시작 위치를 왼쪽이 아닌 오른쪽 끝을 기준으로 잡습니다. 
-- 그리고 SUBSTRING(), MID() 함수는 SUBSTR() 함수와 사용법이 같습니다.
SELECT SUBSTR('This Is MySQL', 6) FIRST,
       SUBSTRING('This Is MySQL', 6, 2) SECOND,
       MID('This Is MySQL', -5) THIRD; -- 음수인덱싱

--  NOW()와 CURDATE()를 자주 쓰며, CURRENT_TIMESTAMP는 테이블 정의 시 기본값으로도 많이 사용됩니다．
-- created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
SELECT CURDATE(), CURRENT_DATE(), CURRENT_DATE,
       CURTIME(), CURRENT_TIME(), CURRENT_TIME,
       NOW(), CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP;
       
SELECT DATE_FORMAT('2024-07-22 13:42:54', '%d-%b-%Y') Fmt1,
       DATE_FORMAT('2024-07-22 13:42:54', '%U %W %j') Fmt2;

-- ISO8601 - https://docs.python.org/ko/3.9/library/datetime.html#strftime-and-strptime-format-codes
SELECT STR_TO_DATE('21,07,2024', '%d,%m,%Y') CONV1,
       STR_TO_DATE('19:30:17', '%H:%i:%s') CONV2,
       STR_TO_DATE('09:30:17', '%h:%i:%s') CONV3,
       STR_TO_DATE('17:30:17', '%h:%i:%s') CONV4;  

SELECT SYSDATE(), SLEEP(2), SYSDATE(); -- 매번 함수 호출시의 시간

SELECT NOW(), SLEEP(2), NOW(); -- 문장 단위로 실행됨

 
SELECT DATE_ADD('2025-07-17', INTERVAL 5 DAY) DATEADD,
	   ADDDATE('2025-07-17', INTERVAL 5 MONTH) ADD_DATE1,
       ADDDATE('2025-07-17', 5 ) ADD_DATE2,
       ADDDATE('2025-07-17', INTERVAL '1 1' YEAR_MONTH) ADD_DATE3;
       
SELECT DATE_SUB('2025-07-17', INTERVAL 5 DAY) DATEADD,
	   SUBDATE('2025-07-17', INTERVAL 5 MONTH) ADD_DATE1,
       SUBDATE('2025-07-17', 5 ) ADD_DATE2,
       SUBDATE('2025-07-17', INTERVAL '1 1' YEAR_MONTH) ADD_DATE3;
       
-- EXTRACT() -- 매개변수의 date에서 특정 날짜 단위를 추출한 결과 반환
SELECT EXTRACT(YEAR_MONTH    FROM '2024-07-22 13:32:03') YEARMON,
       EXTRACT(DAY_HOUR      FROM '2024-07-22 13:32:03') DAYHOUR,
       EXTRACT(MINUTE_SECOND FROM '2024-07-22 13:32:03') MINSEC;

-- int('10') type casting 
SELECT CAST(10 AS CHAR)                 CONV_CHAR,
       CAST('-10' AS SIGNED)           CONV_INT, -- 양수, 음수 다 받는 자료형 
       CAST('10.2131' AS DECIMAL)       CONV_DEC1, -- (최대자리, 소수점이하n자리)
       CAST('10.2131' AS DECIMAL(6, 2)) CONV_DEC2, -- 고정소수점
       CAST('10.2131' AS DOUBLE)        CONV_DOUBLE, -- 부동소수점 -> 앞으로는 뺄거래요 
       CAST('2021-10-31' AS DATE)       CONV_DATE,
       CAST('2021-10-31' AS DATETIME)   CONV_DATETIME;

/*  CONVERT() 함수도 CAST() 함수와 마찬가지로 형 변환하나,
 CAST() 함수와 달리 AS type 대신 type을 두 번째 매개변수로 받음 */
SELECT CONVERT(10, CHAR)                 CONV_CHAR,
       CONVERT('-10', SIGNED)            CONV_INT,
       CONVERT('10.2131', DECIMAL)       CONV_DEC1,
       CONVERT('10.2131', DECIMAL(6, 4)) CONV_DEC2,
       CONVERT('10.2131', DOUBLE)        CONV_DOUBLE,
       CONVERT('2021-10-31', DATE)       CONV_DATE,
       CONVERT('2021-10-31', DATETIME)   CONV_DATETIME;
       
 
 -- 흐름제어 함수
# 흐름 제어(flow control) 함수란 특정 조건을 확인해 조건에 부합하는 경우와 그렇지 않은 경우에 다른 값을 반환하는 함수
# 흐름 제어 함수에는 IF(), IFNULL(), NULLIF() 함수가 있고, 흐름 제어 함수와 비슷한 역할을 하는 CASE 연산자도 있다
SELECT IF(2 < 1, 1, 0) IF1,  -- IF(조건, 참일때 리턴값, 거짓일 때 리턴값)
       IF('A' = 'a', 'SAME', 'NOT SAME') IF2, -- window의 MYSQL에서는 대소문자 구분 X 
       IF(1 = 2, 1, 'A') IF3;

-- NULLIF() 함수는 두 매개변수 expr1과 expr2 값이 같으면 NULL을, 같지 않으면 expr1을 반환
SELECT NULLIF(1, 1) NULLIF1,
       NULLIF(1, 0) NULLIF2,
       NULLIF(NULL, 123) NULLIF3; -- 특징. 첫 번째 인자가 NULL이기 때문에 결과가 NULL이 됨

SELECT STR_TO_DATE('21,07,2024', '%d,%m,%Y') CONV1;

SELECT CAST('123조건' AS DOUBLE); -- 문자열 앞부분부터 숫자로 해석할 수 있는 부분까지만 읽고 변환
SELECT CAST('조건' AS DOUBLE); 
SELECT CAST(FALSE AS UNSIGNED);
SELECT CAST(-23 AS UNSIGNED); 

SELECT CASE 1 WHEN 1 THEN 'A' END; 
SELECT CASE '조건' WHEN 0 THEN 'A' -- CASE 값 WHEN 첫번째 명제 THEN 첫번째 명제가 참일 경우 출력할 값
                  WHEN 1 THEN 'B' --         WHEN 두번째 명제 THEN 두번째 명제가 참일 경우 출력할 값
       END CASE1;
       
-- MYSQL도 0과 FALSE, 1과 TRUE가 내부적으로는 같은 값을 가지는 구나
SELECT CASE 0 WHEN FALSE THEN 'A' -- CASE 값 WHEN 첫번째 명제 THEN 첫번째 명제가 참일 경우 출력할 값
                  WHEN TRUE THEN 'B' --      WHEN 두번째 명제 THEN 두번째 명제가 참일 경우 출력할 값
       END CASE1;

SELECT CASE 'A' WHEN 'A' THEN 'A임' -- CASE 값 WHEN 첫번째 명제 THEN 첫번째 명제가 참일 경우 출력할 값
                WHEN 'B' THEN 'B임' --         WHEN 두번째 명제 THEN 두번째 명제가 참일 경우 출력할 값
       END CASE1;
       

SELECT CASE '1' --  CASE 구문은 값 비교 시 자료형을 자동으로 변환 
            WHEN 0 THEN 'A' -- CASE 값 WHEN 첫번째 명제 THEN 첫번째 명제가 참일 경우 출력할 값
            WHEN 1 THEN 'B' --         WHEN 두번째 명제 THEN 두번째 명제가 참일 경우 출력할 값
       END CASE1,           --         ELSE 앞의 모든 명제가 거짓인 경우 출력할 값 
							-- END 해당 조건을 부르기 위한 ALIAS
       CASE 9 WHEN 0 THEN 'A'
              WHEN 1 THEN 'B'
              ELSE 'None'
       END CASE2,
       CASE WHEN 25 BETWEEN 1 AND 19 THEN '10대' -- 범위 지정도 가능합니다
            WHEN 25 BETWEEN 20 AND 29 THEN '20대'
            WHEN 25 BETWEEN 30 AND 39 THEN '30대'
            ELSE '30대 이상'
       END CASE3;
       
SELECT STR_TO_DATE('2024-04-21', '%Y-%m-%d') CONV1; -- 'YYYY-MM-DD'

/* 1. 2019년 1분기(QUARTER 함수 사용) 개봉 영화 중 
 관객수가 10만 이상인 영화의 
 월별, 영화 유형별 관객 소계를 구하는 쿼리 */

SELECT month(release_date) as 월별, movie_type, sum(audience) as 관객수,
	IF(GROUPING(movie_type) = 1, '소계', movie_type)  -- grouping 함수는 rollup으로 생성된 그룹화된 데이터의 null이면 1을 return. 값을 구별할 수 있음
FROM movies
WHERE year(release_date)=2019 and quarter(release_date)=1 -- and audience>=100000 
group by movie_type, month(release_date)
with rollup -- group by 했을때, 전체의 소계를 해주는 명령어
order by month(release_date), movie_type;


/* 2. 2019년 개봉 영화 중 매출액이 천만 원 이상인 영화의 월별(MONTH), 
	영화 유형별 관객 소계를 구하되
	7월 1일 전에 개봉한 영화이면 상반기,
	7월 1일 이후에 개봉한 영화이면 하반기라고 함께 출력하는 쿼리 */
-- SELECT CASE month(release_date) 
-- 		when month(release_date) between 1 and 6 then '상반기'
-- 		else '하반기'
--     END Half, genre, sum(audience)
-- FROM movies
-- WHERE year(release_date)=2019 and revenue>=10000000
-- group by 
-- 	CASE 
-- 		when month(release_date) between 1 and 6 then '상반기'
-- 		else '하반기' End,
-- 		genre
-- order by Half, genre;


/* 3. 부제가 있는 영화 찾기 ':' 2015년 이후의 개봉영화 중에서 
부제가 달려있는 영화의 개수 세어보기 */


/* 4. 감독이 두 명 이상이면 슬래시(/)로 이어져 있습니다(예, ‘홍길동/김감독’). 감독이 1명이면 그대로, 
   두 명 이상이면 / 대신 , 값으로 대체해(예, ‘홍길동,김감독’) 출력하는 쿼리를 작성해 보세요. */
