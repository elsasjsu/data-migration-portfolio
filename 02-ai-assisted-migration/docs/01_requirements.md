# Migration Requirements Document

**Project:** AI-Assisted Data Migration – Customer, Vendor & Open Items (ECC → S/4HANA)
**Client:** Cascade Industrial Corp. *(fictional)*
**Document version:** 0.1 (Draft)
**Author:** Elsa Rose
**Date:** 25 Nov 2026
**Status:** Draft – for review

> **Disclaimer:** Cascade Industrial Corp. is a fictional client. All data in this
> project is synthetic. Table and field names follow standard, publicly documented
> SAP structures. Nothing here reproduces any client's data or any vendor's
> proprietary methodology or software.

---

## 1. Purpose

This document defines the business and technical requirements for migrating
customer master data, vendor master data and open accounts receivable / accounts
payable items from the client's legacy SAP ECC 6.0 system to SAP S/4HANA.

It is the input to:

- `02_functional_spec.md` – detailed, numbered data-quality and transformation rules
- `03_target_design.md` – target structures and field-level mapping
- The test, reconciliation and readiness reports produced by the migration tool

## 2. Background

Cascade Industrial Corp. is a mid-size manufacturer of industrial pumps and
valves. It operates in three countries and is moving from SAP ECC 6.0 to
SAP S/4HANA as part of a finance and supply chain transformation.

| Company code | Country | Currency | Legal entity |
|---|---|---|---|
| 1000 | United States (also serves Canadian customers) | USD | Cascade Industrial Inc. |
| 2000 | Germany | EUR | Cascade Industrial GmbH |
| 3000 | India | INR | Cascade Industrial Pvt. Ltd. |

Key business drivers:

- S/4HANA requires customers and vendors to be **Business Partners** (Customer–Vendor
  Integration). The legacy data has never been cleaned for this.
- The finance team reports **duplicate vendors**, inconsistent country codes and
  missing payment terms, which cause payment errors today.
- Finance must be able to prove at go-live that **open AR/AP balances in S/4HANA
  match ECC to the cent**.

## 3. Scope

### 3.1 In scope

| ID | Migration object | Source (ECC) | Target (S/4HANA) |
|---|---|---|---|
| OBJ-01 | Customer master → Business Partner | KNA1, KNB1, ADR6 | Business Partner (roles FLCU00 / FLCU01), customer company code data |
| OBJ-02 | Vendor master → Business Partner | LFA1, LFB1, ADR6 | Business Partner (roles FLVN00 / FLVN01), supplier company code data |
| OBJ-03 | Open AR items | BSID | FI – Accounts receivable open items |
| OBJ-04 | Open AP items | BSIK | FI – Accounts payable open items |

### 3.2 Out of scope (this release)

- Sales area data (KNVV) and purchasing organization data (LFM1)
- Bank details, contact persons and credit management data
- Special G/L items (down payments, guarantees) and noted items
- Cleared (historical) items – kept in the legacy archive for audit
- General ledger balances, assets, materials and any other objects

## 4. Source system and extraction

| ID | Requirement | Priority |
|---|---|---|
| REQ-001 | Data is extracted from ECC as flat files (CSV, UTF-8) per table, one extract per mock load. | Must |
| REQ-002 | Each extract includes a header record count and extraction timestamp so completeness can be verified. | Must |
| REQ-003 | Open items are extracted as of the **cutover date** for each mock load, per company code. | Must |
| REQ-004 | Extract files are stored read-only. All changes happen in later stages, never in the raw files. | Must |

## 5. Target system and load approach

| ID | Requirement | Priority |
|---|---|---|
| REQ-010 | Data is loaded with the SAP S/4HANA Migration Cockpit using its standard file templates. The tool produces load files in that template layout. | Must |
| REQ-011 | Load order: Business Partners (customers, vendors) → AR open items → AP open items. | Must |
| REQ-012 | Each legacy customer/vendor number is kept in a **cross-reference table** (legacy ID → new BP number) used by the open item loads and for reconciliation. | Must |
| REQ-013 | Open items are posted against a migration clearing (offset) account, which must be zero after all loads. | Must |

## 6. Selection (relevancy) rules

