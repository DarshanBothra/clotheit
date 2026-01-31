-- ============================================
-- Multi-Vendor E-Commerce Platform Database
-- MySQL Schema with Sample Data
-- ============================================

-- Create and use the database
DROP DATABASE IF EXISTS clotheit_ecommerce;
CREATE DATABASE clotheit_ecommerce;
USE clotheit_ecommerce;

-- ============================================
-- TABLE DEFINITIONS
-- ============================================

-- ---------------------------------------------
-- A. Users & Actors
-- ---------------------------------------------

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    registered_phone VARCHAR(15) NOT NULL,
    registered_email VARCHAR(100) NOT NULL UNIQUE,
    billing_address TEXT NOT NULL,
    sign_up_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer_email (registered_email),
    INDEX idx_customer_phone (registered_phone)
) ENGINE=InnoDB;

-- Vendors Table
CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_name VARCHAR(100) NOT NULL,
    brand_affiliation VARCHAR(100),
    registered_phone VARCHAR(15) NOT NULL,
    registered_email VARCHAR(100) NOT NULL UNIQUE,
    registered_address TEXT NOT NULL,
    sign_up_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_vendor_email (registered_email),
    INDEX idx_vendor_brand (brand_affiliation)
) ENGINE=InnoDB;

-- ---------------------------------------------
-- B. Inventory & Categorization
-- ---------------------------------------------

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0.00,
    total_qty INT NOT NULL DEFAULT 0,
    description VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_product_vendor (vendor_id),
    INDEX idx_product_status (status),
    INDEX idx_product_price (price)
) ENGINE=InnoDB;

-- Tags Table
CREATE TABLE tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_tag_product (product_id),
    INDEX idx_tag_name (tag_name)
) ENGINE=InnoDB;

-- ---------------------------------------------
-- D. Logistics (Created before Orders due to FK dependency)
-- ---------------------------------------------

-- Tracking Table
CREATE TABLE tracking (
    tracking_id INT PRIMARY KEY AUTO_INCREMENT,
    tracking_status ENUM('shipped', 'delivered') NOT NULL DEFAULT 'shipped',
    delivery_partner VARCHAR(100),
    shipped_datetime DATETIME,
    delivery_datetime DATETIME,
    INDEX idx_tracking_status (tracking_status)
) ENGINE=InnoDB;

-- ---------------------------------------------
-- C. Order Management
-- ---------------------------------------------

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    tracking_id INT UNIQUE,
    order_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    payment_method ENUM('cash', 'credit card', 'debit card', 'net banking', 'upi') NOT NULL,
    status ENUM('processing', 'delivered', 'cancelled', 'placed') NOT NULL DEFAULT 'placed',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tracking_id) REFERENCES tracking(tracking_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_order_customer (customer_id),
    INDEX idx_order_status (status),
    INDEX idx_order_datetime (order_datetime)
) ENGINE=InnoDB;

-- Order Items Table (Associative Entity)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    purchase_qty INT NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_orderitem_order (order_id),
    INDEX idx_orderitem_product (product_id)
) ENGINE=InnoDB;

-- ---------------------------------------------
-- E. Support
-- ---------------------------------------------

-- Complaints Table
CREATE TABLE complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    vendor_id INT NOT NULL,
    user_type ENUM('vendor', 'customer') NOT NULL,
    description TEXT NOT NULL,
    status ENUM('open', 'closed', 'resolved') NOT NULL DEFAULT 'open',
    raised_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_datetime DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_complaint_customer (customer_id),
    INDEX idx_complaint_vendor (vendor_id),
    INDEX idx_complaint_status (status)
) ENGINE=InnoDB;

-- ============================================
-- SAMPLE DATA (100 products, 20 records for other tables)
-- ============================================

