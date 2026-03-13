"""
ClotheIt — Order Placement Application
Embedded SQL in Python (mysql-connector-python)

Lets a customer browse products, add items to a cart,
and place an order. The DB-side triggers handle inventory
checks and automatic stock deduction.
"""

import mysql.connector
from mysql.connector import Error
from tabulate import tabulate
from datetime import datetime

DB_CONFIG = {
    "host": "localhost",
    "user": "clotheit",
    "password": "CLOTHEIT@2026#",
    "database": "clotheit_data",
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


# ──────────────────────────────────────────────
# 1. Browse products (with optional tag filter)
# ──────────────────────────────────────────────
def browse_products(conn, tag_filter=None):
    cursor = conn.cursor(dictionary=True)
    if tag_filter:
        cursor.execute(
            """
            SELECT p.id, p.name, v.name AS vendor, v.affiliation AS brand,
                   p.price, p.discount,
                   ROUND(p.price * (1 - p.discount/100), 2) AS effective_price,
                   p.total_qty AS stock
            FROM products p
            JOIN vendors v ON p.vendor_id = v.id
            JOIN tags t    ON t.product_id = p.id
            WHERE t.tag_name = %s AND p.total_qty > 0
            ORDER BY effective_price
            """,
            (tag_filter,),
        )
    else:
        cursor.execute(
            """
            SELECT p.id, p.name, v.name AS vendor, v.affiliation AS brand,
                   p.price, p.discount,
                   ROUND(p.price * (1 - p.discount/100), 2) AS effective_price,
                   p.total_qty AS stock
            FROM products p
            JOIN vendors v ON p.vendor_id = v.id
            WHERE p.total_qty > 0
            ORDER BY p.id
            """
        )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 2. Show customer info
# ──────────────────────────────────────────────
def get_customer(conn, customer_id):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT c.id, c.name, c.email, c.phone,
               a.address_line1, a.city, a.state, a.pincode
        FROM customers c
        JOIN addresses a ON c.billing_address = a.id
        WHERE c.id = %s
        """,
        (customer_id,),
    )
    row = cursor.fetchone()
    cursor.close()
    return row


# ──────────────────────────────────────────────
# 3. Place order  (the core transaction)
# ──────────────────────────────────────────────
def place_order(conn, customer_id, cart):
    """
    cart: list of dicts  [{"product_id": int, "qty": int}, ...]
    Returns order_id on success, raises on failure.
    The BEFORE INSERT trigger on order_items will reject the row
    if stock is insufficient, and the AFTER INSERT trigger will
    deduct stock automatically.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        conn.start_transaction()

        # fetch live prices
        order_total = 0
        enriched_items = []
        for item in cart:
        cursor.execute(
            "SELECT id, price, discount, total_qty "
            "FROM products WHERE id = %s FOR UPDATE",
            (item["product_id"],),
        )
            prod = cursor.fetchone()
            if not prod:
                raise ValueError(f"Product {item['product_id']} not found")
            if prod["total_qty"] < item["qty"]:
                avail = prod["total_qty"]
                want = item["qty"]
                pid = item["product_id"]
                raise ValueError(
                    f"Not enough stock for product {pid} "
                    f"(available: {avail}, requested: {want})"
                )
            price = float(prod["price"])
            disc = float(prod["discount"])
            eff_price = round(price * (1 - disc / 100), 2)
            line_total = round(eff_price * item["qty"], 2)
            order_total += line_total
            enriched_items.append({
                "product_id": prod["id"],
                "qty": item["qty"],
                "unit_price": eff_price,
            })

        # create tracking entry
        cursor.execute(
            """
            INSERT INTO tracking (status, partner, packaging_date)
            VALUES ('PACKAGING', 'BlueDart', %s)
            """,
            (datetime.now(),),
        )
        tracking_id = cursor.lastrowid

        # create order header
        cursor.execute(
            """
            INSERT INTO orders (customer_id, order_datetime, order_total, tracking_id, status)
            VALUES (%s, %s, %s, %s, 'PROCESSING')
            """,
            (customer_id, datetime.now(), round(order_total, 2), tracking_id),
        )
        order_id = cursor.lastrowid

        # insert line items — triggers fire here
        for ei in enriched_items:
            cursor.execute(
                """
                INSERT INTO order_items (order_id, product_id, price, qty)
                VALUES (%s, %s, %s, %s)
                """,
                (order_id, ei["product_id"], ei["unit_price"], ei["qty"]),
            )

        conn.commit()
        return order_id

    except Exception:
        conn.rollback()
        raise
    finally:
        cursor.close()


# ──────────────────────────────────────────────
# 4. View order receipt
# ──────────────────────────────────────────────
def view_order(conn, order_id):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT o.id AS order_id, c.name AS customer, o.order_datetime,
               o.order_total, o.status,
               t.status AS tracking, t.partner
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        LEFT JOIN tracking t ON o.tracking_id = t.id
        WHERE o.id = %s
        """,
        (order_id,),
    )
    header = cursor.fetchone()

    cursor.execute(
        """
        SELECT oi.id AS item_id, p.name AS product, oi.price AS unit_price,
               oi.qty, ROUND(oi.price * oi.qty, 2) AS line_total
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = %s
        """,
        (order_id,),
    )
    items = cursor.fetchall()
    cursor.close()
    return header, items


# ──────────────────────────────────────────────
# Interactive CLI
# ──────────────────────────────────────────────
def main():
    conn = get_connection()
    print("\n╔══════════════════════════════════════╗")
    print("║   ClotheIt — Place Your Order        ║")
    print("╚══════════════════════════════════════╝\n")

    # pick customer
    cust_id = int(input("Enter your Customer ID (1-20): "))
    cust = get_customer(conn, cust_id)
    if not cust:
        print("Customer not found.")
        return
    print(f"\nWelcome, {cust['name']}!  ({cust['email']})")
    addr = (f"{cust['address_line1']}, {cust['city']}, "
            f"{cust['state']} - {cust['pincode']}")
    print(f"Shipping to: {addr}\n")

    # browse
    tag = input("Filter by tag (leave blank for all): ").strip() or None
    products = browse_products(conn, tag)
    if not products:
        print("No products found.")
        return
    print(f"\n{'─'*90}")
    print(tabulate(
        products, headers="keys",
        tablefmt="rounded_outline", floatfmt=".2f",
    ))
    print(f"{'─'*90}\n")

    # build cart
    cart = []
    while True:
        pid = input("Add product ID to cart (or 'done'): ").strip()
        if pid.lower() == "done":
            break
        qty = int(input("  Quantity: "))
        cart.append({"product_id": int(pid), "qty": qty})

    if not cart:
        print("Cart is empty — nothing to order.")
        return

    # place
    try:
        oid = place_order(conn, cust_id, cart)
        print(f"\n  Order #{oid} placed successfully!\n")
    except ValueError as e:
        print(f"\n  Order failed: {e}\n")
        return
    except Error as e:
        print(f"\n  Database error: {e}\n")
        return

    # receipt
    header, items = view_order(conn, oid)
    print("─── ORDER RECEIPT ───────────────────────")
    print(f"  Order ID   : {header['order_id']}")
    print(f"  Customer   : {header['customer']}")
    print(f"  Date       : {header['order_datetime']}")
    print(f"  Status     : {header['status']}")
    trk = f"{header['tracking']} via {header['partner']}"
    print(f"  Tracking   : {trk}")
    print()
    print(tabulate(
        items, headers="keys",
        tablefmt="rounded_outline", floatfmt=".2f",
    ))
    print(f"\n  TOTAL: Rs. {header['order_total']}")
    print("─────────────────────────────────────────\n")

    conn.close()


if __name__ == "__main__":
    main()
