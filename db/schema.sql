DROP DATABASE IF EXISTS clotheit_auth;
DROP DATABASE IF EXISTS clotheit_data;

CREATE DATABASE clotheit_auth;
CREATE DATABASE clotheit_data;

use clotheit_auth;
-- create auth tables
CREATE TABLE users_auth(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    session_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'INACTIVE',
    user_type ENUM('VENDOR', 'CUSTOMER') NOT NULL,
    last_login DATETIME DEFAULT NULL
    );

use clotheit_data;
-- create data tables
CREATE TABLE addresses(
    id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode CHAR(6) NOT NULL,
    CHECK (pincode REGEXP '^[0-9]{6}$')
);
CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone CHAR(10) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    billing_address INT NOT NULL,
    payment_method ENUM('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'NET_BANKING', 'UPI') NOT NULL DEFAULT 'CASH',
    sign_up_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_billing_address
        FOREIGN KEY (billing_address)
        REFERENCES addresses(id)
        ON DELETE RESTRICT,
    CHECK (phone REGEXP '^[0-9]{10}$')
);
CREATE TABLE vendors(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    affiliation VARCHAR(255),
    phone CHAR(10) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    address INT NOT NULL,
    sign_up_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vendor_address
        FOREIGN KEY (address)
        REFERENCES addresses(id)
        ON DELETE RESTRICT,
    CHECK (phone REGEXP '^[0-9]{10}$')
);
CREATE TABLE tracking(
    id INT AUTO_INCREMENT PRIMARY KEY,
    status ENUM('PACKAGING', 'SHIPPED', 'DELIVERED', 'CANCELLED') NOT NULL,
    partner VARCHAR(255) NOT NULL,
    packaging_date DATETIME,
    shipped_date DATETIME,
    deliver_date DATETIME,
    cancelled_date DATETIME

);
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_datetime DATETIME DEFAULT NULL,
    order_total DECIMAL(10, 2) NOT NULL,
    tracking_id INT NOT NULL UNIQUE,
    status enum('PROCESSING', 'DELIVERED', 'CANCELLED', 'PLACED') DEFAULT 'PROCESSING' NOT NULL,
    CONSTRAINT fk_customer_id 
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),
    CONSTRAINT fk_tracking_id
        FOREIGN KEY (tracking_id)
        REFERENCES tracking(id)
);
CREATE TABLE products(
    id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2),
    total_qty INT NOT NULL,
    CONSTRAINT fk_vendor_id
        FOREIGN KEY (vendor_id)
        REFERENCES vendors(id)
);
CREATE TABLE order_items(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    qty INT NOT NULL,
    CONSTRAINT fk_order_id
        FOREIGN KEY (order_id)
        REFERENCES orders(id),
    CONSTRAINT fk_product_id
        FOREIGN KEY (product_id)
        REFERENCES products(id)
);
CREATE TABLE tags(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(255),
    product_id INT NOT NULL
);
CREATE TABLE complaints(
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    vendor_id INT,
    user_type ENUM('VENDOR', 'CUSTOMER') NOT NULL,
    description TEXT,
    status ENUM('OPEN', 'CLOSED', 'RESOLVED') NOT NULL,
    open_datetime DATETIME,
    closed_datetime DATETIME,
    resolved_datetime DATETIME,
    CONSTRAINT fk_customer_id
        FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_vendor_id
        FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);
