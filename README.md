# Data Migration Portfolio – SAP Finance & S/4HANA

Hands-on projects in SAP data migration, data quality and reconciliation, built
the way real migration projects are delivered: requirements → functional spec →
build → mock loads → reconciliation → go-live readiness.

## About Me

- **Former Data Migration Consultant at Syniti (2021–2023)**: SAP Finance and
  Project System data migration on client S/4HANA implementations
- Experience with SAP FICO and PS data, LTMC/LSMW, Syniti ADM, source-to-target
  mapping, data-quality rules and financial reconciliation
- **MS in Applied Data Intelligence, San José State University** (expected 2027)
- Interests: applying AI to speed up migration work while keeping the consultant
  in control

## Projects

| # | Project | What it shows | Status |
|---|---|---|---|
| 01 | [SAP Finance Migration](01-sap-finance-migration/) | Simulated SAP Finance migration: data mapping, transformation rules and reconciliation (SQL, Python, Excel) | In progress |
| 02 | [AI-Assisted Data Migration](02-ai-assisted-migration/) | End-to-end ECC → S/4HANA migration of customers, vendors and open AR/AP items, with AI-suggested mappings and rules approved by the consultant | In progress – target Jan 2027 |

## Featured: 02 – AI-Assisted Data Migration

**Scenario:** Cascade Industrial Corp. (fictional manufacturer, 3 company codes:
US, Germany, India) moves from SAP ECC to S/4HANA. Customers and vendors become
Business Partners, and open AR/AP balances must reconcile to the cent.

**How it works:**

1. **Profile** the legacy data and find quality issues
2. **AI suggests** field mappings, value mappings and data-quality rules, each with
   a confidence score and reason
3. **Consultant approves, edits or rejects** every suggestion, and each decision is logged
4. **Validate and transform**, producing remediation reports for business owners
5. **Generate load files** in Migration Cockpit-style templates
6. **Reconcile** counts, keys and open-item totals by company code
7. **Readiness report** with a go / no-go recommendation across Mock 1 → 3

**Privacy by design:** the LLM runs locally and sees only metadata and profiles,
never full records.

**Progress**

- [x] Requirements document – [01_requirements.md](02-ai-assisted-migration/docs/01_requirements.md)
- [ ] Functional spec with numbered rules
- [ ] SAP-style synthetic data with a logged list of injected defects
- [ ] Data profiling and analysis report
- [ ] AI mapping suggestions + consultant approval screen
- [ ] Data-quality rules and remediation reports
- [ ] Transformation and load files
- [ ] Reconciliation and readiness report
- [ ] Mock load simulation, tests and CI
- [ ] Demo video and user guide

## Skills Demonstrated

- SAP data migration lifecycle (discovery, design, build, mock loads, cutover)
- SAP S/4HANA Business Partner, FI open items and reconciliation
- Source-to-target mapping, value mapping and cross-references
- Data profiling, data-quality rules and remediation reporting
- Python (pandas), SQL, DuckDB, Streamlit, Pytest
- Human-in-the-loop AI with a local LLM (Ollama)
- Git/GitHub workflow with branches and pull requests

## Repository Structure

Each project folder contains:

- `README.md` – problem, approach and results
- `docs/` – requirements, functional spec, mapping and design documents
- `data/` – synthetic datasets
- `python/` or `src/` – transformation, validation and reconciliation code
- `sql/` – queries and scripts

## Data Disclaimer

All data in this repository is **synthetic**. No client data, client documents or
proprietary software from any employer or vendor is used or reproduced.

## Contact

- **Name:** Elsa Rose
- **Location:** San Francisco, CA
- **GitHub:** [elsasjsu](https://github.com/elsasjsu)
- **LinkedIn:** [add your LinkedIn URL]
- **Email:** elsakalliath@gmail.com
