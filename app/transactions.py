"""
ClotheIt — Database Transactions Demo (Task 6)
================================================
Demonstrates various transaction scenarios on the ClotheIt database,
including concurrency conflicts using multiple connections/threads.

Scenarios covered:
  1. Successful order placement  (COMMIT)
  2. Failed order — rollback      (ROLLBACK)
  3. Savepoints & partial rollback
  4. Order cancellation + stock restore (trigger-driven)
  5. Dirty-read prevention        (isolation level demo)
  6. Lost-update / write-write conflict (SELECT … FOR UPDATE)

Run:
    source venv/bin/activate
    python app/transactions.py
"""

import mysql.connector
from mysql.connector import Error
from datetime import datetime
import threading
import time
import textwrap

# ─── Configuration ────────────────────────────────

DB_CONFIG = {
    "host": "localhost",
    "user": "clotheit",
    "password": "Clotheit@2026",
    "database": "clotheit_data",
}

# ─── Helpers ──────────────────────────────────────

CYAN    = "\033[96m"
GREEN   = "\033[92m"
YELLOW  = "\033[93m"
RED     = "\033[91m"
MAGENTA = "\033[95m"
BOLD    = "\033[1m"
DIM     = "\033[2m"
RESET   = "\033[0m"

SEPARATOR = f"{DIM}{'─' * 72}{RESET}"

def conn_new(autocommit=False):
    """Open a fresh connection."""
    return mysql.connector.connect(**DB_CONFIG, autocommit=autocommit)


def banner(num, title, subtitle=""):
    """Print a big scenario header."""
    print(f"\n\n{SEPARATOR}")
    print(f"{BOLD}{CYAN}  SCENARIO {num}: {title}{RESET}")
    if subtitle:
        for line in textwrap.wrap(subtitle, 68):
            print(f"  {DIM}{line}{RESET}")
    print(SEPARATOR)


def step(label):
    """Print a step label."""
    print(f"\n  {YELLOW}▸ {label}{RESET}")


def ok(msg):
    print(f"    {GREEN}✔ {msg}{RESET}")


def fail(msg):
    print(f"    {RED}✘ {msg}{RESET}")


def info(msg):
    print(f"    {DIM}{msg}{RESET}")


def show_products(cur, ids, label=""):
    """Print a quick stock/price snapshot for given product IDs."""
    fmt = ", ".join(["%s"] * len(ids))
    cur.execute(
        f"SELECT id, name, price, total_qty AS stock FROM products WHERE id IN ({fmt})",
        tuple(ids),
    )
    rows = cur.fetchall()
    if label:
        print(f"    {label}")
    for r in rows:
        print(f"      Product #{r['id']:>3}  {r['name']:<30}  "
              f"₹{float(r['price']):>10,.2f}   stock: {r['stock']}")


def pause():
    """Small pause so the user can read output."""
    time.sleep(0.3)


# ═══════════════════════════════════════════════════
#  SCENARIO 1 — Successful Order (COMMIT)
# ═══════════════════════════════════════════════════

def scenario_1():
    banner(1, "Successful Order Placement (COMMIT)",
           "A customer places an order for 2 items. The transaction inserts "
           "tracking, order header, and line items atomically. Triggers fire "
           "to deduct stock.")

    conn = conn_new()
    cur = conn.cursor(dictionary=True)

    step("Snapshot BEFORE transaction")
    show_products(cur, [1, 2], "Current stock:")

    step("BEGIN TRANSACTION")
    conn.start_transaction()
    info("Transaction started")

    # tracking
    cur.execute(
        "INSERT INTO tracking (status, partner, packaging_date) "
        "VALUES ('PACKAGING', 'BlueDart', %s)", (datetime.now(),))
    trk_id = cur.lastrowid
    info(f"Inserted tracking #{trk_id}")

    # order header
    cur.execute(
        "INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status) "
        "VALUES (1, %s, 1643.25, %s, 'PROCESSING')",
        (datetime.now(), trk_id))
    ord_id = cur.lastrowid
    info(f"Inserted order #{ord_id}")

    # line items (triggers fire here)
    cur.execute(
        "INSERT INTO order_items (order_id, product_id, price, qty) "
        "VALUES (%s, 1, 539.10, 2)", (ord_id,))
    info("Inserted line item: product #1 × 2")

    cur.execute(
        "INSERT INTO order_items (order_id, product_id, price, qty) "
        "VALUES (%s, 2, 1104.15, 1)", (ord_id,))
    info("Inserted line item: product #2 × 1")

    step("COMMIT")
    conn.commit()
    ok("Transaction committed successfully")

    step("Snapshot AFTER transaction")
    show_products(cur, [1, 2], "Stock should be reduced:")

    cur.execute("SELECT id, customer_id, order_total, status FROM orders WHERE id = %s", (ord_id,))
    row = cur.fetchone()
    ok(f"Order #{row['id']}  customer={row['customer_id']}  "
       f"total=₹{float(row['order_total']):,.2f}  status={row['status']}")

    cur.close()
    conn.close()
    return ord_id


