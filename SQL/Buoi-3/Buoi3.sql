-- Câu lệnh điều kiện CASE...WHEN
-- Câu lệnh gom nhóm GROUP BY
-- Các câu lệnh kết hợp dữ liệu JOIN

SELECT ... FROM A
[Loai_join] JOIN B ON A.key = B.key

-- Nâng cao hơn một chút với JOIN
-- JOIN nhiều bảng
-- Lấy danh sách đơn hàng (customer_orders AS co), tên khách hàng (customers AS c) và tên sản phẩm (products AS p)

SELECT 
	co.order_id,
	c.first_name || ' ' || c.last_name AS customer_name,
	p.product_name,
	co.order_total
FROM 
	customer_orders AS co
JOIN customers AS c ON co.customer_id = c.customer_id
JOIN products AS p ON co.product_id = p.product_id;

-- JOIN với điều kiện lọc
SELECT * FROM supplier_delivery_status;

-- Lấy các đơn hàng (ordered_items oi) đã giao thành công (status = 3) (supplier_delivery_status sdt) kèm theo người ship (suppliers s) và tên sản phẩm (products p)

SELECT
	oi.order_id,
	p.product_name,
	s.name AS shipper_name,
	sdt.name AS status
FROM
	ordered_items oi
JOIN supplier_delivery_status sdt ON sdt.order_status_id = oi.status
JOIN products p ON p.product_id = oi.product_id
JOIN suppliers s ON oi.shipper_id = s.supplier_id
WHERE sdt.name = 'Delivered';

-- Có thể chỉ định cột chung cùng tên không sử dụng ON, sử dụng USING
-- Lấy tất cả đơn hàng từ ordered_items và tên sản phẩm (products)

SELECT 
	*
FROM ordered_items 
JOIN products USING (product_id);


-- Lưu ý khi sử dụng JOIN
-- Chọn loại JOIN phù hợp theo yêu cầu từ báo cáo mà chọn INNER JOIN, LEFT hay RIGHT hay FULL JOIN.

-- Có thể sử dụng Alias (AS): Đặt tên ngắn gọn cho bảng để dễ đọc và dễ viết các câu truy vấn

-- Sử dụng ON và USING: Chọn một cách kết nối phù hợp giữa các bảng. 
-- ON thì cho phép điều kiện phức tạp hơn trong khi sử dụng USING đơn giản hơn khi có cột trùng tên

-- Tránh việc sử dụng CROSS JOIN không cần thiết: Tạo ra tất cả các tổ hợp có thể, có thể dẫn đến việc là kết quả của câu truy vấn rất lớn và không mong muốn

-- Sử dụng GROUP BY với JOIN: Khi cần tổng hợp dữ liệu sau khi JOIN, có thể kết hợp thêm GROUP BY để nhóm lại kết quả theo các cột mong muốn.

-- Ví dụ: Số đơn hàng của từng khách hàng (tên khách hàng), sắp xếp theo số đơn giảm dần

SELECT 
	c.first_name || ' ' || c.last_name AS customer_name,
	COUNT(co.order_id) AS order_count
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY customer_name
ORDER BY order_count DESC;

-- Ví dụ: Tổng hợp doanh thu theo từng thành phố, sắp xếp theo doanh thu giảm dần
SELECT 
	c.city,
	SUM(co.order_total) AS total_sales
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;

-- Kiểm tra NULL: cần chú ý đến các giá trị NULL, vì có thể ảnh hưởng đến phép toán tổng hợp trong điều kiện lọc
-- Kết hợp DISTINCT khi JOIN tạo ra các dòng trùng lặp để loại bỏ chúng.


-- UNION [ALL]
-- UNION dùng để kết hợp kết quả của hai hoặc nhiều truy vấn SELECT thành một kết quả duy nhất, và loại bỏ các dòng trùng lặp
-- UNION ALL nhưng khác UNION ở chỗ nó sẽ giữ lại tất cả các dòng kể cả dòng trùng lặp

