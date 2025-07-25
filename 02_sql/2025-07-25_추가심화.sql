/* 
1. 스토어드 프로시저(Stored Procedure)
- SQL에서 프로그래밍이 가능해 주는 서버의 기능
- 자주 사용하는 여러개의 SQL문을 한데 묶어 함수처럼 만들어 일괄적으로 처리하는 용도로 사용됩니다.
- 첫 행과 마지막 행에 구분문자라는 의미의 
    DELIMITER ~ DELIMITER 문으로 감싼 후 사이에 BEGIN과 END 사이에 SQL문을 넣습니다.
- DELIMITER에는 $$ // && @@ 등의 부호를 구분문자로 많이 사용합니다.
- 위와 같이 작성해놓으면 CALL 프로시저명(); 으로 위의 SQL 묶음을 호출할 수 있습니다.

- 장점
    - 하나의 요청으로 여러 SQL문을 실행 할 수 있습니다.
    - 독립적으로 실행됩니다. SELECT 문이나 다른 SQL 문에서 직접 사용할 수 없습니다.
    - 데이터베이스 상태를 변경할 수 있습니다. INSERT, UPDATE, DELETE 문을 사용할 수 있습니다.
    - 네트워크 소요 시간을 줄일 수 있습니다.
        - 긴 여러개의 쿼리를 SP를 이용해서 구현한다면 SP를 호출할 때
          한 번만 네트워크를 경유하기 때문에 네트워크 소요시간을 줄이고 성능을 개선할 수 있습니다.
    - 개발 업무를 구분해 개발 할 수 있습니다.
        - 순수한 애플리케이션만 개발하는 조직과 DBMS 관련 코드를 개발하는 조직이 따로 있다면,
          DBMS 개발하는 조직에서는 데이터베이스 관련 처리하는 SP를 만들어 API처럼 제공하고 
          애플리케이션 개발자는 SP를 호출해서 사용하는 형식으로 역할을 구분한 개발이 가능합니다.
          
          SHOW PROCEDURE STATUS; -- 프로시저 목록 확인
		  SHOW CREATE PROCEDURE film_not_in_stock; -- 프로시저 내용 확인
		  DROP PROCEDURE 프로시저이름; -- 프로시저 삭제
		  CALL 프로시저이름(변수1, 변수2, 변수3);
*/
SELECT * FROM fisa.emp;
-- SET @변수이름 = 변수의 값; -- 변수 선언 및 값 대입
-- SELECT @변수이름; -- 변수의 값 출력

SET @count = 1000;
SELECT @count;

SELECT sal 
FROM fisa.emp
LIMIT 5; 

SELECT sal 
FROM fisa.emp
LIMIT @count; 

SELECT code, name, continent, region, population
  FROM world.country
 WHERE population > 100000000
ORDER BY @count DESC; 
 
SET @count = 5;

PREPARE mySQL FROM 'SELECT code, name, continent, region, population
  FROM world.country
 WHERE population > 100000000
 ORDER BY 1 ASC
 LIMIT ?';
 
EXECUTE mySQL USING @count;

-- 여러개의 쿼리문을 절차대로 실행해야 합니다. 
CALL sakila.film_in_stock(1, 1);


select count(*) from fisa.emp WHERE year(hiredate) < 1982;
-- 잠깐 마침표 대신 //를 사용할거야. // $$ 
-- 82년보다 먼저 입사한 사람의 수를 리턴하는 프로시저 
SHOW PROCEDURE STATUS;
USE fisa;
-- DELIMITER 구분자 앞뒤로는 아무것도 작성하지 않습니다.
DELIMITER // 

CREATE PROCEDURE employees_hireyear(IN target_year INT, OUT emloyee_count INT)
BEGIN
  select count(*) INTO emloyee_count from fisa.emp WHERE year(hiredate) < target_year;
END //

DELIMITER ;

CALL employees_hireyear(1985, @emloyee_count);

SELECT @emloyee_count;
select count(*) from fisa.emp WHERE year(hiredate) < 1985;

CALL employees_hireyear('2000', @emloyee_count);

-- OUT 매개변수를 저장할 변수를 선언합니다.



