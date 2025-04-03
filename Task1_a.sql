SELECT 
    r.registrant_id,
    r.registrant_name,
    SUM(f.amount::numeric) AS total_spend
FROM 
    analyst.registrants r
JOIN 
    analyst.filings f ON r.registrant_id = f.registrant_id
GROUP BY 
    r.registrant_id, r.registrant_name
HAVING 
    SUM(f.amount::numeric) > 10000000
ORDER BY 
    total_spend DESC
-- Delete the next line if want all cases
LIMIT 10;