-- ---------------------------------------------
-- Customers (20 records)
-- ---------------------------------------------
INSERT INTO customers (customer_name, registered_phone, registered_email, billing_address, sign_up_datetime) VALUES
('Rahul Sharma', '9876543210', 'rahul.sharma@email.com', '123 MG Road, Mumbai, Maharashtra 400001', '2024-01-15 10:30:00'),
('Priya Patel', '9876543211', 'priya.patel@email.com', '456 Park Street, Kolkata, West Bengal 700016', '2024-01-20 14:45:00'),
('Amit Kumar', '9876543212', 'amit.kumar@email.com', '789 Brigade Road, Bangalore, Karnataka 560001', '2024-02-05 09:15:00'),
('Sneha Reddy', '9876543213', 'sneha.reddy@email.com', '321 Jubilee Hills, Hyderabad, Telangana 500033', '2024-02-10 11:00:00'),
('Vikram Singh', '9876543214', 'vikram.singh@email.com', '654 Connaught Place, New Delhi 110001', '2024-02-15 16:30:00'),
('Anjali Gupta', '9876543215', 'anjali.gupta@email.com', '987 Civil Lines, Jaipur, Rajasthan 302006', '2024-03-01 08:45:00'),
('Karthik Nair', '9876543216', 'karthik.nair@email.com', '147 Marine Drive, Kochi, Kerala 682001', '2024-03-10 12:00:00'),
('Meera Iyer', '9876543217', 'meera.iyer@email.com', '258 Anna Nagar, Chennai, Tamil Nadu 600040', '2024-03-15 15:20:00'),
('Rohan Desai', '9876543218', 'rohan.desai@email.com', '369 SG Highway, Ahmedabad, Gujarat 380054', '2024-03-20 10:10:00'),
('Kavita Joshi', '9876543219', 'kavita.joshi@email.com', '741 FC Road, Pune, Maharashtra 411004', '2024-04-01 13:35:00'),
('Arjun Menon', '9876543220', 'arjun.menon@email.com', '852 Sector 17, Chandigarh 160017', '2024-04-10 09:50:00'),
('Divya Rao', '9876543221', 'divya.rao@email.com', '963 Banjara Hills, Hyderabad, Telangana 500034', '2024-04-15 14:15:00'),
('Sanjay Verma', '9876543222', 'sanjay.verma@email.com', '159 Hazratganj, Lucknow, Uttar Pradesh 226001', '2024-04-20 11:40:00'),
('Pooja Agarwal', '9876543223', 'pooja.agarwal@email.com', '357 Salt Lake, Kolkata, West Bengal 700091', '2024-05-01 16:05:00'),
('Nikhil Saxena', '9876543224', 'nikhil.saxena@email.com', '468 Koramangala, Bangalore, Karnataka 560034', '2024-05-10 08:30:00'),
('Swati Mishra', '9876543225', 'swati.mishra@email.com', '579 Vaishali Nagar, Jaipur, Rajasthan 302021', '2024-05-15 12:55:00'),
('Deepak Choudhary', '9876543226', 'deepak.choudhary@email.com', '681 Gomti Nagar, Lucknow, Uttar Pradesh 226010', '2024-05-20 15:45:00'),
('Ritu Sharma', '9876543227', 'ritu.sharma@email.com', '792 Andheri West, Mumbai, Maharashtra 400058', '2024-06-01 10:20:00'),
('Manish Tiwari', '9876543228', 'manish.tiwari@email.com', '813 Indiranagar, Bangalore, Karnataka 560038', '2024-06-10 13:10:00'),
('Ananya Das', '9876543229', 'ananya.das@email.com', '924 New Town, Kolkata, West Bengal 700156', '2024-06-15 09:00:00');

-- ---------------------------------------------
-- Vendors (20 records)
-- ---------------------------------------------
INSERT INTO vendors (vendor_name, brand_affiliation, registered_phone, registered_email, registered_address, sign_up_datetime) VALUES
('Fashion Forward Inc', 'Trendy Threads', '8765432100', 'contact@fashionforward.com', '101 Fashion Street, Mumbai, Maharashtra 400001', '2023-06-01 10:00:00'),
('Style Studio', 'Urban Chic', '8765432101', 'sales@stylestudio.com', '202 Design District, Bangalore, Karnataka 560001', '2023-06-15 11:30:00'),
('Ethnic Elegance', 'Desi Drapes', '8765432102', 'info@ethnicelegance.com', '303 Silk Lane, Varanasi, Uttar Pradesh 221001', '2023-07-01 09:45:00'),
('Casual Comfort Co', 'Relax Wear', '8765432103', 'hello@casualcomfort.com', '404 Cotton Road, Coimbatore, Tamil Nadu 641001', '2023-07-20 14:00:00'),
('Premium Fabrics Ltd', 'Luxury Line', '8765432104', 'support@premiumfabrics.com', '505 Textile Park, Surat, Gujarat 395001', '2023-08-05 12:15:00'),
('Sporty Styles', 'Active Gear', '8765432105', 'orders@sportystyles.com', '606 Fitness Ave, Pune, Maharashtra 411001', '2023-08-20 16:30:00'),
('Kids Kingdom', 'Little Stars', '8765432106', 'care@kidskingdom.com', '707 Rainbow Street, Jaipur, Rajasthan 302001', '2023-09-01 10:45:00'),
('Formal Affairs', 'Corporate Classics', '8765432107', 'business@formalaffairs.com', '808 Business Bay, Gurgaon, Haryana 122001', '2023-09-15 08:00:00'),
('Denim Den', 'Jean Genius', '8765432108', 'jeans@denimden.com', '909 Blue Street, Ahmedabad, Gujarat 380001', '2023-10-01 13:20:00'),
('Accessory Avenue', 'Accent Plus', '8765432109', 'style@accessoryavenue.com', '110 Trinket Lane, Delhi 110001', '2023-10-20 15:40:00'),
('Winter Warmth', 'Cozy Collection', '8765432110', 'warm@winterwarmth.com', '211 Woolen Way, Ludhiana, Punjab 141001', '2023-11-01 11:00:00'),
('Summer Breeze', 'Cool Cottons', '8765432111', 'fresh@summerbreeze.com', '312 Linen Lane, Chennai, Tamil Nadu 600001', '2023-11-15 09:30:00'),
('Footwear Factory', 'Step Right', '8765432112', 'walk@footwearfactory.com', '413 Shoe Street, Agra, Uttar Pradesh 282001', '2023-12-01 14:50:00'),
('Bag Bazaar', 'Carry Style', '8765432113', 'bags@bagbazaar.com', '514 Leather Lane, Kanpur, Uttar Pradesh 208001', '2023-12-15 10:15:00'),
('Watch World', 'Time Trends', '8765432114', 'time@watchworld.com', '615 Clock Tower, Mumbai, Maharashtra 400002', '2024-01-01 12:00:00'),
('Jewelry Junction', 'Sparkle Studio', '8765432115', 'shine@jewelryjunction.com', '716 Gold Street, Hyderabad, Telangana 500001', '2024-01-15 16:20:00'),
('Eyewear Express', 'Vision Vogue', '8765432116', 'see@eyewearexpress.com', '817 Optic Avenue, Bangalore, Karnataka 560002', '2024-02-01 08:45:00'),
('Belt & Beyond', 'Waist Wonders', '8765432117', 'fit@beltbeyond.com', '918 Leather Loop, Chennai, Tamil Nadu 600002', '2024-02-15 13:30:00'),
('Scarf Studio', 'Wrap Style', '8765432118', 'drape@scarfstudio.com', '119 Silk Road, Varanasi, Uttar Pradesh 221002', '2024-03-01 11:10:00'),
('Hat House', 'Cap Corner', '8765432119', 'top@hathouse.com', '220 Head Street, Delhi 110002', '2024-03-15 15:00:00');

