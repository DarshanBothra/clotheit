-- ==========================================
-- ClotheIt: Database Transactions (Task 6)
-- ==========================================
-- This file demonstrates various transaction
-- scenarios on the ClotheIt e-commerce schema.
--
-- Run these in MySQL CLI interactively, or
-- use the Python script (app/transactions.py)
-- for the full automated demo with conflict
-- simulation.
-- ==========================================

USE clotheit_data;

-- ==========================================
-- TRANSACTION 1: Successful Order Placement
-- (COMMIT path)
--
-- A customer places an order for 2 items.
-- The transaction inserts tracking, order
-- header, and line items atomically. If
-- everything succeeds, we COMMIT.
-- ==========================================

SELECT '=== TRANSACTION 1: Successful Order (COMMIT) ===' AS demo;

-- Snapshot before
SELECT id, name, total_qty AS stock_before FROM products WHERE id IN (1, 2);

START TRANSACTION;

    -- Create tracking record
    INSERT INTO tracking (status, partner, packaging_date)
    VALUES ('PACKAGING', 'BlueDart', NOW());
    SET @trk_id = LAST_INSERT_ID();

    -- Create order header
    INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status)
    VALUES (1, NOW(), 1643.25, @trk_id, 'PROCESSING');
    SET @ord_id = LAST_INSERT_ID();

    -- Insert line items (triggers fire here)
    INSERT INTO order_items (order_id, product_id, price, qty)
    VALUES (@ord_id, 1, 539.10, 2);

    INSERT INTO order_items (order_id, product_id, price, qty)
    VALUES (@ord_id, 2, 1104.15, 1);

COMMIT;

-- Snapshot after — stock should have decreased
SELECT id, name, total_qty AS stock_after FROM products WHERE id IN (1, 2);
SELECT id, customer_id, order_total, status FROM orders WHERE id = @ord_id;


-- ==========================================
-- TRANSACTION 2: Failed Order (ROLLBACK)
--
-- A customer tries to order a product but
-- the trigger detects insufficient stock.
-- The entire transaction must be rolled back
-- so that no partial data remains.
-- ==========================================

SELECT '=== TRANSACTION 2: Failed Order (ROLLBACK) ===' AS demo;

-- Snapshot before
SELECT id, name, total_qty AS stock_before FROM products WHERE id = 25;

START TRANSACTION;

    -- Create tracking
    INSERT INTO tracking (status, partner, packaging_date)
    VALUES ('PACKAGING', 'Delhivery', NOW());
    SET @trk_id2 = LAST_INSERT_ID();

    -- Create order header
    INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status)
    VALUES (3, NOW(), 71993.20, @trk_id2, 'PROCESSING');
    SET @ord_id2 = LAST_INSERT_ID();

    -- Try to order 9999 units of Tweed Sports Jacket (only ~80 in stock)
    -- The BEFORE INSERT trigger will raise error 45000
    -- NOTE: In MySQL CLI, this INSERT will fail and you must ROLLBACK manually.
    --       In the Python script, this is caught and rolled back automatically.

ROLLBACK;

-- Snapshot after — stock should be unchanged
SELECT id, name, total_qty AS stock_after FROM products WHERE id = 25;

-- Verify the order was NOT persisted
SELECT COUNT(*) AS orphaned_orders FROM orders WHERE id = @ord_id2;


-- ==========================================
-- TRANSACTION 3: Savepoints
--
-- Demonstrates partial rollback using
-- SAVEPOINT. We update prices for multiple
-- products, but roll back one of the changes
-- while keeping the others.
-- ==========================================

SELECT '=== TRANSACTION 3: Savepoints ===' AS demo;

-- Snapshot before
SELECT id, name, price AS price_before FROM products WHERE id IN (41, 42, 43);

START TRANSACTION;

    -- Update product 41 price
    UPDATE products SET price = 1699.00 WHERE id = 41;
    SAVEPOINT after_product_41;

    -- Update product 42 price
    UPDATE products SET price = 999.00 WHERE id = 42;
    SAVEPOINT after_product_42;

    -- Update product 43 price (oops, wrong price — roll back this one)
    UPDATE products SET price = 1.00 WHERE id = 43;

    -- Revert only the product 43 change
    ROLLBACK TO SAVEPOINT after_product_42;

COMMIT;

-- Snapshot after — products 41 & 42 should be updated, 43 unchanged
SELECT id, name, price AS price_after FROM products WHERE id IN (41, 42, 43);


-- ==========================================
-- TRANSACTION 4: Order Cancellation with
-- Automatic Stock Restoration
--
-- When an order's status changes to CANCELLED,
-- the trg_restore_stock_on_cancel trigger
-- fires and adds back the quantities.
-- ==========================================

SELECT '=== TRANSACTION 4: Cancellation + Stock Restore ===' AS demo;

-- Use the order we created in Transaction 1
-- Products 1 and 2 had stock deducted

SELECT id, name, total_qty AS stock_before_cancel FROM products WHERE id IN (1, 2);

START TRANSACTION;
    UPDATE orders SET status = 'CANCELLED' WHERE id = @ord_id;
COMMIT;

-- Stock should be restored
SELECT id, name, total_qty AS stock_after_cancel FROM products WHERE id IN (1, 2);
SELECT id, status FROM orders WHERE id = @ord_id;


-- ==========================================
-- CLEANUP: Restore prices changed in Txn 3
-- ==========================================

UPDATE products SET price = 1899.00 WHERE id = 41;
UPDATE products SET price = 1199.00 WHERE id = 42;

SELECT '=== All standalone transaction demos complete ===' AS demo;
SELECT 'Run app/transactions.py for concurrency & conflict demos' AS next_step;
