# Demo Walkthrough — Task 4 & Task 5

## Before the demo (prep, do this the night before)

Open **three terminal tabs** in your project folder. You'll use them for:
1. MySQL CLI (for Task 4 queries)
2. Flask backend server
3. Vite frontend server

---

## Part 1: Task 4 — The 15 SQL Queries

### What to say

> "For Task 4, we wrote 15 SQL queries of varying complexity covering different relational algebra operations — selection, projection, joins, subqueries, aggregation, set operations, and DML. Let me run them against our live database."

### Commands to run (Terminal 1)

```bash
cd ~/clotheit
mysql -u root -p'Root@9999'
```

Once inside MySQL:

```sql
SOURCE db/queries.sql
```

This runs all 15 queries in sequence. Each one has a comment block explaining what it does and which relational operation it demonstrates.

### What to say as results appear

Walk through a few highlights:

- **Query 1** (Selection + Projection): "This pulls customers who signed up in Q1 2024 — basic selection and projection."
- **Query 2** (Inner Join): "Product catalog with vendor info — a standard inner join."
- **Query 3** (Multi-table Join + Aggregation): "Order summary — joins orders, customers, and order_items, then groups to count items per order."
- **Query 5** (Nested Subquery): "High-value customers — finds orders above the average order total using a subquery."
- **Query 7** (Union): "Combined contact directory of all customers and vendors — a union operation."
- **Query 8** (Intersection via EXISTS): "Customers who have both placed orders AND filed complaints."
- **Query 9** (Set Difference via NOT EXISTS): "Inactive customers — signed up but never ordered."
- **Query 10** (GROUP BY + HAVING): "Revenue per vendor, filtered to those above 3000 rupees."
- **Query 12** (Window Function / Ranking): "Products ranked by price within each vendor using RANK()."
- **Query 15** (DML — INSERT, UPDATE, DELETE): "Demonstrates data manipulation — insert a product, update its price, then delete it."

> "So that covers selection, projection, joins, subqueries, union, intersection, set difference, aggregation with HAVING, window functions, cross-database joins, and DML operations — all 15 queries."

---

## Part 2: Task 5 — Embedded SQL Applications & Triggers

### Step 1: Show the triggers

Stay in the MySQL CLI (Terminal 1):

```sql
USE clotheit_data;
SHOW TRIGGERS\G
```

### What to say

> "For Task 5, we defined three database triggers. Let me show them."

> **Trigger 1** — `trg_check_stock_before_order_item`: "This is a BEFORE INSERT trigger on order_items. Before any line item gets inserted, it checks if the product has enough stock. If not, it raises an error and blocks the insert. This is a database-level safety net."

> **Trigger 2** — `trg_deduct_stock_after_order_item`: "This is an AFTER INSERT trigger on order_items. Once a line item is successfully inserted, it automatically decrements the product's stock. The app doesn't need a separate UPDATE statement."

> **Trigger 3** — `trg_restore_stock_on_cancel`: "This is an AFTER UPDATE trigger on orders. When an order gets cancelled, it restores the stock for all items in that order."

### Step 2: Demo the triggers in action

Still in MySQL CLI:

```sql
-- Check current stock of product 1
SELECT id, name, total_qty FROM products WHERE id = 1;

-- Insert a test order item (this will fire both triggers)
INSERT INTO orders (customer_id, order_datetime, order_total, status)
VALUES (1, NOW(), 100, 'PROCESSING');

INSERT INTO order_items (order_id, product_id, price, qty)
VALUES (LAST_INSERT_ID(), 1, 539.10, 3);

-- Check stock again — should be 3 less
SELECT id, name, total_qty FROM products WHERE id = 1;
```

> "See? The stock dropped by 3 automatically — that's Trigger 2 doing its job."

Now test the stock check trigger:

```sql
-- Try to order more than available (this should fail)
INSERT INTO order_items (order_id, product_id, price, qty)
VALUES (1, 1, 539.10, 999999);
```

> "And there's the error — 'Insufficient stock for this product.' That's Trigger 1 blocking the oversell."

Then exit MySQL:

```sql
EXIT;
```

---

### Step 3: Start the Python CLI apps

**Terminal 1** — Order placement app:

```bash
cd ~/clotheit
source venv/bin/activate
python app/place_order.py
```

