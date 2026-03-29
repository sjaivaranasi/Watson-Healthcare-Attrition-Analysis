-- Watson Healthcare Employee Attrition Analysis
-- Milestone 4 Capstone Project
-- Tools: MySQL, DBeaver
-- Dataset: watson_healthcare_cleaned (1,676 employees, 43 columns after cleaning)

USE watson_healthcare;

-- ============================================================
-- QUESTION 1: What is the overall attrition rate in the dataset?
-- ============================================================
-- Logic: Count employees who left / total employees * 100

SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned;

-- Result: 11.87% (199 of 1,676)


-- ============================================================
-- QUESTION 2: How is the attrition rate distributed across different departments?
-- ============================================================
-- Logic: Same attrition rate calculation, grouped by department

SELECT 
    Department,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY Department
ORDER BY attrition_rate DESC;

-- Result: Cardiology 13.94% | Maternity 12.31% | Neurology 7.74%


-- ============================================================
-- QUESTION 3: What are the age demographics of employees who left vs stayed?
-- ============================================================
-- Logic: Compare average, min, max age between leavers and stayers

SELECT 
    Attrition,
    ROUND(AVG(Age), 2) AS avg_age,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age
FROM watson_healthcare_cleaned
GROUP BY Attrition;

-- Result: Stayed avg 37.67 | Left avg 30.90 (7 year gap)

-- Attrition rate by age bracket (using cleaned column)
SELECT 
    AgeBracket,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY AgeBracket
ORDER BY AgeBracket;


-- ============================================================
-- QUESTION 4: Is there a significant difference in attrition rates based on gender or education level?
-- ============================================================

-- 4a: By Gender
SELECT 
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY Gender;

-- Result: Female 12.68% | Male 11.32% (minimal difference)

-- 4b: By Education Level (using cleaned label column)
SELECT 
    EducationLevel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY EducationLevel
ORDER BY attrition_rate DESC;

-- Result: Below College 13.78% | Bachelor's 13.59% | College 10.87% | Master's 10.51% | Doctor 1.79%


-- ============================================================
-- QUESTION 5: How does job role impact the likelihood of attrition?
-- ============================================================

SELECT 
    JobRole,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY JobRole
ORDER BY attrition_rate DESC;

-- Result: Other 16.29% | Nurse 13.02% | Therapist 2.12% | Administrative 0.76%
-- Note: Admin and Administrative were merged during Python cleaning


-- ============================================================
-- QUESTION 6: What is the relationship between job satisfaction and attrition?
-- ============================================================

SELECT 
    JobSatisfaction,
    JobSatisfactionLevel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY JobSatisfaction, JobSatisfactionLevel
ORDER BY JobSatisfaction;

-- Result: Low 15.81% | Medium 13.55% | High 11.83% | Very High 8.49%
-- Clear inverse relationship: higher satisfaction = lower attrition


-- ============================================================
-- QUESTION 7: Does the distance from home affect employee attrition rates?
-- ============================================================

SELECT 
    DistanceBracket,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY DistanceBracket
ORDER BY attrition_rate DESC;

-- Result: 21+ miles 19.75% | 11-20 14.50% | 6-10 10.27% | 0-5 9.29%


-- ============================================================
-- QUESTION 8: How does work-life balance correlate with attrition?
-- ============================================================

SELECT 
    WorkLifeBalance,
    WorkLifeBalanceLevel,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY WorkLifeBalance, WorkLifeBalanceLevel
ORDER BY WorkLifeBalance;

-- Result: Low 26.67% | Medium 14.03% | High 9.73% | Very High 12.14%
-- Poor work-life balance is one of the strongest attrition predictors


-- ============================================================
-- QUESTION 9: Are there any trends between employee performance ratings and attrition?
-- ============================================================

SELECT 
    PerformanceRating,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

-- Result: Rating 3: 11.73% | Rating 4: 12.70%
-- Only 2 rating levels exist. Performance rating is NOT a meaningful predictor.
-- Recommendation: Improve the evaluation system to add granularity.


-- ============================================================
-- QUESTION 10: Is there a noticeable difference in attrition rates among different salary levels?
-- ============================================================

-- Average income comparison
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    MIN(MonthlyIncome) AS min_income,
    MAX(MonthlyIncome) AS max_income
