## **Data Warehouse and Analytics Project 🚀**

Welcome to the **Data Warehouse and Analytics Project r**epository!

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

### 🏗️ **Data Architecture**



The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

### 📖 **Project Overview**



🎯 This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.



This repository is an excellent resource for professionals and students looking to showcase expertise in:

- SQL Development
- Data Architect
- Data Engineering
- ETL Pipeline Developer
- Data Modeling
- Data Analytics

### 🚀 **Project Requirements**



#### **Building the Data Warehouse (Data Engineering)**

#### **Objective**

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### **Specifications**

- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Clean and resolve data quality issues before analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization is not required.
- **Documentation**: Provide clear documentation of the data model to support business stakeholders and analytics teams.

#### **BI: Analytics & Reporting (Data Analysis)**

#### **Objective**

Develop SQL-based analytics to deliver detailed insights into:

**Customer Behavior**

**Product Performance**

**Sales Trends**

These insights provide stakeholders with key business metrics to support strategic decision-making.


## 📂 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                       # Raw ERP and CRM datasets
│
├── docs/                           # Project documentation
│   ├── etl.drawio                 # ETL methods and techniques
│   ├── data_architecture.drawio   # Project architecture
│   ├── data_catalog.md            # Dataset and field descriptions
│   ├── data_flow.drawio           # Data flow diagram
│   ├── data_models.drawio         # Star schema data model
│   └── naming-conventions.md      # Naming standards
│
├── scripts/                        # SQL scripts for ETL and transformations
│   ├── bronze/                     # Raw data ingestion
│   ├── silver/                     # Data cleaning and transformation
│   └── gold/                       # Analytical models
│
├── tests/                          # Data quality and validation scripts

└── README.md                       # Project overview
```
### 🌟 **About Me**

Hi! I’m **Yash**, an aspiring **Data Engineer and AI & Data Science enthusiast**. I’m passionate about working with data, building data pipelines and warehouses, and turning raw data into meaningful insights. I enjoy learning, building real-world projects, and sharing my journey in the world of data and technology. 🚀📊