-- Các câu SELECT phải cùng số lượng cột và kiểu dữ liệu tương thích

SELECT column1, column2 FROM table1
UNION [ALL]
SELECT column1, column2 FROM table2;



-- Lấy danh sách những người có lượng tip cao (> 3) và số lượng khách hàng chi tiêu nhiều (> 1000)

SELECT first_name, last_name, 'good tipper' AS "type"
FROM customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
WHERE tip::FLOAT > 3

UNION

SELECT first_name, last_name, 'high spender' AS "type_a"
FROM customers
WHERE total_money_spent > 1000;



-- SUBQUERY (Truy vấn con)
-- Là một truy vấn nằm bên trong truy vấn khác
-- Có thể thực hiện các thao thức tạp mà không cần nhiều bước truy vấn riêng biệt

-- Các loại subquery phổ biến
-- 1. Subquery trong WHERE hoặc HAVING
-- 2. Subquery trong SELECT
-- 3. Subquery trong FROM

-- 1. Subquery trong WHERE hoặc HAVING
-- Liệt kê tên và lương của nhân viên có mức lương cao hơn trung bình (AVG)

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Liệt kê tên sản phẩm đã từng được đặt hàng
SELECT product_name
FROM products
WHERE product_id IN (SELECT product_id FROM customer_orders);

-- Áp dụng EXISTS, ANY, ALL, SOME
-- Lấy tên các sản phẩm chưa từng được review
SELECT product_name
FROM products p
WHERE NOT EXISTS (
	SELECT * FROM customer_orders_review r WHERE r.product_id = p.product_id
);


-- Áp dụng với HAVING
-- Lấy các thành phố có tổng tiền chi tiêu của khách hàng lớn hơn trung bình các thành phố

SELECT city, SUM(total_money_spent) AS total_spent
FROM customers
GROUP BY city
HAVING SUM(total_money_spent) > (
	SELECT AVG(city_total) FROM (
		SELECT SUM(total_money_spent) AS city_total FROM customers GROUP BY city
	) AS city_avgs
)

-- 2. Subquery trong SELECT

-- Hiển thị tổng số đơn hàng của từng khách hàng.

SELECT 
	c.first_name || ' ' || c.last_name AS customer_name,
	COUNT(co.order_id) AS order_count
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY customer_name;


SELECT
	c.first_name || ' ' || c.last_name AS customer_name,
	(SELECT COUNT(*) FROM customer_orders co WHERE co.customer_id = c.customer_id)
FROM customers c;

-- Hiển thị ngày đặt hàng gần nhất của từng khách hàng (năm-tháng-ngày)
SELECT MAX(order_date) FROM customer_orders;

SELECT 
	c.first_name || ' ' || c.last_name AS customer_name,
	(SELECT MAX(order_date) FROM customer_orders co WHERE co.customer_id = c.customer_id) AS max_order_date
FROM customers c;


-- Subquery nằm trong FROM
-- Câu SELECT nằm bên trong FROM => tạo ra một bảng tạm thời để truy vấn 
-- Lưu ý: Mỗi subquery nằm trong FROM phải đặt bí danh 

SELECT ...
FROM (SELECT ... FROM ...) AS x
WHERE ...;

-- Lấy các sẩn phẩm có tổng số lượng đã bán > 100

SELECT product_name, total_sold 
FROM (
	SELECT
		p.product_name,
		SUM(oi.quantity) AS total_sold
	FROM products p
	JOIN ordered_items oi ON p.product_id = oi.product_id
	GROUP BY p.product_name
)
WHERE total_sold > 100;


-- Rút gọn truy vấn tạp 

SELECT * FROM 
(
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
FROM products
) 
WHERE price_category = 'Rẻ';



