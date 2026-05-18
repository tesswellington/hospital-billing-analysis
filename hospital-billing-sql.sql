-- ==================================================================== --
-- Hospital Billing Analysis
-- ------------------------------------------------
-- Author: Theresa Wellington
-- Last Updated: May 2026
--
-- Purpose: Analyze the gap between US hospital charges and
-- Medicare reimbursement using CMS Medicare Inpatient Hospitals
-- data. Investigates pricing patterns by state, procedure (DRG),
-- and hospital size.
--
--Data source: CMS Medicare Inpatient Hospitals by Provider and
-- Service (2024) . Downloaded from data.cms.gov. Imported into 
-- DB Browser for SQLite as a table named 'charges'
-- ==================================================================== --

--- --- --- Summary Statistics --- --- ---

-- Number of rows, hospitals, DRGs, and states
SELECT 
	COUNT (*) AS row_count,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) AS hospital_count,
	COUNT (DISTINCT DRG_Cd) AS drg_count,
	COUNT (DISTINCT Rndrng_Prvdr_State_Abrvtn) AS state_count
FROM charges;		

-- Summary statistics: per-patient dollar amounts
SELECT
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_hospital_charge,
	ROUND(SUM(Avg_Tot_Pymt_Amt* Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_total_payment,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_medicare_payment,
	ROUND (SUM(Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs / SUM(Tot_Dschrgs), 0) 
		AS avg_gap
FROM charges;

-- Summary statistics: overall ratios
SELECT
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs), 2) 
		AS overall_markup_ratio,
	ROUND(100.0 * SUM(Avg_Mdcr_Pymt_Amt  * Tot_Dschrgs) / SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs), 1) 
		AS overall_medicare_pmt_pct
FROM charges;


--- --- --- Variations by State --- --- ---

-- States in order of highest average hospital bills
SELECT 
	Rndrng_Prvdr_State_Abrvtn AS state, 
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) AS avg_hospital_charge
FROM charges
GROUP BY state
ORDER BY avg_hospital_charge DESC;

-- States in order of highest markup ratio between hospital charge and Medicare payment
SELECT
	Rndrng_Prvdr_State_Abrvtn AS state,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) 
		AS hospital_count,
	SUM(Tot_Dschrgs)
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_hospital_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt   * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs)/ SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt  * Tot_Dschrgs), 2)
		AS markup_ratio
FROM charges
GROUP BY state
ORDER BY markup_ratio DESC;

-- States in order of largest gap between hospital charge and Medicare payment
SELECT
	Rndrng_Prvdr_State_Abrvtn AS state,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) 
		AS hospital_count,
	SUM(Tot_Dschrgs)
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_hospital_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt   * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs)/ SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt  * Tot_Dschrgs), 2)
		AS markup_ratio
FROM charges
GROUP BY state
ORDER BY avg_gap DESC;


--- --- --- Variations by DRG --- --- ---

-- DRGs in order of highest average hospital bills
SELECT
	DRG_Cd,
	DRG_Desc,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) AS hospital_charge
FROM charges
GROUP BY DRG_Cd, DRG_Desc
ORDER BY hospital_charge DESC;

-- DRGs in order of highest markup ratio between hospital charge and Medicare payment
SELECT
	DRG_Cd,
	DRG_Desc,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) 
		AS hospital_count,
	SUM(Tot_Dschrgs)
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_hospital_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt   * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs)/ SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt  * Tot_Dschrgs), 2)
		AS markup_ratio
FROM charges
GROUP BY DRG_Cd, DRG_Desc
ORDER BY markup_ratio DESC;

-- DRGs in order of largest gap between hospital charge and Medicare payment
SELECT
	DRG_Cd,
	DRG_Desc,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) 
		AS hospital_count,
	SUM(Tot_Dschrgs)
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_hospital_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt   * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0)
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs)/ SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt  * Tot_Dschrgs), 2)
		AS markup_ratio
FROM charges
GROUP BY DRG_Cd, DRG_Desc
ORDER BY avg_gap DESC;

--- Variations in DRG 470: major joint replacement 
--- Using min-max
SELECT
	COUNT(*) AS hospitals,
	ROUND(MIN(Avg_Submtd_Cvrd_Chrg), 0) 
		AS min_charge,
	ROUND(MAX(Avg_Submtd_Cvrd_Chrg), 0) 
		AS max_charge,
	ROUND(MAX(Avg_Submtd_Cvrd_Chrg) / MIN(Avg_Submtd_Cvrd_Chrg), 1)
		AS charge_spread_ratio,
	ROUND(MIN(Avg_Mdcr_Pymt_Amt), 0) 
		AS min_medicare_pmt,
	ROUND(MAX(Avg_Mdcr_Pymt_Amt), 0) 
		AS max_medicare_pmt,
	ROUND(MAX(Avg_Mdcr_Pymt_Amt) / MIN(Avg_Mdcr_Pymt_Amt), 1)
		AS medicare_spread_ratio
