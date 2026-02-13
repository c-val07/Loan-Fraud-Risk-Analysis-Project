-- Tables
select * from loan_applications;
select * from transactions;
select * from loan_applications1;
select * from transactions1;

-----------------------------------------------------
-- duplicate tables with data included
CREATE TABLE loan_applications1 AS
SELECT * FROM loan_applications;

CREATE TABLE transactions1 AS
SELECT * FROM transactions;

-----------------------------------------------------
-- check for NULL or 0 values
SELECT *
FROM loan_applications1
WHERE debt_to_income_ratio IS NULL OR debt_to_income_ratio = '';
/* 3533 rows were returned that had a debt to income ratio equal to 0 */

SELECT *
FROM loan_applications1
WHERE number_of_dependents IS NULL OR number_of_dependents = '';
/* 9702 rows were returned that had number of dependents equal to 0 */

SELECT *
FROM loan_applications1
WHERE fraud_flag IS NULL OR fraud_flag = '';
/* 48974 rows were returned that had number a fraud flag equal to 0 */

SELECT *
FROM loan_applications1
WHERE fraud_type IS NULL OR fraud_type = '';
/* 48974 rows were returned that had a NULL fraud type */

/* All columns that returned zero have a justifiable reason to be equal to zero,
the data is acceptable. Fraud type was the only column that returned NULL values.
This is due to the correlation of fraud flag being equal to zero, so a NULL
value is acceptable in the fraud type column if fraud flag is equal to zero */
------------------------------------------------------
-- Update blank fraud_type columns to display as 'None'
UPDATE loan_applications1
SET fraud_type = 'None'
WHERE fraud_type = '';

/* All fraud_type columns that were blank, now display as 'None' for clarity */
------------------------------------------------------
-- Check for duplicates of applicaiton id's
SELECT application_id, COUNT(*) AS id_instances
FROM loan_applications1
GROUP BY application_id
ORDER BY id_instances DESC
LIMIT 10;

/* There are zero duplicates of application id's. */
------------------------------------------------------
-- Do customers ask for multiple loans?
SELECT customer_id, COUNT(*) AS total_loans_requested
FROM loan_applications1
GROUP BY customer_id
ORDER BY total_loans_requested DESC;

/* A high number of 18,314 customers ask for multiple loans on several occasions */
------------------------------------------------------
-- How much in loans has been approved and denied?
SELECT SUM(loan_amount_requested) AS total_loan_value
FROM loan_applications1
WHERE loan_status = 'Approved';

SELECT SUM(loan_amount_requested) AS total_loan_value
FROM loan_applications1
WHERE loan_status = 'Declined';

/* A total of $236,880,157 has been approved and $46,623,966 has been declined
in requested loans */
------------------------------------------------------
-- What percentage of total loan applications were approved vs. declined vs. fraudulent?
SELECT loan_status, COUNT(*) AS loan_count,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM loan_applications1), 2) AS percentage
FROM loan_applications1
GROUP BY loan_status
ORDER BY loan_count DESC;

/* 81.7% of loans were approved and 16.1% of loans were declined.
Very minimal amount of loans were fraudulent with just under 1% being undetected
and just over 1% were detected. A grand total of 1026 loan applications were fraudulent */
------------------------------------------------------
SELECT SUM(loan_amount_requested) AS amount_requested
FROM loan_applications1
WHERE NOT fraud_type = 'None'
GROUP BY loan_status;
------------------------------------------------------
-- How much was requested for each fraud type loan and how many times was it attempted?
select * from loan_applications1;

SELECT fraud_type, SUM(loan_amount_requested) AS total_requested_amount
FROM loan_applications1
WHERE NOT fraud_type = 'None'
GROUP BY fraud_type
ORDER BY total_requested_amount DESC;

SELECT 1605789 + 1517306 + 1357167 + 1326432 AS fraud_total_amount;
SELECT 1605789 - 1517306 AS top_two_fraud_type_difference;

SELECT fraud_type, COUNT(*) AS total_attempts_found
FROM loan_applications1
WHERE NOT fraud_type = 'None'
GROUP BY fraud_type
ORDER BY total_attempts_found DESC;

/* The fraud type that requested the highest overall loan amount is
synthetic identity. This can represent that symthetic identity,
in this case, is most common for loan frauds. Additionally, with only
six more attempts than income misrepresentation, synthetic identity has
requested a total of $88,483 more in loans. An overall amount of $5,806,694 */
------------------------------------------------------
-- How do credit scores differ between approved and declined loans?

SELECT loan_status, ROUND(AVG(credit_score)) AS avg_credit_score
FROM loan_applications1
WHERE loan_status = 'Approved' OR loan_status = 'Declined'
GROUP BY loan_status;

