-- Câu lệnh điều kiện
-- CASE...WHEN...: Là biểu thức dùng để kiểm tra điều kiện và giá trị tương ứng với các điều kiện đầu tiên đang dùng
-- Tương tự như cấu trúc if else trong các ngôn ngữ lập trình phổ biến

-- CASE cơ bản
-- CASE ten_cot
-- 	WHEN gia_tri THEN ket_qua
-- 	WHEN gia_tri2 THEN ket_qua2
-- 	...
-- 	[ELSE ketqua3] -- Nếu mà không có ELSE mà không phù hợp với các WHEN -> NULL
-- END 

-- Searched CASE
-- CASE
-- 	WHEN dieu_kien_1 (price > 50) THEN ket_qua_1
-- 	WHEN dieu_kien_2 THEN ket_qua_2
-- 	...
-- 	[ELSE ket_qua_N]
-- END


-- Phân loại sản phẩm theo giá Rẻ, Trung bình, Đắt
SELECT * FROM products;

-- Rẻ < 2, Trung bình từ 2 đến 10, Đắt > 10
SELECT
	product_name,
	sale_price,
	CASE
		WHEN sale_price < 2 THEN 'Rẻ'
		WHEN sale_price BETWEEN 2 AND 10 THEN 'Trung bình'
		ELSE 'Đắt'
	END AS price_category
FROM
	products;

-- Gán nhãn trạng thái đơn hàng

SELECT * FROM supplier_delivery_status;

SELECT * FROM ordered_items;

SELECT
	order_id,
	status,
	CASE status
		WHEN 1 THEN 'Processed'
		WHEN 2 THEN 'Shipped'
		WHEN 3 THEN 'Delivered'
		ELSE 'Unknown'
	END AS status_name
FROM ordered_items;

-- CASE trong việc kết hợp với các hàm
-- SUM, COUNT, AVG...
-- Tính số lượng các sản phẩm rẻ, trung bình và đắt

SELECT
	SUM(CASE WHEN sale_price < 2 THEN 1 ELSE 0 END) AS cheap_prudcts,
	SUM(CASE WHEN sale_price BETWEEN 2 AND 10 THEN 1 ELSE 0 END) AS medium_products,
	SUM(CASE WHEN sale_price > 10 THEN 1 ELSE 0 END) AS expensive_products
FROM products;

-- CASE lồng nhau

SELECT
	product_name,
	sale_price,
	CASE
		WHEN sale_price < 2 THEN 'Rẻ'
		WHEN sale_price BETWEEN 2 AND 10 THEN
			CASE
				WHEN sale_price < 5 THEN 'Trung bình thấp'
				ELSE 'Trung bình cao'
			END
		ELSE 'Đắt'
	END AS price_category
FROM
	products;

-- Một số các lưu ý
-- Chỉ đánh giá điều kiện đầu tiên đúng, các điều kiện sau bị bỏ qua.
-- Có thể sử dụng CASE ở bất kỳ vị trí nào trong câu truy vấn SELECT, WHERE, ORDER BY..
-- Kết quả mà trả về từ THEN, ELSE nó sẽ phải cùng một kiểu dữ liệu















-- GROUP BY

-- GROUP BY là gì?
-- GROUP BY là một mệnh đề SQL dùng để nhóm các dòng dữ liệu có giá trị giống nhau hoặc nhiều cột lại với nhau
-- Thưởng được sử dụng trong các hàm tổng hợp như COUNT, SUM, AVG, MIN, MAX 
-- Để tạo báo cáo, thống kê tổng hợp theo từng nhóm

-- Cách hoạt động
-- Gom các dòng có cùng giá trị ở cột chỉ định thành một nhóm. 
-- Sau đó nó sẽ tính toán áp dụng các hàm tổng hợp để tính toán giá trị trên từng nhóm
-- ví dụ: tổng hợp số lượng sản phẩm bán ra theo từng loại bánh

-- Cú pháp GROUP BY
SELECT cot1, ham_tong_hop(cot2)
FROM bang_x
GROUP BY cot1;

-- Đếm số lượng sản phẩm theo từng mức giá
SELECT * FROM products;

SELECT 
	sale_price,
	COUNT(*) AS product_count
FROM
	products
GROUP BY sale_price;

-- Tổng số lượng sản phẩm đã được đặt
SELECT * FROM ordered_items

SELECT
	product_id,
	SUM(quantity) AS total_ordered
FROM
	ordered_items
GROUP BY product_id
ORDER BY SUM(quantity) DESC
LIMIT 3;

-- GROUP BY theo nhiều cột
SELECT * FROM employees;

-- Tính lương trung bình của từng chức danh theo phòng ban.
SELECT 
	department,
	title,
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department, title
ORDER BY department ASC, ROUND(AVG(salary), 2) DESC
WHERE ROUND(AVG(salary), 2) = 70000.00;

-- Lọc kết quả nhóm sử dụng HAVING
-- HAVING là mệnh đề để lọc kết quả nhóm sau khi đã áp dụng GROUP BY. Đặt điều kiện trên kết quả của các hàm tổng hợp

