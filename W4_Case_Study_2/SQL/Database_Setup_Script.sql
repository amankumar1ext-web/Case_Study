CREATE DATABASE medicare_hospital;

show databases;

USE medicare_hospital;
SELECT DATABASE();

-- Creating all required Tables-- 
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    specialization VARCHAR(100),
    contact_no BIGINT
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(20),
    contact_no BIGINT,
    address VARCHAR(255),
    chronic_conditions VARCHAR(100)
);

CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    admission_date DATE,
    discharge_date DATE,
    diagnosis VARCHAR(100),
    doctor_id INT NOT NULL,
    room_no VARCHAR(20),

    CONSTRAINT fk_admission_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_admission_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY,
    admission_id INT NOT NULL,
    treatment_date DATE,
    procedure_name VARCHAR(100),
    medication VARCHAR(100),
    dosage VARCHAR(100),

    CONSTRAINT fk_treatment_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
);
DESCRIBE treatments;

CREATE TABLE vitals (
    vital_id INT PRIMARY KEY,
    admission_id INT NOT NULL,
    recorded_time DATETIME,
    heart_rate INT,
    blood_pressure VARCHAR(20),
    oxygen_level INT,
    temperature DECIMAL(5,2),

    CONSTRAINT fk_vitals_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
);
DESCRIBE vitals;

-- select count(*) from admissions;
-- select count(*) from doctors;
-- select count(*) from patients;
-- select count(*) from treatments;
-- select count(*) from vitals;

-- Validating-- 
USE medicare_hospital;

SELECT 'doctors' AS table_name, COUNT(*) AS row_count FROM doctors
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL
SELECT 'treatments', COUNT(*) FROM treatments
UNION ALL
SELECT 'vitals', COUNT(*) FROM vitals;

-- foreign key integrity -- 
-- Admissions → Patients
SELECT COUNT(*) AS invalid_patient_ids
FROM admissions a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Admissions → Doctors
SELECT COUNT(*) AS invalid_doctor_ids
FROM admissions a
LEFT JOIN doctors d
    ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-- Treatments → Admissions
SELECT COUNT(*) AS invalid_treatment_admission_ids
FROM treatments t
LEFT JOIN admissions a
    ON t.admission_id = a.admission_id
WHERE a.admission_id IS NULL;

-- Vitals → Admissions
SELECT COUNT(*) AS invalid_vital_admission_ids
FROM vitals v
LEFT JOIN admissions a
    ON v.admission_id = a.admission_id
WHERE a.admission_id IS NULL;

