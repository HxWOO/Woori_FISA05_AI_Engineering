USE mywork;
DROP TABLE IF EXISTS students;
CREATE TABLE students (
	student_id VARCHAR(10) PRIMARY KEY, -- UNIQUE + NOT NULL
    name VARCHAR(50) NOT NULL UNIQUE, -- 고유한 값만 받겠음, NULL을 허용 
    grade TINYINT UNSIGNED NOT NULL CHECK (grade BETWEEN 1 AND 3) , -- 1~3학년만 허용
    class_name VARCHAR(10) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    age TINYINT UNSIGNED DEFAULT 0, -- NULL 대신 0이 DEFAULT 
    addmision_date DATE NOT NULL
);

#### DML, Data Manipulation Language : 데이터 조작 (삽입, 수정, 삭제 등)
# 삽입(Create): INSERT INTO 테이블명 (컬럼명1, ...) VALUES (실제값들1, ...);
-- ENUM 자료형에서 대소문자는 알아서 변환

INSERT INTO students (
	student_id, name, grade, class_name, gender, age, addmision_date
    ) VALUES (
    'A100002', '신짱아',     3,       '장미', 'm',   NULL, '2025-07-21');

-- PK로 걸어놓은 컬럼을 기준으로 데이터가 정렬됨
INSERT INTO students (
	student_id, name, grade, class_name, gender, addmision_date
    ) VALUES (
    'A100001', '신짱구',     3,       '장미', 'm', '2025-07-21');

-- VARCHAR에 지정한 값보다 큰 값은 들어가지 않음 
INSERT INTO students (
	student_code, name, grade, class_name, gender, addmision_date
    ) VALUES (
    'A1000052222222', '맹구2',     3,       '장미', 'm', '2025-07-21');

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
-- SELECT 컬럼명 FROM DB명.테이블명;
SELECT * FROM students;

-- 와일드카드는 웬만하면 실무에서 사용하지 않는 것이 좋습니다
SELECT * FROM students;
SELECT 
    -- student_id, -- 모든 컬럼을 적고, 정렬해주시면 나중에 재사용하기도 편합니다.
    student_code,
    name,
    grade,
    class_name,
    gender,
    age,
    addmision_date
FROM
    students;