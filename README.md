# Hospital Billing Analysis

An exploratory analysis of U.S. hospital billing patterns using Medicare inpatient data from the Centers for Medicare & Medicare Services (CMS).

---

## Project Overview
This project investigates the gap between what hospitals bill and what Medicare actually pays across over 146,000 records from thousands of US hospitals and hundreds of DRGs. The analysis identifies pricing patterns by procedure type, DRG, state, and hospital size.

---

## Data Source
**CMS Medicare Inpatient Hospitals by Provider and Service**
Access Dataset Here: [[cms.ca.gov](https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-provider-and-service)

## Key Features used for Analysis:
- Diagnosis-Related Group code & description
- Total discharges (Number of Medicare patients for that DRG at that hospital)
- Avg submitted covered charge (Amount the hospital billed)
- Avg total payment (Amount Medicare + patient actually paid)
- Avg Medicare payment (Amount Medicare paid)


---

## Key Findings
**1. Which procedures have the highest billing markup?**
Immunotherapies and organ transplants (specifically heart, lung, and liver) showed the largest gap between billed charges and Medicare reimbursement. For these procedures, hospitals typically bill 5-6x more than Medicare pays.

**2. Which states have the highest billing markup?**
Nevada, Florida, and Colorado are the top three most aggressive billing states. These states consistently show higher markup percentages than the national average.

**3. Which Diagnosis-Related Groups (DRGs) have the highest volume?**
Heart failure, sepsis, and joint replacements account for the largest share of total Medicare expenditure. The procedures themselves do not have extreme costs per-case, but the large number of patients greatly increases the total spending.

