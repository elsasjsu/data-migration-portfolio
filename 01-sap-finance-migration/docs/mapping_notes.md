# Data Mapping Notes

## Country Code Mapping
| Legacy | Target | Description |
|--------|--------|-------------|
| USA    | US     | United States |
| UK     | GB     | United Kingdom |
| GER    | DE     | Germany |

## GL Account Mapping
| Legacy GL | Target GL | Description |
|-----------|-----------|-------------|
| 600100    | 610000    | Purchase Expenses |
| 600200    | 620000    | Professional Services |
| 600300    | 630000    | Office Supplies |

## Date Format Standardization
- **Input formats**: `2024/02/20`, `01-25-2024`, `2024-01-15`
- **Output format**: ISO format `YYYY-MM-DD`

## Data Quality Issues Found
1. Duplicate vendor 1001 (removed)
2. Missing vendor name for vendor 1003
3. Inconsistent date formats in invoices
4. Country codes need standardization