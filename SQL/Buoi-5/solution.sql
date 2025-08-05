-- Temporary View 

CREATE VIEW view_name AS
SELECT ...;

CREATE TEMPORARY VIEW view_name AS
SELECT ...;

-- Cần dùng lại nhiều lần trong phiên làm việc

-- Nhược điểm
-- Chỉ dùng trong phiên hiện tại, và không chia sẻ giữa các phiên.
-- không phù hợp cho các báo cáo, dashbaord, hoặc ứng dụng sử dụng lâu dài
-- Nếu session bị ngắt kết nối, tất cả temporary view sẽ mất.


-- Materialized View: View vật lý
-- Lưu trữ kết quả của một truy vấn dưới dạng vật lý trên đĩa, giống như một bảng tạm thời được cập nhật định kỳ.
-- Không truy vấn dữ liệu gốc mỗi lần gọi, mà trả về dữ liệu đã được "cache" sẵn từ lần cập nhật gần nhất.
-- Để cập nhật dữ liệu mới nhất, phải dùng lệnh REFRESH MATERILIZED VIEW.

-- Khi nào sử dụng 
-- Truy vấn phức tạp, tốn nhiều tài nguyên, dữ liệu không cần cập nhật liên tục
-- Khi cần tăng tốc truy vấn.
-- Khi dữ liệu nguồn thay đổi không quá thường xuyên, chấp nhận độ trễ nhỏ giữa dữ liệu gốc và dữ liệu báo cáo

-- Ưu điểm:
-- Truy vấn nhanh
-- Giảm tải hệ thống: Không phải thực thi lại các phép JOIN
-- Có thể tạo chỉ mục để tăng tốc độ truy vấn

-- Nhược điểm:
-- Dữ liệu lỗi thời: Phải chủ động cập nhật
-- Tốn thêm dung lượng lưu trữ: vì nó lưu trữ như bảng thật
-- Không tự động cập nhật


CREATE MATERIALIZED VIEW view_name AS 
SELECT ...;

-- Tổng hợp số lượng đã bán của từng sản phẩm
CREATE MATERIALIZED VIEW mv_product_sales AS
SELECT
	p.product_id,
	p.product_name,
	SUM(oi.quantity) AS total_sold
FROM 
	products AS p
JOIN ordered_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Truy vấn vào MV
SELECT * FROM mv_product_sales;

-- Cập nhật dữ liệu 
REFRESH MATERIALIZED VIEW mv_product_sales;



-- FUNCTION

CREATE OR REPLACE FUNCTION function_name(
	tham_so_1 Kieu_du_lieu [DEFAULT gia_tri], 
	...
)
RETURNS kieu_tra_ve AS $$
DECLARE
	-- Khai báo các biến cục bộ (nếu cần)
BEGIN
	-- Logic xử lý (IF, LOOP, SELECT, RETURN...)
	RETURN gia_tri_tra_ve
END;
$$ LANGUAGE plpgsql;

-- Tính tổng 2 số nguyên 
-- PL/pgSQL;

CREATE OR REPLACE FUNCTION add_numbers(
	a FLOAT, b FLOAT
)
RETURNS INT AS $$
BEGIN 
	RETURN a + b;
END;
$$ LANGUAGE plpgsql;

SELECT add_numbers(1.2, 2.3);

-- Đảo ngược chuỗi
CREATE OR REPLACE FUNCTION reverse_function(input TEXT)
RETURNS TEXT AS $$
DECLARE
	i INTEGER;
	output TEXT := '';
BEGIN
	FOR i IN REVERSE LENGTH(input)..1 LOOP
		output := output || SUBSTRING(input, i, 1);
	END LOOP;
	RETURN output;
END;
$$ LANGUAGE plpgsql;

SELECT reverse_function('abcdefghijk');


-- INPUT: product_id
-- Kiểm tra sản phẩm tồn kho thấp, trung bình hay cao.
-- OUTPUT: 'Low' < 50, 'Medium' từ 50 đến 100, 'High' > 100

CREATE OR REPLACE FUNCTION check_stock_level(pid INT)
RETURNS TEXT AS $$
DECLARE
	stock INT;
BEGIN
	SELECT units_in_stock INTO stock FROM products WHERE product_id = pid;
	IF stock IS NULL THEN
		RETURN 'Product not found!';
	ELSIF stock < 50 THEN
		RETURN 'Low';
	ELSIF stock <= 100 THEN
		RETURN 'Medium';
	ELSE
		RETURN 'High';
	END IF;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM products;

SELECT check_stock_level(1005); -- 'High'
SELECT check_stock_level(1009); -- 'Low'
SELECT check_stock_level(9999); -- 'Product not found'

