/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the gold layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	customer_id,
	first_name,
	last_name,
	birthdate,
	age,
	age_group,
	gender,
	marital_status,
	id_creation_date,
	customer_tenure,
	email,
	phone_number,
	loyalty_points
FROM silver.crm_customers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_sales_person
-- =============================================================================
IF OBJECT_ID('gold.dim_sales_person', 'V') IS NOT NULL
	DROP VIEW gold.dim_sales_person;
GO

CREATE VIEW gold.dim_sales_person AS
SELECT
    salesperson_id,
    first_name,
    last_name,
    gender,
    date_joined,
    duration,
    email_id,
    outlet_id
FROM silver.crm_sales_person;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	product_id,
	product_name,
	category,
	sub_category,
	price,
	cost
FROM silver.erp_products;
GO

-- =============================================================================
-- Create Dimension: gold.dim_outlets
-- =============================================================================
IF OBJECT_ID('gold.dim_outlets', 'V') IS NOT NULL
	DROP VIEW gold.dim_outlets;
GO

CREATE VIEW gold.dim_outlets AS
SELECT
	outlet_id,
	outlet_name,
	district,
	division,
	store_type,
	sales_channel,
	manager_name,
	opening_date,
	years_of_operation,
	no_of_employee
FROM silver.erp_outlets;
GO

-- =============================================================================
-- Create Dimension: gold.fact_sales_data
-- =============================================================================
IF OBJECT_ID('gold.fact_sales_data', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales_data;
GO

CREATE VIEW gold.fact_sales_data AS
SELECT
	sale_id,
	sale_date,
	customer_id,
	outlet_id,
	product_id,
	quantity,
	unit_price,
	discount_amount,
	revenue,
	payment_method,
	sales_channel,
	return_flag,
	salesperson_id
FROM silver.erp_sales_data
WHERE sale_date BETWEEN '2022-01-01' AND CAST(GETDATE() AS DATE);
GO