-- ---------------------------------------------
-- Products (100 records)
-- ---------------------------------------------
INSERT INTO products (vendor_id, product_name, price, discount, total_qty, description, status) VALUES
-- Vendor 1: Fashion Forward Inc (Trendy Threads) - 5 products
(1, 'Classic Cotton T-Shirt', 599.00, 10.00, 500, 'Premium cotton t-shirt available in multiple colors. Comfortable fit for everyday wear.', 'active'),
(1, 'Slim Fit Casual Shirt', 1299.00, 15.00, 300, 'Modern slim fit shirt perfect for casual outings. Made from breathable fabric.', 'active'),
(1, 'Graphic Print Tee', 799.00, 12.00, 450, 'Trendy graphic print t-shirt with unique designs. 100% cotton.', 'active'),
(1, 'Polo Shirt Classic', 999.00, 8.00, 380, 'Classic polo shirt with embroidered logo. Perfect for smart casual look.', 'active'),
(1, 'Henley Long Sleeve', 899.00, 10.00, 320, 'Comfortable henley with button placket. Ideal for layering.', 'active'),
-- Vendor 2: Style Studio (Urban Chic) - 5 products
(2, 'Designer Blazer', 3999.00, 20.00, 150, 'Stylish blazer for formal occasions. Premium quality with modern cut.', 'active'),
(2, 'Chino Pants', 1799.00, 12.00, 400, 'Versatile chino pants suitable for work and casual wear.', 'active'),
(2, 'Linen Summer Blazer', 4499.00, 18.00, 120, 'Lightweight linen blazer perfect for summer events.', 'active'),
(2, 'Tailored Vest', 2499.00, 15.00, 200, 'Classic tailored vest for layered formal looks.', 'active'),
(2, 'Pleated Dress Pants', 2199.00, 10.00, 280, 'Elegant pleated pants with superior drape.', 'active'),
-- Vendor 3: Ethnic Elegance (Desi Drapes) - 5 products
(3, 'Silk Saree Collection', 4999.00, 5.00, 200, 'Handwoven silk saree with traditional motifs. Perfect for special occasions.', 'active'),
(3, 'Embroidered Kurta Set', 2499.00, 10.00, 250, 'Elegant kurta set with intricate embroidery work.', 'active'),
(3, 'Banarasi Silk Saree', 7999.00, 8.00, 100, 'Authentic Banarasi silk with gold zari work. Bridal collection.', 'active'),
(3, 'Cotton Kurta Pajama', 1899.00, 12.00, 350, 'Comfortable cotton kurta pajama set for daily wear.', 'active'),
(3, 'Anarkali Suit Set', 3499.00, 15.00, 180, 'Beautiful Anarkali suit with dupatta. Festival ready.', 'active'),
-- Vendor 4: Casual Comfort Co (Relax Wear) - 5 products
(4, 'Comfortable Lounge Pants', 899.00, 8.00, 600, 'Super soft lounge pants for ultimate comfort at home.', 'active'),
(4, 'Relaxed Fit Hoodie', 1499.00, 18.00, 350, 'Cozy hoodie with kangaroo pocket. Perfect for winters.', 'active'),
(4, 'Fleece Joggers', 1199.00, 10.00, 500, 'Warm fleece joggers with elastic cuffs. Ultimate comfort.', 'active'),
(4, 'Oversized Sweatshirt', 1299.00, 15.00, 400, 'Trendy oversized sweatshirt in solid colors.', 'active'),
(4, 'Cotton Pajama Set', 999.00, 5.00, 550, 'Soft cotton pajama set for comfortable sleep.', 'active'),
-- Vendor 5: Premium Fabrics Ltd (Luxury Line) - 5 products
(5, 'Premium Wool Suit', 12999.00, 25.00, 100, 'Tailored wool suit for business professionals. Includes jacket and trousers.', 'active'),
(5, 'Cashmere Sweater', 5999.00, 15.00, 180, 'Luxurious cashmere sweater. Lightweight yet warm.', 'active'),
(5, 'Italian Silk Shirt', 4999.00, 12.00, 150, 'Premium Italian silk shirt. Smooth and elegant.', 'active'),
(5, 'Merino Wool Cardigan', 4499.00, 10.00, 200, 'Fine merino wool cardigan with button closure.', 'active'),
(5, 'Tweed Sports Jacket', 8999.00, 20.00, 80, 'Classic tweed jacket for sophisticated casual style.', 'active'),
-- Vendor 6: Sporty Styles (Active Gear) - 5 products
(6, 'Performance Running Shorts', 999.00, 10.00, 450, 'Moisture-wicking shorts designed for runners. Quick dry technology.', 'active'),
(6, 'Gym Tank Top', 699.00, 5.00, 550, 'Breathable tank top for intense workouts.', 'active'),
(6, 'Compression Leggings', 1499.00, 12.00, 380, 'High-performance compression leggings for athletes.', 'active'),
(6, 'Sports Bra Pro', 899.00, 8.00, 420, 'High support sports bra for intense activities.', 'active'),
(6, 'Training Track Jacket', 1799.00, 15.00, 300, 'Lightweight track jacket with zip pockets.', 'active'),
-- Vendor 7: Kids Kingdom (Little Stars) - 5 products
(7, 'Kids Party Dress', 1599.00, 20.00, 300, 'Adorable party dress for little girls. Available in various colors.', 'active'),
(7, 'Boys Denim Jacket', 1299.00, 15.00, 280, 'Trendy denim jacket for boys. Durable and stylish.', 'active'),
(7, 'Girls Tutu Skirt', 899.00, 10.00, 400, 'Fluffy tutu skirt perfect for little princesses.', 'active'),
(7, 'Boys Cargo Shorts', 799.00, 12.00, 450, 'Durable cargo shorts with multiple pockets for active boys.', 'active'),
(7, 'Kids Raincoat Set', 1199.00, 8.00, 350, 'Colorful raincoat with matching boots. Waterproof.', 'active'),
-- Vendor 8: Formal Affairs (Corporate Classics) - 5 products
(8, 'Executive Dress Shirt', 1999.00, 10.00, 400, 'Premium dress shirt for corporate professionals. Wrinkle-resistant fabric.', 'active'),
(8, 'Formal Trousers', 2299.00, 12.00, 350, 'Classic formal trousers with perfect drape. Multiple color options.', 'active'),
(8, 'French Cuff Shirt', 2499.00, 15.00, 250, 'Elegant French cuff shirt for formal occasions.', 'active'),
(8, 'Business Suit Navy', 9999.00, 18.00, 120, 'Classic navy business suit. Two-button single breasted.', 'active'),
(8, 'Silk Pocket Square Set', 599.00, 5.00, 500, 'Set of 3 silk pocket squares in classic patterns.', 'active'),
-- Vendor 9: Denim Den (Jean Genius) - 5 products
(9, 'Classic Blue Jeans', 1899.00, 15.00, 500, 'Timeless blue jeans with comfortable stretch. Perfect everyday wear.', 'active'),
(9, 'Distressed Denim Shorts', 1199.00, 20.00, 400, 'Trendy distressed shorts for casual summer looks.', 'active'),
(9, 'Skinny Fit Black Jeans', 2099.00, 12.00, 380, 'Sleek skinny fit jeans in jet black.', 'active'),
(9, 'Bootcut Vintage Jeans', 2299.00, 10.00, 300, 'Classic bootcut jeans with vintage wash.', 'active'),
(9, 'Denim Trucker Jacket', 2799.00, 18.00, 250, 'Iconic trucker jacket in premium denim.', 'active'),
-- Vendor 10: Accessory Avenue (Accent Plus) - 5 products
(10, 'Leather Belt Collection', 799.00, 5.00, 600, 'Genuine leather belt with classic buckle. Available in brown and black.', 'active'),
(10, 'Silk Tie Set', 999.00, 10.00, 450, 'Premium silk ties in various patterns. Includes matching pocket square.', 'active'),
(10, 'Canvas Tote Bag', 1299.00, 8.00, 350, 'Durable canvas tote for everyday use.', 'active'),
(10, 'Leather Wallet Premium', 1499.00, 12.00, 400, 'Genuine leather wallet with multiple card slots.', 'active'),
(10, 'Cufflinks Gold Plated', 1999.00, 15.00, 200, 'Elegant gold-plated cufflinks for formal wear.', 'active'),
-- Vendor 11: Winter Warmth (Cozy Collection) - 5 products
(11, 'Wool Overcoat', 6999.00, 20.00, 150, 'Classic wool overcoat for harsh winters. Fully lined.', 'active'),
(11, 'Puffer Jacket', 3999.00, 15.00, 280, 'Lightweight puffer jacket with excellent insulation.', 'active'),
(11, 'Knit Beanie Cap', 499.00, 5.00, 600, 'Warm knit beanie in assorted colors.', 'active'),
(11, 'Thermal Innerwear Set', 1299.00, 10.00, 450, 'Thermal top and bottom set for extreme cold.', 'active'),
(11, 'Woolen Muffler', 799.00, 8.00, 500, 'Soft woolen muffler with fringe detail.', 'active'),
-- Vendor 12: Summer Breeze (Cool Cottons) - 5 products
(12, 'Linen Shirt Casual', 1599.00, 12.00, 400, 'Breathable linen shirt perfect for summer.', 'active'),
(12, 'Cotton Shorts Relaxed', 899.00, 8.00, 500, 'Comfortable cotton shorts with elastic waist.', 'active'),
(12, 'Sleeveless Maxi Dress', 2199.00, 15.00, 300, 'Flowy sleeveless maxi dress for beach outings.', 'active'),
(12, 'Linen Palazzo Pants', 1799.00, 10.00, 350, 'Wide-leg linen palazzo pants. Ultra comfortable.', 'active'),
(12, 'Cotton Crop Top', 699.00, 5.00, 450, 'Trendy crop top in solid and printed options.', 'active'),
-- Vendor 13: Footwear Factory (Step Right) - 5 products
(13, 'Classic Leather Loafers', 2999.00, 15.00, 250, 'Handcrafted leather loafers for formal occasions.', 'active'),
(13, 'Running Shoes Pro', 4999.00, 20.00, 300, 'High-performance running shoes with cushioned sole.', 'active'),
(13, 'Canvas Sneakers', 1499.00, 10.00, 450, 'Casual canvas sneakers in multiple colors.', 'active'),
(13, 'Leather Sandals', 1299.00, 8.00, 400, 'Comfortable leather sandals for daily wear.', 'active'),
(13, 'Ankle Boots Suede', 3499.00, 12.00, 200, 'Stylish suede ankle boots for all seasons.', 'active'),
-- Vendor 14: Bag Bazaar (Carry Style) - 5 products
(14, 'Leather Messenger Bag', 3499.00, 15.00, 200, 'Premium leather messenger bag for professionals.', 'active'),
(14, 'Travel Duffel Bag', 2499.00, 12.00, 300, 'Spacious duffel bag perfect for weekend trips.', 'active'),
(14, 'Ladies Handbag Classic', 2999.00, 10.00, 250, 'Elegant handbag with multiple compartments.', 'active'),
(14, 'Laptop Backpack Pro', 1999.00, 8.00, 400, 'Padded laptop backpack with USB charging port.', 'active'),
(14, 'Clutch Evening Bag', 1499.00, 18.00, 350, 'Glamorous clutch for evening events.', 'active'),
-- Vendor 15: Watch World (Time Trends) - 5 products
(15, 'Analog Classic Watch', 2999.00, 15.00, 300, 'Elegant analog watch with leather strap.', 'active'),
(15, 'Smart Fitness Watch', 4999.00, 20.00, 250, 'Feature-rich smartwatch with health tracking.', 'active'),
(15, 'Chronograph Sports Watch', 5999.00, 18.00, 180, 'Sporty chronograph with water resistance.', 'active'),
(15, 'Minimalist Dial Watch', 1999.00, 10.00, 400, 'Clean minimalist design for modern style.', 'active'),
(15, 'Vintage Style Watch', 3499.00, 12.00, 220, 'Retro-inspired watch with roman numerals.', 'active'),
-- Vendor 16: Jewelry Junction (Sparkle Studio) - 5 products
(16, 'Gold Plated Necklace', 2499.00, 15.00, 300, '22k gold plated necklace with pendant.', 'active'),
(16, 'Diamond Stud Earrings', 9999.00, 10.00, 100, 'Certified diamond studs in white gold setting.', 'active'),
(16, 'Silver Charm Bracelet', 1499.00, 12.00, 400, 'Sterling silver bracelet with customizable charms.', 'active'),
(16, 'Pearl Drop Earrings', 1999.00, 8.00, 350, 'Elegant freshwater pearl earrings.', 'active'),
(16, 'Statement Ring Gold', 3499.00, 20.00, 200, 'Bold statement ring in 18k gold finish.', 'active'),
-- Vendor 17: Eyewear Express (Vision Vogue) - 5 products
(17, 'Aviator Sunglasses', 1999.00, 15.00, 400, 'Classic aviator sunglasses with UV protection.', 'active'),
(17, 'Blue Light Glasses', 1499.00, 10.00, 500, 'Computer glasses that block harmful blue light.', 'active'),
(17, 'Cat Eye Frames', 2499.00, 12.00, 300, 'Trendy cat eye frames for women.', 'active'),
(17, 'Round Retro Glasses', 1799.00, 8.00, 350, 'Vintage round frames inspired by classics.', 'active'),
(17, 'Sports Sunglasses', 2999.00, 18.00, 250, 'Polarized sports sunglasses for outdoor activities.', 'active'),
-- Vendor 18: Belt & Beyond (Waist Wonders) - 5 products
(18, 'Reversible Leather Belt', 1299.00, 10.00, 450, 'Two-in-one reversible belt. Black and brown.', 'active'),
(18, 'Braided Canvas Belt', 699.00, 5.00, 550, 'Casual braided belt in multiple colors.', 'active'),
(18, 'Designer Buckle Belt', 1999.00, 15.00, 300, 'Premium belt with signature designer buckle.', 'active'),
(18, 'Stretch Comfort Belt', 599.00, 8.00, 500, 'Elastic stretch belt for maximum comfort.', 'active'),
(18, 'Formal Dress Belt', 1499.00, 12.00, 380, 'Sleek formal belt with polished buckle.', 'active'),
-- Vendor 19: Scarf Studio (Wrap Style) - 5 products
(19, 'Silk Scarf Printed', 1999.00, 15.00, 350, 'Luxurious silk scarf with artistic prints.', 'active'),
(19, 'Cashmere Shawl', 4999.00, 20.00, 150, 'Ultra-soft cashmere shawl for elegance.', 'active'),
(19, 'Cotton Stole Set', 899.00, 8.00, 500, 'Set of 3 lightweight cotton stoles.', 'active'),
(19, 'Wool Blend Wrap', 1499.00, 10.00, 400, 'Warm wool blend wrap for winters.', 'active'),
(19, 'Embroidered Dupatta', 1299.00, 12.00, 350, 'Traditional dupatta with mirror work.', 'active'),
-- Vendor 20: Hat House (Cap Corner) - 5 products
(20, 'Baseball Cap Classic', 599.00, 5.00, 600, 'Classic baseball cap with adjustable strap.', 'active'),
(20, 'Fedora Hat Wool', 1999.00, 15.00, 250, 'Stylish wool fedora for distinguished look.', 'active'),
(20, 'Sun Hat Wide Brim', 1299.00, 10.00, 350, 'Wide brim sun hat with UV protection.', 'active'),
(20, 'Bucket Hat Trendy', 799.00, 8.00, 450, 'Trendy bucket hat in solid colors.', 'active'),
(20, 'Winter Trapper Hat', 1499.00, 12.00, 300, 'Warm trapper hat with ear flaps for cold weather.', 'active');

