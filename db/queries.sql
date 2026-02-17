-- ==========================================
-- ClotheIt: 15 SQL Queries (Task 4)
-- Varying complexities covering relational
-- algebraic operations for application features
-- ==========================================

USE clotheit_data;

-- ==========================================
-- QUERY 1: SELECTION + PROJECTION (σ + π)
-- Feature: Customer Dashboard — list all
-- customers who signed up in 2024 Q1
-- ==========================================
SELECT c.id, c.name, c.email, c.phone, c.sign_up_datetime
FROM customers c
WHERE c.sign_up_datetime BETWEEN '2024-01-01' AND '2024-03-31';


-- ==========================================
-- QUERY 2: INNER JOIN (⨝)
-- Feature: Product Catalog — display all
-- products with their vendor names and brands
-- ==========================================
SELECT p.id AS product_id, p.name AS product_name, p.price, p.discount,
       v.name AS vendor_name, v.affiliation AS brand
FROM products p
INNER JOIN vendors v ON p.vendor_id = v.id;


-- ==========================================
-- QUERY 3: MULTI-TABLE JOIN + AGGREGATION
-- Feature: Order Summary — show each order
-- with customer name and number of items
-- ==========================================
SELECT o.id AS order_id, c.name AS customer_name,
       o.order_datetime, o.order_total, o.status,
       COUNT(oi.id) AS total_items,
       SUM(oi.qty) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, c.name, o.order_datetime, o.order_total, o.status;


-- ==========================================
-- QUERY 4: LEFT OUTER JOIN (⟕)
-- Feature: Vendor Analytics — all vendors
-- with their product count (including vendors
-- with zero products, if any)
-- ==========================================
SELECT v.id AS vendor_id, v.name AS vendor_name, v.affiliation,
       COUNT(p.id) AS product_count,
       COALESCE(SUM(p.total_qty), 0) AS total_inventory
FROM vendors v
LEFT JOIN products p ON v.id = p.vendor_id
GROUP BY v.id, v.name, v.affiliation
ORDER BY product_count DESC;


-- ==========================================
-- QUERY 5: NESTED SUBQUERY (÷ / ∈)
-- Feature: High-Value Customer Detection —
-- find customers who have placed orders
-- with total > average order total
-- ==========================================
SELECT c.id, c.name, c.email, o.id AS order_id, o.order_total
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_total > (
    SELECT AVG(order_total) FROM orders
)
ORDER BY o.order_total DESC;


-- ==========================================
-- QUERY 6: CORRELATED SUBQUERY
-- Feature: Vendor Performance — vendors whose
-- average product price is above the overall
-- average product price
-- ==========================================
SELECT v.id, v.name AS vendor_name, v.affiliation,
       (SELECT AVG(p.price) FROM products p WHERE p.vendor_id = v.id) AS avg_price
FROM vendors v
WHERE (SELECT AVG(p.price) FROM products p WHERE p.vendor_id = v.id) >
      (SELECT AVG(price) FROM products)
ORDER BY avg_price DESC;


-- ==========================================
-- QUERY 7: UNION (∪)
-- Feature: Platform Directory — combined
-- contact list of all customers and vendors
-- ==========================================
SELECT name, email, phone, 'CUSTOMER' AS user_type
FROM customers
UNION
SELECT name, email, phone, 'VENDOR' AS user_type
FROM vendors
ORDER BY user_type, name;


-- ==========================================
-- QUERY 8: INTERSECTION via EXISTS (∩)
-- Feature: Active Buyers — customers who have
-- BOTH placed orders AND filed complaints
-- ==========================================
SELECT DISTINCT c.id, c.name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
)
AND EXISTS (
    SELECT 1 FROM complaints comp WHERE comp.customer_id = c.id
);


-- ==========================================
-- QUERY 9: SET DIFFERENCE via NOT EXISTS (−)
-- Feature: Inactive Customers — customers
-- who have signed up but never placed an order
-- ==========================================
SELECT c.id, c.name, c.email, c.sign_up_datetime
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);


-- ==========================================
-- QUERY 10: GROUP BY + HAVING (Aggregation)
-- Feature: Revenue Report — revenue per
-- vendor, filtered to vendors with revenue
-- above ₹3000
-- ==========================================
SELECT v.name AS vendor_name, v.affiliation AS brand,
       COUNT(DISTINCT oi.order_id) AS orders_served,
       SUM(oi.price * oi.qty) AS total_revenue