-- WINDOW FUNCTION
-- Window function là hàm thực hiện tính toán trên một tập các dòng liên quan đến dòng hiện tại mà không làm giảm số dòng kết quả (khác với group by)
-- Hầu hết các Aggregate Functions (các hàm tổng hợp như COUNT, SUM, MAX, MIN...) cũng có thể sử dụng như các WINDOW FUNCTION khi kết hợp với OVER()

-- Cú pháp chung

function_name(...) OVER([PARTITION BY ...] [ORDER BY ...])

-- 1. Row Number: Đánh số thứ tự trong mỗi partition (hoặc là toàn bộ bảng nếu không sử dụng partition)
-- ROW_NUMBER()


-- Đánh số thứ tự đơn hàng theo ngày đặt hàng mới nhất trước

SELECT 
	order_id, customer_id, order_date,
	ROW_NUMBER() OVER(ORDER BY order_date DESC) AS order_rank
FROM customer_orders
;

-- Đánh thứ tự của đơn hàng của từng khách hàng
SELECT 
	order_id, customer_id, order_date,
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS order_rank
FROM customer_orders;

-- 2. RANK và DENSE RANK 
-- Vẫn là đánh số thứ tự dựa trên giá trị nhưng có sự khác biệt khi gặp các giá trị bằng nhau.

-- RANK: Nếu có các giá trị bằng nhau, chúng sẽ có cùng hạng. Tuy nhiên thứ hạng tiếp theo sẽ bị bỏ qua tương ứng với số lượng giá trị bằng nhau đó.
-- Ví dụ: Nếu có 2 giá trị bằng nhau và xếp ở vị trí thứ 1, giá trị tiếp theo là 3 (thay vì 2)

-- DENSE_RANK: Không bỏ qua thứ hạng. Tức là có hai giá trị bằng nhau ở vị trí 1, giá trị tiếp theo vẫn là 2.

-- Xếp hạng sản phẩm theo số lượng tồn kho (RANK)
SELECT 
	product_id, product_name, units_in_stock,
	RANK() OVER(ORDER BY units_in_stock DESC) AS stock_rank
FROM products;

-- Xếp hạng đơn hàng theo giá trị đơn hàng trong từng thành phố (DENSE_RANK)
SELECT 
	co.order_id, c.city, co.order_total,
	DENSE_RANK() OVER(PARTITION BY c.city ORDER BY co.order_total DESC) AS order_total_rank
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id;


-- Sử dụng các hàm tổng hợp bên trong window function (sum, avg, count, min...)

-- Tính tổng tiền chi tiêu lũy kế của tăng khách hàng theo thời gian.
SELECT 
	customer_id, order_date, order_total,
	SUM(order_total) OVER(PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM customer_orders;


-- LAG(), LEAD()
-- LAG() truy xuất giá trị của dòng trước, truy xuất giá trị dòng sau so với dòng hiện tại của một tập hợp dữ liệu đã được sắp xếp.
-- Rất hữu ích khi mà phân tích hướng, so sánh biến động, hoặc tính toán chênh lệch giữa các dòng liên tiếp.

-- LAG(expression, [offset], [default]): Hàm này truy cập một hàng nằm trước hàng hiện tại trong cùng một phân vùng

-- LEAD(expression, [offset], [default]): Hàm này truy cập một hàng nằm sau hàng hiện tại trong cùng một phân vùng

-- expression: cột, hoặc biểu thức mà bạn muốn lấy giá trị
-- offset (Tùy chọn): Số hàng để tiến tới (LEAD) hoặc là lùi lại (LAG). Mặc định là 1. 
-- default (Tùy chọn): Giá trị trả về nếu không có hàng nào ở offset được chỉ định, mặc định là NULL.


-- Bạn muốn xem mỗi khách hàng đã chi tiêu bao nhiêu trong đơn hàng hiện tại so với đơn hàng trước đó của họ

SELECT
	customer_id,
	order_date,
	order_total,
	LEAD(order_total, 2, 0) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_total
FROM
	customer_orders
ORDER BY
	customer_id, order_date;












