create database IF NOT EXISTS practice;
use practice;

CREATE TABLE `GENRE` (
  `genre_id` BIGINT NOT NULL,
  `genre_name` VARCHAR(30) NULL,
  PRIMARY KEY (`genre_id`)
);

CREATE TABLE `RATING` (
  `rating_id` BIGINT NOT NULL,
  `rating_name` VARCHAR(30) NULL,
  PRIMARY KEY (`rating_id`)
);


CREATE TABLE `MOVIE` (
  `seq_id` INT NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `release_date` DATE NULL,
  `movie_type` ENUM('feature', 'short', 'documentary') NULL,
  `country` VARCHAR(50) NULL,
  `screens` INT NULL,
  `revenue` BIGINT NULL,
  `audience` BIGINT NULL,
  `genre_id` BIGINT NOT NULL,
  `rating_id` BIGINT NOT NULL,
  PRIMARY KEY (`seq_id`),
  CONSTRAINT `FK_GENRE_TO_MOVIE_1` FOREIGN KEY (`genre_id`) REFERENCES `GENRE` (`genre_id`),
  CONSTRAINT `FK_RATING_TO_MOVIE_1` FOREIGN KEY (`rating_id`) REFERENCES `RATING` (`rating_id`)
);

CREATE TABLE `DIRECTOR` (
  `director_id` INT NOT NULL,
  `director_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`director_id`)
);

CREATE TABLE `PRODUCTION` (
  `production_id` INT NOT NULL,
  `production_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`production_id`)
);

CREATE TABLE `IMPORTER` (
  `importer_id` INT NOT NULL,
  `importer_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`importer_id`)
);

CREATE TABLE `DIRECTOR_MOVIE` (
  `director_id` INT NOT NULL,
  `seq_id` INT NOT NULL,
  PRIMARY KEY (`director_id`, `seq_id`),
  CONSTRAINT `FK_DIRECTOR_TO_DIRECTOR_MOVIE_1` FOREIGN KEY (`director_id`) REFERENCES `DIRECTOR` (`director_id`),
  CONSTRAINT `FK_MOVIE_TO_DIRECTOR_MOVIE_1` FOREIGN KEY (`seq_id`) REFERENCES `MOVIE` (`seq_id`)
);

CREATE TABLE `IMPORTER_MOVIE` (
  `importer_id` INT NOT NULL,
  `seq_id` INT NOT NULL,
  PRIMARY KEY (`importer_id`, `seq_id`),
  CONSTRAINT `FK_IMPORTER_TO_IMPORTER_MOVIE_1` FOREIGN KEY (`importer_id`) REFERENCES `IMPORTER` (`importer_id`),
  CONSTRAINT `FK_MOVIE_TO_IMPORTER_MOVIE_1` FOREIGN KEY (`seq_id`) REFERENCES `MOVIE` (`seq_id`)
);

CREATE TABLE `PRODUCTION_MOVIE` (
  `production_id` INT NOT NULL,
  `seq_id` INT NOT NULL,
  PRIMARY KEY (`production_id`, `seq_id`),
  CONSTRAINT `FK_PRODUCTION_TO_PRODUCTION_MOVIE_1` FOREIGN KEY (`production_id`) REFERENCES `PRODUCTION` (`production_id`),
  CONSTRAINT `FK_MOVIE_TO_PRODUCTION_MOVIE_1` FOREIGN KEY (`seq_id`) REFERENCES `MOVIE` (`seq_id`)
);

CREATE TABLE `DISTRIBUTOR` (
  `distributor_id` INT NOT NULL,
  `distributor_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`distributor_id`)
);

CREATE TABLE `DISTRIBUTOR_MOVIE` (
  `distributor_id` INT NOT NULL,
  `seq_id` INT NOT NULL,
  PRIMARY KEY (`distributor_id`, `seq_id`),
  CONSTRAINT `FK_DISTRIBUTOR_TO_DISTRIBUTOR_MOVIE_1` FOREIGN KEY (`distributor_id`) REFERENCES `DISTRIBUTOR` (`distributor_id`),
  CONSTRAINT `FK_MOVIE_TO_DISTRIBUTOR_MOVIE_1` FOREIGN KEY (`seq_id`) REFERENCES `MOVIE` (`seq_id`)
);

-- GENRE 테이블 예시 데이터
INSERT INTO GENRE (genre_id, genre_name) VALUES
(1, 'Action'),
(2, 'Drama'),
(3, 'Comedy');

-- RATING 테이블 예시 데이터
INSERT INTO RATING (rating_id, rating_name) VALUES
(1, 'G'),
(2, 'PG-13'),
(3, 'R');

-- MOVIE 테이블 예시 데이터
INSERT INTO MOVIE (seq_id, title, release_date, movie_type, country, screens, revenue, audience, genre_id, rating_id) VALUES
(1001, 'Action Movie 1', '2023-01-15', 'feature', 'USA', 1200, 150000000, 3000000, 1, 2),
(1002, 'Drama Movie 1', '2023-05-20', 'feature', 'UK', 800, 50000000, 1200000, 2, 3),
(1003, 'Comedy Short', '2023-07-10', 'short', 'Canada', 300, 1000000, 50000, 3, 1);

-- DIRECTOR 테이블 예시 데이터
INSERT INTO DIRECTOR (director_id, director_name) VALUES
(10, 'Steven Spielberg'),
(11, 'Christopher Nolan'),
(12, 'Greta Gerwig');

-- PRODUCTION 테이블 예시 데이터
INSERT INTO PRODUCTION (production_id, production_name) VALUES
(20, 'Warner Bros'),
(21, 'Universal Pictures'),
(22, 'Paramount Pictures');

-- IMPORTER 테이블 예시 데이터
INSERT INTO IMPORTER (importer_id, importer_name) VALUES
(30, 'Importer A'),
(31, 'Importer B');

-- DISTRIBUTOR 테이블 예시 데이터
INSERT INTO DISTRIBUTOR (distributor_id, distributor_name) VALUES
(40, 'Distributor X'),
(41, 'Distributor Y');

-- DIRECTOR_MOVIE (연결 테이블) 예시 데이터
INSERT INTO DIRECTOR_MOVIE (director_id, seq_id) VALUES
(10, 1001),
(11, 1002),
(12, 1003);

-- PRODUCTION_MOVIE (연결 테이블) 예시 데이터
INSERT INTO PRODUCTION_MOVIE (production_id, seq_id) VALUES
(20, 1001),
(21, 1002),
(22, 1003);

-- IMPORTER_MOVIE (연결 테이블) 예시 데이터
INSERT INTO IMPORTER_MOVIE (importer_id, seq_id) VALUES
(30, 1001),
(31, 1002);

-- DISTRIBUTOR_MOVIE (연결 테이블) 예시 데이터
INSERT INTO DISTRIBUTOR_MOVIE (distributor_id, seq_id) VALUES
(40, 1001),
(41, 1002),
(40, 1003);

select * FROM director;
select * FROM movie;