FROM vendors v
JOIN products p ON v.id = p.vendor_id
JOIN order_items oi ON p.id = oi.product_id
GROUP BY v.id, v.name, v.affiliation
HAVING total_revenue > 3000
ORDER BY total_revenue DESC;


-- ==========================================
-- QUERY 11: JOIN ACROSS DATABASES + PROJECTION
-- Feature: User Authentication Audit — list
-- all auth users with their profile info from
-- the data database
-- ==========================================
SELECT ua.user_id, ua.user_email, ua.user_type, ua.session_status, ua.last_login,
       CASE
           WHEN ua.user_type = 'CUSTOMER' THEN c.name
           WHEN ua.user_type = 'VENDOR'   THEN v.name
       END AS profile_name,
       CASE
           WHEN ua.user_type = 'CUSTOMER' THEN c.phone
           WHEN ua.user_type = 'VENDOR'   THEN v.phone
       END AS phone
FROM clotheit_auth.users_auth ua
LEFT JOIN customers c ON ua.user_id = c.auth_user_id
LEFT JOIN vendors v   ON ua.user_id = v.auth_user_id
ORDER BY ua.user_type, ua.user_id;


-- ==========================================
-- QUERY 12: CARTESIAN PRODUCT / SELF-JOIN idea
-- + Ranking with Window Function
-- Feature: Product Ranking — rank products
-- within each vendor by price (descending)
-- ==========================================
SELECT v.name AS vendor_name,
       p.name AS product_name,
       p.price,
       RANK() OVER (PARTITION BY p.vendor_id ORDER BY p.price DESC) AS price_rank
FROM products p
JOIN vendors v ON p.vendor_id = v.id
ORDER BY v.name, price_rank;


-- ==========================================
-- QUERY 13: COMPLEX JOIN + AGGREGATION
-- Feature: Order Tracking Dashboard —
-- full order lifecycle details with tracking
-- ==========================================
SELECT o.id AS order_id,
       c.name AS customer_name,
       a.city AS customer_city,
       a.state AS customer_state,
       o.order_total,
       o.status AS order_status,
       t.status AS tracking_status,
       t.partner AS delivery_partner,
       t.packaging_date,
       t.shipped_date,
       t.deliver_date,
       DATEDIFF(t.deliver_date, t.shipped_date) AS delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN addresses a ON c.billing_address = a.id
LEFT JOIN tracking t ON o.tracking_id = t.id
ORDER BY o.order_datetime DESC;


-- ==========================================
-- QUERY 14: DIVISION-like query
-- Feature: Complaint Analytics — customers
-- who have filed more than one complaint
-- (repeat complainers)
-- ==========================================
SELECT c.id, c.name, c.email,
       COUNT(comp.id) AS complaint_count,
       SUM(CASE WHEN comp.status = 'OPEN' THEN 1 ELSE 0 END) AS open_complaints,
       SUM(CASE WHEN comp.status = 'RESOLVED' THEN 1 ELSE 0 END) AS resolved_complaints,
       SUM(CASE WHEN comp.status = 'CLOSED' THEN 1 ELSE 0 END) AS closed_complaints
FROM customers c
JOIN complaints comp ON c.id = comp.customer_id
GROUP BY c.id, c.name, c.email
HAVING complaint_count > 1
ORDER BY complaint_count DESC;


-- ==========================================
-- QUERY 15: INSERT + UPDATE + DELETE (DML)
-- Feature: Admin Operations — demonstrate
-- data manipulation (insert a new product,
-- update its price, then delete it)
-- ==========================================

-- 15a. INSERT: Add a new product for vendor 1
INSERT INTO products (vendor_id, name, price, discount, total_qty)
VALUES (1, 'Limited Edition Jacket', 2999.00, 20.00, 50);

-- Show the inserted product
SELECT * FROM products WHERE name = 'Limited Edition Jacket';

-- 15b. UPDATE: Apply a flash sale discount
UPDATE products
SET discount = 35.00, price = 2499.00
WHERE name = 'Limited Edition Jacket';

-- Show the updated product
SELECT id, name, price, discount FROM products WHERE name = 'Limited Edition Jacket';

-- 15c. DELETE: Remove the test product
DELETE FROM products WHERE name = 'Limited Edition Jacket';

-- Verify deletion
SELECT COUNT(*) AS remaining FROM products WHERE name = 'Limited Edition Jacket';
