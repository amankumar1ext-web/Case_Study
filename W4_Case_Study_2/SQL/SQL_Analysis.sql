-- Business SQL Analysis
-- Admission Volume by Diagnosis 
SELECT
    diagnosis,
    COUNT(*) AS admission_count
FROM admissions
GROUP BY diagnosis
ORDER BY admission_count DESC;

-- Average Length of Stay by Diagnosis
SELECT
    diagnosis,
    COUNT(*) AS admission_count,
    ROUND(AVG(DATEDIFF(discharge_date, admission_date)), 2) AS average_stay_days,
    MIN(DATEDIFF(discharge_date, admission_date)) AS minimum_stay_days,
    MAX(DATEDIFF(discharge_date, admission_date)) AS maximum_stay_days
FROM admissions
GROUP BY diagnosis
ORDER BY average_stay_days DESC;


-- doctor workload

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    COUNT(a.admission_id) AS admission_count
FROM doctors d
LEFT JOIN admissions a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY admission_count DESC;

-- Treatment Activity by Procedure
SELECT
    procedure_name,
    COUNT(*) AS treatment_count,
    COUNT(DISTINCT admission_id) AS admissions_with_treatment
FROM treatments
GROUP BY procedure_name
ORDER BY treatment_count DESC;

-- Patient Readmission Pattern
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.admission_id) AS admission_count
FROM patients p
JOIN admissions a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
HAVING COUNT(a.admission_id) > 1
ORDER BY admission_count DESC, p.patient_id;

-- prompt refined
SELECT
    admission_count,
    COUNT(*) AS patient_count
FROM (
    SELECT
        patient_id,
        COUNT(admission_id) AS admission_count
    FROM admissions
    GROUP BY patient_id
) AS patient_admissions
GROUP BY admission_count
ORDER BY admission_count;

-- Vital Signs Analysis
SELECT
    COUNT(*) AS vital_records,
    ROUND(AVG(heart_rate), 2) AS avg_heart_rate,
    ROUND(AVG(oxygen_level), 2) AS avg_oxygen_level,
    ROUND(AVG(temperature), 2) AS avg_temperature,
    ROUND(AVG(CAST(SUBSTRING_INDEX(blood_pressure, '/', 1) AS DECIMAL(10,2))), 2) AS avg_systolic,
    ROUND(AVG(CAST(SUBSTRING_INDEX(blood_pressure, '/', -1) AS DECIMAL(10,2))), 2) AS avg_diastolic
FROM vitals;