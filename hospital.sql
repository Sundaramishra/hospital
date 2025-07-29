-- Hospital CRM Database
-- Database: hospital
-- Character Set: utf8mb4
-- Collation: utf8mb4_unicode_ci
-- Engine: InnoDB

-- Create database
CREATE DATABASE IF NOT EXISTS `hospital` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `hospital`;

-- Roles table
CREATE TABLE `roles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `description` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users table
CREATE TABLE `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `email` varchar(100) NOT NULL,
    `password` varchar(255) NOT NULL,
    `role_id` int(11) NOT NULL,
    `is_active` tinyint(1) DEFAULT 1,
    `last_login` timestamp NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`),
    UNIQUE KEY `email` (`email`),
    FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Settings table
CREATE TABLE `settings` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `setting_key` varchar(100) NOT NULL,
    `setting_value` text,
    `description` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Patients table
CREATE TABLE `patients` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `patient_id` varchar(20) NOT NULL,
    `user_id` int(11) NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name` varchar(50) NOT NULL,
    `email` varchar(100),
    `phone` varchar(20),
    `date_of_birth` date,
    `gender` enum('Male','Female','Other'),
    `blood_group` varchar(5),
    `address` text,
    `emergency_contact` varchar(20),
    `emergency_contact_name` varchar(100),
    `photo` varchar(255),
    `medical_history` text,
    `allergies` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `patient_id` (`patient_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Doctors table
CREATE TABLE `doctors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name` varchar(50) NOT NULL,
    `email` varchar(100),
    `phone` varchar(20),
    `specialization` varchar(100),
    `qualification` varchar(100),
    `experience_years` int(11),
    `consultation_fee` decimal(10,2),
    `photo` varchar(255),
    `is_available` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Staff table
CREATE TABLE `staff` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name` varchar(50) NOT NULL,
    `email` varchar(100),
    `phone` varchar(20),
    `department` varchar(100),
    `position` varchar(100),
    `hire_date` date,
    `salary` decimal(10,2),
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Appointments table
CREATE TABLE `appointments` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `appointment_id` varchar(20) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11) NOT NULL,
    `appointment_date` date NOT NULL,
    `appointment_time` time NOT NULL,
    `reason` text,
    `status` enum('Scheduled','Confirmed','Completed','Cancelled','No-show') DEFAULT 'Scheduled',
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `appointment_id` (`appointment_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Prescriptions table
CREATE TABLE `prescriptions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11) NOT NULL,
    `appointment_id` int(11),
    `diagnosis` text,
    `prescription_date` date NOT NULL,
    `next_visit_date` date,
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Prescription details table
CREATE TABLE `prescription_details` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `prescription_id` int(11) NOT NULL,
    `medicine_name` varchar(100) NOT NULL,
    `dosage` varchar(50),
    `frequency` varchar(50),
    `duration` varchar(50),
    `instructions` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pharmacy table
CREATE TABLE `pharmacy` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `medicine_name` varchar(100) NOT NULL,
    `generic_name` varchar(100),
    `category` varchar(50),
    `manufacturer` varchar(100),
    `unit_price` decimal(10,2) NOT NULL,
    `stock_quantity` int(11) DEFAULT 0,
    `reorder_level` int(11) DEFAULT 10,
    `expiry_date` date,
    `description` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pharmacy sales table
CREATE TABLE `pharmacy_sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `sale_id` varchar(20) NOT NULL,
    `patient_id` int(11),
    `total_amount` decimal(10,2) NOT NULL,
    `payment_status` enum('Pending','Paid','Cancelled') DEFAULT 'Pending',
    `sale_date` timestamp DEFAULT CURRENT_TIMESTAMP,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `sale_id` (`sale_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pharmacy sale items table
