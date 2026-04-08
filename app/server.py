"""
ClotheIt — Flask REST API
Wraps the existing embedded-SQL functions from place_order.py
and analytics.py into JSON endpoints for the React frontend.
"""

import decimal
import datetime
import mysql.connector
from mysql.connector import Error
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

DB_CONFIG = {
    "host": "localhost",
    "user": "clotheit",
    "password": "Clotheit@2026",
    "database": "clotheit_data",
}


def get_conn():
    return mysql.connector.connect(**DB_CONFIG, autocommit=True)


def serialize(rows):
    """Convert Decimal / datetime objects so json.dumps won't choke."""
    out = []
    for row in rows:
        clean = {}
        for k, v in row.items():
            if isinstance(v, decimal.Decimal):
                clean[k] = float(v)
            elif isinstance(v, (datetime.datetime, datetime.date)):
                clean[k] = v.isoformat()
            else:
                clean[k] = v
        out.append(clean)
    return out


# ─── Customers ────────────────────────────────────────

@app.get("/api/customers")
def api_customers():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.id, c.name, c.email, c.phone,
               a.address_line1, a.city, a.state, a.pincode
        FROM customers c
        JOIN addresses a ON c.billing_address = a.id
        ORDER BY c.id
    """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/customers/<int:cid>")
def api_customer(cid):
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.id, c.name, c.email, c.phone,
               a.address_line1, a.city, a.state, a.pincode
        FROM customers c
        JOIN addresses a ON c.billing_address = a.id
        WHERE c.id = %s
    """, (cid,))
    row = cur.fetchone()
    cur.close()
    conn.close()
    if not row:
        return jsonify({"error": "Customer not found"}), 404
    return jsonify(serialize([row])[0])


# ─── Products ─────────────────────────────────────────

@app.get("/api/products")
def api_products():
    tag = request.args.get("tag")
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    if tag:
        cur.execute("""
            SELECT DISTINCT p.id, p.name,
                   v.name AS vendor, v.affiliation AS brand,
                   p.price, p.discount,
                   ROUND(p.price * (1 - p.discount/100), 2) AS effective_price,
                   p.total_qty AS stock
            FROM products p
            JOIN vendors v ON p.vendor_id = v.id
            JOIN tags t ON t.product_id = p.id
            WHERE t.tag_name = %s AND p.total_qty > 0
            ORDER BY effective_price
        """, (tag,))
    else:
        cur.execute("""
            SELECT p.id, p.name,
                   v.name AS vendor, v.affiliation AS brand,
                   p.price, p.discount,
                   ROUND(p.price * (1 - p.discount/100), 2) AS effective_price,
                   p.total_qty AS stock
            FROM products p
            JOIN vendors v ON p.vendor_id = v.id
            WHERE p.total_qty > 0
            ORDER BY p.id
        """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/tags")
def api_tags():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT DISTINCT tag_name FROM tags ORDER BY tag_name")
    rows = [r["tag_name"] for r in cur.fetchall()]
    cur.close()
    conn.close()
    return jsonify(rows)


# ─── Orders ───────────────────────────────────────────

@app.get("/api/orders")
def api_orders_list():
    cid = request.args.get("customer_id", type=int)
    if not cid:
        return jsonify({"error": "customer_id required"}), 400
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT o.id AS order_id, o.order_datetime, o.order_total,
               o.status, t.status AS tracking, t.partner
        FROM orders o
        LEFT JOIN tracking t ON o.tracking_id = t.id
        WHERE o.customer_id = %s
        ORDER BY o.order_datetime DESC
    """, (cid,))
    orders = serialize(cur.fetchall())

    for order in orders:
        cur.execute("""
            SELECT oi.id AS item_id, p.name AS product,
                   oi.price AS unit_price, oi.qty,
                   ROUND(oi.price * oi.qty, 2) AS line_total
            FROM order_items oi
            JOIN products p ON oi.product_id = p.id
            WHERE oi.order_id = %s
        """, (order["order_id"],))
        order["items"] = serialize(cur.fetchall())

    cur.close()
    conn.close()
    return jsonify(orders)


@app.get("/api/orders/<int:oid>")
def api_order_detail(oid):
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT o.id AS order_id, c.name AS customer,
               o.order_datetime, o.order_total, o.status,
               t.status AS tracking, t.partner
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        LEFT JOIN tracking t ON o.tracking_id = t.id
        WHERE o.id = %s
    """, (oid,))
    header = cur.fetchone()
    if not header:
        cur.close()
        conn.close()
        return jsonify({"error": "Order not found"}), 404

    cur.execute("""
        SELECT oi.id AS item_id, p.name AS product,
               oi.price AS unit_price, oi.qty,
               ROUND(oi.price * oi.qty, 2) AS line_total
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = %s
    """, (oid,))
    items = serialize(cur.fetchall())
    cur.close()
    conn.close()

    result = serialize([header])[0]
    result["items"] = items
    return jsonify(result)