FROM watson_healthcare_cleaned
GROUP BY Attrition;

-- By salary bracket (using cleaned column)
SELECT 
    SalaryBracket,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY SalaryBracket
ORDER BY attrition_rate DESC;

-- Result: Low (<3K) 26.23% | Mid 8.38% | High 6.49% | Very High 3.69%
-- Leavers avg $4,024 vs stayers avg $6,852. Compensation is a dominant factor.


-- ============================================================
-- QUESTION 11: How do years at the company influence attrition rates?
-- ============================================================

-- Average tenure comparison
SELECT 
    Attrition,
    ROUND(AVG(YearsAtCompany), 2) AS avg_years
FROM watson_healthcare_cleaned
GROUP BY Attrition;

-- By tenure bracket (using cleaned column)
SELECT 
    TenureBracket,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY TenureBracket
ORDER BY attrition_rate DESC;

-- Result: 0-2 years 27.65% | 3-5 10.18% | 6-10 6.81% | 10+ 2.46%
-- First 2 years are critical. Over 27% leave during this period.


-- ============================================================
-- QUESTION 12: What role do promotions and years in current role play in attrition?
-- ============================================================

SELECT 
    Attrition,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_years_since_promo,
    ROUND(AVG(YearsInCurrentRole), 2) AS avg_years_in_role
FROM watson_healthcare_cleaned
GROUP BY Attrition;

-- Result: Stayed: 2.30 yrs since promo, 4.54 in role | Left: 1.44 yrs since promo, 2.21 in role
-- Counterintuitive: leavers had fewer years since promotion because they're newer employees
-- who left before reaching promotion consideration.


-- ============================================================
-- QUESTION 13: Is there a correlation between the number of training hours and attrition?
-- ============================================================

SELECT 
    TrainingTimesLastYear,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;

-- Result: 0 trainings 21.31% | 1 training 5.95% | pattern not perfectly linear after that
-- Zero training is a major red flag for retention.


-- ============================================================
-- QUESTION 14: How does the availability of career development opportunities impact retention?
-- ============================================================

SELECT 
    Attrition,
    ROUND(AVG(TrainingTimesLastYear), 2) AS avg_training,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_since_promo,
    ROUND(AVG(YearsInCurrentRole), 2) AS avg_in_role,
    ROUND(AVG(JobLevel), 2) AS avg_job_level
FROM watson_healthcare_cleaned
GROUP BY Attrition;

-- Result: Leavers are at lower job levels (1.44 vs 2.15), less training, newer overall.
-- Attrition is concentrated among lower-level employees not yet in the career development pipeline.


-- ============================================================
-- QUESTION 15: Does overtime affect attrition? (My Own Question)
-- ============================================================
-- Rationale: Overtime is a known burnout factor in healthcare.
-- Testing whether it appears as an attrition driver in this dataset.

SELECT 
    OverTime,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS attrition_rate
FROM watson_healthcare_cleaned
GROUP BY OverTime;

-- Result: No overtime 5.0% | Yes overtime 29.2%
-- SINGLE BIGGEST FINDING. Nearly 6x difference.
-- Overtime creates a vicious cycle: understaffing -> overtime -> burnout -> more departures -> more understaffing


-- ============================================================
-- QUESTION 16: Summary - Key Factors and Recommendations
-- ============================================================
-- See working process document and slide deck for full analysis.
--
-- TOP 5 ATTRITION DRIVERS:
-- 1. Overtime (29.2% vs 5.0%)
-- 2. Low compensation (26.23% for under $3K/month)
-- 3. Short tenure (27.65% in first 2 years)
-- 4. Poor work-life balance (26.67% for lowest rating)
-- 5. Young age / low career level (avg leaver is 31, job level 1.44)
--
-- KEY RECOMMENDATIONS:
-- 1. Reduce mandatory overtime - hire additional staff
-- 2. Increase entry-level compensation
-- 3. Strengthen first-2-year onboarding experience
-- 4. Improve work-life balance with flexible scheduling
-- 5. Target nurse retention specifically (largest at-risk group)
-- 6. Ensure all employees receive at least basic training
-- 7. Offer remote/flexible options for non-patient-facing roles