CREATE TABLE `pharmacy_sale_items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `sale_id` int(11) NOT NULL,
    `medicine_id` int(11) NOT NULL,
    `quantity` int(11) NOT NULL,
    `unit_price` decimal(10,2) NOT NULL,
    `total_price` decimal(10,2) NOT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`sale_id`) REFERENCES `pharmacy_sales` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`medicine_id`) REFERENCES `pharmacy` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Laboratory table
CREATE TABLE `laboratory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_name` varchar(100) NOT NULL,
    `test_code` varchar(20),
    `category` varchar(50),
    `price` decimal(10,2) NOT NULL,
    `description` text,
    `preparation_instructions` text,
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `test_code` (`test_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Lab tests table
CREATE TABLE `lab_tests` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_id` varchar(20) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11) NOT NULL,
    `laboratory_id` int(11) NOT NULL,
    `test_date` date NOT NULL,
    `status` enum('Pending','In Progress','Completed','Cancelled') DEFAULT 'Pending',
    `result_date` date,
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `test_id` (`test_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`laboratory_id`) REFERENCES `laboratory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Laboratory results table
CREATE TABLE `laboratory_results` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_id` int(11) NOT NULL,
    `parameter_name` varchar(100) NOT NULL,
    `result_value` varchar(100),
    `normal_range` varchar(50),
    `unit` varchar(20),
    `is_abnormal` tinyint(1) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Billing table
CREATE TABLE `billing` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `bill_id` varchar(20) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `bill_date` date NOT NULL,
    `total_amount` decimal(10,2) NOT NULL,
    `discount_amount` decimal(10,2) DEFAULT 0.00,
    `tax_amount` decimal(10,2) DEFAULT 0.00,
    `final_amount` decimal(10,2) NOT NULL,
    `payment_status` enum('Pending','Paid','Partial','Cancelled') DEFAULT 'Pending',
    `payment_method` varchar(50),
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `bill_id` (`bill_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bill items table
CREATE TABLE `bill_items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `bill_id` int(11) NOT NULL,
    `item_type` enum('Consultation','Medicine','Lab Test','Other') NOT NULL,
    `item_name` varchar(100) NOT NULL,
    `quantity` int(11) DEFAULT 1,
    `unit_price` decimal(10,2) NOT NULL,
    `total_price` decimal(10,2) NOT NULL,
    `description` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`bill_id`) REFERENCES `billing` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Blood donors table
CREATE TABLE `blood_donors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donor_id` varchar(20) NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name` varchar(50) NOT NULL,
    `email` varchar(100),
    `phone` varchar(20),
    `date_of_birth` date,
    `gender` enum('Male','Female','Other'),
    `blood_group` varchar(5) NOT NULL,
    `address` text,
    `emergency_contact` varchar(20),
    `medical_history` text,
    `is_eligible` tinyint(1) DEFAULT 1,
    `last_donation_date` date,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `donor_id` (`donor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Blood donations table
