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

create or alter procedure Bronze.load_bronze as 
begin

declare @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY

        SET @batch_start_time = GETDATE();
       
		PRINT '------------------------------------------------';
		PRINT 'Loading Bronze Layer';
		PRINT '------------------------------------------------';
		
       
		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		

        PRINT '>> Truncating Table: bronze.crm_cust_info';
        truncate table bronze.crm_cust_info;
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        bulk insert bronze.crm_cust_info
        from 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_crm\cust_info.csv'
        with ( 
            firstrow = 2,
            fieldterminator = ',',
            tablock 
        );

        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        bulk insert bronze.crm_prd_info
        from 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_crm\prd_info.csv'
        with ( 
            firstrow = 2,
            fieldterminator = ',',
            tablock 
        );
        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_info';
        truncate table bronze.crm_sales_info;
        PRINT '>> Inserting Data Into: bronze.crm_sales_info';
        bulk insert bronze.crm_sales_info
        from 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_crm\sales_details.csv'
        with ( 
            firstrow = 2,
            fieldterminator = ',',
            tablock 
        );
        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

--------------------------------------------------------------------------------------------------------------------------------------------------

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_erp\cust_az12.csv'
        WITH (
		        FIRSTROW = 2,
		        FIELDTERMINATOR = ',',
		        TABLOCK
	        );
        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_LOC_A101;
        PRINT '>> Inserting Data Into: bronze.erp_LOC_A101';
        BULK INSERT bronze.erp_LOC_A101
        FROM 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_erp\LOC_A101.csv'
        WITH (
		        FIRSTROW = 2,
		        FIELDTERMINATOR = ',',
		        TABLOCK
	        );
        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
        PRINT '>> Inserting Data Into: bronze.erp_PX_CAT_G1V2';
        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'D:\# Workspace\Projects\DataWareHouse\Datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
		        FIRSTROW = 2,
		        FIELDTERMINATOR = ',',
		        TABLOCK
	        );
        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY

    BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH

end

-- Execute the stored procedure

Exec Bronze.load_bronze