SELECT 
	department,
	title,
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department, title
HAVING ROUND(AVG(salary), 2) = 70000.00
ORDER BY department ASC, ROUND(AVG(salary), 2) DESC
;

-- Lấy danh sách các sản phẩm có tổng số lượng đặt hàng trên 100
SELECT
	product_id,
	SUM(quantity) AS total_ordered
FROM
	ordered_items
GROUP BY product_id
HAVING SUM(quantity) > 100;


-- JOIN
-- JOIN là gì ?
-- JOIN là lệnh dùng để kết hợp dữ liệu từ 2 hay nhiều bảng giữa trên mối quan hệ giữa các cột chung
-- Các cột chung là các cột có giá trị trùng nhau, kiểu dữ liệu giống nhau

-- Mục đích: Truy xuất dữ liệu liên quan từ nhiều bảng, tạo báo cáo tổng hợp, phân tích đa chiều

-- INNER JOIN: Chỉ lấy các dòng có giá trị chung ở cả hai bảng
-- Kết quả trả về: Chỉ dữ liệu khớp ở hai bảng

SELECT ... FROM Bang_A
INNER JOIN Bang_B
ON Bang_A.key = Bang_B.key;


-- Ví dụ INNER JOIN: 

SELECT * FROM ordered_items;

SELECT * FROM products;

SELECT 
	oi.order_id,
	oi.product_id,
	p.product_name,
	oi.quantity
FROM ordered_items AS oi
INNER JOIN products AS p ON oi.product_id = p.product_id;

-- LEFT JOIN
-- Lấy tất cả các dòng từ bảng bên trái, nếu không hợp thì cột bên phải là NULL
-- Kết quả mà trả về: Tất cả các dòng từ bảng trái, và bảng phải có thể NULL.

SELECT ... FROM Bang_A
LEFT JOIN Bang_B
ON Bang_A.key = Bang_B.key

-- Tất cả đơn hàng và tên sản phẩm 
-- Kể cả những trường hợp mà sản phẩm đã bị xóa khỏi bảng products
-- Nó sẽ trả về ở bảng bên phải là NULL

SELECT 
	oi.order_id,
	oi.product_id,
	p.product_name,
	oi.quantity
FROM ordered_items AS oi
LEFT JOIN products AS p ON oi.product_id = p.product_id;


-- RIGHT JOIN: Khác LEFT JOIN ở chỗ là lấy tất cả từ bảng bên phải, nếu mà không có giá trị khớp thị cột bên trái là NULL
SELECT 
	oi.order_id,
	oi.product_id,
	p.product_name,
	oi.quantity
FROM ordered_items AS oi
RIGHT JOIN products AS p ON oi.product_id = p.product_id;

-- FULL JOIN
-- Lấy tất cả các dòng từ hai bảng, nếu mà giá trị nào không khớp thì nó sẽ trả về là NULL

SELECT .. FROM Bang_A
FULL [OUTER] JOIN Bang_B ON Bang_A.key = Bang_B.key

SELECT 
	oi.order_id,
	oi.product_id,
	p.product_name,
	oi.quantity
FROM ordered_items AS oi
FULL JOIN products AS p ON oi.product_id = p.product_id;


-- CROSS JOIN
-- Kết hợp tất cả các dòng của hai bảng (Tích đề các descartes)
-- Số dòng = Số dòng của bảng 1 x Số dòng của bảng 2

SELECT ... FROM Bang_A
CROSS JOIN Bang_B;

-- CROSS JOIN: Tạo tổ hợp tất cả sản phẩm (products) với tất cả nhà cung cấp (supliers)

SELECT 
	p.product_name,
	s.name
FROM suppliers s
CROSS JOIN products p;


-- SELF JOIN: Kết nối một bảng với chính nó
-- Kết quả như JOIN hai bảng nhưng thực hiện trên cùng một bảng
-- Có thể sử dụng với các loại JOIN, LEFT JOIN, RIGHT JOIN...

-- Ví dụ một bảng employee, employee_id, manager_id
SELECT ... FROM bang_a
JOIN bang_a 
ON bang_a.employee_id = bang_a.manager_id

-- Liệt kê mọi cặp nhân viên làm cùng một phòng ban
-- Trả về là 2 cột: tên_nv_1, tên_nv_2
-- tên_nv_1 != tên_nv_2

SELECT * FROM employees;

SELECT 
	e1.first_name || ' ' || e1.last_name AS employee1,
	e2.first_name || ' ' || e2.last_name AS employee2
FROM employees e1
JOIN employees e2
	ON e1.department = e2.department
	AND e1.employee_id != e2.employee_id
ORDER BY e1.department

-- NATURAL JOIN:
-- Tự động kết nối các cột cùng tên giữa hai bảng 
-- Có thể dùng NATURAL kết hợp với các loại JOIN khác INNER, LEFT, RIGHT...

SELECT *
FROM customer_orders
NATURAL JOIN customers;