FROM charges
WHERE DRG_Cd = '470';

--- Using CV
SELECT
	DRG_Cd,
	COUNT(*) AS hospitals,
	ROUND(AVG(Avg_Submtd_Cvrd_Chrg), 0)
		AS mean_charge,
	ROUND(SQRT(AVG(Avg_Submtd_Cvrd_Chrg * Avg_Submtd_Cvrd_Chrg) - AVG(Avg_Submtd_Cvrd_Chrg) * AVG(Avg_Submtd_Cvrd_Chrg)), 0)
		AS sd_charge,
	ROUND(100.0 * SQRT(AVG(Avg_Submtd_Cvrd_Chrg * Avg_Submtd_Cvrd_Chrg) - AVG(Avg_Submtd_Cvrd_Chrg) * AVG(Avg_Submtd_Cvrd_Chrg)) / AVG(Avg_Submtd_Cvrd_Chrg), 1)
		AS cv_charge_pct,
	ROUND(AVG(Avg_Mdcr_Pymt_Amt), 0)
		AS mean_medicare,
	ROUND(SQRT(AVG(Avg_Mdcr_Pymt_Amt * Avg_Mdcr_Pymt_Amt) - AVG(Avg_Mdcr_Pymt_Amt) * AVG(Avg_Mdcr_Pymt_Amt)), 0)
		AS sd_medicare,
	ROUND(100.0 * SQRT(AVG(Avg_Mdcr_Pymt_Amt * Avg_Mdcr_Pymt_Amt) - AVG(Avg_Mdcr_Pymt_Amt) * AVG(Avg_Mdcr_Pymt_Amt)) / AVG(Avg_Mdcr_Pymt_Amt), 1) 
		AS cv_medicare_pct
FROM charges
WHERE DRG_Cd = '470';

--- Variations in DRG 652: kidney transplant (using CV)
SELECT
	DRG_Cd,
	COUNT(*) AS hospitals,
	ROUND(AVG(Avg_Submtd_Cvrd_Chrg), 0)
		AS mean_charge,
	ROUND(SQRT(AVG(Avg_Submtd_Cvrd_Chrg * Avg_Submtd_Cvrd_Chrg) - AVG(Avg_Submtd_Cvrd_Chrg) * AVG(Avg_Submtd_Cvrd_Chrg)), 0)
		AS sd_charge,
	ROUND(100.0 * SQRT(AVG(Avg_Submtd_Cvrd_Chrg * Avg_Submtd_Cvrd_Chrg) - AVG(Avg_Submtd_Cvrd_Chrg) * AVG(Avg_Submtd_Cvrd_Chrg)) / AVG(Avg_Submtd_Cvrd_Chrg), 1)
		AS cv_charge_pct,
	ROUND(AVG(Avg_Mdcr_Pymt_Amt), 0)
		AS mean_medicare,
	ROUND(SQRT(AVG(Avg_Mdcr_Pymt_Amt * Avg_Mdcr_Pymt_Amt) - AVG(Avg_Mdcr_Pymt_Amt) * AVG(Avg_Mdcr_Pymt_Amt)), 0)
		AS sd_medicare,
	ROUND(100.0 * SQRT(AVG(Avg_Mdcr_Pymt_Amt * Avg_Mdcr_Pymt_Amt) - AVG(Avg_Mdcr_Pymt_Amt) * AVG(Avg_Mdcr_Pymt_Amt)) / AVG(Avg_Mdcr_Pymt_Amt), 1) 
		AS cv_medicare_pct
FROM charges
WHERE DRG_Cd = '652';

--- --- --- Variations by hospital size --- --- ---

-- Exploring hospital sizes, defined by total Medicare patient discharges
SELECT
	Rndrng_Prvdr_CCN AS ccn,
	Rndrng_Prvdr_Org_Name AS hospital,
	Rndrng_Prvdr_State_Abrvtn AS state,
	SUM(Tot_Dschrgs) AS total_patients,
	COUNT(DISTINCT DRG_Cd) AS drgs_offered
FROM charges
GROUP BY ccn, hospital, state
ORDER BY total_patients DESC;