CREATE TABLE `blood_donations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donation_id` varchar(20) NOT NULL,
    `donor_id` int(11) NOT NULL,
    `donation_date` date NOT NULL,
    `blood_group` varchar(5) NOT NULL,
    `quantity_ml` int(11) NOT NULL,
    `hemoglobin_level` decimal(4,2),
    `blood_pressure` varchar(20),
    `pulse_rate` int(11),
    `donation_type` enum('Voluntary','Replacement','Emergency') DEFAULT 'Voluntary',
    `status` enum('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `donation_id` (`donation_id`),
    FOREIGN KEY (`donor_id`) REFERENCES `blood_donors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Blood inventory table
CREATE TABLE `blood_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `blood_group` varchar(5) NOT NULL,
    `quantity_ml` int(11) DEFAULT 0,
    `expiry_date` date,
    `status` enum('Available','Reserved','Expired','Discarded') DEFAULT 'Available',
    `donation_id` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`donation_id`) REFERENCES `blood_donations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Blood requests table
CREATE TABLE `blood_requests` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `request_id` varchar(20) NOT NULL,
    `patient_id` int(11),
    `requested_by` varchar(100) NOT NULL,
    `blood_group` varchar(5) NOT NULL,
    `quantity_ml` int(11) NOT NULL,
    `urgency` enum('Normal','Urgent','Emergency') DEFAULT 'Normal',
    `request_date` date NOT NULL,
    `required_date` date,
    `status` enum('Pending','Approved','Completed','Cancelled') DEFAULT 'Pending',
    `reason` text,
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `request_id` (`request_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Organ donors table
CREATE TABLE `organ_donors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donor_id` varchar(20) NOT NULL,
    `first_name` varchar(50) NOT NULL,
    `last_name` varchar(50) NOT NULL,
    `email` varchar(100),
    `phone` varchar(20),
    `date_of_birth` date,
    `gender` enum('Male','Female','Other'),
    `blood_group` varchar(5),
    `address` text,
    `emergency_contact` varchar(20),
    `organs_to_donate` text,
    `donation_type` enum('Living','Deceased') DEFAULT 'Living',
    `is_registered` tinyint(1) DEFAULT 0,
    `registration_date` date,
    `medical_history` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `donor_id` (`donor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Organ recipients table
CREATE TABLE `organ_recipients` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `recipient_id` varchar(20) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `organ_needed` varchar(100) NOT NULL,
    `blood_group` varchar(5),
    `urgency` enum('Low','Medium','High','Critical') DEFAULT 'Medium',
    `waiting_since` date,
    `status` enum('Waiting','Matched','Transplanted','Removed') DEFAULT 'Waiting',
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `recipient_id` (`recipient_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Organ transplants table
CREATE TABLE `organ_transplants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `transplant_id` varchar(20) NOT NULL,
    `donor_id` int(11) NOT NULL,
    `recipient_id` int(11) NOT NULL,
    `organ` varchar(100) NOT NULL,
    `transplant_date` date NOT NULL,
    `surgeon` varchar(100),
    `hospital` varchar(100),
    `status` enum('Scheduled','Completed','Cancelled','Failed') DEFAULT 'Scheduled',
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `transplant_id` (`transplant_id`),
    FOREIGN KEY (`donor_id`) REFERENCES `organ_donors` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`recipient_id`) REFERENCES `organ_recipients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insurance companies table
CREATE TABLE `insurance_companies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `company_name` varchar(100) NOT NULL,
    `contact_person` varchar(100),
    `email` varchar(100),
    `phone` varchar(20),
    `address` text,
    `website` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Patient insurance policies table
CREATE TABLE `patient_insurance_policies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `patient_id` int(11) NOT NULL,
    `insurance_company_id` int(11) NOT NULL,
    `policy_number` varchar(50) NOT NULL,
    `policy_type` varchar(50),
    `coverage_amount` decimal(12,2),
    `premium_amount` decimal(10,2),
    `start_date` date,
    `end_date` date,
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `policy_number` (`policy_number`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`insurance_company_id`) REFERENCES `insurance_companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insurance claims table
CREATE TABLE `insurance_claims` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `claim_id` varchar(20) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `policy_id` int(11) NOT NULL,
    `bill_id` int(11) NOT NULL,
    `claim_amount` decimal(10,2) NOT NULL,
    `claim_date` date NOT NULL,
    `status` enum('Pending','Approved','Rejected','Paid') DEFAULT 'Pending',
    `approved_amount` decimal(10,2),
    `rejection_reason` text,
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `claim_id` (`claim_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`policy_id`) REFERENCES `patient_insurance_policies` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`bill_id`) REFERENCES `billing` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Equipment table
CREATE TABLE `equipment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `equipment_id` varchar(20) NOT NULL,
    `name` varchar(100) NOT NULL,
    `category` varchar(50),
    `manufacturer` varchar(100),
    `model` varchar(100),
    `serial_number` varchar(100),
    `purchase_date` date,
    `warranty_expiry` date,
    `location` varchar(100),
    `status` enum('Available','In Use','Maintenance','Out of Order') DEFAULT 'Available',
    `last_maintenance` date,
    `next_maintenance` date,
    `notes` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `equipment_id` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications table
CREATE TABLE `notifications` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `title` varchar(255) NOT NULL,
    `message` text NOT NULL,
    `type` enum('Info','Success','Warning','Error') DEFAULT 'Info',
    `is_read` tinyint(1) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activity logs table
CREATE TABLE `activity_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11),
    `action` varchar(100) NOT NULL,
    `table_name` varchar(50),
    `record_id` int(11),
    `description` text,
    `ip_address` varchar(45),
    `user_agent` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert initial data
INSERT INTO `roles` (`name`, `description`) VALUES
('admin', 'System Administrator with full access'),
('receptionist', 'Front desk staff for patient registration'),
('doctor', 'Medical professionals'),
('patient', 'Hospital patients'),
('pharmacy_staff', 'Pharmacy department staff'),
('lab_technician', 'Laboratory technicians'),
('nurse', 'Nursing staff'),
('accountant', 'Billing and accounting staff');