@app.post("/api/orders")
def api_place_order():
    body = request.get_json()
    if not body:
        return jsonify({"error": "JSON body required"}), 400
    customer_id = body.get("customer_id")
    cart = body.get("items", [])
    if not customer_id or not cart:
        return jsonify({"error": "customer_id and items required"}), 400

    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    try:
        conn.start_transaction()
        order_total = 0
        enriched = []
        for item in cart:
            cur.execute(
                "SELECT id, price, discount, total_qty "
                "FROM products WHERE id = %s FOR UPDATE",
                (item["product_id"],),
            )
            prod = cur.fetchone()
            if not prod:
                raise ValueError(
                    f"Product {item['product_id']} not found")
            if prod["total_qty"] < item["qty"]:
                raise ValueError(
                    f"Not enough stock for product {item['product_id']} "
                    f"(available: {prod['total_qty']}, "
                    f"requested: {item['qty']})")
            price = float(prod["price"])
            disc = float(prod["discount"])
            eff = round(price * (1 - disc / 100), 2)
            order_total += round(eff * item["qty"], 2)
            enriched.append({
                "product_id": prod["id"],
                "qty": item["qty"],
                "unit_price": eff,
            })

        now = datetime.datetime.now()
        cur.execute(
            "INSERT INTO tracking (status, partner, packaging_date) "
            "VALUES ('PACKAGING', 'BlueDart', %s)", (now,))
        tracking_id = cur.lastrowid

        cur.execute(
            "INSERT INTO orders "
            "(customer_id, order_datetime, order_total, tracking_id, status) "
            "VALUES (%s, %s, %s, %s, 'PROCESSING')",
            (customer_id, now, round(order_total, 2), tracking_id))
        order_id = cur.lastrowid

        for ei in enriched:
            cur.execute(
                "INSERT INTO order_items "
                "(order_id, product_id, price, qty) "
                "VALUES (%s, %s, %s, %s)",
                (order_id, ei["product_id"],
                 ei["unit_price"], ei["qty"]))

        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"order_id": order_id,
                        "order_total": round(order_total, 2)}), 201

    except ValueError as e:
        conn.rollback()
        cur.close()
        conn.close()
        return jsonify({"error": str(e)}), 400
    except Error as e:
        conn.rollback()
        cur.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


# ─── Cancel Order ─────────────────────────────────────

@app.put("/api/orders/<int:oid>/cancel")
def api_cancel_order(oid):
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    try:
        conn.autocommit = False
        conn.start_transaction()

        cur.execute("SELECT id, status FROM orders WHERE id = %s FOR UPDATE", (oid,))
        order = cur.fetchone()
        if not order:
            conn.rollback()
            cur.close()
            conn.close()
            return jsonify({"error": "Order not found"}), 404

        if order["status"] == "CANCELLED":
            conn.rollback()
            cur.close()
            conn.close()
            return jsonify({"error": "Order is already cancelled"}), 400

        if order["status"] == "DELIVERED":
            conn.rollback()
            cur.close()
            conn.close()
            return jsonify({"error": "Cannot cancel a delivered order"}), 400

        # Update order status — the trg_restore_stock_on_cancel trigger
        # will automatically restore stock for every item in this order
        cur.execute(
            "UPDATE orders SET status = 'CANCELLED' WHERE id = %s", (oid,))

        # Also update tracking status
        cur.execute(
            "UPDATE tracking t JOIN orders o ON o.tracking_id = t.id "
            "SET t.status = 'CANCELLED', t.cancelled_date = NOW() "
            "WHERE o.id = %s", (oid,))

        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": f"Order #{oid} cancelled successfully",
                         "order_id": oid}), 200

    except Error as e:
        conn.rollback()
        cur.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