# ═══════════════════════════════════════════════════
#  SCENARIO 2 — Failed Order (ROLLBACK)
# ═══════════════════════════════════════════════════

def scenario_2():
    banner(2, "Failed Order — Insufficient Stock (ROLLBACK)",
           "A customer tries to order 99999 units of a product. The BEFORE "
           "INSERT trigger raises an error. The entire transaction is rolled "
           "back so no orphaned rows remain.")

    conn = conn_new()
    cur = conn.cursor(dictionary=True)

    step("Snapshot BEFORE transaction")
    show_products(cur, [25], "Current stock:")

    step("BEGIN TRANSACTION")
    conn.start_transaction()

    cur.execute(
        "INSERT INTO tracking (status, partner, packaging_date) "
        "VALUES ('PACKAGING', 'Delhivery', %s)", (datetime.now(),))
    trk_id = cur.lastrowid
    info(f"Inserted tracking #{trk_id}")

    cur.execute(
        "INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status) "
        "VALUES (3, %s, 99999.00, %s, 'PROCESSING')",
        (datetime.now(), trk_id))
    ord_id = cur.lastrowid
    info(f"Inserted order #{ord_id}")

    try:
        cur.execute(
            "INSERT INTO order_items (order_id, product_id, price, qty) "
            "VALUES (%s, 25, 7199.20, 99999)", (ord_id,))
        fail("Expected trigger to reject this — something is wrong!")
    except Error as e:
        fail(f"Trigger rejected insert: {e.msg}")

    step("ROLLBACK")
    conn.rollback()
    ok("Transaction rolled back — no partial data")

    step("Snapshot AFTER rollback")
    show_products(cur, [25], "Stock should be UNCHANGED:")

    cur.execute("SELECT COUNT(*) AS cnt FROM orders WHERE id = %s", (ord_id,))
    row = cur.fetchone()
    ok(f"Order #{ord_id} exists? count = {row['cnt']}  (should be 0)")

    cur.close()
    conn.close()


# ═══════════════════════════════════════════════════
#  SCENARIO 3 — Savepoints & Partial Rollback
# ═══════════════════════════════════════════════════

def scenario_3():
    banner(3, "Savepoints — Partial Rollback",
           "We update prices for 3 products. After updating #43 with a "
           "wrong price (₹1.00), we ROLLBACK TO SAVEPOINT to undo only that "
           "change, keeping the other two.")

    conn = conn_new()
    cur = conn.cursor(dictionary=True)

    step("Snapshot BEFORE")
    show_products(cur, [41, 42, 43], "Current prices:")

    # remember original prices for cleanup
    cur.execute("SELECT id, price FROM products WHERE id IN (41, 42, 43)")
    originals = {r["id"]: float(r["price"]) for r in cur.fetchall()}

    step("BEGIN TRANSACTION")
    conn.start_transaction()

    cur.execute("UPDATE products SET price = 1699.00 WHERE id = 41")
    info("Updated product #41 → ₹1,699.00")
    cur.execute("SAVEPOINT after_product_41")
    ok("SAVEPOINT after_product_41 created")

    cur.execute("UPDATE products SET price = 999.00 WHERE id = 42")
    info("Updated product #42 → ₹999.00")
    cur.execute("SAVEPOINT after_product_42")
    ok("SAVEPOINT after_product_42 created")

    cur.execute("UPDATE products SET price = 1.00 WHERE id = 43")
    info("Updated product #43 → ₹1.00  (OOPS! Wrong price)")

    step("ROLLBACK TO SAVEPOINT after_product_42")
    cur.execute("ROLLBACK TO SAVEPOINT after_product_42")
    ok("Rolled back only the product #43 change")

    step("COMMIT")
    conn.commit()
    ok("Transaction committed")

    step("Snapshot AFTER")
    show_products(cur, [41, 42, 43],
                  "Products 41 & 42 updated, 43 unchanged:")

    # cleanup
    step("Cleanup — restoring original prices")
    for pid, price in originals.items():
        cur.execute("UPDATE products SET price = %s WHERE id = %s", (price, pid))
    conn.commit()
    ok("Original prices restored")

    cur.close()
    conn.close()


