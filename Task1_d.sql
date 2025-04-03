SELECT 
    CASE 
        WHEN title LIKE '% Act' OR title LIKE '% Law' OR title LIKE '% Resolution' THEN 'Standard'
        ELSE 'Non-Standard'
    END AS title_type,
    COUNT(*) AS count
FROM 
    analyst.bills
GROUP BY 
    title_type;