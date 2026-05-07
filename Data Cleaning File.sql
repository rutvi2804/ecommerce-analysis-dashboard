#Data Cleaning
#1. Missing values
#checking missing values in orders table
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(order_id IS NULL) AS missing_order_id,
  COUNTIF(customer_id IS NULL) AS missing_customer_id,
  COUNTIF(order_purchase_timestamp IS NULL) AS missing_purchase_ts,
  COUNTIF(order_status IS NULL) AS missing_status
FROM `my-project-1408-488221.olist_data.orders`;

#checking missing values in order items
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(order_id IS NULL) AS missing_order_id,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(price IS NULL OR price < 0) AS invalid_price,
  COUNTIF(freight_value IS NULL OR freight_value < 0) AS missing_freight
FROM `my-project-1408-488221.olist_data.order_items`;

#checking missing values in customers
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(customer_id IS NULL) AS missing_customer_id,  
  COUNTIF(customer_unique_id IS NULL) AS missing_customer_unique_id
FROM `my-project-1408-488221.olist_data.customers`;

#checking missing values in review
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(order_id IS NULL) AS missing_order_id, 
  COUNTIF(review_score IS NULL OR review_score < 0 OR review_score > 5) AS invalid_review_score
FROM `my-project-1408-488221.olist_data.order_reviews`;

#checking missing values in products -- missing product name 
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(product_id IS NULL) AS missing_product_id,
  COUNTIF(product_category_name IS NULL) AS missing_product_category
FROM `my-project-1408-488221.olist_data.products`;

#2. Check Duplicate
#For orders table
SELECT 
  order_id, 
  COUNT(*) AS duplicate_value
FROM `my-project-1408-488221.olist_data.orders`
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_value DESC;

#For customers
SELECT customer_id, COUNT(*) AS duplicate_value
FROM  `my-project-1408-488221.olist_data.customers`
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY duplicate_value DESC;

#For review - Has duplicates
SELECT review_id, COUNT(*) AS duplicate_value
FROM `my-project-1408-488221.olist_data.order_reviews`
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY duplicate_value DESC;

#3. Check invalid values
#Review score should be 1 to 5
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(review_score IS NULL OR review_score < 0 OR review_score > 5) AS invalid_review
FROM `my-project-1408-488221.olist_data.order_reviews`;

#4. checking date logic -- delivered date should not be before purchase date
SELECT 
  COUNT(*) AS invalid_date
FROM `my-project-1408-488221.olist_data.orders`
WHERE order_delivered_customer_date Is NOT NULL
      AND order_purchase_timestamp IS NOT NULL 
      AND order_delivered_customer_date < order_purchase_timestamp;



#Creating cleaned tables from original tables
#1. Clean orders table -- order status is euqal to delivered
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.cleaned_orders` AS
SELECT 
  *
FROM `my-project-1408-488221.olist_data.orders`
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp;

#2. Clean order items
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.cleaned_order_items` AS
SELECT 
  order_id,
  order_item_id,
  product_id,
  seller_id,
  price,
  freight_value,
  shipping_limit_date
FROM `my-project-1408-488221.olist_data.order_items`
WHERE order_id IS NOT NULL
  AND product_id IS NOT NULL
  AND product_id IS NOT NULL
  AND seller_id IS NOT NULL
  AND price IS NOT NULL
  AND price > 0
  AND freight_value IS NOT NULL
  AND freight_value > 0;

#3. Clean customers table
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.v_customers_clean` AS
SELECT
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
FROM `my-project-1408-488221.olist_data.customers`
WHERE customer_id IS NOT NULL
  AND customer_unique_id IS NOT NULL;

#4. Clean Products
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.v_products_clean` AS
SELECT
  product_id,
  COALESCE(product_category_name, 'unknown') AS product_category_name,
  product_name_lenght,
  product_description_lenght,
  product_photos_qty,
  product_weight_g,
  product_length_cm,
  product_height_cm,
  product_width_cm
FROM `my-project-1408-488221.olist_data.products`
WHERE product_id IS NOT NULL;

#5. Clean Reviews table
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.v_reviews_clean` AS
SELECT * EXCEPT(rn)
FROM (
   SELECT 
    review_id, 
    order_id, 
    review_score, 
    review_comment_title, 
    review_comment_message, 
    review_creation_date,
    review_answer_timestamp,
    ROW_NUMBER() OVER ( 
      PARTITION BY order_id 
      ORDER BY review_creation_date DESC, review_answer_timestamp DESC ) AS rn 
      FROM `my-project-1408-488221.olist_data.order_reviews` 
    WHERE order_id IS NOT NULL 
      AND review_score BETWEEN 1 AND 5 ) 
      WHERE rn = 1;

#Final Master table 
CREATE OR REPLACE VIEW `my-project-1408-488221.olist_data.master_table` AS
SELECT 
  o.order_id,
  o.order_status,
  o.order_purchase_timestamp,
  DATE(o.order_purchase_timestamp) AS order_purchase_date,
  FORMAT_TIMESTAMP('%Y-%m', o.order_purchase_timestamp) AS order_purchase_year_month,
  o.order_delivered_customer_date,
  o.estimate_delivery_date,

  c.customer_id,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state,

  oi.order_itme_id,
  oi.product_id,
  oi.seller_id,
  oi.prie,
  oi.freight_value,
  (oi.price + oi.freight_value) AS otem_total_value,

  p.product_category_name,

  r.review_id,
  r.review_score,
  r.review_comment_message,

  TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) AS days_late,

  FROM `my-project-1408-488221.olist_data.cleaned_orders` AS o
  JOIN `my-project-1408-488221.olist_data.cleaned_order_items` AS oi
    ON o.order_id = oi.order_id
  JOIN `my-project-1408-488221.olist_data.v_customers_clean` AS c
    ON o.customer_id = c.customer_id
  LEFT JOIN `your_dataset.v_products_clean` p
  ON oi.product_id = p.product_id
  LEFT JOIN `your_dataset.v_reviews_clean` r
  ON o.order_id = r.order_id;
