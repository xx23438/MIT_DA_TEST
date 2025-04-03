WITH top_registrants AS (
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
    ORDER BY 
        total_spend DESC
    LIMIT 5
),
client_spending AS (
    SELECT 
        tr.registrant_id,
        tr.registrant_name,
        c.client_name,
        SUM(f.amount::numeric) AS client_total,
        ROW_NUMBER() OVER (PARTITION BY tr.registrant_id ORDER BY SUM(f.amount::numeric) DESC) AS rank
    FROM 
        top_registrants tr
    JOIN 
        analyst.filings f ON tr.registrant_id = f.registrant_id
    JOIN 
        analyst.clients c ON f.client_id = c.client_id
    GROUP BY 
        tr.registrant_id, tr.registrant_name, c.client_name
)
SELECT 
    registrant_name,
    client_name
FROM 
    client_spending
WHERE 
    rank <= 5
ORDER BY 
    registrant_name, client_total DESC;