-- Insert default admin user (password: admin123)
INSERT INTO `users` (`username`, `email`, `password`, `role_id`) VALUES
('admin', 'admin@hospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);

-- Insert default settings
INSERT INTO `settings` (`setting_key`, `setting_value`, `description`) VALUES
('hospital_name', 'General Hospital', 'Hospital name displayed throughout the system'),
('hospital_address', '123 Main Street, City, State 12345', 'Hospital address'),
('hospital_phone', '+1-555-123-4567', 'Hospital contact phone number'),
('hospital_email', 'info@hospital.com', 'Hospital contact email'),
('hospital_website', 'www.hospital.com', 'Hospital website URL'),
('currency', 'USD', 'Default currency for billing'),
('timezone', 'UTC', 'System timezone'),
('date_format', 'Y-m-d', 'Date format for display'),
('time_format', 'H:i:s', 'Time format for display'),
('appointment_duration', '30', 'Default appointment duration in minutes'),
('consultation_fee', '50.00', 'Default consultation fee'),
('tax_rate', '8.5', 'Default tax rate percentage'),
('logo_path', 'assets/images/logo.png', 'Hospital logo file path'),
('favicon_path', 'assets/images/favicon.ico', 'Favicon file path'),
('theme_color', '#007bff', 'Primary theme color'),
('secondary_color', '#6c757d', 'Secondary theme color'),
('max_file_size', '5242880', 'Maximum file upload size in bytes (5MB)'),
('allowed_file_types', 'jpg,jpeg,png,gif,pdf,doc,docx', 'Allowed file types for uploads'),
('email_notifications', '1', 'Enable email notifications (1=yes, 0=no)'),
('sms_notifications', '0', 'Enable SMS notifications (1=yes, 0=no)'),
('maintenance_mode', '0', 'Maintenance mode (1=yes, 0=no)'),
('session_timeout', '3600', 'Session timeout in seconds'),
('password_expiry_days', '90', 'Password expiry in days'),
('min_password_length', '8', 'Minimum password length'),
('require_strong_password', '1', 'Require strong password (1=yes, 0=no)'),
('max_login_attempts', '5', 'Maximum login attempts before lockout'),
('lockout_duration', '900', 'Account lockout duration in seconds'),
('backup_frequency', 'daily', 'Database backup frequency'),
('backup_retention_days', '30', 'Number of days to retain backups'),
('patient_id_prefix', 'P', 'Prefix for patient ID generation'),
('doctor_id_prefix', 'D', 'Prefix for doctor ID generation'),
('appointment_id_prefix', 'APT', 'Prefix for appointment ID generation'),
('bill_id_prefix', 'BILL', 'Prefix for bill ID generation'),
('prescription_id_prefix', 'PRESC', 'Prefix for prescription ID generation'),
('lab_test_id_prefix', 'LAB', 'Prefix for lab test ID generation'),
('blood_donation_id_prefix', 'BD', 'Prefix for blood donation ID generation'),
('organ_donor_id_prefix', 'OD', 'Prefix for organ donor ID generation'),
('insurance_claim_id_prefix', 'IC', 'Prefix for insurance claim ID generation'),
('equipment_id_prefix', 'EQ', 'Prefix for equipment ID generation');

-- Create indexes for better performance
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_staff_user_id ON staff(user_id);
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX idx_pharmacy_sales_patient_id ON pharmacy_sales(patient_id);
CREATE INDEX idx_lab_tests_patient_id ON lab_tests(patient_id);
CREATE INDEX idx_lab_tests_doctor_id ON lab_tests(doctor_id);
CREATE INDEX idx_billing_patient_id ON billing(patient_id);
CREATE INDEX idx_billing_date ON billing(bill_date);
CREATE INDEX idx_blood_donations_donor_id ON blood_donations(donor_id);
CREATE INDEX idx_blood_requests_patient_id ON blood_requests(patient_id);
CREATE INDEX idx_organ_recipients_patient_id ON organ_recipients(patient_id);
CREATE INDEX idx_insurance_claims_patient_id ON insurance_claims(patient_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);