/* Approved loans had an average credit score of 714 falling in the 'Good' credit range
whereas declined loans had an average credit score of 624 falling in the 'Fair' credit range */
------------------------------------------------------
-- What type of loans are most often requested?
SELECT loan_type, COUNT(*) AS loans_requested
FROM loan_applications1
GROUP BY loan_type
ORDER BY COUNT(loan_type) DESC;

-- Which loan types have the highest decline rate?
SELECT loan_type, COUNT(*) AS loans_declined
FROM loan_applications1
WHERE loan_status = 'Declined'
GROUP BY loan_type
ORDER BY COUNT(loan_type) DESC;


SELECT ROUND((1639/10056)*100, 2); -- Home loans declined rate
SELECT ROUND((1630/10022)*100, 2); -- Education Loans declined rate
SELECT ROUND((1627/10020)*100, 2); -- Personal loans declined rate
SELECT ROUND((1610/9961)*100, 2); -- Business loans declined rate
SELECT ROUND((1586/9941)*100, 2); -- Car loans declined rate

/* The total loans requested and total loans declined are in the same
order. Home loans have the most loan requests, but also the most loans, of that type,
declined at 16.30%.*/
------------------------------------------------------
-- How does monthly income relate to loan declines?
SELECT
CASE 
	WHEN monthly_income < 300 THEN 'Low income'
	WHEN monthly_income BETWEEN 301 AND 600 THEN 'Moderate Income'
	ELSE 'High Income' 
END AS income_group,
ROUND(SUM(CASE WHEN loan_status = 'Declined' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS decline_rate
FROM loan_applications1
GROUP BY income_group
ORDER BY decline_rate DESC;

-- How does monthly income relate to interest rates offered?
SELECT
CASE 
	WHEN monthly_income < 300 THEN 'Low income'
	WHEN monthly_income BETWEEN 301 AND 600 THEN 'Moderate Income'
	ELSE 'High Income' 
END AS income_group,
ROUND(AVG(interest_rate_offered),2) AS avg_interest
FROM loan_applications1
GROUP BY income_group
ORDER BY avg_interest DESC;

select * from loan_applications1;

/* The high income group has a higher declination rate of 16.35% compared
to the low income group declination rate of 15.74%. In terms of interest
rates offered, the low and moderate income group was offered an average
interest rate of 10.53% and the high income group was offered an average
of 10.52% */
------------------------------------------------------
-- What applicant age group is most likely to be declined?
select * from loan_applications1;

SELECT
CASE
	WHEN applicant_age < 30 THEN 'Under 30'
    WHEN applicant_age BETWEEN 30 AND 50 THEN '30-50'
    ELSE 'Over 50'
    END AS age_group,
ROUND(SUM(CASE WHEN loan_status = 'Declined' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS decline_rate
FROM loan_applications1
GROUP BY age_group
ORDER BY decline_rate DESC;

/* Applicants between the ages of 30 and 50 years of age are slightly likely
to have their loan application denied, with a rating of 16.26%.
Applicants under 30 and over 50 have the same rate of declination
at 16.11% */
------------------------------------------------------
-- What is the average loan amount requested per employement status?
SELECT employment_status, ROUND(AVG(loan_amount_requested)) AS amount_requested
FROM loan_applications1
GROUP BY employment_status
ORDER BY amount_requested DESC;

-- What is the average credit score per purpose of loan?
SELECT purpose_of_loan, ROUND(AVG(credit_score)) AS avg_credit_score
FROM loan_applications1
GROUP BY purpose_of_loan
ORDER BY AVG(credit_score) DESC;

/* Applicants who requested loans for medical emergencies, weddings,
and debt consolidation had an average credit score of 700. Others
who requested loans for home renovation, business expansions, and 
education had an average credit score of 699. Applicants who
requested a vehicle purchase loan had an average score of 698 */
------------------------------------------------------
-- How many are approved and declined per purpose of loan?
SELECT purpose_of_loan,
	SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS loan_approved,
    SUM(CASE WHEN loan_status = 'Declined' THEN 1 ELSE 0 END) AS loan_declined
FROM loan_applications1
GROUP BY purpose_of_loan
ORDER BY loan_approved DESC;

/* Applicants who requested a loan for medical emergencies were the most
approved whereas applicants who requested a loan for education were the
least approved. */
------------------------------------------------------
-- How many are approved and declined per property ownership status?
SELECT property_ownership_status,
	SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS loan_approved,
    SUM(CASE WHEN loan_status = 'Declined' THEN 1 ELSE 0 END) AS loan_declined
FROM loan_applications1
GROUP BY property_ownership_status
ORDER BY loan_approved DESC;

/* Applicants who rent property are second most likely to have their loan 
request approved, but are also the most commonly declined. Meaning applicants
who rent, also apply for the most loans */
------------------------------------------------------

