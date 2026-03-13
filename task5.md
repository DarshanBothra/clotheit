# Task 5 — Embedded SQL Applications & Triggers

## What this is about

For this task we wrote two Python applications that talk to our ClotheIt MySQL database using embedded SQL (via `mysql-connector-python`), and defined three database triggers that enforce business rules at the DB level.

The idea was to pick two realistic use-cases from our e-commerce domain — placing an order, and analyzing inventory/customers — and build small CLI tools around them. The triggers exist so that certain critical checks (like "don't sell more than what's in stock") happen inside the database itself, not just in application code.

---

## The two applications

### 1. `app/place_order.py` — Order Placement

This one simulates the core shopping flow:

- You log in as a customer (by ID).
- You can browse the product catalog, optionally filtering by tag (e.g. "cotton", "formal", "jeans").
- You add items to a cart with quantities.
- When you confirm, the app starts a transaction — it locks the relevant product rows (`SELECT ... FOR UPDATE`), computes effective prices after discount, creates a tracking entry, inserts the order header, and then inserts each line item.
- At the end it prints a receipt with all the details.

The important thing here is that the `INSERT INTO order_items` calls are where the triggers kick in. The BEFORE INSERT trigger checks stock, and the AFTER INSERT trigger deducts it. So even if someone somehow bypassed the app-level check, the database would still reject an oversold item.

We used `FOR UPDATE` row locks plus the trigger as a belt-and-suspenders approach — the app checks stock in Python, and the DB double-checks via the trigger.

### 2. `app/analytics.py` — Inventory & Customer Analytics

This is a menu-driven dashboard with six reports:

1. **Low-Stock Alert** — finds products below a given stock threshold. Useful for reordering decisions.
2. **Customer Spending & Segmentation** — ranks every customer by total spend and assigns them a tier (Platinum / Gold / Silver / Bronze). Handy for targeted marketing.
3. **Vendor Revenue Breakdown** — shows each vendor's total revenue, number of orders fulfilled, and inventory levels.
4. **Monthly Sales Trend** — aggregates orders by month so you can see if sales are growing or dipping.
5. **Top-Selling Products** — ranks products by units sold.
6. **Complaint Summary** — per-customer breakdown of open/resolved/closed complaints.

All of these are read-only queries with JOINs, GROUP BY, CASE expressions, and aggregations. Nothing fancy on the Python side — the heavy lifting is in the SQL.

---

## The triggers

All three are defined in `db/triggers.sql`.

### Trigger 1: `trg_check_stock_before_order_item` (BEFORE INSERT on `order_items`)

Fires right before a new order item row is inserted. It looks up the product's `total_qty` and compares it to the requested quantity. If stock is insufficient, it raises a MySQL error (`SIGNAL SQLSTATE '45000'`) and the insert is rejected. This prevents overselling at the database level regardless of what the application does.

### Trigger 2: `trg_deduct_stock_after_order_item` (AFTER INSERT on `order_items`)

Fires right after an order item is successfully inserted (meaning it passed Trigger 1). It decrements the product's `total_qty` by the ordered quantity. This keeps inventory in sync automatically — the application doesn't need to run a separate `UPDATE products SET total_qty = ...` statement.

### Trigger 3 (bonus): `trg_restore_stock_on_cancel` (AFTER UPDATE on `orders`)

Fires when an order's status changes to `CANCELLED`. It loops through all items in that order and adds their quantities back to the respective products. This handles the inventory-restoration side of cancellations without the app needing to manually reverse each line item.

---

## How to run it

### Prerequisites

- MySQL 8.0+ running locally
- Python 3.10+
- The ClotheIt database already set up (`schema.sql` + `seed.sql`)

### Setup

```bash
# from the project root
python3 -m venv venv
source venv/bin/activate
pip install mysql-connector-python tabulate

# load the triggers into MySQL
mysql -u clotheit -p clotheit_data < db/triggers.sql
```

### Running the apps

```bash
# activate venv first
source venv/bin/activate

# order placement
python app/place_order.py

# analytics dashboard
python app/analytics.py
```

The order placement app will walk you through picking a customer, browsing products, building a cart, and placing the order. The analytics app gives you a numbered menu — just pick a report and it prints the results in a formatted table.

---

## Why we did it this way

- **Python + mysql-connector** was the simplest choice for embedded SQL. No ORM, no abstraction layers — just raw parameterized queries, which is what the task asks for.
- **Triggers at the DB level** mean the integrity rules hold even if someone connects to the database directly (say, through the MySQL CLI) and tries to insert an order item manually. The app doesn't have to be the only gatekeeper.
- **Transactions with row-level locking** (`FOR UPDATE`) in the order placement app prevent race conditions if two customers try to buy the last item at the same time.
- We kept the code straightforward — no classes, no frameworks, just functions and a `main()` loop. Easy to read, easy to demo.