| ID | Requirement | Priority |
|---|---|---|
| REQ-020 | Migrate customers and vendors that were created or had postings in the last 24 months, **or** that have at least one open item. | Must |
| REQ-021 | Exclude records flagged for deletion (LOEVM = 'X') **unless** they have open items. Those go to the business for a decision. | Must |
| REQ-022 | Blocked records (posting block) with open items are migrated **with the block kept**. | Should |
| REQ-023 | Migrate only open (uncleared) AR/AP items. Exclude cleared items and special G/L items. | Must |
| REQ-024 | Each excluded record is listed in an exclusion report with the reason, so the business can sign off. | Must |

## 7. Data-quality requirements

Detailed rules with IDs (BP-001…, OI-001…) are defined in `02_functional_spec.md`.

| ID | Requirement | Priority |
|---|---|---|
| REQ-030 | **Completeness:** mandatory target fields (name, country, company code, reconciliation account, payment terms) are filled. | Must |
| REQ-031 | **Validity:** country codes are valid ISO codes; postal codes match the country's format (e.g. US 5 digits, Canada A1A 1A1, India 6 digits, Germany 5 digits); e-mail addresses are well formed; dates are valid. | Must |
| REQ-032 | **Uniqueness:** no duplicate customers or vendors. Exact duplicates are removed; likely duplicates (similar name + same postal code / tax number) are sent to the business for a merge decision. | Must |
| REQ-033 | **Consistency:** every open item refers to a customer/vendor that is being migrated, in the same company code (no orphan items). | Must |
| REQ-034 | **Accuracy:** open item amounts, currencies, document dates and baseline dates are unchanged between source and target. | Must |
| REQ-035 | Every record that fails a rule appears in a **remediation report** with the record key, rule ID, problem description and suggested fix, in a format a business owner can work through. | Must |
| REQ-036 | Each rule has a severity: **Critical** (record cannot load), **High** (loads but must be fixed before go-live), **Low** (accepted risk). | Must |

## 8. Transformation and value mapping

| ID | Requirement | Priority |
|---|---|---|
| REQ-040 | Country values are standardized to ISO codes (e.g. "USA", "US", "United States" → US). | Must |
| REQ-041 | Legacy payment terms are mapped to the S/4HANA payment terms configuration through a maintained value map. | Must |
| REQ-042 | Legacy account groups are mapped to Business Partner groupings and roles. | Must |
| REQ-043 | Names and addresses are trimmed of extra spaces and stored in the correct target fields. | Must |
| REQ-044 | Dates are converted to a single format (YYYY-MM-DD) before load. | Must |
| REQ-045 | All mapping and value-mapping rules are kept in configuration files (not hard-coded) so they can be changed per client or per mock without code changes. | Must |

## 9. Reconciliation requirements

| ID | Requirement | Priority |
|---|---|---|
| REQ-050 | **Count reconciliation:** extracted records = loaded + rejected + excluded, per object and company code. | Must |
| REQ-051 | **Key reconciliation:** every in-scope legacy key is found in the target through the cross-reference table. | Must |
| REQ-052 | **Field reconciliation:** key fields (name, country, payment terms, amounts) are compared between source and target for all records, not a sample. | Should |
| REQ-053 | **Financial reconciliation:** total open AR and AP per company code, currency and reconciliation account match between ECC and S/4HANA with **zero tolerance**. | Must |
| REQ-054 | The migration clearing account balance is zero after all open item loads. | Must |
| REQ-055 | Reconciliation results are produced as a report that finance can sign off. | Must |

## 10. AI assistance and human approval

The tool uses an LLM to speed up the consultant's work. The consultant always
makes the final decision.

| ID | Requirement | Priority |
|---|---|---|
| REQ-060 | The AI suggests source-to-target field mappings, value mappings and data-quality rules, each with a **confidence score and a short reason**. | Must |
| REQ-061 | No AI suggestion is used until a consultant **approves, edits or rejects** it. Nothing is approved automatically. | Must |
| REQ-062 | Every decision is written to an **audit log**: who, when, the AI suggestion and the final approved version. | Must |
| REQ-063 | The AI writes summaries of the readiness and reconciliation reports in plain language. **All numbers come from code**, not from the AI. | Must |
| REQ-064 | If the LLM is unavailable, the pipeline still runs with rules-only checks and previously approved mappings. | Should |
| REQ-065 | The quality of AI suggestions is measured against a known answer key (synthetic data with logged, injected defects), and the results are reported. | Should |