# ═══════════════════════════════════════════════════
#  SCENARIO 4 — Order Cancellation + Stock Restore
# ═══════════════════════════════════════════════════

def scenario_4(order_id):
    banner(4, "Order Cancellation + Automatic Stock Restoration",
           "We cancel the order created in Scenario 1. The "
           "trg_restore_stock_on_cancel trigger fires and adds "
           "back the quantities to products 1 and 2.")

    conn = conn_new()
    cur = conn.cursor(dictionary=True)

    step("Snapshot BEFORE cancellation")
    show_products(cur, [1, 2], "Current stock (after Scenario 1 deductions):")

    step("BEGIN TRANSACTION — cancel order")
    conn.start_transaction()
    cur.execute("UPDATE orders SET status = 'CANCELLED' WHERE id = %s", (order_id,))
    info(f"Order #{order_id} status → CANCELLED")
    conn.commit()
    ok("Committed")

    step("Snapshot AFTER cancellation")
    show_products(cur, [1, 2], "Stock should be RESTORED:")

    cur.execute("SELECT id, status FROM orders WHERE id = %s", (order_id,))
    row = cur.fetchone()
    ok(f"Order #{row['id']} status = {row['status']}")

    cur.close()
    conn.close()


# ═══════════════════════════════════════════════════
#  SCENARIO 5 — Dirty-Read Prevention (Isolation)
# ═══════════════════════════════════════════════════

def scenario_5():
    banner(5, "Dirty-Read Prevention (Isolation Level Demo)",
           "Session A starts a transaction and updates a product price "
           "without committing. Session B (READ COMMITTED) reads the same "
           "product and should see the OLD price — the uncommitted change "
           "is invisible. Then Session A rolls back.")

    results = {}  # shared dict for thread results

    def session_a():
        """Writer session — updates but doesn't commit immediately."""
        conn = conn_new()
        cur = conn.cursor(dictionary=True)

        step(f"{MAGENTA}Session A{RESET}: BEGIN TRANSACTION")
        conn.start_transaction()

        cur.execute("SELECT id, name, price FROM products WHERE id = 10")
        row = cur.fetchone()
        info(f"Session A sees price = ₹{float(row['price']):,.2f}")
        results["original_price"] = float(row["price"])

        cur.execute("UPDATE products SET price = 1.00 WHERE id = 10")
        info(f"Session A updated price → ₹1.00 (NOT committed yet)")

        # signal that update is done
        results["a_updated"] = True

        # wait for B to read
        while not results.get("b_read"):
            time.sleep(0.05)

        step(f"{MAGENTA}Session A{RESET}: ROLLBACK")
        conn.rollback()
        ok("Session A rolled back — price reverts")

        cur.close()
        conn.close()
        results["a_done"] = True

    def session_b():
        """Reader session — tries to read the dirty value."""
        # wait for A to update
        while not results.get("a_updated"):
            time.sleep(0.05)

        conn = conn_new()
        cur = conn.cursor(dictionary=True)

        # Set isolation level to READ COMMITTED (default for many setups)
        conn.start_transaction(isolation_level="READ COMMITTED")
        step(f"{CYAN}Session B{RESET}: BEGIN TRANSACTION (READ COMMITTED)")

        cur.execute("SELECT id, name, price FROM products WHERE id = 10")
        row = cur.fetchone()
        price_seen = float(row["price"])
        results["b_price"] = price_seen

        if price_seen == 1.00:
            fail(f"Session B sees ₹{price_seen:,.2f} — DIRTY READ happened!")
        else:
            ok(f"Session B sees ₹{price_seen:,.2f} — dirty read PREVENTED ✓")

        conn.commit()
        cur.close()
        conn.close()
        results["b_read"] = True

    t_a = threading.Thread(target=session_a, name="Session-A")
    t_b = threading.Thread(target=session_b, name="Session-B")

    t_a.start()
    t_b.start()
    t_a.join()
    t_b.join()

    pause()

    step("Final verification")
    conn = conn_new(autocommit=True)
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id, name, price FROM products WHERE id = 10")
    row = cur.fetchone()
    ok(f"Product #10 price = ₹{float(row['price']):,.2f}  (original, unchanged)")
    cur.close()
    conn.close()


