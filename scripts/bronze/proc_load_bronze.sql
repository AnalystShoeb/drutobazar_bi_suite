/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================================'
		PRINT 'Loading Bronze Layer'
		PRINT '================================================================'

				PRINT '================================================================'
		PRINT 'Loading CRM Table'
		PRINT '================================================================'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_customers';
		TRUNCATE TABLE bronze.crm_customers;
		PRINT '>> Inserting Data Into: bronze.crm_customers';
		BULK INSERT bronze.crm_customers
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\crm_customers.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_person';
		TRUNCATE TABLE bronze.crm_sales_person;
		PRINT '>> Inserting Data Into: bronze.crm_sales_person';
		BULK INSERT bronze.crm_sales_person
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\crm_sales_person.csv'
		WITH (
				FIRSTROW = 2, 
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'


		PRINT '================================================================'
		PRINT 'Loading ERP Table'
		PRINT '================================================================'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_products';
		TRUNCATE TABLE bronze.erp_products;
		PRINT '>> Inserting Data Into: bronze.erp_products';
		BULK INSERT bronze.erp_products
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_products.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_outlets';
		TRUNCATE TABLE bronze.erp_outlets;
		PRINT '>> Inserting Data Into: bronze.erp_outlets';
		BULK INSERT bronze.erp_outlets
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_outlets.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_sales_data';
		TRUNCATE TABLE bronze.erp_sales_data;
		-- Load the first CSV file 'erp_sales_data_1.csv'
		PRINT '>> Inserting Data Into: bronze.erp_sales_data';
		BULK INSERT bronze.erp_sales_data
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_sales_data_1.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		-- Insert the remaining files
		SET @end_time = GETDATE();
		BULK INSERT bronze.erp_sales_data
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_sales_data_2.csv'
		WITH (
				FIRSTROW = 1,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @end_time = GETDATE();
		BULK INSERT bronze.erp_sales_data
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_sales_data_3.csv'
		WITH (
				FIRSTROW = 1,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		SET @end_time = GETDATE();
		BULK INSERT bronze.erp_sales_data
		FROM 'D:\Project\drutobarzar_data_analytics\01. data\erp_sales_data_4.csv'
		WITH (
				FIRSTROW = 1,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Dutation: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------';

		SET @batch_end_time = GETDATE();
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '  - Total Load Dutation: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>=======================';

	END TRY
	BEGIN CATCH
		PRINT '================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================='
	END CATCH
END
