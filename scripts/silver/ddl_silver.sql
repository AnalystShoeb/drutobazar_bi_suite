/*
===============================================================================
Create Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the structure of Tables
===============================================================================
*/

IF OBJECT_ID('silver.crm_customers', 'U') IS NOT NULL
	DROP TABLE silver.crm_customers;
GO

CREATE TABLE silver.crm_customers (
	customer_id			NVARCHAR(50),
	first_name			NVARCHAR(50),
	last_name			NVARCHAR(50),
	birthdate			DATE,
	age					INT,
	age_group			NVARCHAR(50),
	gender				NVARCHAR(50),
	marital_status		NVARCHAR(50),
	id_creation_date	DATE,
	customer_tenure		INT,
	email				NVARCHAR(50),
	phone_number		NVARCHAR(25),
	loyalty_points		INT,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_person', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_person;
GO

CREATE TABLE silver.crm_sales_person(
	salesperson_id	NVARCHAR(50),
	first_name		NVARCHAR(50),
	last_name		NVARCHAR(50),
	gender			NVARCHAR(50),
	date_joined		DATE,
	duration		INT,
	email_id		NVARCHAR(50),
	outlet_id		NVARCHAR(50),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_products', 'U') IS NOT NULL
	DROP TABLE silver.erp_products;
GO

CREATE TABLE silver.erp_products (
	product_id		NVARCHAR(50),
	product_name	NVARCHAR(50),
	category		NVARCHAR(50),
	sub_category	NVARCHAR(50),
	price			DECIMAL(10,2),
	cost			DECIMAL(10,2),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_outlets', 'U') IS NOT NULL
	DROP TABLE silver.erp_outlets;
GO

CREATE TABLE silver.erp_outlets(
	outlet_id		NVARCHAR(50),
	outlet_name		NVARCHAR(50),
	district		NVARCHAR(50),
	division		NVARCHAR(50),
	store_type		NVARCHAR(50),
	sales_channel	NVARCHAR(50),
	manager_name	NVARCHAR(50),
	opening_date	DATE,
	years_of_operation INT,
	no_of_employee	INT,
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_sales_data', 'U') IS NOT NULL
	DROP TABLE silver.erp_sales_data;
GO

CREATE TABLE silver.erp_sales_data(
	sale_id			NVARCHAR(50),
	sale_date		DATE,
	customer_id		NVARCHAR(50),
	outlet_id		NVARCHAR(50),
	product_id		NVARCHAR(50),
	quantity		INT,
	unit_price		DECIMAL(10,2),
	discount_amount DECIMAL(10,2),
	revenue			DECIMAL(10,2),
	payment_method	NVARCHAR(50),
	sales_channel	NVARCHAR(50),
	return_flag		NVARCHAR(50),
	salesperson_id	NVARCHAR(50),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);
GO