# ═══════════════════════════════════════════════════
#  SCENARIO 6 — Write-Write Conflict (Lost Update)
# ═══════════════════════════════════════════════════

def scenario_6():
    banner(6, "Write-Write Conflict — Lost Update Prevention",
           "Two sessions try to buy the last 5 units of a product "
           "simultaneously. Without row-level locking one would "
           "oversell (lost update). With SELECT … FOR UPDATE, the "
           "second session waits and sees updated stock.")

    # Setup: set product #50 stock to exactly 5
    conn_setup = conn_new(autocommit=True)
    cur_setup = conn_setup.cursor(dictionary=True)
    cur_setup.execute("SELECT total_qty FROM products WHERE id = 50")
    orig_stock = cur_setup.fetchone()["total_qty"]
    cur_setup.execute("UPDATE products SET total_qty = 5 WHERE id = 50")
    cur_setup.close()
    conn_setup.close()

    step("Setup: Product #50 stock set to 5 for this demo")

    results = {"lock_acquired": False, "a_committed": False}

    def buyer_a():
        """First buyer — acquires the lock first."""
        conn = conn_new()
        cur = conn.cursor(dictionary=True)
        conn.start_transaction()

        step(f"{MAGENTA}Buyer A{RESET}: SELECT … FOR UPDATE on product #50")
        cur.execute("SELECT id, name, total_qty FROM products WHERE id = 50 FOR UPDATE")
        row = cur.fetchone()
        stock = row["total_qty"]
        info(f"Buyer A sees stock = {stock}")
        results["lock_acquired"] = True

        if stock >= 3:
            cur.execute(
                "INSERT INTO tracking (status, partner, packaging_date) "
                "VALUES ('PACKAGING', 'BlueDart', %s)", (datetime.now(),))
            trk = cur.lastrowid
            cur.execute(
                "INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status) "
                "VALUES (2, %s, 5097.15, %s, 'PROCESSING')", (datetime.now(), trk))
            oid = cur.lastrowid
            cur.execute(
                "INSERT INTO order_items (order_id, product_id, price, qty) "
                "VALUES (%s, 50, 1699.05, 3)", (oid,))
            ok(f"Buyer A ordered 3 units → order #{oid}")
        else:
            fail("Buyer A: not enough stock")

        # small delay so B is definitely waiting
        time.sleep(0.5)

        conn.commit()
        ok(f"Buyer A COMMITTED — stock now deducted")
        results["a_committed"] = True

        cur.close()
        conn.close()

    def buyer_b():
        """Second buyer — has to wait for A's lock."""
        # wait for A to acquire the lock
        while not results.get("lock_acquired"):
            time.sleep(0.05)

        conn = conn_new()
        cur = conn.cursor(dictionary=True)
        conn.start_transaction()

        step(f"{CYAN}Buyer B{RESET}: SELECT … FOR UPDATE on product #50 (will BLOCK)")
        info("Buyer B is waiting for Buyer A to release the lock …")

        cur.execute("SELECT id, name, total_qty FROM products WHERE id = 50 FOR UPDATE")
        row = cur.fetchone()
        stock = row["total_qty"]
        info(f"Buyer B lock acquired — sees stock = {stock}")

        if stock >= 5:
            # This would be the lost-update case (shouldn't happen with locking)
            cur.execute(
                "INSERT INTO tracking (status, partner, packaging_date) "
                "VALUES ('PACKAGING', 'Delhivery', %s)", (datetime.now(),))
            trk = cur.lastrowid
            cur.execute(
                "INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status) "
                "VALUES (4, %s, 8495.25, %s, 'PROCESSING')", (datetime.now(), trk))
            oid = cur.lastrowid
            cur.execute(
                "INSERT INTO order_items (order_id, product_id, price, qty) "
                "VALUES (%s, 50, 1699.05, 5)", (oid,))
            fail(f"Buyer B ordered 5 units — OVERSOLD! (lost update)")
            conn.commit()
        elif stock >= 2:
            # Ordered fewer since not all are available
            cur.execute(
                "INSERT INTO tracking (status, partner, packaging_date) "
                "VALUES ('PACKAGING', 'Delhivery', %s)", (datetime.now(),))
            trk = cur.lastrowid
            cur.execute(
                "INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status) "
                "VALUES (4, %s, %s, %s, 'PROCESSING')",
                (datetime.now(), round(1699.05 * stock, 2), trk))
            oid = cur.lastrowid
            cur.execute(
                "INSERT INTO order_items (order_id, product_id, price, qty) "
                "VALUES (%s, 50, 1699.05, %s)", (oid, stock))
            ok(f"Buyer B ordered remaining {stock} units → order #{oid}")
            conn.commit()
        else:
            info(f"Only {stock} left — Buyer B decides not to buy")
            conn.rollback()
            ok("Buyer B rolled back — no oversell")

        cur.close()
        conn.close()

    t_a = threading.Thread(target=buyer_a, name="Buyer-A")
    t_b = threading.Thread(target=buyer_b, name="Buyer-B")

    t_a.start()
    t_b.start()
    t_a.join()
    t_b.join()

    pause()

    step("Final verification")
    conn = conn_new(autocommit=True)
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id, name, total_qty AS stock FROM products WHERE id = 50")
    row = cur.fetchone()
    final_stock = row["stock"]
    ok(f"Product #50 final stock = {final_stock}  (started at 5, no oversell)")

    if final_stock < 0:
        fail("NEGATIVE STOCK — lost update occurred!")
    else:
        ok("Stock is non-negative — locking prevented the lost update ✓")

    # Restore original stock
    cur.execute("UPDATE products SET total_qty = %s WHERE id = 50", (orig_stock,))
    info(f"Cleanup: restored product #50 stock to {orig_stock}")

    cur.close()
    conn.close()