-- 저장 프로시저를 호출합니다.

SHOW PROCEDURE STATUS; -- 프로시저 목록 확인
SHOW CREATE PROCEDURE employees_hireyear; -- 프로시저 내용 확인
DROP PROCEDURE employees_hireyear; -- 프로시저 삭제
-- 결과를 확인합니다.

-- IF 문을 사용한 스토어드 프로시저: 
-- emp 테이블을 활용하여 hiredate가 입력받은 값보다 이전인 직원들의 수를 세는 스토어드 프로시저 예제를 만들어보세요.
-- procedure 이름은 employees_hireyear로 지정합니다.
-- employee_count > 10 '명예퇴직 기간' else 'OKAY'
USE fisa;
-- DELIMITER 구분자 앞뒤로는 아무것도 작성하지 않습니다.
DELIMITER // 

CREATE PROCEDURE employees_hireyear2(IN target_year INT, OUT emloyee_count INT, OUT status_message VARCHAR(10))
BEGIN
  -- emloyee_count를 계산하는 쿼리 1.
  select count(*) INTO emloyee_count 
  from fisa.emp 
  WHERE year(hiredate) < target_year;
  
  -- emloyee_count의 결과를 조건삼아 status를 바꿉니다.
  IF emloyee_count > 10 THEN
	SET status_message = '명예퇴직 기간';
  ELSE
	SET status_message = 'OKAY';
  END IF;
END //

DELIMITER ;

CALL employees_hireyear2(1981, @emloyee_count, @status1);

SELECT @emloyee_count;
SELECT @status1;

select count(*) from fisa.emp WHERE year(hiredate) < 1985;

CALL employees_hireyear('2000', @emloyee_count);
SELECT * FROM fisa.emp;
USE fisa;

/* 
2. SQL 함수
- 프로시저는 db로 결과를 반환하고, 함수는 쿼리문 안으로 결과를 반환합니다. 
- 특정 작업을 수행하고 값을 반환하는 데 사용됩니다.
- 항상 값을 반환합니다. 단일 값 또는 테이블 형식의 값을 반환할 수 있습니다.
- SELECT 문, WHERE 절, JOIN 절 등에서 사용할 수 있습니다.
- 데이터베이스 상태를 변경할 수 없습니다. 즉, INSERT, UPDATE, DELETE 문을 사용할 수 없습니다.

	DELIMITER //

	CREATE FUNCTION function_name(parameter_name parameter_type, ...)
	RETURNS return_type
	DETERMINISTIC  -- 함수가 동일한 입력에 대해 항상 동일한 출력을 반환함을 나타냅니다.
	BEGIN
		-- 변수 선언
		DECLARE variable_name variable_type;

		-- 함수 로직
		-- 예: SELECT ... INTO variable_name FROM ... WHERE ...;

		-- 반환 값
		RETURN variable_name;
	END //

	DELIMITER ;

SELECT sakila.inventory_in_stock(2);
-- inventory_id가 1인 경우 재고 여부를 확인합니다.
-- 이 구문을 실행하면 inventory_id가 1인 경우 재고에 있는지 여부를 확인할 수 있습니다.
-- 결과는 1(재고 있음) 또는 0(재고 없음)으로 표시됩니다.

*/
USE fisa;

DELIMITER // 

CREATE FUNCTION employees_hireyear()
RETURNS INT -- 리턴받을 자료형 
DETERMINISTIC -- 입력에 따라 같은 로직을 사용한 결과 출력하겠다 
BEGIN
	DECLARE employee_count INT;
	select count(*) INTO employee_count 
    from fisa.emp WHERE year(hiredate) < 1985;
    RETURN employee_count;
END //

DELIMITER ;

-- SQL 함수는 테이블로 결과를 돌려주기 때문에 조회, 검색에 사용할 수 있다.
SELECT ename, year(hiredate), employees_hireyear() AS 기준인원
FROM emp
ORDER BY 2;

USE fisa;
-- employees_hireyear2를 sql함수로 변환. 
-- return은 status_message만 받습니다.
DELIMITER $$ 

