-- ==========================================
-- ClotheIt: Database Triggers (Task 5)
-- ==========================================

USE clotheit_data;

-- ==========================================
-- TRIGGER 1: trg_check_stock_before_order_item
--
-- BEFORE INSERT on order_items
-- Prevents an order item from being inserted
-- if the requested quantity exceeds available
-- stock. This acts as a database-level safety
-- net — even if the application somehow skips
-- its own validation, the DB won't let an
-- oversold item slip through.
-- ==========================================

DROP TRIGGER IF EXISTS trg_check_stock_before_order_item;

DELIMITER //
CREATE TRIGGER trg_check_stock_before_order_item
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    SELECT total_qty INTO available_stock
    FROM products
    WHERE id = NEW.product_id;

    IF available_stock < NEW.qty THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for this product';
    END IF;
END //
DELIMITER ;


-- ==========================================
-- TRIGGER 2: trg_deduct_stock_after_order_item
--
-- AFTER INSERT on order_items
-- Once a line item is successfully inserted
-- (i.e. it passed the stock check above),
-- this trigger automatically reduces the
-- product's total_qty by the ordered amount.
-- Keeps inventory in sync without the app
-- needing a separate UPDATE statement.
-- ==========================================

DROP TRIGGER IF EXISTS trg_deduct_stock_after_order_item;

DELIMITER //
CREATE TRIGGER trg_deduct_stock_after_order_item
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET total_qty = total_qty - NEW.qty
    WHERE id = NEW.product_id;
END //
DELIMITER ;


-- ==========================================
-- TRIGGER 3 (bonus): trg_restore_stock_on_cancel
--
-- AFTER UPDATE on orders
-- When an order's status changes to CANCELLED,
-- this trigger restores the stock for every
-- item in that order. Handles the refund side
-- of inventory automatically.
-- ==========================================

DROP TRIGGER IF EXISTS trg_restore_stock_on_cancel;

DELIMITER //
CREATE TRIGGER trg_restore_stock_on_cancel
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status != 'CANCELLED' AND NEW.status = 'CANCELLED' THEN
        UPDATE products p
        JOIN order_items oi ON oi.product_id = p.id
        SET p.total_qty = p.total_qty + oi.qty
        WHERE oi.order_id = NEW.id;
    END IF;
END //
DELIMITER ;
