"""
ClotheIt — Inventory & Customer Analytics Application
Embedded SQL in Python (mysql-connector-python)

Provides a menu-driven CLI for:
  - Inventory health check (low-stock alerts, dead stock)
  - Customer spending analysis & segmentation
  - Vendor revenue breakdown
  - Monthly sales trends
"""

import mysql.connector
from mysql.connector import Error
from tabulate import tabulate

DB_CONFIG = {
    "host": "localhost",
    "user": "clotheit",
    "password": "Clotheit@2026",
    "database": "clotheit_data",
}


def get_connection():
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except Error as e:
        print(f"\nCould not connect to MySQL: {e}")
        print("Make sure the database is set up:")
        print("  mysql -u root -p < db/setup.sql")
        raise SystemExit(1)


# ──────────────────────────────────────────────
# 1. Low-stock products (threshold-based)
# ──────────────────────────────────────────────
def low_stock_report(conn, threshold=100):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
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
        """,
        (threshold, threshold),
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 2. Customer spending analysis
# ──────────────────────────────────────────────
def customer_spending(conn):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
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
        """
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 3. Vendor revenue & product performance
# ──────────────────────────────────────────────
def vendor_revenue(conn):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT v.id, v.name AS vendor, v.affiliation AS brand,
               COUNT(DISTINCT p.id) AS products_listed,
               SUM(p.total_qty) AS total_inventory,
               COUNT(DISTINCT oi.order_id) AS orders_fulfilled,
               COALESCE(SUM(oi.price * oi.qty), 0) AS revenue
        FROM vendors v
        LEFT JOIN products p    ON v.id = p.vendor_id
        LEFT JOIN order_items oi ON p.id = oi.product_id
        GROUP BY v.id, v.name, v.affiliation
        ORDER BY revenue DESC
        """
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 4. Monthly sales trend
# ──────────────────────────────────────────────
def monthly_sales(conn):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT DATE_FORMAT(o.order_datetime, '%Y-%m') AS month,
               COUNT(o.id) AS orders,
               SUM(o.order_total) AS revenue,
               ROUND(AVG(o.order_total), 2) AS avg_order
        FROM orders o
        WHERE o.status != 'CANCELLED'
        GROUP BY month
        ORDER BY month
        """
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 5. Top-selling products
# ──────────────────────────────────────────────
def top_products(conn, limit=10):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT p.id, p.name AS product, v.name AS vendor,
               SUM(oi.qty) AS units_sold,
               SUM(oi.price * oi.qty) AS revenue
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        JOIN vendors v  ON p.vendor_id = v.id
        GROUP BY p.id, p.name, v.name
        ORDER BY units_sold DESC
        LIMIT %s
        """,
        (limit,),
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# 6. Complaint summary per customer
# ──────────────────────────────────────────────
def complaint_summary(conn):
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        """
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
        """
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows


# ──────────────────────────────────────────────
# Interactive menu
# ──────────────────────────────────────────────
def main():
    conn = get_connection()
    menu = """
╔══════════════════════════════════════════╗
║   ClotheIt — Analytics Dashboard         ║
╠══════════════════════════════════════════╣
║  1. Low-Stock / Inventory Alert          ║
║  2. Customer Spending & Segmentation     ║
║  3. Vendor Revenue Breakdown             ║
║  4. Monthly Sales Trend                  ║
║  5. Top-Selling Products                 ║
║  6. Complaint Summary                    ║
║  0. Exit                                 ║
╚══════════════════════════════════════════╝
"""

    while True:
        print(menu)
        choice = input("Pick an option: ").strip()

        if choice == "1":
            thresh = input("  Stock threshold (default 100): ").strip()
            thresh = int(thresh) if thresh else 100
            rows = low_stock_report(conn, thresh)
            if rows:
                print(f"\n  Products with stock < {thresh}:\n")
                print(tabulate(
                    rows, headers="keys",
                    tablefmt="rounded_outline",
                ))
            else:
                print(
                    f"\n  All products have stock >= "
                    f"{thresh}. Inventory looks healthy!\n"
                )

        elif choice == "2":
            rows = customer_spending(conn)
            title = "Customer Spending & Tier Segmentation"
            print(f"\n  {title}:\n")
            print(tabulate(
                rows, headers="keys",
                tablefmt="rounded_outline", floatfmt=".2f",
            ))

        elif choice == "3":
            rows = vendor_revenue(conn)
            print("\n  Vendor Revenue Breakdown:\n")
            print(tabulate(
                rows, headers="keys",
                tablefmt="rounded_outline", floatfmt=".2f",
            ))

        elif choice == "4":
            rows = monthly_sales(conn)
            print("\n  Monthly Sales Trend:\n")
            print(tabulate(
                rows, headers="keys",
                tablefmt="rounded_outline", floatfmt=".2f",
            ))

        elif choice == "5":
            prompt = "  How many top products? (default 10): "
            n = input(prompt).strip()
            n = int(n) if n else 10
            rows = top_products(conn, n)
            print(f"\n  Top {n} Products by Units Sold:\n")
            print(tabulate(
                rows, headers="keys",
                tablefmt="rounded_outline", floatfmt=".2f",
            ))

        elif choice == "6":
            rows = complaint_summary(conn)
            print("\n  Complaint Summary per Customer:\n")
            print(tabulate(
                rows, headers="keys",
                tablefmt="rounded_outline",
            ))

        elif choice == "0":
            print("\nBye!\n")
            break
        else:
            print("\n  Invalid choice, try again.\n")

    conn.close()


if __name__ == "__main__":
    main()