-- ---------------------------------------------
-- Tags (100 records - covering all products)
-- ---------------------------------------------
INSERT INTO tags (tag_name, product_id) VALUES
-- Tags for Vendor 1 products (1-5)
('cotton', 1),
('casual', 1),
('menswear', 2),
('shirt', 2),
('graphic', 3),
('tshirt', 3),
('polo', 4),
('classic', 4),
('henley', 5),
('layering', 5),
-- Tags for Vendor 2 products (6-10)
('formal', 6),
('blazer', 6),
('pants', 7),
('chino', 7),
('linen', 8),
('summer', 8),
('vest', 9),
('tailored', 9),
('pleated', 10),
('dressy', 10),
-- Tags for Vendor 3 products (11-15)
('ethnic', 11),
('silk', 11),
('traditional', 12),
('kurta', 12),
('banarasi', 13),
('bridal', 13),
('pajama', 14),
('daily', 14),
('anarkali', 15),
('festival', 15),
-- Tags for Vendor 4 products (16-20)
('loungewear', 16),
('comfort', 16),
('winter', 17),
('hoodie', 17),
('fleece', 18),
('joggers', 18),
('oversized', 19),
('sweatshirt', 19),
('sleepwear', 20),
('nightwear', 20),
-- Tags for Vendor 5 products (21-25)
('premium', 21),
('business', 21),
('cashmere', 22),
('luxury', 22),
('italian', 23),
('elegant', 23),
('merino', 24),
('cardigan', 24),
('tweed', 25),
('sophisticated', 25),
-- Tags for Vendor 6 products (26-30)
('sportswear', 26),
('running', 26),
('gym', 27),
('workout', 27),
('compression', 28),
('athletic', 28),
('sports-bra', 29),
('fitness', 29),
('training', 30),
('activewear', 30),
-- Tags for Vendor 7 products (31-35)
('kidswear', 31),
('party', 31),
('boys', 32),
('denim', 32),
('girls', 33),
('tutu', 33),
('cargo', 34),
('shorts', 34),
('rainwear', 35),
('waterproof', 35),
-- Tags for Vendor 8 products (36-40)
('corporate', 36),
('executive', 36),
('trousers', 37),
('office', 37),
('french-cuff', 38),
('formal-shirt', 38),
('suit', 39),
('navy', 39),
('pocket-square', 40),
('accessories', 40),
-- Tags for Vendor 9 products (41-45)
('jeans', 41),
('blue', 41),
('distressed', 42),
('summer-wear', 42),
('skinny', 43),
('black', 43),
('bootcut', 44),
('vintage', 44),
('trucker', 45),
('jacket', 45),
-- Tags for Vendor 10 products (46-50)
('belt', 46),
('leather', 46),
('tie', 47),
('formal-accessory', 47),
('tote', 48),
('canvas', 48),
('wallet', 49),
('genuine-leather', 49),
('cufflinks', 50),
('gold-plated', 50);