# ─── Analytics ────────────────────────────────────────

@app.get("/api/analytics/low-stock")
def api_low_stock():
    threshold = request.args.get("threshold", 100, type=int)
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT p.id, p.name AS product, v.name AS vendor,
               p.total_qty AS stock, p.price,
               CASE
                   WHEN p.total_qty = 0 THEN 'OUT OF STOCK'
                   WHEN p.total_qty < %s THEN 'LOW STOCK'
                   ELSE 'OK'
               END AS status
        FROM products p
        JOIN vendors v ON p.vendor_id = v.id
        WHERE p.total_qty < %s
        ORDER BY p.total_qty ASC
    """, (threshold, threshold))
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/analytics/customers")
def api_analytics_customers():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.id, c.name, c.email,
               COUNT(o.id) AS total_orders,
               COALESCE(SUM(o.order_total), 0) AS total_spent,
               COALESCE(ROUND(AVG(o.order_total), 2), 0) AS avg_order_value,
               MAX(o.order_datetime) AS last_order_date,
               CASE
                   WHEN SUM(o.order_total) >= 10000 THEN 'PLATINUM'
                   WHEN SUM(o.order_total) >= 5000  THEN 'GOLD'
                   WHEN SUM(o.order_total) >= 2000  THEN 'SILVER'
                   ELSE 'BRONZE'
               END AS tier
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.id, c.name, c.email
        ORDER BY total_spent DESC
    """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/analytics/vendors")
def api_analytics_vendors():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT v.id, v.name AS vendor, v.affiliation AS brand,
               COUNT(DISTINCT p.id) AS products_listed,
               SUM(p.total_qty) AS total_inventory,
               COUNT(DISTINCT oi.order_id) AS orders_fulfilled,
               COALESCE(SUM(oi.price * oi.qty), 0) AS revenue
        FROM vendors v
        LEFT JOIN products p ON v.id = p.vendor_id
        LEFT JOIN order_items oi ON p.id = oi.product_id
        GROUP BY v.id, v.name, v.affiliation
        ORDER BY revenue DESC
    """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/analytics/monthly")
def api_analytics_monthly():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT DATE_FORMAT(o.order_datetime, '%Y-%m') AS month,
               COUNT(o.id) AS orders,
               SUM(o.order_total) AS revenue,
               ROUND(AVG(o.order_total), 2) AS avg_order
        FROM orders o
        WHERE o.status != 'CANCELLED'
        GROUP BY month
        ORDER BY month
    """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/analytics/top-products")
def api_analytics_top_products():
    limit = request.args.get("limit", 10, type=int)
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT p.id, p.name AS product, v.name AS vendor,
               SUM(oi.qty) AS units_sold,
               SUM(oi.price * oi.qty) AS revenue
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        JOIN vendors v ON p.vendor_id = v.id
        GROUP BY p.id, p.name, v.name
        ORDER BY units_sold DESC
        LIMIT %s
    """, (limit,))
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


@app.get("/api/analytics/complaints")
def api_analytics_complaints():
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.name AS customer,
               COUNT(comp.id) AS total_complaints,
               SUM(comp.status = 'OPEN') AS open_count,
               SUM(comp.status = 'RESOLVED') AS resolved_count,
               SUM(comp.status = 'CLOSED') AS closed_count,
               MIN(comp.open_datetime) AS first_complaint,
               MAX(comp.open_datetime) AS latest_complaint
        FROM complaints comp
        JOIN customers c ON comp.customer_id = c.id
        GROUP BY c.id, c.name
        ORDER BY total_complaints DESC
    """)
    rows = serialize(cur.fetchall())
    cur.close()
    conn.close()
    return jsonify(rows)


if __name__ == "__main__":
    app.run(debug=True, port=5001)
