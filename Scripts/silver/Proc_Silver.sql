/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

create or alter procedure silver.load_silver as 
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	BEGIN TRY
	set @batch_start_time = getdate();
	print '************************'
	print '>> Loading Silver Layer ';
	print '************************'

	print '======================='
	print '>> Loading CRM table '
	print '======================='

	set @start_time = getdate()
	print '>> Truncating table Silver.crm_cust_info'

	-- Truncating table Silver.crm_cust_info
	Truncate table silver.crm_cust_info

	print '>>Inserting into silver.crm_cust_info'
	
	-- Inserting into silver.crm_cust_info
	insert into silver.crm_cust_info
	(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)

	 select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case 
		when upper(trim(cst_marital_status)) = 'M' then 'Married' 
		when upper(trim(cst_marital_status)) = 'S' then 'Single'
		else 'UnKnown' 
		end cst_marital_status ,
		case 
		when upper(trim(cst_gndr)) = 'M' then 'Male' 
		when upper(trim(cst_gndr)) = 'F' then 'Female'
		else 'UnKnown' 
		end cst_gndr,
		cst_create_date
	 from (
			select 
			*,
			row_number() over(partition by cst_id order by cst_create_date desc) flag_last
			from bronze.crm_cust_info
			where cst_id is not null
		)t
		where flag_last = 1

		set @end_time = getdate()
		print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

	-----------------------------------------------------------------------------------

	set @start_time = getdate()

	-- Truncate table 'silver.crm_prd_info'
	truncate table silver.crm_prd_info
	-- inserting values in table 'silver.crm_prd_info'
	insert into silver.crm_prd_info
			(	
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)

	select
		prd_id,
		replace(substring(prd_key,1,5),'-','_') as cat_id,
		substring(prd_key,7,len(prd_key)) prd_key,
		prd_nm,
		isnull(prd_cost,0) prd_cost,
		case upper(trim(prd_line))
			when 'M' then 'Mountain'
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'T' then 'Touring'
			else 'Unknown'
		end prd_line,
		cast(prd_start_dt as date) prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 as date) prd_end_dt
	from bronze.crm_prd_info

	
	set @end_time = getdate()
	print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'
	------------------------------------------------------------------------------------------

	set @start_time = getdate()

	-- truncating table 'silver.crm_sales_info
	truncate table Silver.crm_sales_info

	-- inserting values in 'silver.crm_sales_info'
	insert into Silver.crm_sales_info(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)

	select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
			else cast(cast(sls_order_dt as varchar(8)) as date)
		end sls_order_dt ,
		case 
			when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
			else cast(cast(sls_ship_dt as varchar(8)) as date)
		end sls_ship_dt,
		case 
			when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
			else cast(cast(sls_due_dt as varchar(8)) as date)
		end sls_due_dt,
		case 
			when sls_sales is null or sls_sales < 0 or sls_sales != sls_quantity * abs(sls_price)
			then sls_quantity * abs(sls_price)
			else sls_sales
		end sls_sales,
		sls_quantity,
		case 
			when sls_price is null or sls_price < 0 
			then abs(sls_sales) / nullif(sls_quantity,0)
			else sls_price
		end sls_price
	from Bronze.crm_sales_info

	
	set @end_time = getdate()
	print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

	-------------------------------------------------------------------------------

		print '======================='
		print '>> Loading ERP
		table '
		print '======================='

		set @start_time = getdate()

	-- Truncating table 'silver.erp_cust_az12'
	Truncate table silver.erp_cust_az12
	-- inserting values in 'silver.erp_cust_az12'
	insert into silver.erp_cust_az12(
		cid,
		bdate,
		gen
		)
	select
		case 
			when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid
		end CID,
		case 
			when bdate > getdate() then null 
			else BDate
		end BDate,
		case 
			when upper(trim(gen)) in ('M','MALE') then 'Male'
			when upper(trim(gen)) in ('F','FEMALE') then 'Female'
			else 'Unknown'
		end gen 
	from bronze.erp_cust_az12

	
	set @end_time = getdate()
	print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

	 ------------------------------------------------------------------------------

	 set @start_time = getdate()

	 -- Truncating table 'silver.erp_loc_a101'
	Truncate table silver.erp_loc_a101

	-- inserting values in 'silver.erp_loc_a101'
	insert into silver.erp_loc_a101(
		cid,
		cntry
		)

	select
		replace(CID,'-','') CID,
		case
			when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) in ('US','USA') then 'United States'
			when CNTRY is null or
			trim(CNTRY) = '' then 'Unknown'
			else trim(CNTRY)
		end CNTRY
	from bronze.erp_loc_a101

	
	set @end_time = getdate()
	print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

	---------------------------------------------------------------------

	set @start_time = getdate()

	-- Truncating table 'silver.erp_px_cat_g1v2'
	Truncate table silver.erp_px_cat_g1v2

	-- inserting values in 'silver.erp_px_cat_g1v2'
	insert into silver.erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenance
		)

	select 
		id,
		cat,
		subcat,
		maintenance
	from bronze.erp_px_cat_g1v2

	
	set @end_time = getdate()
	print '>> load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

	print ' --------- Batch End ---------'

	set @batch_end_time = getdate()
	print '>> Total load duration' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + ' seconds'

	end try

	begin catch
	print '=================================='
	print ' Error occured during silver layer';
	print ' Error Message :' + Error_message();
	print ' Error Number :' + cast(Error_number() as nvarchar);
	print ' Error State :' + cast( Error_state() as nvarchar);
	print '=================================='
	end catch

end

-- Execute Stored Procedure
EXEC silver.load_silver