-- ---------------------------------------------
-- Tracking (20 records)
-- ---------------------------------------------
INSERT INTO tracking (tracking_status, delivery_partner, shipped_datetime, delivery_datetime) VALUES
('delivered', 'BlueDart', '2024-06-01 09:00:00', '2024-06-03 14:30:00'),
('delivered', 'Delhivery', '2024-06-02 10:30:00', '2024-06-05 11:00:00'),
('shipped', 'FedEx', '2024-06-05 08:00:00', NULL),
('delivered', 'DTDC', '2024-06-07 11:00:00', '2024-06-10 16:45:00'),
('shipped', 'Ecom Express', '2024-06-10 09:30:00', NULL),
('delivered', 'BlueDart', '2024-06-12 14:00:00', '2024-06-14 10:00:00'),
('delivered', 'Delhivery', '2024-06-15 08:30:00', '2024-06-18 15:20:00'),
('shipped', 'FedEx', '2024-06-18 10:00:00', NULL),
('delivered', 'DTDC', '2024-06-20 12:00:00', '2024-06-23 09:30:00'),
('delivered', 'Ecom Express', '2024-06-22 09:00:00', '2024-06-25 14:00:00'),
('shipped', 'BlueDart', '2024-06-25 11:30:00', NULL),
('delivered', 'Delhivery', '2024-06-27 08:00:00', '2024-06-30 12:45:00'),
('delivered', 'FedEx', '2024-07-01 10:30:00', '2024-07-04 16:00:00'),
('shipped', 'DTDC', '2024-07-03 09:00:00', NULL),
('delivered', 'Ecom Express', '2024-07-05 14:00:00', '2024-07-08 11:30:00'),
('delivered', 'BlueDart', '2024-07-08 08:30:00', '2024-07-11 15:00:00'),
('shipped', 'Delhivery', '2024-07-10 10:00:00', NULL),
('delivered', 'FedEx', '2024-07-12 11:00:00', '2024-07-15 09:45:00'),
('delivered', 'DTDC', '2024-07-15 09:30:00', '2024-07-18 14:20:00'),
('shipped', 'Ecom Express', '2024-07-18 08:00:00', NULL);

