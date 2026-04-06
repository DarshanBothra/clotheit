# Task 6 — Database Transactions (Including Conflicting Ones)

## What this is about

For Task 6 we wrote and executed database transactions — both simple and conflicting — and observed their effects on the ClotheIt database. We demonstrate the ACID properties of MySQL/InnoDB in practice: atomicity (COMMIT/ROLLBACK), consistency (trigger-enforced constraints), isolation (dirty-read prevention), and durability (committed data survives).

We built two deliverables:

1. **`db/transactions.sql`** — Standalone SQL transactions that can be run in the MySQL CLI.
2. **`app/transactions.py`** — A Python script that runs 6 scenarios including concurrency/conflict demos using threaded connections.

---

## The 6 transaction scenarios

### Scenario 1: Successful Order Placement (COMMIT)

A customer places an order for 2 products. The transaction:
- Inserts a tracking record
- Inserts the order header
- Inserts 2 line items (triggers fire to deduct stock)
- COMMITs

We verify that stock decreases and the order row persists.

### Scenario 2: Failed Order — Insufficient Stock (ROLLBACK)

A customer tries to order 99,999 units of a product that only has ~80 in stock. The `trg_check_stock_before_order_item` trigger raises an error (`SIGNAL SQLSTATE '45000'`). The app catches the exception and ROLLBACKs the entire transaction. We verify:
- No orphaned tracking or order rows remain
- Stock is unchanged

This demonstrates atomicity — either all operations succeed, or none do.

### Scenario 3: Savepoints — Partial Rollback

We update the prices of 3 products within a single transaction, creating a SAVEPOINT after each update. After the third update (an intentionally wrong price of ₹1.00), we `ROLLBACK TO SAVEPOINT` to undo only that change while keeping the first two. We verify:
- Products 41 and 42 have new prices
- Product 43 is untouched

### Scenario 4: Order Cancellation + Automatic Stock Restoration

We cancel the order created in Scenario 1. The `trg_restore_stock_on_cancel` trigger fires automatically and adds back the quantities for all items in that order. We verify that stock returns to its pre-order levels.

### Scenario 5: Dirty-Read Prevention (Isolation Level)

Two concurrent sessions access the same product:
- **Session A** starts a transaction and updates a product's price to ₹1.00 **without committing**.
- **Session B** (running at `READ COMMITTED` isolation) reads the same product and should see the **original price**, not Session A's uncommitted change.
- Session A then rolls back.

This proves that InnoDB's isolation prevents dirty reads — a transaction cannot see another transaction's uncommitted work.

### Scenario 6: Write-Write Conflict — Lost Update Prevention

Two buyers try to purchase the last 5 units of the same product simultaneously:
- **Buyer A** runs `SELECT … FOR UPDATE` (acquires a row-level lock), sees 5 in stock, and orders 3 units.
- **Buyer B** runs the same `SELECT … FOR UPDATE` but **blocks** until Buyer A commits.
- When Buyer B finally acquires the lock, it sees the updated stock (now 2), and orders only the remaining 2 — no overselling.

Without the `FOR UPDATE` lock, both buyers would read stock = 5 and both would order their full quantities, resulting in a **lost update** and negative stock. The lock serialises the access and prevents this.

---

## Files

| File | What it does |
|------|-------------|
| `db/transactions.sql` | 4 standalone transaction examples (COMMIT, ROLLBACK, SAVEPOINT, CANCEL) for MySQL CLI |
| `app/transactions.py` | Python script with 6 scenarios including concurrency demos via threads |

---

## How to run

### The SQL file (quick demo)

```bash
mysql -u clotheit -p'Clotheit@2026' clotheit_data < db/transactions.sql
```

Or interactively:
```sql
SOURCE db/transactions.sql;
```

### The Python script (full demo with concurrency)

```bash
source venv/bin/activate
python app/transactions.py
```

This runs all 6 scenarios in sequence, printing coloured output with stock snapshots before/after each transaction. The concurrency demos in Scenarios 5 and 6 use Python threads to simulate two database sessions running in parallel.

---

## Why it matters

| Concept | How we demonstrated it |
|---------|----------------------|
| **Atomicity** | Scenarios 1 & 2 — all-or-nothing via COMMIT/ROLLBACK |
| **Consistency** | Scenario 2 — trigger enforces stock constraint inside the DB |
| **Isolation** | Scenario 5 — READ COMMITTED prevents dirty reads |
| **Durability** | Scenario 1 — after COMMIT, the order survives even if the app crashes |
| **Savepoints** | Scenario 3 — partial rollback within a transaction |
| **Row-level Locking** | Scenario 6 — `FOR UPDATE` prevents lost updates / overselling |
| **Trigger-driven side effects** | Scenario 4 — cancellation automatically restores stock |

---

## Key takeaways for the demo

1. **Transactions are essential for multi-step operations.** An order placement involves 3+ tables — if any step fails, ROLLBACK ensures we don't leave garbage data behind.
2. **Triggers enforce rules at the database level** — even if someone connects via MySQL CLI and runs raw SQL, the stock check and deduction still happen.
3. **Isolation levels control what concurrent transactions can see.** READ COMMITTED prevents dirty reads; REPEATABLE READ (MySQL default) goes further and prevents non-repeatable reads.
4. **Row-level locking with `SELECT … FOR UPDATE`** is the standard way to prevent lost updates in concurrent environments. Without it, two threads reading the same row at the same time could both act on stale data.
