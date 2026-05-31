# Medicare Part D GLP-1 Prescribing Outlier Analysis

## Overview
This project uses dbt and BigQuery to identify statistical outliers in GLP-1 
prescribing patterns among Medicare Part D providers in 2022. It was built as 
an end-to-end analytics engineering project to demonstrate the full transformation 
pipeline from raw CMS data to analysis-ready mart tables.

## Analytical Question
Which providers are statistical outliers in GLP-1 prescribing relative to peers 
in their specialty, and what does the distribution of those outliers look like 
across specialties and geographies?

## Data Source
CMS Medicare Part D Prescriber Public Use File (PUF) 2022  
~25.8 million rows | 1.057 million unique providers | 181 specialties  
Source: https://data.cms.gov/provider-summary-by-type-of-service/medicare-part-d-prescribers

## Tech Stack
- **BigQuery** — cloud data warehouse
- **dbt** — data transformation and testing
- **Google Cloud Storage** — raw data staging

## Project Structure

```
models/
├── staging/
│   ├── stg_prescriber_drug.sql      # Clean and rename raw CMS columns
│   └── sources.yml                  # Source table definitions
├── intermediate/
│   └── int_glp1_prescribers.sql    # Filter to GLP-1 drugs, aggregate by provider
└── marts/
    └── mart_glp1_outliers.sql      # Z-score outlier classification by specialty
```
## Transformation Pipeline
1. **Staging** — Renames cryptic CMS column names, filters null NPIs
2. **Intermediate** — Filters to 9 GLP-1 drug generic names, aggregates claims 
   and beneficiaries to one row per provider
3. **Mart** — Calculates z-scores within each specialty, classifies providers 
   into prescribing tiers

## Outlier Classification
| Tier | Z-Score |
|------|---------|
| Extreme Outlier | ≥ 3 |
| Outlier | ≥ 2 |
| Above Average | ≥ 1 |
| Average | -1 to 1 |
| Below Average | < -1 |

## Key Findings (2022)
- 2,476 providers classified as extreme outliers (z ≥ 3)
- Family Practice produced the most outliers by count (814)
- Nurse Practitioners had the highest single-provider claim volume (2,368 claims)
- Specialties with fewer than 10 GLP-1 prescribers excluded from analysis

## Data Quality Tests
9 dbt tests covering null checks, uniqueness, and accepted values across all 
three model layers — all passing.

## Notes
Wegovy and Zepbound (the weight-loss-specific semaglutide and tirzepatide 
formulations) are absent from this dataset, as they had limited Medicare Part D 
coverage in 2022. Analysis reflects primarily diabetes-indication prescribing.