-- ---------------------------------------------
-- Orders (20 records)
-- ---------------------------------------------
INSERT INTO orders (customer_id, tracking_id, order_datetime, order_total, payment_method, status) VALUES
(1, 1, '2024-05-30 15:30:00', 2398.00, 'credit card', 'delivered'),
(2, 2, '2024-06-01 10:00:00', 4999.00, 'upi', 'delivered'),
(3, 3, '2024-06-04 14:45:00', 3598.00, 'debit card', 'processing'),
(4, 4, '2024-06-06 09:30:00', 1299.00, 'net banking', 'delivered'),
(5, 5, '2024-06-09 16:00:00', 5499.00, 'credit card', 'processing'),
(6, 6, '2024-06-11 11:15:00', 899.00, 'upi', 'delivered'),
(7, 7, '2024-06-14 08:45:00', 12999.00, 'credit card', 'delivered'),
(8, 8, '2024-06-17 13:30:00', 2998.00, 'debit card', 'processing'),
(9, 9, '2024-06-19 10:00:00', 1799.00, 'cash', 'delivered'),
(10, 10, '2024-06-21 15:45:00', 3797.00, 'upi', 'delivered'),
(11, 11, '2024-06-24 09:00:00', 999.00, 'net banking', 'processing'),
(12, 12, '2024-06-26 12:30:00', 2499.00, 'credit card', 'delivered'),
(13, 13, '2024-06-30 08:15:00', 4298.00, 'debit card', 'delivered'),
(14, 14, '2024-07-02 14:00:00', 1598.00, 'upi', 'processing'),
(15, 15, '2024-07-04 11:30:00', 5999.00, 'credit card', 'delivered'),
(16, 16, '2024-07-07 09:45:00', 1899.00, 'cash', 'delivered'),
(17, 17, '2024-07-09 16:15:00', 2698.00, 'net banking', 'processing'),
(18, 18, '2024-07-11 10:30:00', 3999.00, 'upi', 'delivered'),
(19, 19, '2024-07-14 13:00:00', 1499.00, 'debit card', 'delivered'),
(20, 20, '2024-07-17 08:30:00', 7498.00, 'credit card', 'processing');

