/*
=================================================================================
Stored Procedures: Load Silver Layer (Bronze -> Silver)
=================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process 
    to populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncate Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameter:
    None.
        This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        -- Loading silver.crm_customers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_customers';
        TRUNCATE TABLE silver.crm_customers;
        PRINT '>> Inserting Data Into: silver.crm_customers';
        INSERT INTO silver.crm_customers (
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
        )
        SELECT 
            customer_id,
            TRIM(first_name) AS first_name,
            TRIM(last_name) AS last_name,
            birthdate,
            DATEDIFF(YEAR, birthdate, GETDATE()) AS age,
            CASE WHEN DATEDIFF(YEAR, birthdate, GETDATE()) < 18 THEN 'below 18'
                 WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 18 AND 25 THEN '18 - 25'
                 WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 26 AND 35 THEN '26 - 35'
                 WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 36 AND 45 THEN '36 - 45'
				 WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 46 AND 55 THEN '46 - 55'
                 ELSE 'above 55'
            END AS age_group,
            gender,
            marital_status,
            id_creation_date,
            DATEDIFF(YEAR, id_creation_date, GETDATE()) AS customer_tenure,
            email,
            phone_number,
            loyalty_points
        FROM bronze.crm_customers;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.crm_sales_person
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_sales_person';
        TRUNCATE TABLE silver.crm_sales_person;
        PRINT '>> Inserting Data Into: silver.crm_sales_person';
        INSERT INTO silver.crm_sales_person(
            salesperson_id,
            first_name,
            last_name,
            gender,
            date_joined,
            duration,
            email_id,
            outlet_id
        )
        SELECT
            salesperson_id,
            first_name,
            last_name,
            gender,
            date_joined,
            DATEDIFF(YEAR, date_joined, GETDATE()) AS duration,
            email_id,
            outlet_id
        FROM bronze.crm_sales_person;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        -- Loading silver.erp_products
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_products';
        TRUNCATE TABLE silver.erp_products;
        PRINT '>> Inserting Data Into: silver.erp_products';
        INSERT INTO silver.erp_products(
            product_id,
            product_name,
            category,
            sub_category,
            price,
            cost
        )
        SELECT 
            product_id,
            product_name,
            category,
            sub_category,
            price,
            cost
        FROM bronze.erp_products;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.erp_outlets
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_outlets';
        TRUNCATE TABLE silver.erp_outlets;
        PRINT '>> Inserting Data Into: silver.erp_outlets';
        INSERT INTO silver.erp_outlets(
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
        )
        SELECT 
            outlet_id,
            outlet_name,
            district,
            division,
            store_type,
            CASE WHEN channel = 'Online' THEN 'Both'
                 WHEN channel = 'Offline' THEN 'Offline'
                 ELSE 'Both'
            END AS sales_channel,
            manager_name,
            opening_date,
            DATEDIFF(YEAR, opening_date, GETDATE()) AS years_of_operation,
            employee_count AS no_of_employee
        FROM bronze.erp_outlets;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.erp_sales_data
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_sales_data';
        TRUNCATE TABLE silver.erp_sales_data;
        PRINT '>> Inserting Data Into: silver.erp_sales_data';
        INSERT INTO silver.erp_sales_data(
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
        )
        SELECT
            sale_id,
            sale_date,
            customer_id,
            outlet_id,
            product_id,
            quantity,
            unit_price,
            discount_amount,
            (quantity * unit_price) - discount_amount AS revenue,
            payment_method,
            sale_channel AS sales_channel,
            return_flag,
            salesperson_id
        FROM bronze.erp_sales_data;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT '- Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
