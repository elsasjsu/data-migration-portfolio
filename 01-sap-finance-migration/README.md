# SAP Finance Data Migration Simulation

## Problem Statement
Simulate migrating SAP Finance data from a legacy system to a target system, including:
- Data cleansing (remove duplicates, fix formatting)
- Data mapping (legacy codes → target codes)
- Data transformation (standardize dates, currencies)
- Validation & reconciliation (ensure totals match)

## Data Source
- **Source**: Legacy vendor/invoice/GL data (CSV files)
- **Target**: Cleaned finance tables ready for SAP load

## Tools Used
- SQL Server (data cleaning, validation queries)
- Python (pandas for transformation)
- Excel (data mapping reference)

## What I Will Build
1. Source data samples (vendors, invoices, GL accounts)
2. SQL scripts for data cleansing
3. Python transformation notebook
4. Data quality validation checks
5. Reconciliation report (source vs target totals)

## Project Status
- [ ] Create sample data
- [ ] Write SQL cleanup scripts
- [ ] Build Python transformation
- [ ] Add validation queries
- [ ] Create documentation