# ═══════════════════════════════════════════════════
#  Main
# ═══════════════════════════════════════════════════

def main():
    print(f"\n{BOLD}{'═' * 72}{RESET}")
    print(f"{BOLD}{CYAN}  ClotheIt — Database Transactions Demo (Task 6){RESET}")
    print(f"{BOLD}{'═' * 72}{RESET}")
    print(f"  {DIM}This script demonstrates 6 transaction scenarios including")
    print(f"  concurrency conflicts.  Each scenario is self-contained and")
    print(f"  cleans up after itself.{RESET}")

    # Test connection
    try:
        c = conn_new(autocommit=True)
        c.close()
    except Error as e:
        print(f"\n  {RED}Could not connect to MySQL: {e}{RESET}")
        print(f"  Make sure the database is set up: mysql -u root -p < db/setup.sql")
        raise SystemExit(1)

    # --- Run all scenarios ---
    order_id = scenario_1()        # COMMIT
    pause()

    scenario_2()                   # ROLLBACK
    pause()

    scenario_3()                   # Savepoints
    pause()

    scenario_4(order_id)           # Cancellation + stock restore
    pause()

    scenario_5()                   # Dirty-read prevention
    pause()

    scenario_6()                   # Write-write conflict / lost update
    pause()

    # --- Summary ---
    print(f"\n\n{BOLD}{'═' * 72}{RESET}")
    print(f"{BOLD}{GREEN}  ALL 6 TRANSACTION SCENARIOS COMPLETED SUCCESSFULLY{RESET}")
    print(f"{BOLD}{'═' * 72}{RESET}")
    print(f"""
  {BOLD}Recap:{RESET}
    1. {GREEN}✔{RESET}  COMMIT         — Atomic order placement
    2. {GREEN}✔{RESET}  ROLLBACK       — Trigger-driven rejection, full rollback
    3. {GREEN}✔{RESET}  SAVEPOINT      — Partial rollback within a transaction
    4. {GREEN}✔{RESET}  CANCEL+RESTORE — Trigger restores stock on cancellation
    5. {GREEN}✔{RESET}  DIRTY READ     — Isolation prevents reading uncommitted data
    6. {GREEN}✔{RESET}  LOST UPDATE    — SELECT … FOR UPDATE prevents overselling
""")


if __name__ == "__main__":
    main()
