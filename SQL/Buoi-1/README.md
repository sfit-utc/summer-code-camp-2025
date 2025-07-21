# BUỔI 1 - GIỚI THIỆU VỀ SQL VÀ CÁC CÂU LỆNH CƠ BẢN

Slide: [Canva Slide](https://www.canva.com/design/DAGZ06NLg-M/HzrkwHwd7L9z469Q6bBlsQ/edit?utm_content=DAGZ06NLg-M&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## CÀI ĐẶT MÔI TRƯỜNG PostgreSQL

Cài đặt PostgreSQL trên máy tính của bạn. 
- Bạn có thể tải xuống từ trang chính thức của PostgreSQL: [PostgreSQL Downloads](https://www.postgresql.org/download/).
- Làm theo hướng dẫn cài đặt cho hệ điều hành của bạn (Windows, macOS, Linux).
- Trong quá trình cài đặt, hãy nhớ ghi lại tên người dùng và mật khẩu bạn đã tạo cho tài khoản quản trị viên (thường là `postgres`).

## SETUP DỮ LIỆU MẪU CHO BUỔI HỌC
- Dữ liệu mẫu sẽ được sử dụng trong buổi học này là một cơ sở dữ liệu về cửa hàng bánh ngọt (bakery). Có các bảng như sau:
![image](../static/images/bakery-db.png)
- Mở PGAdmin, trong giao diện chính, tạo một cơ sở dữ liệu mới với tên `bakery`.
- Chọn cơ sở dữ liệu `bakery` vừa tạo, sau đó mở tab "Query Tool".
- Sao chép và dán đoạn mã SQL của file `bakery-db.sql` vào cửa sổ truy vấn. Link file: [bakery-db.sql](./bakery-db.sql)

## SCRIPT THỰC HÀNH
1. SELECT ... FROM cơ bản:
```sql
-- Lấy tất cả các sản phẩm
SELECT * FROM products;

-- Lấy danh sách tên và giá bán của sản phẩm
SELECT product_name, sale_price FROM products;

-- Lấy tên sản phẩm, giá bán và giá sau khi giảm 10%
SELECT 
    product_name, 
    sale_price, 
    sale_price * 0.9 AS discounted_price
FROM 
    products;
```

2. WHERE để lọc dữ liệu:
```sql
-- Lấy các sản phẩm còn nhiều hơn 50 đơn vị trong kho
SELECT * FROM products WHERE units_in_stock > 50;

-- Lấy thông tin khách hàng ở thành phố Scranton
SELECT * FROM customers WHERE city = 'Scranton';
```

3. SELECT với các toán tử logic
- Sử dụng AND, OR
```sql
-- Sản phẩm có giá từ $1 đến $3 VÀ còn hơn 100 sản phẩm trong kho
SELECT * 
FROM products 
WHERE sale_price BETWEEN 1 AND 3 
  AND units_in_stock > 100;

-- Khách hàng ở Texas (TX) HOẶC Pennsylvania (PA)
SELECT *
FROM customers
WHERE state = 'TX' OR state = 'PA';
```
- Sử dụng NOT
```sql
-- Khách hàng KHÔNG đến từ Texas (TX) hoặc California (CA)
SELECT *
FROM customers
WHERE state NOT IN ('TX', 'CA');

```

4. SELECT với IN, BETWEEN
- Toán tử IN được dùng để kiểm tra xem giá trị của một cột có nằm trong một danh sách các giá trị được chỉ định hay không. Đây là cách viết tắt hiệu quả cho nhiều điều kiện OR
- 
```sql
-- Lấy các sản phẩm có mã là 1001, 1003 hoặc 1005
SELECT * FROM products WHERE product_id IN (1001, 1003, 1005);

-- Lấy các đơn hàng có tổng tiền từ 10 đến 50
SELECT * FROM customer_orders WHERE order_total BETWEEN 10 AND 50;

-- Lấy các nhân viên thuộc phòng 'Bakery' hoặc 'Marketing'
SELECT * FROM employees WHERE department IN ('Bakery', 'Marketing');
```

- Toán tử BETWEEN dùng để chọn các giá trị trong một khoảng nhất định. Các giá trị này có thể là số, văn bản hoặc ngày tháng. Nó bao gồm cả giá trị bắt đầu và kết thúc của khoảng.
```sql
-- Lấy các đơn hàng có tổng tiền từ 10 đến 50
SELECT * FROM customer_orders WHERE order_total BETWEEN 10 AND 50;

-- Để lấy tất cả các đơn hàng được đặt trong quý đầu tiên của năm 2020:
SELECT
    order_id,
    customer_id,
    order_date,
    order_total
FROM
    customer_orders
WHERE
    order_date BETWEEN '2020-01-01' AND '2020-03-31';
```

5. SELECT với LIKE
- Trong SQL, LIKE là một toán tử được sử dụng trong mệnh đề WHERE để tìm kiếm một mẫu (pattern) cụ thể trong một cột dữ liệu văn bản. Nó rất hữu ích khi bạn không biết chính xác chuỗi ký tự cần tìm.
- Toán tử LIKE sử dụng các ký tự đại diện
- Ký tự đại diện:
  - `%`: đại diện cho bất kỳ chuỗi ký tự nào (bao gồm cả chuỗi rỗng).
  - `_`: đại diện cho một ký tự đơn lẻ.
- Ví dụ:
  - `LIKE 'abc%'`: tìm kiếm các chuỗi bắt đầu bằng "abc".
  - `LIKE '%xyz'`: tìm kiếm các chuỗi kết thúc bằng "xyz".
  - `LIKE '%abc%'`: tìm kiếm các chuỗi chứa "abc" ở bất kỳ vị trí nào.
  - `LIKE 'a_c'`: tìm kiếm các chuỗi có "a" ở đầu, "c" ở cuối và một ký tự bất kỳ ở giữa.
  
```sql
-- Lấy các sản phẩm có tên bắt đầu bằng 'Ch'
SELECT * FROM products WHERE product_name LIKE 'Ch%';

-- Lấy khách hàng có họ kết thúc bằng 'son'
SELECT * FROM customers WHERE last_name LIKE '%son';

-- Lấy các sản phẩm có tên chứa từ 'Cake'
SELECT * FROM products WHERE product_name LIKE '%Cake%';

-- Sản phẩm KHÔNG có từ 'Cookie' trong tên
SELECT *
FROM products
WHERE product_name NOT LIKE '%Cookie%';

```

## TỔ CHỨC KẾT QUẢ TRUY VẤN
1. Sắp xếp kết quả với ORDER BY
- Sắp xếp theo một hoặc nhiều cột
- Sắp xếp theo thứ tự tăng dần (ASC) hoặc giảm dần (DESC)

- ODER BY 101
``` sql
SELECT * FROM customers
ORDER BY first_name;

-- ORDER BY theo thứ tự của cột
SELECT * FROM customers
ORDER BY 2 ASC, 3 DESC;
```

- ORDER BY theo câu
```sql
-- 1. Lấy danh sách sản phẩm, sắp xếp theo giá bán tăng dần
SELECT product_id, product_name, sale_price
FROM products
ORDER BY sale_price ASC;

-- 2. Lấy danh sách khách hàng, sắp xếp theo số tiền đã chi tiêu giảm dần
SELECT customer_id, first_name, last_name, total_money_spent
FROM customers
ORDER BY total_money_spent DESC;

-- 3. Lấy danh sách đơn hàng của khách hàng, sắp xếp theo ngày đặt hàng mới nhất trước
SELECT order_id, customer_id, order_date, order_total
FROM customer_orders
ORDER BY order_date DESC;

-- 4. Lấy danh sách nhân viên, sắp xếp theo phòng ban (department) tăng dần và lương giảm dần trong từng phòng ban
SELECT employee_id, first_name, last_name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;
```

2. Giới hạn kết quả với LIMIT
- LIMIT 101
```sql
-- 1. Lấy 5 sản phẩm đầu tiên trong bảng products
SELECT * FROM products
LIMIT 5;

-- 2. Lấy 3 khách hàng đầu tiên trong bảng customers
SELECT * FROM customers
LIMIT 3;

-- 3. Lấy 10 đơn hàng mới nhất (giả sử order_id tăng dần theo thời gian)
SELECT * FROM customer_orders
ORDER BY order_id DESC
LIMIT 10;

-- 4. Lấy 1 nhân viên có mức lương cao nhất
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;
```

- Giới hạn kết quả với OFFSET
  - OFFSET chỉ định số lượng hàng sẽ bỏ qua từ đầu tập kết quả trước khi bắt đầu đếm.
```sql
-- 1. Lấy 5 sản phẩm, bắt đầu từ sản phẩm thứ 6 (bỏ qua 5 sản phẩm đầu tiên)
SELECT * FROM products
ORDER BY product_id
LIMIT 5 OFFSET 5;

-- 2. Lấy 3 khách hàng tiếp theo, bắt đầu từ khách hàng thứ 4 (bỏ qua 3 khách hàng đầu tiên)
SELECT * FROM customers
ORDER BY customer_id
LIMIT 3 OFFSET 3;

-- 3. Lấy 10 đơn hàng, bắt đầu từ đơn hàng thứ 21 (phục vụ phân trang, mỗi trang 10 đơn hàng)
SELECT * FROM customer_orders
ORDER BY order_id
LIMIT 10 OFFSET 20;
```
3. Aliasing
- Aliasing (đặt bí danh) là việc gán một tên tạm thời cho một bảng hoặc một cột trong một truy vấn. Tên tạm thời này chỉ tồn tại trong suốt quá trình thực thi truy vấn và không làm thay đổi tên thực tế của bảng hoặc cột trong cơ sở dữ liệu.
- Aliasing giúp làm cho kết quả truy vấn dễ đọc hơn, đặc biệt khi làm việc với các phép toán phức tạp hoặc khi cần sử dụng các tên cột dài hoặc khó hiểu.

- Aliasing với cột
```sql
-- Đặt bí danh cho cột, dùng AS hoặc không cần AS
SELECT 
    product_name AS name,
    sale_price AS price
FROM products;

-- Hoặc không dùng AS (vẫn hợp lệ)
SELECT 
    product_name name,
    sale_price price
FROM products;
```

- Aliasing với bảng
```sql
SELECT 
    c.first_name, 
    c.last_name, 
    o.order_total
FROM customers c
JOIN customer_orders o ON c.customer_id = o.customer_id;
```

## DATA TYPES TRONG POSTGRESQL
1. Numeric functions
```sql
-- Lấy giá trị tuyệt đối của sự chênh lệch giữa số lượng tồn kho và 100
SELECT product_id, product_name, units_in_stock, ABS(units_in_stock - 100) AS abs_difference
FROM products;

-- Làm tròn giá bán sản phẩm đến 2 chữ số thập phân
SELECT product_id, product_name, sale_price, ROUND(sale_price, 2) AS rounded_price
FROM products;

-- Làm tròn lên giá bán sản phẩm
SELECT product_id, product_name, sale_price, CEIL(sale_price) AS ceil_price
FROM products;

-- Làm tròn xuống giá bán sản phẩm
SELECT product_id, product_name, sale_price, FLOOR(sale_price) AS floor_price
FROM products

-- Tính bình phương số lượng tồn kho
SELECT product_id, product_name, units_in_stock, POWER(units_in_stock, 2) AS stock_squared
FROM products;

-- Tính căn bậc hai của số lượng tồn kho
SELECT product_id, product_name, units_in_stock, SQRT(units_in_stock) AS stock_sqrt
FROM products;

-- Cắt bớt phần thập phân của giá bán sản phẩm (không làm tròn)
SELECT product_id, product_name, sale_price, TRUNC(sale_price) AS truncated_price
FROM products;
```

2. String functions
```sql
-- Lấy độ dài tên sản phẩm
SELECT product_id, product_name, LENGTH(product_name) AS name_length
FROM products;

-- Chuyển tên sản phẩm sang chữ hoa
SELECT product_id, UPPER(product_name) AS upper_name
FROM products;

-- Chuyển tên khách hàng sang chữ thường
SELECT customer_id, LOWER(first_name) AS lower_first_name
FROM customers;

-- Nối họ và tên khách hàng thành một chuỗi đầy đủ
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Hoặc
SELECT customer_id, first_name || ' ' || last_name) AS full_name
FROM customers;

-- Lấy 5 ký tự đầu tiên của tên sản phẩm
SELECT product_id, SUBSTRING(product_name FROM 1 FOR 5) AS short_name
FROM products;

-- Loại bỏ khoảng trắng ở đầu và cuối tên sản phẩm sử dụng TRIM hoặc LTRIM và RTRIM
SELECT product_id, TRIM(product_name) AS trimmed_name
FROM products;

-- Thay thế từ 'Cake' bằng 'Bread' trong tên sản phẩm
SELECT product_id, REPLACE(product_name, 'Cake', 'Bread') AS new_name
FROM products;

-- Tìm vị trí xuất hiện đầu tiên của từ 'Cake' trong tên sản phẩm
SELECT product_id, POSITION('Cake' IN product_name) AS cake_pos
FROM products;

-- Lấy 3 ký tự bên trái của tên sản phẩm
SELECT product_id, LEFT(product_name, 3) AS left3
FROM products;

-- Lấy 4 ký tự bên phải của tên sản phẩm
SELECT product_id, RIGHT(product_name, 4) AS right4
FROM products;
```

3. Date and time functions
```sql
-- Lấy thời gian hiện tại của hệ thống
SELECT NOW() AS current_datetime;

-- Lấy ngày hiện tại
SELECT CURRENT_DATE AS today;

-- Lấy giờ hiện tại
SELECT CURRENT_TIME AS current_time;

-- Tính số năm/tháng/ngày từ ngày sinh khách hàng đến hiện tại
SELECT customer_id, first_name, birth_date, AGE(birth_date) AS age
FROM customers;

-- Lấy năm đặt hàng từ cột order_date
SELECT order_id, order_date, EXTRACT(YEAR FROM order_date) AS order_year
FROM customer_orders;

-- Lấy tháng từ ngày sinh khách hàng
SELECT customer_id, birth_date, EXTRACT(MONTH FROM birth_date) AS birth_month
FROM customers;

-- Lấy ngày trong tháng từ ngày đặt hàng
SELECT order_id, DATE_PART('day', order_date) AS day_of_month
FROM customer_orders;

-- Hiển thị ngày đặt hàng theo định dạng DD/MM/YYYY
SELECT order_id, TO_CHAR(order_date, 'DD/MM/YYYY') AS formatted_date
FROM customer_orders;

-- Tính ngày giao hàng dự kiến sau 5 ngày kể từ ngày đặt hàng
SELECT order_id, order_date, order_date + INTERVAL '5 days' AS expected_delivery
FROM customer_orders;

-- Lấy ngày đầu tiên của tháng cho mỗi đơn hàng
-- date_trunc trong PostgreSQL dùng để cắt ngắn (truncate) một giá trị timestamp hoặc interval đến một đơn vị thời gian cụ thể.
SELECT order_id, order_date, DATE_TRUNC('month', order_date) AS month_start
FROM customer_orders;
```

## LỆNH ĐIỀU KIỆN VÀ CHUYỂN ĐỔI

### Chuyển đổi kiểu dữ liệu

Chuyển đổi kiểu dữ liệu trong PostgreSQL có thể được thực hiện bằng cách sử dụng các hàm chuyển đổi hoặc cú pháp CAST. Dưới đây là một số ví dụ về cách chuyển đổi kiểu dữ liệu trong PostgreSQL:

```sql
SELECT CAST(sale_price AS INTEGER) AS sale_price_int FROM products;

SELECT sale_price::INTEGER AS sale_price_int FROM products;

SELECT CAST('2024-06-15' AS DATE) AS converted_date;
SELECT '2024-06-15'::DATE AS converted_date;

SELECT '{10,20,30}'::INT[] AS int_array;
```
