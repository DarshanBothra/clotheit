# ClotheIt - Multi-Vendor E-Commerce Platform Database

A complete MySQL database schema for a multi-vendor e-commerce platform with sample data.

## Database Overview

This database supports a clothing e-commerce marketplace where multiple vendors can sell products to customers.

### Entity-Relationship Diagram

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   CUSTOMERS  │       │    ORDERS    │       │   TRACKING   │
│──────────────│       │──────────────│       │──────────────│
│ customer_id  │──┐    │ order_id     │───────│ tracking_id  │
│ customer_name│  │    │ customer_id  │       │ tracking_    │
│ phone        │  └───>│ tracking_id  │       │   status     │
│ email        │       │ order_total  │       │ delivery_    │
│ address      │       │ payment_     │       │   partner    │
│ sign_up_date │       │   method     │       │ shipped_     │
└──────────────┘       │ status       │       │   datetime   │
                       └──────┬───────┘       │ delivery_    │
                              │               │   datetime   │
                              │               └──────────────┘
                              │
                              ▼
                       ┌──────────────┐       ┌──────────────┐
                       │ ORDER_ITEMS  │       │   PRODUCTS   │
                       │──────────────│       │──────────────│
                       │ order_item_id│       │ product_id   │
                       │ order_id     │──────>│ vendor_id    │
                       │ product_id   │       │ product_name │
                       │ purchase_    │       │ price        │
                       │   price      │       │ discount     │
                       │ purchase_qty │       │ total_qty    │
                       └──────────────┘       │ description  │
                                              │ status       │
                                              └──────┬───────┘
                                                     │
┌──────────────┐       ┌──────────────┐              │
│   VENDORS    │       │     TAGS     │              │
│──────────────│       │──────────────│              │
│ vendor_id    │<──────│ tag_id       │              │
│ vendor_name  │       │ tag_name     │<─────────────┘
│ brand_       │       │ product_id   │
│  affiliation │       └──────────────┘
│ phone        │
│ email        │       ┌──────────────┐
│ address      │       │  COMPLAINTS  │
│ sign_up_date │       │──────────────│
└──────────────┘       │ complaint_id │
        ▲              │ customer_id  │──────> CUSTOMERS
        │              │ vendor_id    │──────> VENDORS  
        └──────────────│ user_type    │
                       │ description  │
                       │ status       │
                       │ raised_date  │
                       │ closed_date  │
                       └──────────────┘
```

## Tables

| Table | Description | Records |
|-------|-------------|---------|
| `customers` | End-user data | 20 |
| `vendors` | Seller data | 20 |
| `products` | Items for sale | 100 |
| `tags` | Product categorization | 100 |
| `orders` | Transaction headers | 20 |
| `order_items` | Line items (Order-Product junction) | 20 |
| `tracking` | Shipping details | 20 |
| `complaints` | Customer/Vendor issues | 20 |

## Relationships

| Relationship | Type | Description |
|--------------|------|-------------|
| Customer → Order | One-to-Many | A customer places many orders |
| Order → Order Item | One-to-Many | An order contains many items |
| Product → Order Item | One-to-Many | A product appears in many order items |
| Vendor → Product | One-to-Many | A vendor sells many products |
| Product → Tags | One-to-Many | A product has multiple tags |
| Order → Tracking | One-to-One | An order has one tracking record |
| Customer/Vendor → Complaint | Many-to-Many | Complaints link customers and vendors |

## Installation

### Prerequisites

- MySQL 8.0+ or MariaDB 10.5+

### Steps

1. **Connect to MySQL**
   ```bash
   mysql -u root -p
   ```

2. **Execute the schema file**
   ```bash
   mysql -u root -p < schema.sql
   ```

   Or from within MySQL:
   ```sql
   SOURCE /path/to/schema.sql;
   ```

3. **Verify installation**
   ```sql
   USE clotheit_ecommerce;
   SHOW TABLES;
   ```

## Sample Queries

### Get all products with vendor information
```sql
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount,
    v.vendor_name,
    v.brand_affiliation
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id;
```

### Get order details with customer and items
```sql
SELECT 
    o.order_id,
    c.customer_name,
    o.order_datetime,
    o.order_total,
    o.payment_method,
    o.status AS order_status,
    COUNT(oi.order_item_id) AS total_items
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;
```

### Get products with their tags
```sql
SELECT 
    p.product_name,
    GROUP_CONCAT(t.tag_name SEPARATOR ', ') AS tags
FROM products p
LEFT JOIN tags t ON p.product_id = t.product_id
GROUP BY p.product_id;
```

### Get open complaints
```sql
SELECT 
    comp.complaint_id,
    c.customer_name,
    v.vendor_name,
    comp.user_type,
    comp.description,
    comp.raised_datetime
FROM complaints comp
JOIN customers c ON comp.customer_id = c.customer_id
JOIN vendors v ON comp.vendor_id = v.vendor_id
WHERE comp.status = 'open'
ORDER BY comp.raised_datetime DESC;
```

### Track an order
```sql
SELECT 
    o.order_id,
    c.customer_name,
    t.tracking_status,
    t.delivery_partner,
    t.shipped_datetime,
    t.delivery_datetime,
    o.status AS order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN tracking t ON o.tracking_id = t.tracking_id
WHERE o.order_id = 1;
```

### Revenue by vendor
```sql
SELECT 
    v.vendor_name,
    v.brand_affiliation,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.purchase_price * oi.purchase_qty) AS total_revenue
FROM vendors v
JOIN products p ON v.vendor_id = p.vendor_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY v.vendor_id
ORDER BY total_revenue DESC;
```

## Schema Features

- **Indexes** on frequently queried columns for performance
- **Foreign Key constraints** with CASCADE rules for data integrity
- **ENUM types** for status fields ensuring data consistency
- **Timestamps** for audit trails
- **InnoDB engine** for transaction support

## Data Types Reference

| Column Type | MySQL Type | Example |
|-------------|------------|---------|
| Price/Amount | `DECIMAL(10,2)` | 1299.00 |
| Discount | `DECIMAL(5,2)` | 15.00 |
| Phone | `VARCHAR(15)` | 9876543210 |
| Email | `VARCHAR(100)` | user@email.com |
| Status | `ENUM(...)` | 'active', 'open' |
| Datetime | `DATETIME` | 2024-06-01 10:00:00 |

## License

This database schema is provided for educational and development purposes.
