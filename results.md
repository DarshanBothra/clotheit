mysql> SOURCE /Users/ashish/Desktop/clotheit-1/db/queries.sql
Query OK, 0 rows affected (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----+--------------+------------------------+------------+---------------------+
| id | name         | email                  | phone      | sign_up_datetime    |
+----+--------------+------------------------+------------+---------------------+
|  1 | Rahul Sharma | rahul.sharma@email.com | 9876543210 | 2024-01-15 10:30:00 |
|  2 | Priya Patel  | priya.patel@email.com  | 9876543211 | 2024-01-20 14:45:00 |
|  3 | Amit Kumar   | amit.kumar@email.com   | 9876543212 | 2024-02-05 09:15:00 |
|  4 | Sneha Reddy  | sneha.reddy@email.com  | 9876543213 | 2024-02-10 11:00:00 |
|  5 | Vikram Singh | vikram.singh@email.com | 9876543214 | 2024-02-15 16:30:00 |
|  6 | Anjali Gupta | anjali.gupta@email.com | 9876543215 | 2024-03-01 08:45:00 |
|  7 | Karthik Nair | karthik.nair@email.com | 9876543216 | 2024-03-10 12:00:00 |
|  8 | Meera Iyer   | meera.iyer@email.com   | 9876543217 | 2024-03-15 15:20:00 |
|  9 | Rohan Desai  | rohan.desai@email.com  | 9876543218 | 2024-03-20 10:10:00 |
+----+--------------+------------------------+------------+---------------------+
9 rows in set (0.002 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+------------+----------------------------+----------+----------+---------------------+--------------------+
| product_id | product_name               | price    | discount | vendor_name         | brand              |
+------------+----------------------------+----------+----------+---------------------+--------------------+
|          1 | Classic Cotton T-Shirt     |   599.00 |    10.00 | Fashion Forward Inc | Trendy Threads     |
|          2 | Slim Fit Casual Shirt      |  1299.00 |    15.00 | Fashion Forward Inc | Trendy Threads     |
|          3 | Graphic Print Tee          |   799.00 |    12.00 | Fashion Forward Inc | Trendy Threads     |
|          4 | Polo Shirt Classic         |   999.00 |     8.00 | Fashion Forward Inc | Trendy Threads     |
|          5 | Henley Long Sleeve         |   899.00 |    10.00 | Fashion Forward Inc | Trendy Threads     |
|          6 | Designer Blazer            |  3999.00 |    20.00 | Style Studio        | Urban Chic         |
|          7 | Chino Pants                |  1799.00 |    12.00 | Style Studio        | Urban Chic         |
|          8 | Linen Summer Blazer        |  4499.00 |    18.00 | Style Studio        | Urban Chic         |
|          9 | Tailored Vest              |  2499.00 |    15.00 | Style Studio        | Urban Chic         |
|         10 | Pleated Dress Pants        |  2199.00 |    10.00 | Style Studio        | Urban Chic         |
|         11 | Silk Saree Collection      |  4999.00 |     5.00 | Ethnic Elegance     | Desi Drapes        |
|         12 | Embroidered Kurta Set      |  2499.00 |    10.00 | Ethnic Elegance     | Desi Drapes        |
|         13 | Banarasi Silk Saree        |  7999.00 |     8.00 | Ethnic Elegance     | Desi Drapes        |
|         14 | Cotton Kurta Pajama        |  1899.00 |    12.00 | Ethnic Elegance     | Desi Drapes        |
|         15 | Anarkali Suit Set          |  3499.00 |    15.00 | Ethnic Elegance     | Desi Drapes        |
|         16 | Comfortable Lounge Pants   |   899.00 |     8.00 | Casual Comfort Co   | Relax Wear         |
|         17 | Relaxed Fit Hoodie         |  1499.00 |    18.00 | Casual Comfort Co   | Relax Wear         |
|         18 | Fleece Joggers             |  1199.00 |    10.00 | Casual Comfort Co   | Relax Wear         |
|         19 | Oversized Sweatshirt       |  1299.00 |    15.00 | Casual Comfort Co   | Relax Wear         |
|         20 | Cotton Pajama Set          |   999.00 |     5.00 | Casual Comfort Co   | Relax Wear         |
|         21 | Premium Wool Suit          | 12999.00 |    25.00 | Premium Fabrics Ltd | Luxury Line        |
|         22 | Cashmere Sweater           |  5999.00 |    15.00 | Premium Fabrics Ltd | Luxury Line        |
|         23 | Italian Silk Shirt         |  4999.00 |    12.00 | Premium Fabrics Ltd | Luxury Line        |
|         24 | Merino Wool Cardigan       |  4499.00 |    10.00 | Premium Fabrics Ltd | Luxury Line        |
|         25 | Tweed Sports Jacket        |  8999.00 |    20.00 | Premium Fabrics Ltd | Luxury Line        |
|         26 | Performance Running Shorts |   999.00 |    10.00 | Sporty Styles       | Active Gear        |
|         27 | Gym Tank Top               |   699.00 |     5.00 | Sporty Styles       | Active Gear        |
|         28 | Compression Leggings       |  1499.00 |    12.00 | Sporty Styles       | Active Gear        |
|         29 | Sports Bra Pro             |   899.00 |     8.00 | Sporty Styles       | Active Gear        |
|         30 | Training Track Jacket      |  1799.00 |    15.00 | Sporty Styles       | Active Gear        |
|         31 | Kids Party Dress           |  1599.00 |    20.00 | Kids Kingdom        | Little Stars       |
|         32 | Boys Denim Jacket          |  1299.00 |    15.00 | Kids Kingdom        | Little Stars       |
|         33 | Girls Tutu Skirt           |   899.00 |    10.00 | Kids Kingdom        | Little Stars       |
|         34 | Boys Cargo Shorts          |   799.00 |    12.00 | Kids Kingdom        | Little Stars       |
|         35 | Kids Raincoat Set          |  1199.00 |     8.00 | Kids Kingdom        | Little Stars       |
|         36 | Executive Dress Shirt      |  1999.00 |    10.00 | Formal Affairs      | Corporate Classics |
|         37 | Formal Trousers            |  2299.00 |    12.00 | Formal Affairs      | Corporate Classics |
|         38 | French Cuff Shirt          |  2499.00 |    15.00 | Formal Affairs      | Corporate Classics |
|         39 | Business Suit Navy         |  9999.00 |    18.00 | Formal Affairs      | Corporate Classics |
|         40 | Silk Pocket Square Set     |   599.00 |     5.00 | Formal Affairs      | Corporate Classics |
|         41 | Classic Blue Jeans         |  1899.00 |    15.00 | Denim Den           | Jean Genius        |
|         42 | Distressed Denim Shorts    |  1199.00 |    20.00 | Denim Den           | Jean Genius        |
|         43 | Skinny Fit Black Jeans     |  2099.00 |    12.00 | Denim Den           | Jean Genius        |
|         44 | Bootcut Vintage Jeans      |  2299.00 |    10.00 | Denim Den           | Jean Genius        |
|         45 | Denim Trucker Jacket       |  2799.00 |    18.00 | Denim Den           | Jean Genius        |
|         46 | Leather Belt Collection    |   799.00 |     5.00 | Accessory Avenue    | Accent Plus        |
|         47 | Silk Tie Set               |   999.00 |    10.00 | Accessory Avenue    | Accent Plus        |
|         48 | Canvas Tote Bag            |  1299.00 |     8.00 | Accessory Avenue    | Accent Plus        |
|         49 | Leather Wallet Premium     |  1499.00 |    12.00 | Accessory Avenue    | Accent Plus        |
|         50 | Cufflinks Gold Plated      |  1999.00 |    15.00 | Accessory Avenue    | Accent Plus        |
|         51 | Wool Overcoat              |  6999.00 |    20.00 | Winter Warmth       | Cozy Collection    |
|         52 | Puffer Jacket              |  3999.00 |    15.00 | Winter Warmth       | Cozy Collection    |
|         53 | Knit Beanie Cap            |   499.00 |     5.00 | Winter Warmth       | Cozy Collection    |
|         54 | Thermal Innerwear Set      |  1299.00 |    10.00 | Winter Warmth       | Cozy Collection    |
|         55 | Woolen Muffler             |   799.00 |     8.00 | Winter Warmth       | Cozy Collection    |
|         56 | Linen Shirt Casual         |  1599.00 |    12.00 | Summer Breeze       | Cool Cottons       |
|         57 | Cotton Shorts Relaxed      |   899.00 |     8.00 | Summer Breeze       | Cool Cottons       |
|         58 | Sleeveless Maxi Dress      |  2199.00 |    15.00 | Summer Breeze       | Cool Cottons       |
|         59 | Linen Palazzo Pants        |  1799.00 |    10.00 | Summer Breeze       | Cool Cottons       |
|         60 | Cotton Crop Top            |   699.00 |     5.00 | Summer Breeze       | Cool Cottons       |
|         61 | Classic Leather Loafers    |  2999.00 |    15.00 | Footwear Factory    | Step Right         |
|         62 | Running Shoes Pro          |  4999.00 |    20.00 | Footwear Factory    | Step Right         |
|         63 | Canvas Sneakers            |  1499.00 |    10.00 | Footwear Factory    | Step Right         |
|         64 | Leather Sandals            |  1299.00 |     8.00 | Footwear Factory    | Step Right         |
|         65 | Ankle Boots Suede          |  3499.00 |    12.00 | Footwear Factory    | Step Right         |
|         66 | Leather Messenger Bag      |  3499.00 |    15.00 | Bag Bazaar          | Carry Style        |
|         67 | Travel Duffel Bag          |  2499.00 |    12.00 | Bag Bazaar          | Carry Style        |
|         68 | Ladies Handbag Classic     |  2999.00 |    10.00 | Bag Bazaar          | Carry Style        |
|         69 | Laptop Backpack Pro        |  1999.00 |     8.00 | Bag Bazaar          | Carry Style        |
|         70 | Clutch Evening Bag         |  1499.00 |    18.00 | Bag Bazaar          | Carry Style        |
|         71 | Analog Classic Watch       |  2999.00 |    15.00 | Watch World         | Time Trends        |
|         72 | Smart Fitness Watch        |  4999.00 |    20.00 | Watch World         | Time Trends        |
|         73 | Chronograph Sports Watch   |  5999.00 |    18.00 | Watch World         | Time Trends        |
|         74 | Minimalist Dial Watch      |  1999.00 |    10.00 | Watch World         | Time Trends        |
|         75 | Vintage Style Watch        |  3499.00 |    12.00 | Watch World         | Time Trends        |
|         76 | Gold Plated Necklace       |  2499.00 |    15.00 | Jewelry Junction    | Sparkle Studio     |
|         77 | Diamond Stud Earrings      |  9999.00 |    10.00 | Jewelry Junction    | Sparkle Studio     |
|         78 | Silver Charm Bracelet      |  1499.00 |    12.00 | Jewelry Junction    | Sparkle Studio     |
|         79 | Pearl Drop Earrings        |  1999.00 |     8.00 | Jewelry Junction    | Sparkle Studio     |
|         80 | Statement Ring Gold        |  3499.00 |    20.00 | Jewelry Junction    | Sparkle Studio     |
|         81 | Aviator Sunglasses         |  1999.00 |    15.00 | Eyewear Express     | Vision Vogue       |
|         82 | Blue Light Glasses         |  1499.00 |    10.00 | Eyewear Express     | Vision Vogue       |
|         83 | Cat Eye Frames             |  2499.00 |    12.00 | Eyewear Express     | Vision Vogue       |
|         84 | Round Retro Glasses        |  1799.00 |     8.00 | Eyewear Express     | Vision Vogue       |
|         85 | Sports Sunglasses          |  2999.00 |    18.00 | Eyewear Express     | Vision Vogue       |
|         86 | Reversible Leather Belt    |  1299.00 |    10.00 | Belt & Beyond       | Waist Wonders      |
|         87 | Braided Canvas Belt        |   699.00 |     5.00 | Belt & Beyond       | Waist Wonders      |
|         88 | Designer Buckle Belt       |  1999.00 |    15.00 | Belt & Beyond       | Waist Wonders      |
|         89 | Stretch Comfort Belt       |   599.00 |     8.00 | Belt & Beyond       | Waist Wonders      |
|         90 | Formal Dress Belt          |  1499.00 |    12.00 | Belt & Beyond       | Waist Wonders      |
|         91 | Silk Scarf Printed         |  1999.00 |    15.00 | Scarf Studio        | Wrap Style         |
|         92 | Cashmere Shawl             |  4999.00 |    20.00 | Scarf Studio        | Wrap Style         |
|         93 | Cotton Stole Set           |   899.00 |     8.00 | Scarf Studio        | Wrap Style         |
|         94 | Wool Blend Wrap            |  1499.00 |    10.00 | Scarf Studio        | Wrap Style         |
|         95 | Embroidered Dupatta        |  1299.00 |    12.00 | Scarf Studio        | Wrap Style         |
|         96 | Baseball Cap Classic       |   599.00 |     5.00 | Hat House           | Cap Corner         |
|         97 | Fedora Hat Wool            |  1999.00 |    15.00 | Hat House           | Cap Corner         |
|         98 | Sun Hat Wide Brim          |  1299.00 |    10.00 | Hat House           | Cap Corner         |
|         99 | Bucket Hat Trendy          |   799.00 |     8.00 | Hat House           | Cap Corner         |
|        100 | Winter Trapper Hat         |  1499.00 |    12.00 | Hat House           | Cap Corner         |
+------------+----------------------------+----------+----------+---------------------+--------------------+
100 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----------+------------------+---------------------+-------------+-----------+-------------+----------------+
| order_id | customer_name    | order_datetime      | order_total | status    | total_items | total_quantity |
+----------+------------------+---------------------+-------------+-----------+-------------+----------------+
|        1 | Rahul Sharma     | 2024-05-30 15:30:00 |     2398.00 | DELIVERED |           2 |              3 |
|        2 | Priya Patel      | 2024-06-01 10:00:00 |     4999.00 | DELIVERED |           1 |              1 |
|        3 | Amit Kumar       | 2024-06-04 14:45:00 |     3598.00 | PLACED    |           2 |              2 |
|        4 | Sneha Reddy      | 2024-06-06 09:30:00 |     1299.00 | DELIVERED |           1 |              1 |
|        5 | Vikram Singh     | 2024-06-09 16:00:00 |     5499.00 | PLACED    |           1 |              1 |
|        6 | Anjali Gupta     | 2024-06-11 11:15:00 |      899.00 | DELIVERED |           1 |              1 |
|        7 | Karthik Nair     | 2024-06-14 08:45:00 |    12999.00 | DELIVERED |           2 |              2 |
|        8 | Meera Iyer       | 2024-06-17 13:30:00 |     2998.00 | PLACED    |           2 |              2 |
|        9 | Rohan Desai      | 2024-06-19 10:00:00 |     1799.00 | DELIVERED |           1 |              1 |
|       10 | Kavita Joshi     | 2024-06-21 15:45:00 |     3797.00 | DELIVERED |           2 |              5 |
|       11 | Arjun Menon      | 2024-06-24 09:00:00 |      999.00 | PLACED    |           1 |              1 |
|       12 | Divya Rao        | 2024-06-26 12:30:00 |     2499.00 | DELIVERED |           1 |              1 |
|       13 | Sanjay Verma     | 2024-06-30 08:15:00 |     4298.00 | DELIVERED |           1 |              2 |
|       14 | Pooja Agarwal    | 2024-07-02 14:00:00 |     1598.00 | PLACED    |           1 |              1 |
|       15 | Nikhil Saxena    | 2024-07-04 11:30:00 |     5999.00 | DELIVERED |           1 |              1 |
|       16 | Swati Mishra     | 2024-07-07 09:45:00 |     1899.00 | DELIVERED |           1 |              2 |
|       17 | Deepak Choudhary | 2024-07-09 16:15:00 |     2698.00 | CANCELLED |           2 |              2 |
|       18 | Ritu Sharma      | 2024-07-11 10:30:00 |     3999.00 | DELIVERED |           2 |              2 |
|       19 | Manish Tiwari    | 2024-07-14 13:00:00 |     1499.00 | DELIVERED |           1 |              1 |
|       20 | Ananya Das       | 2024-07-17 08:30:00 |     7498.00 | PLACED    |           2 |              2 |
+----------+------------------+---------------------+-------------+-----------+-------------+----------------+
20 rows in set (0.003 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+-----------+---------------------+--------------------+---------------+-----------------+
| vendor_id | vendor_name         | affiliation        | product_count | total_inventory |
+-----------+---------------------+--------------------+---------------+-----------------+
|         1 | Fashion Forward Inc | Trendy Threads     |             5 |            1950 |
|         2 | Style Studio        | Urban Chic         |             5 |            1150 |
|         3 | Ethnic Elegance     | Desi Drapes        |             5 |            1080 |
|         4 | Casual Comfort Co   | Relax Wear         |             5 |            2400 |
|         5 | Premium Fabrics Ltd | Luxury Line        |             5 |             710 |
|         6 | Sporty Styles       | Active Gear        |             5 |            2100 |
|         7 | Kids Kingdom        | Little Stars       |             5 |            1780 |
|         8 | Formal Affairs      | Corporate Classics |             5 |            1620 |
|         9 | Denim Den           | Jean Genius        |             5 |            1830 |
|        10 | Accessory Avenue    | Accent Plus        |             5 |            2000 |
|        11 | Winter Warmth       | Cozy Collection    |             5 |            1980 |
|        12 | Summer Breeze       | Cool Cottons       |             5 |            2000 |
|        13 | Footwear Factory    | Step Right         |             5 |            1600 |
|        14 | Bag Bazaar          | Carry Style        |             5 |            1500 |
|        15 | Watch World         | Time Trends        |             5 |            1350 |
|        16 | Jewelry Junction    | Sparkle Studio     |             5 |            1350 |
|        17 | Eyewear Express     | Vision Vogue       |             5 |            1800 |
|        18 | Belt & Beyond       | Waist Wonders      |             5 |            2180 |
|        19 | Scarf Studio        | Wrap Style         |             5 |            1750 |
|        20 | Hat House           | Cap Corner         |             5 |            1950 |
+-----------+---------------------+--------------------+---------------+-----------------+
20 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----+---------------+-------------------------+----------+-------------+
| id | name          | email                   | order_id | order_total |
+----+---------------+-------------------------+----------+-------------+
|  7 | Karthik Nair  | karthik.nair@email.com  |        7 |    12999.00 |
| 20 | Ananya Das    | ananya.das@email.com    |       20 |     7498.00 |
| 15 | Nikhil Saxena | nikhil.saxena@email.com |       15 |     5999.00 |
|  5 | Vikram Singh  | vikram.singh@email.com  |        5 |     5499.00 |
|  2 | Priya Patel   | priya.patel@email.com   |        2 |     4999.00 |
| 13 | Sanjay Verma  | sanjay.verma@email.com  |       13 |     4298.00 |
| 18 | Ritu Sharma   | ritu.sharma@email.com   |       18 |     3999.00 |
| 10 | Kavita Joshi  | kavita.joshi@email.com  |       10 |     3797.00 |
+----+---------------+-------------------------+----------+-------------+
8 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+------+---------------------+--------------------+-------------+
| id   | vendor_name         | affiliation        | avg_price   |
+------+---------------------+--------------------+-------------+
|    5 | Premium Fabrics Ltd | Luxury Line        | 7499.000000 |
|    3 | Ethnic Elegance     | Desi Drapes        | 4179.000000 |
|   15 | Watch World         | Time Trends        | 3899.000000 |
|   16 | Jewelry Junction    | Sparkle Studio     | 3899.000000 |
|    8 | Formal Affairs      | Corporate Classics | 3479.000000 |
|    2 | Style Studio        | Urban Chic         | 2999.000000 |
|   13 | Footwear Factory    | Step Right         | 2859.000000 |
|   11 | Winter Warmth       | Cozy Collection    | 2719.000000 |
+------+---------------------+--------------------+-------------+
8 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+---------------------+----------------------------+------------+-----------+
| name                | email                      | phone      | user_type |
+---------------------+----------------------------+------------+-----------+
| Amit Kumar          | amit.kumar@email.com       | 9876543212 | CUSTOMER  |
| Ananya Das          | ananya.das@email.com       | 9876543229 | CUSTOMER  |
| Anjali Gupta        | anjali.gupta@email.com     | 9876543215 | CUSTOMER  |
| Arjun Menon         | arjun.menon@email.com      | 9876543220 | CUSTOMER  |
| Deepak Choudhary    | deepak.choudhary@email.com | 9876543226 | CUSTOMER  |
| Divya Rao           | divya.rao@email.com        | 9876543221 | CUSTOMER  |
| Karthik Nair        | karthik.nair@email.com     | 9876543216 | CUSTOMER  |
| Kavita Joshi        | kavita.joshi@email.com     | 9876543219 | CUSTOMER  |
| Manish Tiwari       | manish.tiwari@email.com    | 9876543228 | CUSTOMER  |
| Meera Iyer          | meera.iyer@email.com       | 9876543217 | CUSTOMER  |
| Nikhil Saxena       | nikhil.saxena@email.com    | 9876543224 | CUSTOMER  |
| Pooja Agarwal       | pooja.agarwal@email.com    | 9876543223 | CUSTOMER  |
| Priya Patel         | priya.patel@email.com      | 9876543211 | CUSTOMER  |
| Rahul Sharma        | rahul.sharma@email.com     | 9876543210 | CUSTOMER  |
| Ritu Sharma         | ritu.sharma@email.com      | 9876543227 | CUSTOMER  |
| Rohan Desai         | rohan.desai@email.com      | 9876543218 | CUSTOMER  |
| Sanjay Verma        | sanjay.verma@email.com     | 9876543222 | CUSTOMER  |
| Sneha Reddy         | sneha.reddy@email.com      | 9876543213 | CUSTOMER  |
| Swati Mishra        | swati.mishra@email.com     | 9876543225 | CUSTOMER  |
| Vikram Singh        | vikram.singh@email.com     | 9876543214 | CUSTOMER  |
| Accessory Avenue    | style@accessoryavenue.com  | 8765432109 | VENDOR    |
| Bag Bazaar          | bags@bagbazaar.com         | 8765432113 | VENDOR    |
| Belt & Beyond       | fit@beltbeyond.com         | 8765432117 | VENDOR    |
| Casual Comfort Co   | hello@casualcomfort.com    | 8765432103 | VENDOR    |
| Denim Den           | jeans@denimden.com         | 8765432108 | VENDOR    |
| Ethnic Elegance     | info@ethnicelegance.com    | 8765432102 | VENDOR    |
| Eyewear Express     | see@eyewearexpress.com     | 8765432116 | VENDOR    |
| Fashion Forward Inc | contact@fashionforward.com | 8765432100 | VENDOR    |
| Footwear Factory    | walk@footwearfactory.com   | 8765432112 | VENDOR    |
| Formal Affairs      | business@formalaffairs.com | 8765432107 | VENDOR    |
| Hat House           | top@hathouse.com           | 8765432119 | VENDOR    |
| Jewelry Junction    | shine@jewelryjunction.com  | 8765432115 | VENDOR    |
| Kids Kingdom        | care@kidskingdom.com       | 8765432106 | VENDOR    |
| Premium Fabrics Ltd | support@premiumfabrics.com | 8765432104 | VENDOR    |
| Scarf Studio        | drape@scarfstudio.com      | 8765432118 | VENDOR    |
| Sporty Styles       | orders@sportystyles.com    | 8765432105 | VENDOR    |
| Style Studio        | sales@stylestudio.com      | 8765432101 | VENDOR    |
| Summer Breeze       | fresh@summerbreeze.com     | 8765432111 | VENDOR    |
| Watch World         | time@watchworld.com        | 8765432114 | VENDOR    |
| Winter Warmth       | warm@winterwarmth.com      | 8765432110 | VENDOR    |
+---------------------+----------------------------+------------+-----------+
40 rows in set (0.002 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----+---------------+-------------------------+
| id | name          | email                   |
+----+---------------+-------------------------+
|  1 | Rahul Sharma  | rahul.sharma@email.com  |
|  2 | Priya Patel   | priya.patel@email.com   |
|  3 | Amit Kumar    | amit.kumar@email.com    |
|  4 | Sneha Reddy   | sneha.reddy@email.com   |
|  5 | Vikram Singh  | vikram.singh@email.com  |
|  6 | Anjali Gupta  | anjali.gupta@email.com  |
|  7 | Karthik Nair  | karthik.nair@email.com  |
|  8 | Meera Iyer    | meera.iyer@email.com    |
|  9 | Rohan Desai   | rohan.desai@email.com   |
| 10 | Kavita Joshi  | kavita.joshi@email.com  |
| 11 | Arjun Menon   | arjun.menon@email.com   |
| 12 | Divya Rao     | divya.rao@email.com     |
| 13 | Sanjay Verma  | sanjay.verma@email.com  |
| 14 | Pooja Agarwal | pooja.agarwal@email.com |
| 15 | Nikhil Saxena | nikhil.saxena@email.com |
+----+---------------+-------------------------+
15 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Empty set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+---------------------+-----------------+---------------+---------------+
| vendor_name         | brand           | orders_served | total_revenue |
+---------------------+-----------------+---------------+---------------+
| Style Studio        | Urban Chic      |             7 |      39450.46 |
| Fashion Forward Inc | Trendy Threads  |             6 |      15104.11 |
| Ethnic Elegance     | Desi Drapes     |             3 |       8667.75 |
| Winter Warmth       | Cozy Collection |             2 |       6073.25 |
+---------------------+-----------------+---------------+---------------+
4 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+---------+----------------------------+-----------+----------------+------------+---------------------+------------+
| user_id | user_email                 | user_type | session_status | last_login | profile_name        | phone      |
+---------+----------------------------+-----------+----------------+------------+---------------------+------------+
|      21 | contact@fashionforward.com | VENDOR    | INACTIVE       | NULL       | Fashion Forward Inc | 8765432100 |
|      22 | sales@stylestudio.com      | VENDOR    | INACTIVE       | NULL       | Style Studio        | 8765432101 |
|      23 | info@ethnicelegance.com    | VENDOR    | INACTIVE       | NULL       | Ethnic Elegance     | 8765432102 |
|      24 | hello@casualcomfort.com    | VENDOR    | INACTIVE       | NULL       | Casual Comfort Co   | 8765432103 |
|      25 | support@premiumfabrics.com | VENDOR    | INACTIVE       | NULL       | Premium Fabrics Ltd | 8765432104 |
|      26 | orders@sportystyles.com    | VENDOR    | INACTIVE       | NULL       | Sporty Styles       | 8765432105 |
|      27 | care@kidskingdom.com       | VENDOR    | INACTIVE       | NULL       | Kids Kingdom        | 8765432106 |
|      28 | business@formalaffairs.com | VENDOR    | INACTIVE       | NULL       | Formal Affairs      | 8765432107 |
|      29 | jeans@denimden.com         | VENDOR    | INACTIVE       | NULL       | Denim Den           | 8765432108 |
|      30 | style@accessoryavenue.com  | VENDOR    | INACTIVE       | NULL       | Accessory Avenue    | 8765432109 |
|      31 | warm@winterwarmth.com      | VENDOR    | INACTIVE       | NULL       | Winter Warmth       | 8765432110 |
|      32 | fresh@summerbreeze.com     | VENDOR    | INACTIVE       | NULL       | Summer Breeze       | 8765432111 |
|      33 | walk@footwearfactory.com   | VENDOR    | INACTIVE       | NULL       | Footwear Factory    | 8765432112 |
|      34 | bags@bagbazaar.com         | VENDOR    | INACTIVE       | NULL       | Bag Bazaar          | 8765432113 |
|      35 | time@watchworld.com        | VENDOR    | INACTIVE       | NULL       | Watch World         | 8765432114 |
|      36 | shine@jewelryjunction.com  | VENDOR    | INACTIVE       | NULL       | Jewelry Junction    | 8765432115 |
|      37 | see@eyewearexpress.com     | VENDOR    | INACTIVE       | NULL       | Eyewear Express     | 8765432116 |
|      38 | fit@beltbeyond.com         | VENDOR    | INACTIVE       | NULL       | Belt & Beyond       | 8765432117 |
|      39 | drape@scarfstudio.com      | VENDOR    | INACTIVE       | NULL       | Scarf Studio        | 8765432118 |
|      40 | top@hathouse.com           | VENDOR    | INACTIVE       | NULL       | Hat House           | 8765432119 |
|       1 | rahul.sharma@email.com     | CUSTOMER  | INACTIVE       | NULL       | Rahul Sharma        | 9876543210 |
|       2 | priya.patel@email.com      | CUSTOMER  | INACTIVE       | NULL       | Priya Patel         | 9876543211 |
|       3 | amit.kumar@email.com       | CUSTOMER  | INACTIVE       | NULL       | Amit Kumar          | 9876543212 |
|       4 | sneha.reddy@email.com      | CUSTOMER  | INACTIVE       | NULL       | Sneha Reddy         | 9876543213 |
|       5 | vikram.singh@email.com     | CUSTOMER  | INACTIVE       | NULL       | Vikram Singh        | 9876543214 |
|       6 | anjali.gupta@email.com     | CUSTOMER  | INACTIVE       | NULL       | Anjali Gupta        | 9876543215 |
|       7 | karthik.nair@email.com     | CUSTOMER  | INACTIVE       | NULL       | Karthik Nair        | 9876543216 |
|       8 | meera.iyer@email.com       | CUSTOMER  | INACTIVE       | NULL       | Meera Iyer          | 9876543217 |
|       9 | rohan.desai@email.com      | CUSTOMER  | INACTIVE       | NULL       | Rohan Desai         | 9876543218 |
|      10 | kavita.joshi@email.com     | CUSTOMER  | INACTIVE       | NULL       | Kavita Joshi        | 9876543219 |
|      11 | arjun.menon@email.com      | CUSTOMER  | INACTIVE       | NULL       | Arjun Menon         | 9876543220 |
|      12 | divya.rao@email.com        | CUSTOMER  | INACTIVE       | NULL       | Divya Rao           | 9876543221 |
|      13 | sanjay.verma@email.com     | CUSTOMER  | INACTIVE       | NULL       | Sanjay Verma        | 9876543222 |
|      14 | pooja.agarwal@email.com    | CUSTOMER  | INACTIVE       | NULL       | Pooja Agarwal       | 9876543223 |
|      15 | nikhil.saxena@email.com    | CUSTOMER  | INACTIVE       | NULL       | Nikhil Saxena       | 9876543224 |
|      16 | swati.mishra@email.com     | CUSTOMER  | INACTIVE       | NULL       | Swati Mishra        | 9876543225 |
|      17 | deepak.choudhary@email.com | CUSTOMER  | INACTIVE       | NULL       | Deepak Choudhary    | 9876543226 |
|      18 | ritu.sharma@email.com      | CUSTOMER  | INACTIVE       | NULL       | Ritu Sharma         | 9876543227 |
|      19 | manish.tiwari@email.com    | CUSTOMER  | INACTIVE       | NULL       | Manish Tiwari       | 9876543228 |
|      20 | ananya.das@email.com       | CUSTOMER  | INACTIVE       | NULL       | Ananya Das          | 9876543229 |
+---------+----------------------------+-----------+----------------+------------+---------------------+------------+
40 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+---------------------+----------------------------+----------+------------+
| vendor_name         | product_name               | price    | price_rank |
+---------------------+----------------------------+----------+------------+
| Accessory Avenue    | Cufflinks Gold Plated      |  1999.00 |          1 |
| Accessory Avenue    | Leather Wallet Premium     |  1499.00 |          2 |
| Accessory Avenue    | Canvas Tote Bag            |  1299.00 |          3 |
| Accessory Avenue    | Silk Tie Set               |   999.00 |          4 |
| Accessory Avenue    | Leather Belt Collection    |   799.00 |          5 |
| Bag Bazaar          | Leather Messenger Bag      |  3499.00 |          1 |
| Bag Bazaar          | Ladies Handbag Classic     |  2999.00 |          2 |
| Bag Bazaar          | Travel Duffel Bag          |  2499.00 |          3 |
| Bag Bazaar          | Laptop Backpack Pro        |  1999.00 |          4 |
| Bag Bazaar          | Clutch Evening Bag         |  1499.00 |          5 |
| Belt & Beyond       | Designer Buckle Belt       |  1999.00 |          1 |
| Belt & Beyond       | Formal Dress Belt          |  1499.00 |          2 |
| Belt & Beyond       | Reversible Leather Belt    |  1299.00 |          3 |
| Belt & Beyond       | Braided Canvas Belt        |   699.00 |          4 |
| Belt & Beyond       | Stretch Comfort Belt       |   599.00 |          5 |
| Casual Comfort Co   | Relaxed Fit Hoodie         |  1499.00 |          1 |
| Casual Comfort Co   | Oversized Sweatshirt       |  1299.00 |          2 |
| Casual Comfort Co   | Fleece Joggers             |  1199.00 |          3 |
| Casual Comfort Co   | Cotton Pajama Set          |   999.00 |          4 |
| Casual Comfort Co   | Comfortable Lounge Pants   |   899.00 |          5 |
| Denim Den           | Denim Trucker Jacket       |  2799.00 |          1 |
| Denim Den           | Bootcut Vintage Jeans      |  2299.00 |          2 |
| Denim Den           | Skinny Fit Black Jeans     |  2099.00 |          3 |
| Denim Den           | Classic Blue Jeans         |  1899.00 |          4 |
| Denim Den           | Distressed Denim Shorts    |  1199.00 |          5 |
| Ethnic Elegance     | Banarasi Silk Saree        |  7999.00 |          1 |
| Ethnic Elegance     | Silk Saree Collection      |  4999.00 |          2 |
| Ethnic Elegance     | Anarkali Suit Set          |  3499.00 |          3 |
| Ethnic Elegance     | Embroidered Kurta Set      |  2499.00 |          4 |
| Ethnic Elegance     | Cotton Kurta Pajama        |  1899.00 |          5 |
| Eyewear Express     | Sports Sunglasses          |  2999.00 |          1 |
| Eyewear Express     | Cat Eye Frames             |  2499.00 |          2 |
| Eyewear Express     | Aviator Sunglasses         |  1999.00 |          3 |
| Eyewear Express     | Round Retro Glasses        |  1799.00 |          4 |
| Eyewear Express     | Blue Light Glasses         |  1499.00 |          5 |
| Fashion Forward Inc | Slim Fit Casual Shirt      |  1299.00 |          1 |
| Fashion Forward Inc | Polo Shirt Classic         |   999.00 |          2 |
| Fashion Forward Inc | Henley Long Sleeve         |   899.00 |          3 |
| Fashion Forward Inc | Graphic Print Tee          |   799.00 |          4 |
| Fashion Forward Inc | Classic Cotton T-Shirt     |   599.00 |          5 |
| Footwear Factory    | Running Shoes Pro          |  4999.00 |          1 |
| Footwear Factory    | Ankle Boots Suede          |  3499.00 |          2 |
| Footwear Factory    | Classic Leather Loafers    |  2999.00 |          3 |
| Footwear Factory    | Canvas Sneakers            |  1499.00 |          4 |
| Footwear Factory    | Leather Sandals            |  1299.00 |          5 |
| Formal Affairs      | Business Suit Navy         |  9999.00 |          1 |
| Formal Affairs      | French Cuff Shirt          |  2499.00 |          2 |
| Formal Affairs      | Formal Trousers            |  2299.00 |          3 |
| Formal Affairs      | Executive Dress Shirt      |  1999.00 |          4 |
| Formal Affairs      | Silk Pocket Square Set     |   599.00 |          5 |
| Hat House           | Fedora Hat Wool            |  1999.00 |          1 |
| Hat House           | Winter Trapper Hat         |  1499.00 |          2 |
| Hat House           | Sun Hat Wide Brim          |  1299.00 |          3 |
| Hat House           | Bucket Hat Trendy          |   799.00 |          4 |
| Hat House           | Baseball Cap Classic       |   599.00 |          5 |
| Jewelry Junction    | Diamond Stud Earrings      |  9999.00 |          1 |
| Jewelry Junction    | Statement Ring Gold        |  3499.00 |          2 |
| Jewelry Junction    | Gold Plated Necklace       |  2499.00 |          3 |
| Jewelry Junction    | Pearl Drop Earrings        |  1999.00 |          4 |
| Jewelry Junction    | Silver Charm Bracelet      |  1499.00 |          5 |
| Kids Kingdom        | Kids Party Dress           |  1599.00 |          1 |
| Kids Kingdom        | Boys Denim Jacket          |  1299.00 |          2 |
| Kids Kingdom        | Kids Raincoat Set          |  1199.00 |          3 |
| Kids Kingdom        | Girls Tutu Skirt           |   899.00 |          4 |
| Kids Kingdom        | Boys Cargo Shorts          |   799.00 |          5 |
| Premium Fabrics Ltd | Premium Wool Suit          | 12999.00 |          1 |
| Premium Fabrics Ltd | Tweed Sports Jacket        |  8999.00 |          2 |
| Premium Fabrics Ltd | Cashmere Sweater           |  5999.00 |          3 |
| Premium Fabrics Ltd | Italian Silk Shirt         |  4999.00 |          4 |
| Premium Fabrics Ltd | Merino Wool Cardigan       |  4499.00 |          5 |
| Scarf Studio        | Cashmere Shawl             |  4999.00 |          1 |
| Scarf Studio        | Silk Scarf Printed         |  1999.00 |          2 |
| Scarf Studio        | Wool Blend Wrap            |  1499.00 |          3 |
| Scarf Studio        | Embroidered Dupatta        |  1299.00 |          4 |
| Scarf Studio        | Cotton Stole Set           |   899.00 |          5 |
| Sporty Styles       | Training Track Jacket      |  1799.00 |          1 |
| Sporty Styles       | Compression Leggings       |  1499.00 |          2 |
| Sporty Styles       | Performance Running Shorts |   999.00 |          3 |
| Sporty Styles       | Sports Bra Pro             |   899.00 |          4 |
| Sporty Styles       | Gym Tank Top               |   699.00 |          5 |
| Style Studio        | Linen Summer Blazer        |  4499.00 |          1 |
| Style Studio        | Designer Blazer            |  3999.00 |          2 |
| Style Studio        | Tailored Vest              |  2499.00 |          3 |
| Style Studio        | Pleated Dress Pants        |  2199.00 |          4 |
| Style Studio        | Chino Pants                |  1799.00 |          5 |
| Summer Breeze       | Sleeveless Maxi Dress      |  2199.00 |          1 |
| Summer Breeze       | Linen Palazzo Pants        |  1799.00 |          2 |
| Summer Breeze       | Linen Shirt Casual         |  1599.00 |          3 |
| Summer Breeze       | Cotton Shorts Relaxed      |   899.00 |          4 |
| Summer Breeze       | Cotton Crop Top            |   699.00 |          5 |
| Watch World         | Chronograph Sports Watch   |  5999.00 |          1 |
| Watch World         | Smart Fitness Watch        |  4999.00 |          2 |
| Watch World         | Vintage Style Watch        |  3499.00 |          3 |
| Watch World         | Analog Classic Watch       |  2999.00 |          4 |
| Watch World         | Minimalist Dial Watch      |  1999.00 |          5 |
| Winter Warmth       | Wool Overcoat              |  6999.00 |          1 |
| Winter Warmth       | Puffer Jacket              |  3999.00 |          2 |
| Winter Warmth       | Thermal Innerwear Set      |  1299.00 |          3 |
| Winter Warmth       | Woolen Muffler             |   799.00 |          4 |
| Winter Warmth       | Knit Beanie Cap            |   499.00 |          5 |
+---------------------+----------------------------+----------+------------+
100 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----------+------------------+---------------+----------------+-------------+--------------+-----------------+------------------+---------------------+---------------------+---------------------+---------------+
| order_id | customer_name    | customer_city | customer_state | order_total | order_status | tracking_status | delivery_partner | packaging_date      | shipped_date        | deliver_date        | delivery_days |
+----------+------------------+---------------+----------------+-------------+--------------+-----------------+------------------+---------------------+---------------------+---------------------+---------------+
|       20 | Ananya Das       | Kolkata       | West Bengal    |     7498.00 | PLACED       | PACKAGING       | Ecom Express     | 2024-07-18 08:00:00 | NULL                | NULL                |          NULL |
|       19 | Manish Tiwari    | Bangalore     | Karnataka      |     1499.00 | DELIVERED    | DELIVERED       | DTDC             | 2024-07-14 10:00:00 | 2024-07-15 09:30:00 | 2024-07-18 14:20:00 |             3 |
|       18 | Ritu Sharma      | Mumbai        | Maharashtra    |     3999.00 | DELIVERED    | DELIVERED       | FedEx            | 2024-07-11 14:00:00 | 2024-07-12 11:00:00 | 2024-07-15 09:45:00 |             3 |
|       17 | Deepak Choudhary | Lucknow       | Uttar Pradesh  |     2698.00 | CANCELLED    | CANCELLED       | Delhivery        | 2024-07-09 12:00:00 | NULL                | NULL                |          NULL |
|       16 | Swati Mishra     | Jaipur        | Rajasthan      |     1899.00 | DELIVERED    | DELIVERED       | BlueDart         | 2024-07-07 09:00:00 | 2024-07-08 08:30:00 | 2024-07-11 15:00:00 |             3 |
|       15 | Nikhil Saxena    | Bangalore     | Karnataka      |     5999.00 | DELIVERED    | DELIVERED       | Ecom Express     | 2024-07-04 15:00:00 | 2024-07-05 14:00:00 | 2024-07-08 11:30:00 |             3 |
|       14 | Pooja Agarwal    | Kolkata       | West Bengal    |     1598.00 | PLACED       | SHIPPED         | DTDC             | 2024-07-02 11:00:00 | 2024-07-03 09:00:00 | NULL                |          NULL |
|       13 | Sanjay Verma     | Lucknow       | Uttar Pradesh  |     4298.00 | DELIVERED    | DELIVERED       | FedEx            | 2024-06-30 14:00:00 | 2024-07-01 10:30:00 | 2024-07-04 16:00:00 |             3 |
|       12 | Divya Rao        | Hyderabad     | Telangana      |     2499.00 | DELIVERED    | DELIVERED       | Delhivery        | 2024-06-26 13:00:00 | 2024-06-27 08:00:00 | 2024-06-30 12:45:00 |             3 |
|       11 | Arjun Menon      | Chandigarh    | Chandigarh     |      999.00 | PLACED       | SHIPPED         | BlueDart         | 2024-06-24 10:00:00 | 2024-06-25 11:30:00 | NULL                |          NULL |
|       10 | Kavita Joshi     | Pune          | Maharashtra    |     3797.00 | DELIVERED    | DELIVERED       | Ecom Express     | 2024-06-21 16:00:00 | 2024-06-22 09:00:00 | 2024-06-25 14:00:00 |             3 |
|        9 | Rohan Desai      | Ahmedabad     | Gujarat        |     1799.00 | DELIVERED    | DELIVERED       | DTDC             | 2024-06-19 11:00:00 | 2024-06-20 12:00:00 | 2024-06-23 09:30:00 |             3 |
|        8 | Meera Iyer       | Chennai       | Tamil Nadu     |     2998.00 | PLACED       | SHIPPED         | FedEx            | 2024-06-17 15:00:00 | 2024-06-18 10:00:00 | NULL                |          NULL |
|        7 | Karthik Nair     | Kochi         | Kerala         |    12999.00 | DELIVERED    | DELIVERED       | Delhivery        | 2024-06-14 09:00:00 | 2024-06-15 08:30:00 | 2024-06-18 15:20:00 |             3 |
|        6 | Anjali Gupta     | Jaipur        | Rajasthan      |      899.00 | DELIVERED    | DELIVERED       | BlueDart         | 2024-06-11 13:00:00 | 2024-06-12 14:00:00 | 2024-06-14 10:00:00 |             2 |
|        5 | Vikram Singh     | New Delhi     | Delhi          |     5499.00 | PLACED       | SHIPPED         | Ecom Express     | 2024-06-09 10:00:00 | 2024-06-10 09:30:00 | NULL                |          NULL |
|        4 | Sneha Reddy      | Hyderabad     | Telangana      |     1299.00 | DELIVERED    | DELIVERED       | DTDC             | 2024-06-06 16:00:00 | 2024-06-07 11:00:00 | 2024-06-10 16:45:00 |             3 |
|        3 | Amit Kumar       | Bangalore     | Karnataka      |     3598.00 | PLACED       | SHIPPED         | FedEx            | 2024-06-04 11:00:00 | 2024-06-05 08:00:00 | NULL                |          NULL |
|        2 | Priya Patel      | Kolkata       | West Bengal    |     4999.00 | DELIVERED    | DELIVERED       | Delhivery        | 2024-06-01 14:00:00 | 2024-06-02 10:30:00 | 2024-06-05 11:00:00 |             3 |
|        1 | Rahul Sharma     | Mumbai        | Maharashtra    |     2398.00 | DELIVERED    | DELIVERED       | BlueDart         | 2024-05-31 09:00:00 | 2024-06-01 09:00:00 | 2024-06-03 14:30:00 |             2 |
+----------+------------------+---------------+----------------+-------------+--------------+-----------------+------------------+---------------------+---------------------+---------------------+---------------+
20 rows in set (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

+----+--------------+------------------------+-----------------+-----------------+---------------------+-------------------+
| id | name         | email                  | complaint_count | open_complaints | resolved_complaints | closed_complaints |
+----+--------------+------------------------+-----------------+-----------------+---------------------+-------------------+
|  1 | Rahul Sharma | rahul.sharma@email.com |               2 |               0 |                   2 |                 0 |
|  4 | Sneha Reddy  | sneha.reddy@email.com  |               2 |               0 |                   1 |                 1 |
|  5 | Vikram Singh | vikram.singh@email.com |               2 |               2 |                   0 |                 0 |
+----+--------------+------------------------+-----------------+-----------------+---------------------+-------------------+
3 rows in set (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 1 row affected (0.011 sec)

Query OK, 0 rows affected (0.000 sec)

+-----+-----------+------------------------+---------+----------+-----------+
| id  | vendor_id | name                   | price   | discount | total_qty |
+-----+-----------+------------------------+---------+----------+-----------+
| 102 |         1 | Limited Edition Jacket | 2999.00 |    20.00 |        50 |
+-----+-----------+------------------------+---------+----------+-----------+
1 row in set (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 1 row affected (0.001 sec)
Rows matched: 1  Changed: 1  Warnings: 0

Query OK, 0 rows affected (0.000 sec)

+-----+------------------------+---------+----------+
| id  | name                   | price   | discount |
+-----+------------------------+---------+----------+
| 102 | Limited Edition Jacket | 2499.00 |    35.00 |
+-----+------------------------+---------+----------+
1 row in set (0.000 sec)

Query OK, 0 rows affected (0.000 sec)

Query OK, 1 row affected (0.001 sec)

Query OK, 0 rows affected (0.000 sec)

+-----------+
| remaining |
+-----------+
|         0 |
+-----------+
1 row in set (0.000 sec)