-- ---------------------------------------------
-- Order Items (20 records)
-- ---------------------------------------------
INSERT INTO order_items (order_id, product_id, purchase_price, purchase_qty) VALUES
(1, 1, 539.10, 2),
(1, 2, 1104.15, 1),
(2, 5, 4749.05, 1),
(3, 3, 3199.20, 1),
(3, 4, 1583.12, 1),
(4, 2, 1104.15, 1),
(5, 9, 9749.25, 1),
(6, 7, 827.08, 1),
(7, 9, 9749.25, 1),
(7, 10, 5099.15, 1),
(8, 6, 2249.10, 1),
(8, 8, 1229.18, 1),
(9, 4, 1583.12, 1),
(10, 11, 899.10, 2),
(10, 12, 664.05, 3),
(11, 20, 899.10, 1),
(12, 6, 2249.10, 1),
(13, 15, 1799.10, 2),
(14, 13, 1279.20, 1),
(15, 10, 5099.15, 1);

-- ---------------------------------------------
-- Complaints (20 records)
-- ---------------------------------------------
INSERT INTO complaints (customer_id, vendor_id, user_type, description, status, raised_datetime, closed_datetime) VALUES
(1, 1, 'customer', 'Product received was damaged. T-shirt had a tear on the sleeve.', 'resolved', '2024-06-05 10:00:00', '2024-06-08 14:30:00'),
(2, 3, 'customer', 'Saree color does not match the product image on the website.', 'resolved', '2024-06-08 11:30:00', '2024-06-12 09:00:00'),
(3, 2, 'customer', 'Blazer size is smaller than mentioned. Need exchange.', 'open', '2024-06-10 14:00:00', NULL),
(4, 1, 'customer', 'Received wrong product. Ordered shirt but received t-shirt.', 'closed', '2024-06-12 09:30:00', '2024-06-15 16:00:00'),
(5, 5, 'customer', 'Suit fabric quality not as expected. Seems different from description.', 'open', '2024-06-15 13:45:00', NULL),
(6, 4, 'customer', 'Hoodie zipper is broken. Product is defective.', 'resolved', '2024-06-18 10:00:00', '2024-06-22 11:30:00'),
(7, 5, 'customer', 'Delivery was delayed by 5 days. No proper tracking updates.', 'closed', '2024-06-20 15:30:00', '2024-06-25 10:00:00'),
(8, 3, 'customer', 'Embroidery on kurta is coming off after first wash.', 'open', '2024-06-22 08:45:00', NULL),
(9, 4, 'customer', 'Lounge pants shrunk after washing despite following care instructions.', 'resolved', '2024-06-25 11:00:00', '2024-06-30 14:20:00'),
(10, 6, 'customer', 'Running shorts elastic band is loose. Does not fit properly.', 'open', '2024-06-28 14:30:00', NULL),
(11, 10, 'customer', 'Silk tie has visible defects. Thread is loose at multiple places.', 'resolved', '2024-07-01 09:00:00', '2024-07-05 12:00:00'),
(12, 3, 'customer', 'Wrong billing amount charged. Discount not applied.', 'closed', '2024-07-03 16:00:00', '2024-07-07 10:30:00'),
(13, 8, 'customer', 'Formal trousers have incorrect stitching. Button fell off.', 'open', '2024-07-06 11:30:00', NULL),
(14, 7, 'customer', 'Kids dress color faded significantly after first wash.', 'resolved', '2024-07-09 08:00:00', '2024-07-13 15:45:00'),
(15, 5, 'customer', 'Cashmere sweater developed pilling within a week of use.', 'open', '2024-07-12 13:00:00', NULL),
(1, 9, 'customer', 'Jeans button broke within first month of purchase.', 'resolved', '2024-07-15 10:30:00', '2024-07-19 09:00:00'),
(2, 8, 'vendor', 'Customer claims package was not delivered but tracking shows delivered.', 'open', '2024-07-18 14:00:00', NULL),
(3, 6, 'vendor', 'Customer requesting refund after product return window expired.', 'closed', '2024-07-20 09:30:00', '2024-07-25 11:00:00'),
(4, 9, 'customer', 'Denim shorts have uneven hem. Quality issue.', 'resolved', '2024-07-22 16:00:00', '2024-07-27 10:30:00'),
(5, 10, 'customer', 'Leather belt buckle is scratched. Product was not packed properly.', 'open', '2024-07-25 11:30:00', NULL);

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify record counts
SELECT 'customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION ALL
SELECT 'vendors', COUNT(*) FROM vendors
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'tags', COUNT(*) FROM tags
UNION ALL
SELECT 'tracking', COUNT(*) FROM tracking
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'complaints', COUNT(*) FROM complaints;

-- Display schema summary
SELECT 
    'Database Schema Created Successfully!' AS message,
    NOW() AS created_at;
