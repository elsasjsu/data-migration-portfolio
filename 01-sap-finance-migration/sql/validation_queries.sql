-- SAP Finance Data Migration - Validation Queries
-- Validate data quality after cleaning

-- 1. Check no duplicates in cleaned vendors
-- SELECT vendor_id, COUNT(*) as count
-- FROM vendors_cleaned
-- GROUP BY vendor_id
-- HAVING COUNT(*) > 1;

-- 2. Check all GL accounts mapped
-- SELECT gl_account, COUNT(*) as count
-- FROM invoices_cleaned
-- WHERE target_gl IS NULL
-- GROUP BY gl_account;

-- 3. Reconciliation: source vs target totals
-- SELECT SUM(amount) as total_amount_source FROM invoices_source;
-- SELECT SUM(amount) as total_amount_target FROM invoices_cleaned;