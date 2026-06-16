-- SAP Finance Data Migration - Cleanup Queries
-- This script cleans and standardizes vendor and invoice data

-- 1. Remove duplicate vendors (keep first occurrence)
WITH deduplicated AS (
    SELECT vendor_id, vendor_name, address, country, currency, status,
           ROW_NUMBER() OVER (PARTITION BY vendor_id ORDER BY vendor_id) AS rn
    FROM vendors_source
)
SELECT vendor_id, vendor_name, address, country, currency, status
FROM deduplicated
WHERE rn = 1;

-- 2. Standardize country codes
SELECT 
    vendor_id,
    vendor_name,
    address,
    CASE 
        WHEN country = 'USA' THEN 'US'
        WHEN country = 'UK' THEN 'GB'
        WHEN country = 'GER' THEN 'DE'
        ELSE country
    END AS country_standardized,
    currency,
    status
FROM vendors_source;

-- 3. Standardize invoice date formats
SELECT 
    invoice_id,
    vendor_id,
    invoice_date,
    amount,
    currency,
    gl_account
FROM invoices_source;

-- 4. GL Account mapping
SELECT 
    invoice_id,
    vendor_id,
    invoice_date,
    amount,
    currency,
    gl_account,
    target_gl,
    gl_description
FROM invoices_source
LEFT JOIN gl_mapping ON invoices_source.gl_account = gl_mapping.legacy_gl;