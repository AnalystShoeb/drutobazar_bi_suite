/*
===============================================================================
Create Tables
===============================================================================
Script Purpose:
    This script creates tables in the dropping existing tables 
    if they already exist.
	Run this script to re-define the structure of Tables
===============================================================================
*/

IF OBJECT_ID('bronze.crm_customers', 'U') IS NOT NULL
	DROP TABLE bronze.crm_customers;
GO

CREATE TABLE bronze.crm_customers (
	customer_id			NVARCHAR(50),
	first_name			NVARCHAR(50),
	last_name			NVARCHAR(50),
	birthdate			DATE,
	gender				NVARCHAR(50),
	marital_status		NVARCHAR(50),
	id_creation_date	DATE,
	email				NVARCHAR(50),
	phone_number		NVARCHAR(25),
	loyalty_points		INT
);
GO

IF OBJECT_ID('bronze.crm_sales_person', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_person;
GO

CREATE TABLE bronze.crm_sales_person(
	salesperson_id	NVARCHAR(50),
	first_name		NVARCHAR(50),
	last_name		NVARCHAR(50),
	gender			NVARCHAR(50),
	date_joined		DATE,
	email_id		NVARCHAR(50),
	outlet_id		NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_products', 'U') IS NOT NULL
	DROP TABLE bronze.erp_products;
GO

CREATE TABLE bronze.erp_products (
	product_id		NVARCHAR(50),
	product_name	NVARCHAR(50),
	category		NVARCHAR(50),
	sub_category	NVARCHAR(50),
	price			DECIMAL(10,2),
	cost			DECIMAL(10,2)
);
GO

IF OBJECT_ID('bronze.erp_outlets', 'U') IS NOT NULL
	DROP TABLE bronze.erp_outlets;
GO

CREATE TABLE bronze.erp_outlets(
	outlet_id	NVARCHAR(50),
	outlet_name	NVARCHAR(50),
	district	NVARCHAR(50),
	division	NVARCHAR(50),
	store_type	NVARCHAR(50),
	channel		NVARCHAR(50),
	manager_name NVARCHAR(50),
	opening_date DATE,
	employee_count INT
);
GO

IF OBJECT_ID('bronze.erp_sales_data', 'U') IS NOT NULL
	DROP TABLE bronze.erp_sales_data;
GO

CREATE TABLE bronze.erp_sales_data(
	sale_id		NVARCHAR(50),
	sale_date	DATE,
	customer_id	NVARCHAR(50),
	outlet_id	NVARCHAR(50),
	product_id	NVARCHAR(50),
	quantity	INT,
	unit_price	DECIMAL(10,2),
	payment_method NVARCHAR(50),
	discount_amount DECIMAL(10,2),
	sale_channel NVARCHAR(50),
	return_flag NVARCHAR(50),
	salesperson_id NVARCHAR(50)
);
GO
