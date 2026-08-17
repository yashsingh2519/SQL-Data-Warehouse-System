/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

if object_id ('bronze.crm_cust_info','u') is not null
	drop table bronze.crm_cust_info;

create table bronze.crm_cust_info (
	cst_id int ,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),	
	cst_gndr nvarchar(20),
	cst_create_date date
);
go

-- =========================================================
-- CRM: Product Information
-- Stores raw product details and product validity dates.
-- =========================================================

if object_id ('bronze.crm_prd_info','u') is not null
	drop table bronze.crm_prd_info;

create table bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line char(1),
	prd_start_dt datetime,
	prd_end_dt datetime
);
go


-- =========================================================
-- CRM: Sales Information
-- Stores raw sales order and transaction information.
-- =========================================================

if object_id ('bronze.crm_sales_info','u') is not null
	drop table bronze.crm_sales_info;

create table bronze.crm_sales_info(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
go


-- =========================================================
-- ERP: Customer Information
-- Stores raw customer demographic information from ERP.
-- =========================================================

if object_id ('bronze.erp_cust_az12','u') is not null
	drop table bronze.erp_cust_az12;

create table bronze.erp_cust_az12 (
	CID nvarchar(50),
	BDate date,
	Gen nvarchar(10)
);
go

-- =========================================================
-- ERP: Customer Location
-- Stores raw customer country/location information.
-- =========================================================

if object_id ('bronze.erp_loc_a101','u') is not null
	drop table bronze.erp_loc_a101;

create table bronze.erp_loc_a101 (
	CID nvarchar(50),
	CNTRY nvarchar(50)
);
go

-- =========================================================
-- ERP: Product Category
-- Stores raw product category, subcategory,
-- and maintenance information.
-- =========================================================
if object_id ('bronze.erp_Px_Cat_g1v2','u') is not null
	drop table bronze.erp_Px_Cat_g1v2;

create table bronze.erp_Px_Cat_g1v2 (
	ID nvarchar(50),
	CAT nvarchar(50),
	SubCat nvarchar(50),
	Maintenance nvarchar(50)
);
go