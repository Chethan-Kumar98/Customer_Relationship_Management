SELECT * FROM opportunity;
SET SQL_SAFE_UPDATES=0;
UPDATE OPPORTUNITY SET OPPORTUNITY_TYPE="NA" WHERE OPPORTUNITY_TYPE="";

# 1. Expected Amount
select sum(Expected_Amount) as Total_expected_Amount from opportunity;

# 2. Active opporunities
SELECT COUNT(CLOSED) AS ACTIVE_OPPORTUNITIES FROM OPPORTUNITY WHERE CLOSED="FALSE";

# 3. CONVERSION RATE

SELECT CONCAT(ROUND(
             (COUNT(CASE WHEN STAGE = 'CLOSED WON' THEN 1 END) / COUNT(*)) * 100, 2),"%") AS conversion_rate
			 FROM opportunity;

# 4. WON RATE
SELECT CONCAT(ROUND(
             (COUNT(CASE WHEN WON = 'TRUE' THEN 1 END) / COUNT(*)) * 100, 2),"%") AS WON_RATE
			 FROM opportunity;
             
# 5. LOSS RATE
SELECT CONCAT(ROUND(
             (COUNT(CASE WHEN WON = 'FALSE' THEN 1 END) / COUNT(*)) * 100, 2),"%") AS LOSS_RATE
			 FROM opportunity;
             
# 6. EXPECTED AMOUNT BY OPPORTUNITY TYPE

SELECT OPPORTUNITY_TYPE, SUM(EXPECTED_AMOUNT) AS EXPECTED_AMOUNT FROM OPPORTUNITY GROUP BY OPPORTUNITY_TYPE;

# 7. OPPORTUNITIES BY INDUSTRY

SELECT INDUSTRY,COUNT(OPPORTUNITY_ID) AS OPPORTUNITIES FROM OPPORTUNITY GROUP BY INDUSTRY;

# 8. RUNNING EXPECTED AMOUNT VS COMMIT FORECAST AMOUNT OVER TIME

SELECT FISCAL_YEAR, SUM(EXPECTED_AMOUNT) AS EXPECTED_AMOUNT,
					SUM(AMOUNT) AS COMMIT_FORECAST_AMOUNT
                    FROM OPPORTUNITY
                    GROUP BY FISCAL_YEAR
                    ORDER BY FISCAL_YEAR;

# 9. RUNNING TOTAL ACTIVE VS TOTAL OPPORTUNITIES

SELECT FISCAL_YEAR,COUNT(OPPORTUNITY_ID) AS OPPORTUNITIES,
                   SUM(CASE WHEN CLOSED= "FALSE" THEN 1 ELSE 0 END) AS ACTIVE_OPPORTUNITIES
                   FROM OPPORTUNITY
                   GROUP BY FISCAL_YEAR
                   ORDER BY FISCAL_YEAR;

# 10. CLOSED WON VS TOTAL OPPORTUNITIES OVER TIME

SELECT FISCAL_YEAR,COUNT(OPPORTUNITY_ID) AS OPPORTUNITIES,
				   SUM(CASE WHEN STAGE="CLOSED WON" THEN 1 ELSE 0 END) AS CLOSED_WON,
                   CONCAT(ROUND((SUM(CASE WHEN STAGE="CLOSED WON" THEN 1 ELSE 0 END)/COUNT(OPPORTUNITY_ID))*100,2),"%") AS WON_PERCENTAGE
                   FROM OPPORTUNITY
                   GROUP BY FISCAL_YEAR
                   ORDER BY FISCAL_YEAR;

# 11. CLOSED WON VS TOTAL CLOSED OVER TIME

SELECT FISCAL_YEAR, COUNT(OPPORTUNITY_ID) AS OPPORTUNITIES,
                    SUM(CASE WHEN CLOSED="TRUE" THEN 1 ELSE 0 END) AS TOTAL_CLOSED,
                    SUM(CASE WHEN STAGE="CLOSED WON" THEN 1 ELSE 0 END) AS CLOSED_WON,
					CONCAT(ROUND(
				    (COUNT(CASE WHEN STAGE = 'Closed Won' THEN 1 END) / COUNT(CASE WHEN STAGE IN ('Closed Won', 'Closed Lost') THEN 1 END)) * 100, 2),"%") 
                    AS CLOSEDWON_VS_TOTALCLOSED_PERCENT
                    FROM OPPORTUNITY 
                    GROUP BY FISCAL_YEAR 
                    ORDER BY FISCAL_YEAR;
