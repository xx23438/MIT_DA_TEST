WITH top_registrant AS (
    SELECT 
        r.registrant_id, 
        r.registrant_name
    FROM 
        analyst.registrants r
    JOIN 
        analyst.filings f ON r.registrant_id = f.registrant_id
    JOIN 
        analyst.filings_issues fi ON f.filing_uuid = fi.filing_uuid
    JOIN 
        analyst.filings_bills fb ON fi.filing_uuid = fb.filing_uuid
    WHERE 
        fi.general_issue_code = 'MMM'
    GROUP BY 
        r.registrant_id, r.registrant_name
    ORDER BY 
        COUNT(DISTINCT fb.bill_id) DESC
    LIMIT 1
)
SELECT 
    r.registrant_id,
    r.registrant_name,
    ARRAY_AGG(DISTINCT fb.bill_id) AS lobbied_bills
FROM 
    top_registrant r
JOIN 
    analyst.filings f ON r.registrant_id = f.registrant_id
JOIN 
    analyst.filings_issues fi ON f.filing_uuid = fi.filing_uuid
JOIN 
    analyst.filings_bills fb ON fi.filing_uuid = fb.filing_uuid
WHERE 
    fi.general_issue_code = 'MMM'
GROUP BY 
    r.registrant_id, r.registrant_name
LIMIT 10;