## 11. Data security and privacy

| ID | Requirement | Priority |
|---|---|---|
| REQ-070 | The LLM receives only **metadata**: column names, data profiles and masked sample values. It never receives full records. | Must |
| REQ-071 | Personal data (names, e-mails, addresses, tax numbers) is masked in logs, screenshots and any example shared outside the project. | Must |
| REQ-072 | The LLM runs locally (Ollama). No data is sent to an external service. | Must |
| REQ-073 | No credentials or secrets are stored in the code repository. | Must |

## 12. Migration approach and timeline

| Cycle | Purpose | Exit criteria |
|---|---|---|
| Mock 1 | Prove the end-to-end process and find data problems | ≥ 85% of records load; all defects logged |
| Mock 2 | Fix rules and data; test with business users | ≥ 97% of records load; no open Critical defects |
| Mock 3 / dress rehearsal | Full cutover rehearsal with timings | ≥ 99.5% of records load; **100% financial reconciliation**; finance sign-off |
| Production cutover | Go-live | Same as Mock 3, plus business sign-off of the exclusion and reconciliation reports |

## 13. Roles and responsibilities

| Role | Responsibility |
|---|---|
| Data migration consultant | Profiling, mapping, rules, loads, reconciliation, reports; approves AI suggestions |
| Business data owner (Finance – AR/AP) | Approves selection rules and value mappings; fixes data in the remediation reports; decides on duplicates |
| Finance controller | Signs off the financial reconciliation |
| SAP functional consultant (FI) | Provides target configuration (payment terms, reconciliation accounts, BP groupings) |
| Project manager / PMO | Tracks mock load status, defects and go-live readiness |

## 14. Success criteria

1. 100% of open AR/AP balances reconcile per company code, currency and reconciliation account.
2. Fewer than 0.5% of in-scope records are rejected at Mock 3, and each rejection has an agreed resolution.
3. No duplicate Business Partners are created.
4. Every AI-suggested mapping and rule has a recorded consultant decision.
5. The readiness report gives a clear go / no-go recommendation backed by numbers.

## 15. Assumptions, constraints and risks

**Assumptions**

- Target configuration (company codes, payment terms, reconciliation accounts,
  BP groupings) is complete before Mock 2.
- The business provides data owners who can fix data within agreed timelines.

**Constraints**

- The cutover window allows one load run per object.
- Only synthetic data is used in this project.

**Risks**

| Risk | Impact | Mitigation |
|---|---|---|
| Duplicate vendors are not resolved in time | Duplicate BPs, payment errors | Start duplicate review in Mock 1; business owner signs off merge list |
| Value mappings change late | Load failures at Mock 3 | Freeze value maps after Mock 2; change control after that |
| Orphan open items (no migrated customer/vendor) | Balances do not reconcile | Consistency check REQ-033 in every mock; early review with finance |
| Over-trust in AI suggestions | Wrong mappings loaded | Required human approval (REQ-061), audit log, measured AI accuracy |

## 16. Open questions

| # | Question | Owner |
|---|---|---|
| Q1 | Should blocked vendors without open items be migrated at all? | Business data owner |
| Q2 | Is a tax number (STCD1) required for all German and Indian vendors? | Finance / tax |
| Q3 | What is the cutover date for each mock load? | Project manager |

## 17. Glossary

| Term | Meaning |
|---|---|
| BP | Business Partner – the single S/4HANA object for customers and vendors |
| CVI | Customer–Vendor Integration – the link between BP and customer/vendor data |
| ECC | SAP ERP Central Component, the legacy system |
| Mock load | A full test run of the migration before go-live |
| Open item | An invoice or credit not yet paid or cleared |
| Reconciliation account | The G/L account that sums all customer or vendor balances |
| Cross-reference | Table linking legacy IDs to new S/4HANA IDs |
