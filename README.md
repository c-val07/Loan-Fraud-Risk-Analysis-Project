# Loan Application and Fraud Risk Analysis

## Overview

This project analyzes loan application and repayment data to uncover trends in loan approvals, declines, 
and fraudulent activity. By leveraging SQL, I explored applicant demographics, financial metrics, loan 
characteristics, and fraud indicators to support data-driven decisions for risk assessment and lending 
optimization.

---

## Dataset Description

The project utilized the following tables:

loan_applications: Contains applicant demographic details, financial information, loan requests, and outcomes.

transactions: Contains transactional information linked to loan disbursements and repayments.

loan_applications1 & transactions1: Duplicates of the original tables created for safe modifications 
and data cleaning.

Key Columns in loan_applications1:
application_id, customer_id, loan_amount_requested, loan_tenure_months, interest_rate_offered, 
monthly_income, credit_score, debt_to_income_ratio, loan_status, employment_status, applicant_age, 
loan_type, purpose_of_loan, property_ownership_status, fraud_flag, fraud_type

---

## Project Objectives

* Determine loan approval, decline, and fraud rates across the dataset.
* Identify which loan types, purposes, and applicant demographics carry higher risk of decline.
* Analyze credit score distributions between approved and declined loans.
* Evaluate the impact of income brackets and age groups on loan outcomes.
* Quantify fraud types and their associated financial impact.
* Examine loan requests by property ownership and employment status to uncover trends.

---

## Methodology

### 1. Data Preparation

*Created duplicate tables (loan_applications1 and transactions1) to safely modify and clean the dataset.
*Checked for null or zero values in key fields such as debt_to_income_ratio, number_of_dependents, and fraud_flag.
*Updated blank fraud_type entries to "None" for clarity.
*Verified unique application IDs and removed duplicates as needed.

### 2. Loan Volume and Approval Analysis

*Aggregated total loans requested, approved, and declined.
*Calculated percentages of approvals, declines, and fraud cases.
*Analyzed the total loan value approved versus declined.

### 3. Fraud Analysis

*Grouped loans by fraud_type to determine frequency and total requested amounts.
*Compared top fraud types to quantify the financial impact of each.
*Demographic and Loan Characteristics Analysis
*Evaluated average credit scores for approved versus declined loans.
*Analyzed declines by income group, age group, and employment status.
*Assessed loan approval and decline trends based on loan type, purpose, and property ownership.
*Examined interest rates offered across income brackets to identify patterns.

### 4. Validation

*Cross-checked results for consistency and completeness.
*Verified that all cleaning steps (e.g., duplicate removal, null updates) preserved data integrity.

---

## Key Findings

*Loan Outcomes: 81.7% of applications were approved, 16.1% declined, and approximately 2% flagged as fraudulent.
*Fraud Trends: Synthetic identity fraud was the most frequent and highest-impact fraud type, with total 
loan requests exceeding $1.5M.
*Credit Score Insights: Approved applicants had an average credit score of 714, while declined 
applicants averaged 624.
*Loan Types and Risk: Home loans were the most requested and most frequently declined (16.3% decline rate).
*Income and Age Trends: Higher-income applicants showed slightly higher decline rates (16.35%) 
than lower-income groups (15.74%). Applicants aged 30–50 had marginally higher declination rates 
(16.26%) than those under 30 or over 50 (16.11%).
*Purpose and Property: Loans for medical emergencies were most frequently approved; applicants 
renting property were commonly declined but represented a high volume of requests.

---

## Skills Demonstrated

*SQL querying: SELECT, JOIN, GROUP BY, CASE WHEN, aggregation (SUM, COUNT, AVG)
*Data cleaning and validation: handling nulls, duplicates, and inconsistent fields
*Data aggregation and segmentation by demographic and financial characteristics
*Fraud detection and analysis
*Translating raw data into actionable insights for risk assessment

---

## Tools Used

*MySQL: Data querying, aggregation, and cleaning
*SQL Workbench / MySQL client: Query execution and table management

---
