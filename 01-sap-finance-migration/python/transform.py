import pandas as pd

# Load source data
print("Loading source data...")
vendors = pd.read_csv('../data/vendors_source.csv')
invoices = pd.read_csv('../data/invoices_source.csv')
gl_mapping = pd.read_csv('../data/gl_mapping.csv')

print(f"Vendors: {len(vendors)} records")
print(f"Invoices: {len(invoices)} records")

# 1. Clean vendors - remove duplicates
print("Removing duplicate vendors...")
vendors_clean = vendors.drop_duplicates(subset=['vendor_id'], keep='first')
print(f"Vendors after dedup: {len(vendors_clean)} records")

# 2. Standardize country codes
print("Standardizing country codes...")
country_map = {'USA': 'US', 'UK': 'GB', 'GER': 'DE'}
vendors_clean['country'] = vendors_clean['country'].map(country_map).fillna(vendors_clean['country'])

# 3. Standardize invoice dates
print("Standardizing invoice dates...")
def standardize_date(date_str):
    if '/' in date_str:  # 2024/02/20
        parts = date_str.split('/')
        return f"{parts[1]}-{parts[2]}-{parts[0]}"
    elif date_str[0].isdigit() and date_str[1] == '-':  # 01-25-2024
        parts = date_str.split('-')
        return f"{parts[2]}-{parts[0]}-{parts[1]}"
    else:  # 2024-01-15
        return date_str

invoices['invoice_date'] = invoices['invoice_date'].apply(standardize_date)

# 4. Map GL accounts
print("Mapping GL accounts...")
invoices['target_gl'] = invoices['gl_account'].map(
    gl_mapping.set_index('legacy_gl')['target_gl']
)

# 5. Save cleaned data
print("Saving cleaned data...")
vendors_clean.to_csv('../data/vendors_cleaned.csv', index=False)
invoices.to_csv('../data/invoices_cleaned.csv', index=False)

print("\nData cleaned and saved!")
print(f"Vendors: {len(vendors_clean)} records")
print(f"Invoices: {len(invoices)} records")