-- Stored Procedure (Procedure hoặc SP)
-- Là một tập hợp các lệnh SQL được lưu trữ trong cơ sở dữ liệu.
-- Thực hiện một hay nhiều thao tác logic phức tạp

-- Tại sao sử dụng Stored Procedure?
-- Tái sử dụng mã
-- Hiệu suất: khi một stored procedure được thực thi lần đầu tiên, postgresql sẽ biên dịch nó, và các lần sau nó sẽ sử dụng bản đã biên dịch rồi.
-- Bảo mật: Cấp quyền thực thi procedure mà không cần phải cấp quyền trực tiếp vào bảng cơ sở dữ liệu.
-- Tính toàn vẹn dữ liệu: Gói gọn logic nghiệp vụ trong procedure, đảm bảo nhất quán, tuân thủ quy tắc nghiệp vụ.
-- Giảm lưu lượng mạng
-- Quản lý giao dịch.

CREATE [OR REPLACE] PROCEDURE procedure_name (
	param1 data_type [DEFAULT ...],
	IN param2 data_type [DEFAULT ...],
	OUT param3 data_type [DEFAULT ...],
	INOUT param4 data_type [DEFAULT ...],
	...
)
LANGUAGE plpgsql
AS $$
DECLARE [optional]

BEGIN
	-- Chứa các lệnh SQL và logic chính
	-- COMMIT, ROLLBACK
END;
$$;


-- Thêm một sản phẩm mới vào bảng products
INSERT INTO products (product_id, product_name, units_in_stock, sale_price)
VALUES (1, 'Coke', 50, 2.0);

CREATE OR REPLACE PROCEDURE add_product(
	p_id INT,
	p_name VARCHAR,
	p_stock INT,
	p_price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO products (product_id, product_name, units_in_stock, sale_price)
	VALUES (p_id, p_name, p_stock, p_price);
END;
$$;

CALL add_product(1011, 'Lemon Tart', 50, 3.75);

SELECT * FROM products;

-- Cập nhật giá bá ncho sản phẩm theo product_id.
UPDATE products
SET sale_price = ...
WHERE product_id = ...


CREATE OR REPLACE PROCEDURE update_product_price(
	p_id INT,
	new_price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE products SET sale_price = new_price WHERE product_id = p_id;
END;
$$;

CALL update_product_price(1011, 4.0);
SELECT * FROM products;

-- Quản lý tồn kho sản phẩm với giao dịch xuất/nhập kho

CREATE TABLE product_transactions (
	transaction_id SERIAL PRIMARY KEY,
	product_id INTEGER NOT NULL,
	transaction_type VARCHAR(10) NOT NULL, -- 'IN' và 'OUT'
	quantity INTEGER NOT NULL,
	transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
	note TEXT
);

CREATE OR REPLACE PROCEDURE process_product_transaction(
	IN p_product_id INT,
	IN p_type VARCHAR,
	IN p_quantity INT,
	IN p_note TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE 
	current_stock INT;
BEGIN
	SELECT units_in_stock INTO current_stock FROM products WHERE product_id = p_product_id FOR UPDATE;

	IF p_type = 'OUT' THEN -- San pham khong ton tai, khong du so luong san pham
		IF current_stock IS NULL THEN 
			RAISE EXCEPTION 'Product does not exist!';
		ELSIF current_stock < p_quantity THEN
			RAISE EXCEPTION 'Not enough stock! Transaction cancelled';
		END IF;
		-- Trừ tồn kho khi không xảy ra lỗi
		UPDATE products SET units_in_stock = units_in_stock - p_quantity WHERE product_id = p_product_id;
	ELSIF p_type = 'IN' THEN
		-- Cộng tồn kho vào bảng products
		UPDATE products SET units_in_stock = units_in_stock + p_quantity WHERE product_id = p_product_id;
	ELSE 
		RAISE EXCEPTION 'Invalid transaction type!';
	END IF;

	-- Ghi nhận giao dịch
	INSERT INTO product_transactions (product_id, transaction_type, quantity, note)
	VALUES (p_product_id, p_type, p_quantity, p_note);
END;
$$;

SELECT * FROM products ORDER BY product_id;
SELECT * FROM product_transactions;

-- Gọi giao dịch thành công
CALL process_product_transaction(1001, 'OUT', 10, 'Xuất kho bán lẻ');
-- Giao dịch thất bại (xuất kho quá số lượng tồn kho)
CALL process_product_transaction(1001, 'OUT', 100000, 'Xuất kho vượt quá');
-- Nhập kho
CALL process_product_transaction(1001, 'IN', 20, 'Nhập thêm hàng');
