SELECT * FROM box_office.movies LIMIT 10;
CREATE DATABASE box_office2;

USE box_office2;

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title TEXT,
    director TEXT,
    release_date DATE,
    movie_type TEXT,
    country TEXT,
    screens INT,
    revenue DOUBLE,
    audience BIGINT,
    genre TEXT,
    rating TEXT
);

ALTER TABLE box_office2.movies MODIFY movie_id INT AUTO_INCREMENT;

CREATE TABLE productions (
    production_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE 
);
ALTER TABLE productions ADD CONSTRAINT unique_production_name UNIQUE (name);

CREATE TABLE importers (
    importer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE distributors (
    distributor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE movie_production (
    movie_id INT,
    production_id INT,
    PRIMARY KEY (movie_id, production_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (production_id) REFERENCES productions(production_id)
);

CREATE TABLE movie_importer (
    movie_id INT,
    importer_id INT,
    PRIMARY KEY (movie_id, importer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (importer_id) REFERENCES importers(importer_id)
);

CREATE TABLE movie_distributor (
    movie_id INT,
    distributor_id INT,
    PRIMARY KEY (movie_id, distributor_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (distributor_id) REFERENCES distributors(distributor_id)
);

-- 데이터 삽입
INSERT INTO movies VALUES 
(1, '명량', '김한민', '2014-07-30', '장편', '한국', 1587, 135748398910, 17613682, '사극', '15세이상관람가'),
(2, '극한직업', '이병헌', '2019-01-23', '장편', '한국', 1978, 139647979516, 16264944, '코미디', '15세이상관람가'),
(3, '신과함께-죄와 벌', '김용화', '2017-12-20', '장편', '한국', 1912, 115698654137, 14410754, '판타지', '12세이상관람가');


INSERT INTO productions (name) VALUES
('(주)빅스톤픽쳐스'),
('(주)어바웃잇'),
('영화사 해그림 주식회사'),
('(주)씨제이이엔엠'),
('리얼라이즈픽쳐스(주)'),
('(주)덱스터스튜디오');

-- 명량
INSERT INTO movie_production VALUES (1, 1);

-- 극한직업
INSERT INTO movie_production VALUES (2, 2), (2, 3), (2, 4);

-- 신과함께
INSERT INTO movie_production VALUES (3, 5), (3, 6);

INSERT INTO distributors (name) VALUES
('(주)씨제이이엔엠'),
('롯데쇼핑㈜롯데엔터테인먼트');

INSERT INTO movie_distributor VALUES
(1, 1),
(2, 1),
(3, 2);

-- ① 각 영화별 제작사 목록 확인
SELECT 
    m.title, p.name AS production_company
FROM movies m
JOIN movie_production mp ON m.movie_id = mp.movie_id
JOIN productions p ON mp.production_id = p.production_id
ORDER BY m.movie_id;

-- ② 영화, 배급사, 관객 수 정보
SELECT 
    m.title,
    d.name AS distributor,
    m.audience
FROM movies m
JOIN movie_distributor md ON m.movie_id = md.movie_id
JOIN distributors d ON md.distributor_id = d.distributor_id;

-- ③ 배급사별 총 관객 수
SELECT 
    d.name AS distributor,
    SUM(m.audience) AS total_audience
FROM movies m
JOIN movie_distributor md ON m.movie_id = md.movie_id
JOIN distributors d ON md.distributor_id = d.distributor_id
GROUP BY d.name
ORDER BY total_audience DESC;

-- 4위 영화 추가
-- 영화
INSERT INTO movies (title, director, release_date, movie_type, country, screens, revenue, audience, genre, rating)
VALUES ('국제시장', '윤제균', '2014-12-17', '장편', '한국', 966, 110828014630, 14245998, '드라마', '12세이상관람가');

-- 제작사 (중복되지 않았다면)
INSERT IGNORE INTO productions (name) VALUES ('(주)제이케이필름'), ('(주)씨제이이엔엠');

-- 배급사
INSERT IGNORE INTO distributors (name) VALUES ('(주)씨제이이엔엠');
SELECT * FROM distributors;

-- 관계 (movie_id는 방금 INSERT된 ID 기준)
SELECT @movie_id;

SET @movie_id := LAST_INSERT_ID();
INSERT INTO movie_production (movie_id, production_id)
SELECT @movie_id, production_id FROM productions WHERE name IN ('(주)제이케이필름', '(주)씨제이이엔엠');
SELECT * FROM movie_production;

SELECT * FROM productions;
INSERT INTO movie_distributor (movie_id, distributor_id)
SELECT @movie_id, distributor_id FROM distributors WHERE name = '(주)씨제이이엔엠';
SELECT * FROM movie_distributor;
SELECT * FROM distributors;

-- 5위 영화 추가
-- 영화
INSERT INTO movies (title, director, release_date, movie_type, country, screens, revenue, audience, genre, rating)
VALUES ('어벤져스: 엔드게임', '안소니 루소,조 루소', '2019-04-24', '장편', '미국', 2835, 122182694160, 13934592, '액션', '12세이상관람가');

-- 제작사 없음
-- 수입사 및 배급사
INSERT IGNORE INTO distributors (name) VALUES ('월트디즈니컴퍼니코리아 유한책임회사'); -- 중복값이거나 제약조건 위반시 무시하고 넘어가기
INSERT IGNORE INTO importers (name) VALUES ('월트디즈니컴퍼니코리아 유한책임회사');

SELECT * FROM movie_distributor;
SELECT * FROM distributors;
-- 관계
SET @movie_id := LAST_INSERT_ID();
SELECT @movie_id;
INSERT INTO movie_distributor (movie_id, distributor_id)
SELECT @movie_id, distributor_id FROM distributors WHERE name = '월트디즈니컴퍼니코리아 유한책임회사';

-- 트랜잭션 기반 작업
SELECT @@autocommit;
SET @@autocommit = 0;
SELECT @@autocommit;

START TRANSACTION;

-- 1. 영화 등록
INSERT INTO movies (title, director, release_date, movie_type, country, screens, revenue, audience, genre, rating)
VALUES ('겨울왕국 2', '크리스 벅,제니퍼 리', '2019-11-21', '장편', '미국', 2648, 114810421450, 13747792, '애니메이션', '전체관람가');

-- 2. 제작사 등록 (있다고 가정)
INSERT IGNORE INTO productions (name)
VALUES ('월트디즈니컴퍼니코리아 유한책임회사');

-- 3. 배급사 등록
INSERT IGNORE INTO distributors (name)
VALUES ('월트디즈니컴퍼니코리아 유한책임회사');

-- 4. 관계 등록
SET @movie_id := LAST_INSERT_ID();

-- 제작사 관계
INSERT INTO movie_production (movie_id, production_id)
SELECT @movie_id, production_id
FROM productions
WHERE name = '월트디즈니컴퍼니코리아 유한책임회사'; -- '월트디즈니컴퍼니코리아 유한책임회사2'; 로 변경해보기

-- 배급사 관계
INSERT INTO movie_distributor (movie_id, distributor_id)
SELECT @movie_id, distributor_id
FROM distributors
WHERE name = '월트디즈니컴퍼니코리아 유한책임회사';

COMMIT;

SET @@autocommit=1;
SELECT @@autocommit;

-- 프로시저 작성 및 사용
DELIMITER //

CREATE PROCEDURE insert_movie_with_metadata (
    IN p_title TEXT,
    IN p_director TEXT,
    IN p_release_date DATE,
    IN p_movie_type TEXT,
    IN p_country TEXT,
    IN p_screens INT,
    IN p_revenue DOUBLE,
    IN p_audience BIGINT,
    IN p_genre TEXT,
    IN p_rating TEXT,
    IN p_productions TEXT,     -- 쉼표로 구분된 제작사
    IN p_distributors TEXT     -- 쉼표로 구분된 배급사
)
BEGIN
  DECLARE exit handler FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
  END;

  START TRANSACTION;

  -- 1. 영화 정보 삽입
  INSERT INTO movies (
    title, director, release_date, movie_type, country,
    screens, revenue, audience, genre, rating
  ) VALUES (
    p_title, p_director, p_release_date, p_movie_type, p_country,
    p_screens, p_revenue, p_audience, p_genre, p_rating
  );

  SET @movie_id := LAST_INSERT_ID();

  -- 2. 제작사 등록 및 관계 설정
  WHILE LENGTH(p_productions) > 0 DO
    SET @idx := LOCATE(',', p_productions);
    IF @idx > 0 THEN
      SET @name := TRIM(SUBSTRING(p_productions, 1, @idx - 1));
      SET p_productions := SUBSTRING(p_productions, @idx + 1);
    ELSE
      SET @name := TRIM(p_productions);
      SET p_productions := '';
    END IF;

    INSERT IGNORE INTO productions (name) VALUES (@name);
    INSERT INTO movie_production (movie_id, production_id)
    SELECT @movie_id, production_id FROM productions WHERE name = @name;
  END WHILE;

  -- 3. 배급사 등록 및 관계 설정
  WHILE LENGTH(p_distributors) > 0 DO
    SET @idx := LOCATE(',', p_distributors);
    IF @idx > 0 THEN
      SET @name := TRIM(SUBSTRING(p_distributors, 1, @idx - 1));
      SET p_distributors := SUBSTRING(p_distributors, @idx + 1);
    ELSE
      SET @name := TRIM(p_distributors);
      SET p_distributors := '';
    END IF;

    INSERT IGNORE INTO distributors (name) VALUES (@name);
    INSERT INTO movie_distributor (movie_id, distributor_id)
    SELECT @movie_id, distributor_id FROM distributors WHERE name = @name;
  END WHILE;

  COMMIT;
END //

DELIMITER ;

CALL insert_movie_with_metadata(
  '아바타',
  '제임스 카메론',
  '2009-12-17',
  '장편',
  '미국',
  912,
  128447097523,
  13624328,
  'SF',
  '12세이상관람가',
  '이십세기폭스필름코퍼레이션',
  '주식회사 해리슨앤컴퍼니,이십세기폭스코리아(주)'
);

CALL insert_movie_with_metadata('베테랑', '류승완', '2015-08-05', '장편', '한국', 1064, 105024756250, 13395400, '액션', '15세이상관람가');
select * from box_office2.movies;

SELECT * FROM productions;
SELECT * FROM importers;
SELECT * FROM distributors;
/* 
-- 예시: movies
INSERT INTO movies (movie_id, title, director, release_date, movie_type, country, screens, revenue, audience, genre, rating) VALUES
(1, '명량', '김한민', '2014-07-30', '장편', '한국', 1587, 135748398910, 17613682, '사극', '15세이상관람가'),
(2, '극한직업', '이병헌', '2019-01-23', '장편', '한국', 1978, 139647979516, 16264944, '코미디', '15세이상관람가'),
(3, '신과함께-죄와 벌', '김용화', '2017-12-20', '장편', '한국', 1912, 115698654137, 14410754, '판타지', '12세이상관람가'),
(4, '국제시장', '윤제균', '2014-12-17', '장편', '한국', 966, 110828014630, 14245998, '드라마', '12세이상관람가'),
(5, '어벤져스: 엔드게임', '안소니 루소,조 루소', '2019-04-24', '장편', '미국', 2835, 122182694160, 13934592, '액션', '12세이상관람가'),
(6, '겨울왕국 2', '크리스 벅,제니퍼 리', '2019-11-21', '장편', '미국', 2648, 114810421450, 13747792, '애니메이션', '전체관람가'),
(7, '아바타', '제임스 카메론', '2009-12-17', '장편', '미국', 912, 128447097523, 13624328, 'SF', '12세이상관람가'),
(8, '베테랑', '류승완', '2015-08-05', '장편', '한국', 1064, 105024756250, 13395400, '액션', '15세이상관람가'),
(9, '서울의 봄', '김성수', '2023-11-22', '장편', '한국', 2328, 127926951712, 13128080, '드라마', '12세이상관람가'),
(10, '괴물', '봉준호', '2006-07-27', '장편', '한국', 0, NULL, 13019740, 'SF', '12세관람가');

-- 예시: productions (중복 제거 후 입력)
INSERT INTO productions (name) VALUES
('(주)빅스톤픽쳐스'), ('(주)어바웃잇'), ('영화사 해그림 주식회사'),
('(주)씨제이이엔엠'), ('리얼라이즈픽쳐스(주)'), ('(주)덱스터스튜디오'),
('(주)제이케이필름'), ('월트디즈니컴퍼니코리아 유한책임회사'),
('이십세기폭스필름코퍼레이션'), ('(주)외유내강'), ('(주)필름케이'),
('(주)하이브미디어코프'), ('영화사청어람(주)');

-- 예시: distributors
INSERT INTO distributors (name) VALUES
('(주)씨제이이엔엠'), ('롯데쇼핑㈜롯데엔터테인먼트'), ('월트디즈니컴퍼니코리아 유한책임회사'),
('이십세기폭스코리아(주)'), ('메가박스중앙(주) 플러스엠 엔터테인먼트'), ('(주)쇼박스');

-- 예시: movie_production 관계
-- (movie_id, production_id)
INSERT INTO movie_production VALUES 
(1, 1),
(2, 2), (2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7), (4, 4),
(5, 8),
(6, 8),
(7, 9),
(8, 10), (8, 11),
(9, 12),
(10, 13);

-- 예시: movie_distributor 관계
-- (movie_id, distributor_id)
INSERT INTO movie_distributor VALUES 
(1, 1), (2, 1),
(3, 2),
(4, 1),
(5, 3), (6, 3),
(7, 4),
(8, 1),
(9, 5),
(10, 6);
*/

-- 전체 출력
SELECT 
    m.movie_id,
    m.title,
    m.director,
    GROUP_CONCAT(DISTINCT p.name SEPARATOR ', ') AS productions,
    GROUP_CONCAT(DISTINCT i.name SEPARATOR ', ') AS importers,
    GROUP_CONCAT(DISTINCT d.name SEPARATOR ', ') AS distributors,
    m.release_date,
    m.movie_type,
    m.country,
    m.screens,
    m.revenue,
    m.audience,
    m.genre,
    m.rating
FROM movies m
-- 제작사
LEFT JOIN movie_production mp ON m.movie_id = mp.movie_id
LEFT JOIN productions p ON mp.production_id = p.production_id
-- 수입사
LEFT JOIN movie_importer mi ON m.movie_id = mi.movie_id
LEFT JOIN importers i ON mi.importer_id = i.importer_id
-- 배급사
LEFT JOIN movie_distributor md ON m.movie_id = md.movie_id
LEFT JOIN distributors d ON md.distributor_id = d.distributor_id
GROUP BY
    m.movie_id,
    m.title,
    m.director,
    m.release_date,
    m.movie_type,
    m.country,
    m.screens,
    m.revenue,
    m.audience,
    m.genre,
    m.rating
ORDER BY m.movie_id;
