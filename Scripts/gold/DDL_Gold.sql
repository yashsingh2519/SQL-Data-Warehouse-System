/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
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

create view gold.dim_customers as 
	select 
		ROW_NUMBER() over(order by cst_id) as customer_key,
		ci.cst_id as customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname first_name,
		ci.cst_lastname as last_name,
			la.cntry as country,
		ci.cst_marital_status as marital_status,
		case
			when ci.cst_gndr != 'Unknown' then ci.cst_gndr
			else coalesce(ca.gen,'Unknown')
		end gender,
			ca.bdate as birth_date,
		ci.cst_create_date as create_date
	from silver.crm_cust_info ci
	left join silver.erp_cust_az12 ca
	on ci.cst_key = ca.cid
	left join silver.erp_loc_a101 la
	on ci.cst_key = la.cid

go
-----------------------------------------------------------
-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

create view gold.dim_products as 
	select 
		ROW_NUMBER() over(order by prd_start_dt,prd_key) as product_key,
		p.prd_id as product_id,
		p.prd_key as product_number,
		p.prd_nm as product_name,
		p.cat_id as category_id,
		pc.cat as category,
		pc.subcat as subcategory,
		pc.maintenance ,
		p.prd_cost as product_cost,
		p.prd_line as product_line,
		p.prd_start_dt as start_date
	from silver.crm_prd_info p
	left join silver.erp_px_cat_g1v2 pc
	on p.cat_id = pc.id
	where p.prd_end_dt is null

go
------------------------------------------------------------------------

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

create view gold.fact_sales as 
	select 
		si.sls_ord_num as order_number,
		dp.product_key,
		dc.customer_key,
		si.sls_order_dt as order_date,
		si.sls_ship_dt as shipping_date,
		si.sls_due_dt as due_date,
		si.sls_sales as sales_amount,
		si.sls_quantity as quantity,
		si.sls_price as price
	from silver.crm_sales_info si
	left join gold.dim_products dp
	on si.sls_prd_key = dp.product_number
	left join gold.dim_customers dc
	on si.sls_cust_id = dc.customer_id