-- Percentiles of hospital sizes
WITH hospital_sizes AS (
	SELECT 
		Rndrng_Prvdr_CCN AS ccn,
		SUM(Tot_Dschrgs) AS total_patients
	FROM charges
	GROUP BY Rndrng_Prvdr_CCN
),
ranked AS (
	SELECT 
		total_patients,
		NTILE(3) OVER (ORDER BY total_patients) as quartile
		FROM hospital_sizes
)
SELECT quartile,
	MIN(total_patients) AS quartile_min,
	MAX(total_patients) AS quartile_max,
	COUNT(*) AS hospital_count
FROM ranked
GROUP BY quartile;

-- Creating hospital size table
DROP TABLE IF EXISTS hospital_size;
CREATE TABLE hospital_size AS
SELECT
	Rndrng_Prvdr_CCN AS ccn,
	SUM(Tot_Dschrgs) AS total_patients,
	CASE
		WHEN SUM(Tot_Dschrgs) < 400 THEN 'Small'
		WHEN SUM(Tot_Dschrgs) < 2000 THEN 'Medium'
		ELSE 'Large'
	END AS size_buckets
FROM charges
GROUP BY ccn;

--- Markup based on hospital size
SELECT
	hs.size_buckets AS size,
	COUNT(DISTINCT c.Rndrng_Prvdr_CCN)
		AS hospital_count,
	SUM(c.Tot_Dschrgs)
		AS total_patients,
	ROUND(SUM(c.Avg_Submtd_Cvrd_Chrg * c.Tot_Dschrgs) / SUM(c.Tot_Dschrgs), 0)
		AS avg_hospital_charge,
	ROUND(SUM(c.Avg_Mdcr_Pymt_Amt   * c.Tot_Dschrgs) / SUM(c.Tot_Dschrgs), 0)
		AS avg_medicare_pmt,
    ROUND(SUM((c.Avg_Submtd_Cvrd_Chrg - c.Avg_Mdcr_Pymt_Amt) * c.Tot_Dschrgs) / SUM(c.Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(c.Avg_Submtd_Cvrd_Chrg * c.Tot_Dschrgs) /  SUM(c.Avg_Mdcr_Pymt_Amt  * c.Tot_Dschrgs), 2) 
		AS markup_ratio
FROM charges c
JOIN hospital_size hs ON hs.ccn = c.Rndrng_Prvdr_CCN
GROUP BY hs.size_buckets
ORDER BY
	CASE hs.size_buckets
		WHEN 'Small' THEN 1
		WHEN 'Medium' THEN 2
		ELSE 3
	END;
	
--- --- --- Tableau Views --- --- ---

--- (1) Summary by state
SELECT
	Rndrng_Prvdr_State_Abrvtn AS state,
	COUNT(DISTINCT Rndrng_Prvdr_CCN) 
		AS hospital_count,
	SUM(Tot_Dschrgs) 
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs), 2)
		AS markup_ratio
FROM charges
GROUP BY Rndrng_Prvdr_State_Abrvtn;

--- (2) Summary by DRG
SELECT
	DRG_Cd,
	DRG_Desc,
	SUM(Tot_Dschrgs) 
		AS total_patients,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_charge,
	ROUND(SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_medicare_pmt,
	ROUND(SUM((Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) * Tot_Dschrgs) / SUM(Tot_Dschrgs), 0) 
		AS avg_gap,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / SUM(Avg_Mdcr_Pymt_Amt * Tot_Dschrgs), 2) 
		AS markup_ratio,
	ROUND(SUM(Avg_Submtd_Cvrd_Chrg * Tot_Dschrgs) / 1000000000, 2) 
		AS total_billions_billed
FROM charges
GROUP BY DRG_Cd, DRG_Desc
HAVING COUNT(DISTINCT Rndrng_Prvdr_CCN) >= 50;

--- (3a) Hospital bill vs Medicare payment for DRG 652: kidney transplant
SELECT
	Rndrng_Prvdr_Org_Name AS hospital,
	Rndrng_Prvdr_State_Abrvtn AS state,
	Tot_Dschrgs AS total_patients,
	Avg_Submtd_Cvrd_Chrg AS avg_charge,
	Avg_Mdcr_Pymt_Amt AS avg_medicare_pmt
FROM charges
WHERE DRG_Cd = '652';

--- (3b) Hospital bill vs Medicare payment for DRG 470: major joint replacement w/o mcc 
SELECT
	Rndrng_Prvdr_Org_Name AS hospital,
	Rndrng_Prvdr_State_Abrvtn AS state,
	Tot_Dschrgs AS total_patients,
	Avg_Submtd_Cvrd_Chrg AS avg_charge,
	Avg_Mdcr_Pymt_Amt AS avg_medicare_pmt
FROM charges
WHERE DRG_Cd = '470';