CREATE FUNCTION employees_hireyear2(target_year INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	DECLARE emloyee_count INT;
    DECLARE status_message VARCHAR(10);
    
  -- emloyee_count를 계산하는 쿼리 1.
  select count(*) INTO emloyee_count 
  from fisa.emp 
  WHERE year(hiredate) < target_year;
  
  -- emloyee_count의 결과를 조건삼아 status를 바꿉니다.
  IF emloyee_count > 10 THEN
	SET status_message='명예퇴직 기간';
  ELSE
	SET status_message='OKAY';
  END IF;
  
  RETURN status_message;
END $$ 

DELIMITER ;

SELECT ename, year(hiredate), employees_hireyear2(1984) AS 현재상황
FROM emp
ORDER BY 2;
-- ?? 함수를 호출하여 결과를 확인합니다.

### employees_hiredate2를 변경해서 아래와 같이 
## 각 행의 hiredate 상태에 따라 다른 결과를 return 하는 employees_hiredate3 만들기 
USE fisa;


DELIMITER $$

CREATE FUNCTION employees_hireyear3(hire_date INT, target_year INT) 
RETURNS varchar(10) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
	DECLARE emloyee_count INT;
    DECLARE status_message VARCHAR(10);
    
  -- hire_date와 target_year를 비교한 결과를 조건삼아 status를 바꿉니다.
  IF hire_date < target_year THEN
	SET status_message='명예퇴직 대상';
  ELSE
	SET status_message='OKAY';
  END IF;
  
  RETURN status_message;
END $$

DELIMITER ;

SELECT
  empno,
  ename,
  YEAR(hiredate) AS 입사년도,
  employees_hireyear3(YEAR(hiredate), 1987) AS 상태
FROM emp
ORDER BY 3 DESC;
select employees_hireyear3(1987, 1984);

-- 또는 sql 함수의 동작결과를 sql변수에 넣어서 사용할 수도 있습니다.
SET @hire_status = employees_hireyear3(1924, 1984);
SELECT @hire_status;




/* 
3. TRIGGER
- 사전적 의미로 '방아쇠'라는 뜻으로, 
  MySQL에서 트리거는 테이블에서 어떤 이벤트가 발생했을 때 자동으로 실행됩니다.
- 즉, 어떤 테이블에서 특정한 이벤트(update, insert, delete)가 발생했을 때, 
  실행시키려는 추가 쿼리 작업들을 자동으로 수행할 수 있게끔 트리거를 미리 설정해 두는 것입니다. 
- 트리거는 직접 실행시킬 수 없고 오직 해당 테이블에 이벤트가 발생할 경우에만 실행됩니다. 
- DML에만 작동되며, MySQL에서는 VIEW에는 트리거를 사용할 수 없습니다.

	DELIMITER $$

	CREATE TRIGGER 트리거이름
		AFTER DELETE -- 트리거를 달 동작
		ON 테이블 FOR EACH ROW
	BEGIN
		-- 문장
	END $$    

	DELIMITER ;

- BEFORE/AFTER는 명령 키워드가 사용된 후에 처리할지 아니면 끝난 후 처리할지를 나타냅니다.
- 또한 처리할 내용 부분에서 OLD, NEW로 명령 키워드로 변경되는 테이블에 접근할 수 있습니다.
    - ( OLD : 변경되기 전 테이블, NEW : 변경된 후 테이블 )
- 프로시저는 특정 경우에만 동작시킨다면, 트리거는 매번 DML이 실행될 때마다 동작합니다.
- truncate는 commit까지 완료되므로 trigger를 부착할 수 없습니다.

*/

CREATE DATABASE market;
USE market;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
    email VARCHAR(30)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATETIME,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE backup_order (
    backup_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    product_id INT,
    order_date DATETIME,
    quantity INT
);

INSERT INTO customers (name, email) VALUES 
('김철수', 'chulsoo.kim@example.com'),
('박영희', 'younghee.park@example.com'),
('이민수', 'minsoo.lee@example.com');

INSERT INTO products (name, price) VALUES 
('노트북', 1200.00),
('스마트폰', 800.00),
('헤드폰', 150.00);

INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES 
(1, 1, '2024-07-21 10:30:00', 1),
(2, 3, '2024-07-21 11:00:00', 2),
(3, 2, '2024-07-21 11:30:00', 1);

SHOW TRIGGERS;
USE market;
DROP TRIGGER IF EXISTS test_trg;

-- 트리거 작성
DELIMITER //

-- @msg 
CREATE TRIGGER test_trg -- 트리거 이름
	AFTER DELETE -- 트리거가 동작할 순서 작업 
	ON orders -- ON 트리거를 부탁할 테이블명
	FOR EACH ROW -- 각 행에 대해서 적용해
BEGIN
	SET @msg = '주문정보 삭제';
END // 

DELIMITER ;


-- 트리거 확인

SELECT * FROM orders;

DELETE FROM market.orders WHERE order_id=3;

SELECT @msg;

SHOW TRIGGERS LIKE 'orders'; -- 테이블에 부착 
DROP TABLE IF EXISTS backup_order;

CREATE TABLE backup_order
	(backup_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    product_id INT,
    order_date DATETIME,
    cancel_date DATETIME,
    quantity INT);

DROP TRIGGER IF EXISTS backtable_update_trg;
-- 트리거 작성
DELIMITER //

-- @msg 
CREATE TRIGGER backtable_update_trg -- 트리거 이름
	AFTER DELETE -- 트리거가 동작할 순서 작업 
	ON orders -- ON 트리거를 부탁할 테이블명
	FOR EACH ROW -- 각 행에 대해서 적용해
BEGIN
	-- backup_order 테이블에 order 테이블에 있던(OLD.컬럼) 값을 넣습니다. 
    INSERT INTO backup_order (order_id, customer_id, product_id, order_date,
			cancel_date, quantity)
		VALUES (OLD.order_id, OLD.customer_id, OLD.product_id, OLD.order_date, NOW(), OLD.quantity);
END // 

DELIMITER ;


-- 트리거 확인

SELECT * FROM orders;
SELECT * FROM backup_order;

DELETE FROM market.orders WHERE order_id=2;
show triggers;

USE market;
SELECT * FROM products;

-- stock 재고가 0이 되면 stock_status 컬럼이 '재고없음'으로 바뀌는 트리거 
ALTER TABLE products ADD COLUMN stock INT DEFAULT 0;
ALTER TABLE products ADD COLUMN stock_status VARCHAR(20) DEFAULT '재고없음';
UPDATE products SET stock=10, stock_status='재고있음' WHERE name='노트북';
SELECT * FROM products;

DELIMITER // 

CREATE TRIGGER trg_update_stock_status
BEFORE UPDATE ON products 
FOR EACH ROW
BEGIN
	IF NEW.stock = 0 THEN
		SET NEW.stock_status = '재고없음';
	ELSE
		SET NEW.stock_status = '재고있음';
	END IF;
END // 

DELIMITER ; 
SHOW TRIGGERS;

USE market;
UPDATE products SET stock=0 WHERE name='노트북';
SELECT * FROM products;
-- 트리거 때문에 동작한 건가요? DEFAULT 값 때문에 동작한 건가요?
DESC products;
INSERT INTO products (name, price, stock) VALUES (4, '마우스', 0);

-- 트리거는 디버깅이 까다롭습니다. 직접 실행 불가. 


USE fisa;

SHOW TRIGGERS;
DROP TRIGGER before_emp_trg;

DELIMITER //

CREATE TRIGGER before_emp_trg
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.ename) > 20 THEN
        SET NEW.ename = LEFT(NEW.ename, 20);
    END IF;
END//


DELIMITER ;

# 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

SET @@SESSION.sql_mode = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELETE FROM emp WHERE empno > 100000;
INSERT INTO emp VALUES (199997, 'ALLENNNNdddddddddddddddddddddNNNNNNNN', 'MANAGER', NULL, now(), 0, 0, 20);
select * from emp;
-- 글자수를 넘어가는 데이터에 대한 처리, 자료형 문제 
-- 테이블단에 DEFAULT, CHECK, 자료형으로 미리 정해주시거나 
-- DB에 값을 넣는 코드단에서 처리해주는 것이 훨씬 좋은 방법입니다. 