When it asks:
- Enter Customer ID: **1**
- Filter by tag: **cotton** (or leave blank for all)
- It shows the product table
- Add product ID: **1**, Quantity: **2**
- Type **done**
- It places the order and prints a receipt

### What to say

> "This is the order placement application — embedded SQL in Python using mysql-connector. It browses products, builds a cart, and places an order inside a transaction with row-level locking. The triggers fire during the INSERT INTO order_items — the BEFORE trigger checks stock, the AFTER trigger deducts it."

**Terminal 1** — Analytics app:

```bash
python app/analytics.py
```

Walk through a couple of options:
- Press **2** — Customer Spending & Segmentation (shows tier badges: Platinum, Gold, Silver, Bronze)
- Press **4** — Monthly Sales Trend
- Press **5** — Top Products (enter **5** for top 5)
- Press **0** to exit

### What to say

> "This is the analytics application — also embedded SQL in Python. It runs complex queries with JOINs, GROUP BY, CASE expressions, and aggregations to generate reports like customer segmentation, vendor revenue, and sales trends."

---

### Step 4: Start the web UI

Now the impressive part. Open **Terminal 2**:

```bash
cd ~/clotheit
source venv/bin/activate
python app/server.py
```

Open **Terminal 3**:

```bash
cd ~/clotheit/frontend
npm run dev
```

Then open your browser to **http://localhost:5173/**

### What to say

> "We also built a full web interface — React frontend with Tailwind CSS, talking to a Flask REST API that wraps the same embedded SQL functions."

### What to click and show

1. **Shop page** (loads automatically at `/`)
   - > "This is the product catalog. 100 products from 20 vendors, with prices, discounts, and stock levels."
   - Click a tag chip like **"formal"** or **"cotton"** to filter
   - > "Tag filtering hits the database — it's the same SQL query with a WHERE clause on the tags table."
   - Type something in the search bar
   - > "Search is client-side filtering on top of the API results."
   - Click **"Add to Cart"** on 2-3 products

2. **Cart drawer** (click the bag icon in the top-right)
   - > "The cart drawer shows selected items with quantity controls."
   - Adjust quantities with + / - buttons
   - Click **"Place Order"**
   - > "This sends a POST to the API, which starts a transaction, locks the product rows, inserts the order and line items — and the triggers fire to check and deduct stock."
   - You'll see an alert with the order ID

3. **My Orders page** (click "My Orders" in the nav)
   - > "This shows all orders for the selected customer."
   - Click on an order card to expand it
   - > "Each order shows the tracking status, delivery partner, and line items."

4. **Change customer** (use the dropdown in the navbar, pick Customer #7 or #10)
   - > "We can switch customers — this is like a lightweight login. The orders page updates to show that customer's orders."

5. **Analytics page** (click "Analytics" in the nav)
   - **Low Stock tab**: > "Products below the stock threshold, with status badges."
   - **Customers tab**: > "Customer spending analysis with tier segmentation — Platinum, Gold, Silver, Bronze — based on total spend."
   - **Vendors tab**: > "Revenue breakdown per vendor."
   - **Monthly Sales tab**: > "Monthly sales trend with a visual bar for revenue."
   - **Top Products tab**: > "Top-selling products ranked by units sold."
   - **Complaints tab**: > "Complaint summary per customer — open complaints highlighted in red."

---

## Wrapping up

### What to say at the end

> "So to summarize — Task 4 has 15 SQL queries covering all the required relational operations. Task 5 has two Python applications with embedded SQL — one for ordering, one for analytics — plus three database triggers that enforce stock checks, automatic inventory deduction, and stock restoration on cancellation. And we built a React web UI on top of it all that talks to the same database through a Flask API."

---

## Quick reference — all commands in order

| Step | Terminal | Command |
|------|----------|---------|
| Task 4 queries | 1 | `mysql -u root -p'Root@9999'` then `SOURCE db/queries.sql` |
| Show triggers | 1 | `SHOW TRIGGERS\G` |
| Demo triggers | 1 | (the INSERT/SELECT commands above) |
| CLI: place order | 1 | `source venv/bin/activate && python app/place_order.py` |
| CLI: analytics | 1 | `python app/analytics.py` |
| Start API | 2 | `cd ~/clotheit && source venv/bin/activate && python app/server.py` |
| Start frontend | 3 | `cd ~/clotheit/frontend && npm run dev` |
| Open browser | — | http://localhost:5173/ |
