-- Hospital CRM Database Structure
-- Database Name: hospital

CREATE DATABASE IF NOT EXISTS `hospital` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `hospital`;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS `activity_logs`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `laboratory_results`;
DROP TABLE IF EXISTS `lab_tests`;
DROP TABLE IF EXISTS `laboratory`;
DROP TABLE IF EXISTS `pharmacy_sale_items`;
DROP TABLE IF EXISTS `pharmacy_sales`;
DROP TABLE IF EXISTS `pharmacy`;
DROP TABLE IF EXISTS `prescription_details`;
DROP TABLE IF EXISTS `prescriptions`;
DROP TABLE IF EXISTS `billing`;
DROP TABLE IF EXISTS `appointments`;
DROP TABLE IF EXISTS `blood_requests`;
DROP TABLE IF EXISTS `blood_inventory`;
DROP TABLE IF EXISTS `blood_donations`;
DROP TABLE IF EXISTS `blood_donors`;
DROP TABLE IF EXISTS `organ_transplants`;
DROP TABLE IF EXISTS `organ_recipients`;
DROP TABLE IF EXISTS `organ_donors`;
DROP TABLE IF EXISTS `insurance_claims`;
DROP TABLE IF EXISTS `patient_insurance_policies`;
DROP TABLE IF EXISTS `insurance_companies`;
DROP TABLE IF EXISTS `equipment`;
DROP TABLE IF EXISTS `staff`;
DROP TABLE IF EXISTS `doctors`;
DROP TABLE IF EXISTS `patients`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;

-- Create roles table
CREATE TABLE `roles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `role_name` varchar(50) NOT NULL UNIQUE,
    `role_display_name` varchar(100) NOT NULL,
    `description` text,
    `permissions` text,
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create users table
CREATE TABLE `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(100) NOT NULL UNIQUE,
    `email` varchar(255) NOT NULL UNIQUE,
    `password_hash` varchar(255) NOT NULL,
    `role_id` int(11) NOT NULL,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `phone` varchar(20),
    `address` text,
    `profile_photo` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `last_login` timestamp NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create settings table (for customization)
CREATE TABLE `settings` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `setting_key` varchar(100) NOT NULL UNIQUE,
    `setting_value` text,
    `setting_type` enum('text','number','boolean','file','textarea') DEFAULT 'text',
    `category` varchar(50) DEFAULT 'general',
    `description` text,
    `is_public` tinyint(1) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create patients table
CREATE TABLE `patients` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `patient_id` varchar(20) NOT NULL UNIQUE,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `email` varchar(255) NOT NULL UNIQUE,
    `phone` varchar(20),
    `address` text,
    `date_of_birth` date,
    `gender` enum('male','female','other') DEFAULT 'male',
    `blood_group` varchar(10),
    `emergency_contact_name` varchar(100),
    `emergency_contact_phone` varchar(20),
    `medical_history` text,
    `allergies` text,
    `photo` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create doctors table
CREATE TABLE `doctors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11),
    `doctor_name` varchar(100) NOT NULL,
    `specialization` varchar(100),
    `qualification` varchar(100),
    `phone` varchar(20),
    `email` varchar(255) NOT NULL UNIQUE,
    `address` text,
    `consultation_fee` decimal(10,2) DEFAULT 0.00,
    `experience_years` int(3) DEFAULT 0,
    `schedule` text,
    `photo` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create staff table
CREATE TABLE `staff` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11),
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `email` varchar(255) NOT NULL UNIQUE,
    `phone` varchar(20),
    `address` text,
    `position` varchar(100),
    `department` varchar(100),
    `hire_date` date,
    `salary` decimal(10,2),
    `photo` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create appointments table
CREATE TABLE `appointments` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `appointment_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11) NOT NULL,
    `appointment_date` date NOT NULL,
    `appointment_time` time NOT NULL,
    `appointment_type` enum('consultation','emergency','follow_up','surgery') DEFAULT 'consultation',
    `reason` text,
    `status` enum('scheduled','confirmed','in_progress','completed','cancelled','no_show') DEFAULT 'scheduled',
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create prescriptions table
CREATE TABLE `prescriptions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `prescription_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11) NOT NULL,
    `diagnosis` text,
    `notes` text,
    `status` enum('active','completed','cancelled') DEFAULT 'active',
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create prescription_details table
CREATE TABLE `prescription_details` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `prescription_id` int(11) NOT NULL,
    `medicine_name` varchar(255) NOT NULL,
    `dosage` varchar(100),
    `frequency` varchar(100),
    `duration` varchar(100),
    `instructions` text,
    `quantity` int(11) DEFAULT 1,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create pharmacy table
CREATE TABLE `pharmacy` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `medicine_name` varchar(255) NOT NULL,
    `generic_name` varchar(255),
    `category` varchar(100),
    `manufacturer` varchar(255),
    `batch_number` varchar(100),
    `expiry_date` date,
    `unit_price` decimal(10,2) DEFAULT 0.00,
    `stock_quantity` int(11) DEFAULT 0,
    `min_stock_level` int(11) DEFAULT 10,
    `reorder_level` int(11) DEFAULT 5,
    `description` text,
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create pharmacy_sales table
CREATE TABLE `pharmacy_sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `sale_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11),
    `sale_date` date NOT NULL,
    `total_amount` decimal(10,2) DEFAULT 0.00,
    `payment_status` enum('pending','paid','partial') DEFAULT 'pending',
    `payment_method` varchar(50),
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create pharmacy_sale_items table
CREATE TABLE `pharmacy_sale_items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `sale_id` int(11) NOT NULL,
    `medicine_id` int(11) NOT NULL,
    `quantity` int(11) NOT NULL,
    `unit_price` decimal(10,2) NOT NULL,
    `total_price` decimal(10,2) NOT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`sale_id`) REFERENCES `pharmacy_sales`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`medicine_id`) REFERENCES `pharmacy`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create laboratory table
CREATE TABLE `laboratory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_name` varchar(255) NOT NULL,
    `test_code` varchar(50) UNIQUE,
    `category` varchar(100),
    `price` decimal(10,2) DEFAULT 0.00,
    `description` text,
    `preparation_instructions` text,
    `normal_range` varchar(255),
    `unit` varchar(50),
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create lab_tests table
CREATE TABLE `lab_tests` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_order_id` varchar(20) NOT NULL,
    `test_id` int(11) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11),
    `test_date` date NOT NULL,
    `status` enum('pending','in_progress','completed','cancelled') DEFAULT 'pending',
    `priority` enum('normal','urgent','emergency') DEFAULT 'normal',
    `notes` text,
    `total_amount` decimal(10,2) DEFAULT 0.00,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`test_id`) REFERENCES `laboratory`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create laboratory_results table
CREATE TABLE `laboratory_results` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `test_id` int(11) NOT NULL,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11),
    `result_value` text,
    `notes` text,
    `test_date` date NOT NULL,
    `status` enum('pending','completed','abnormal') DEFAULT 'pending',
    `conducted_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`test_id`) REFERENCES `lab_tests`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`conducted_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create billing table
CREATE TABLE `billing` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `bill_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `bill_date` date NOT NULL,
    `due_date` date NOT NULL,
    `total_amount` decimal(10,2) DEFAULT 0.00,
    `discount_amount` decimal(10,2) DEFAULT 0.00,
    `tax_amount` decimal(10,2) DEFAULT 0.00,
    `paid_amount` decimal(10,2) DEFAULT 0.00,
    `balance_amount` decimal(10,2) DEFAULT 0.00,
    `payment_status` enum('pending','paid','partial','overdue') DEFAULT 'pending',
    `payment_method` varchar(50),
    `appointment_id` int(11),
    `pharmacy_sale_id` int(11),
    `lab_test_id` int(11),
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`appointment_id`) REFERENCES `appointments`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`pharmacy_sale_id`) REFERENCES `pharmacy_sales`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`lab_test_id`) REFERENCES `lab_tests`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create blood_donors table
CREATE TABLE `blood_donors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donor_id` varchar(20) NOT NULL UNIQUE,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `email` varchar(255) UNIQUE,
    `phone` varchar(20),
    `date_of_birth` date,
    `gender` enum('male','female','other') DEFAULT 'male',
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    `address` text,
    `emergency_contact` varchar(100),
    `emergency_phone` varchar(20),
    `last_donation_date` date,
    `donation_count` int(11) DEFAULT 0,
    `status` enum('active','inactive','deceased') DEFAULT 'active',
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create blood_donations table
CREATE TABLE `blood_donations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donation_id` varchar(20) NOT NULL UNIQUE,
    `donor_id` int(11) NOT NULL,
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    `units_collected` int(11) NOT NULL,
    `donation_date` date NOT NULL,
    `collection_site` varchar(255),
    `staff_id` int(11),
    `hemoglobin_level` decimal(5,2),
    `blood_pressure` varchar(20),
    `temperature` decimal(4,2),
    `weight` decimal(5,2),
    `medical_notes` text,
    `status` enum('collected','processed','expired','used') DEFAULT 'collected',
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`donor_id`) REFERENCES `blood_donors`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`staff_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create blood_inventory table
CREATE TABLE `blood_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    `units_available` int(11) DEFAULT 0,
    `expiry_date` date NOT NULL,
    `source_donation_id` int(11),
    `status` enum('available','reserved','expired','used') DEFAULT 'available',
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`source_donation_id`) REFERENCES `blood_donations`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create blood_requests table
CREATE TABLE `blood_requests` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `request_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    `units_requested` int(11) NOT NULL,
    `urgency_level` enum('normal','urgent','emergency') DEFAULT 'normal',
    `requested_by` int(11),
    `request_date` date NOT NULL,
    `required_date` date NOT NULL,
    `purpose` text,
    `status` enum('pending','approved','fulfilled','cancelled') DEFAULT 'pending',
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`requested_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create organ_donors table
CREATE TABLE `organ_donors` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `donor_id` varchar(20) NOT NULL UNIQUE,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `email` varchar(255) UNIQUE,
    `phone` varchar(20),
    `date_of_birth` date,
    `gender` enum('male','female','other') DEFAULT 'male',
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-'),
    `address` text,
    `emergency_contact` varchar(100),
    `emergency_phone` varchar(20),
    `organs_to_donate` text,
    `medical_history` text,
    `status` enum('active','inactive','deceased') DEFAULT 'active',
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create organ_recipients table
CREATE TABLE `organ_recipients` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `recipient_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `doctor_id` int(11),
    `organ_needed` varchar(100) NOT NULL,
    `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-'),
    `urgency_level` enum('low','medium','high','critical') DEFAULT 'medium',
    `priority_score` int(11) DEFAULT 0,
    `medical_condition` text,
    `status` enum('waiting','matched','transplanted','cancelled') DEFAULT 'waiting',
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create organ_transplants table
CREATE TABLE `organ_transplants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `transplant_id` varchar(20) NOT NULL UNIQUE,
    `donor_id` int(11) NOT NULL,
    `recipient_id` int(11) NOT NULL,
    `organ` varchar(100) NOT NULL,
    `surgeon_id` int(11),
    `transplant_date` date,
    `status` enum('scheduled','in_progress','completed','cancelled') DEFAULT 'scheduled',
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`donor_id`) REFERENCES `organ_donors`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`recipient_id`) REFERENCES `organ_recipients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`surgeon_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create insurance_companies table
CREATE TABLE `insurance_companies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `company_name` varchar(255) NOT NULL,
    `company_code` varchar(50) UNIQUE,
    `contact_person` varchar(100),
    `contact_email` varchar(255),
    `contact_phone` varchar(20),
    `address` text,
    `website` varchar(255),
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create patient_insurance_policies table
CREATE TABLE `patient_insurance_policies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `patient_id` int(11) NOT NULL,
    `insurance_company_id` int(11) NOT NULL,
    `policy_number` varchar(100) NOT NULL,
    `policy_type` varchar(100),
    `coverage_amount` decimal(12,2),
    `premium_amount` decimal(10,2),
    `start_date` date,
    `end_date` date,
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`insurance_company_id`) REFERENCES `insurance_companies`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create insurance_claims table
CREATE TABLE `insurance_claims` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `claim_id` varchar(20) NOT NULL UNIQUE,
    `patient_id` int(11) NOT NULL,
    `insurance_company_id` int(11) NOT NULL,
    `policy_id` int(11),
    `bill_id` int(11),
    `claim_amount` decimal(10,2) NOT NULL,
    `approved_amount` decimal(10,2),
    `claim_date` date NOT NULL,
    `status` enum('pending','approved','rejected','paid') DEFAULT 'pending',
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`insurance_company_id`) REFERENCES `insurance_companies`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`policy_id`) REFERENCES `patient_insurance_policies`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`bill_id`) REFERENCES `billing`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create equipment table
CREATE TABLE `equipment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `equipment_name` varchar(255) NOT NULL,
    `equipment_code` varchar(50) UNIQUE,
    `category` varchar(100),
    `manufacturer` varchar(255),
    `model` varchar(100),
    `serial_number` varchar(100),
    `purchase_date` date,
    `warranty_expiry` date,
    `location` varchar(255),
    `status` enum('available','in_use','maintenance','out_of_order') DEFAULT 'available',
    `last_maintenance` date,
    `next_maintenance` date,
    `notes` text,
    `created_by` int(11),
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create notifications table
CREATE TABLE `notifications` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `title` varchar(255) NOT NULL,
    `message` text NOT NULL,
    `type` enum('info','success','warning','error') DEFAULT 'info',
    `is_read` tinyint(1) DEFAULT 0,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create activity_logs table
CREATE TABLE `activity_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11),
    `action` varchar(100) NOT NULL,
    `description` text,
    `module` varchar(50) DEFAULT 'system',
    `ip_address` varchar(45),
    `user_agent` text,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default roles
INSERT INTO `roles` (`role_name`, `role_display_name`, `description`, `permissions`) VALUES
('admin', 'Administrator', 'Full system access', 'all'),
('doctor', 'Doctor', 'Doctor access to patients and appointments', 'patients,appointments,prescriptions'),
('nurse', 'Nurse', 'Nurse access to patient care', 'patients,appointments'),
('receptionist', 'Receptionist', 'Reception and appointment management', 'patients,appointments,billing'),
('pharmacy_staff', 'Pharmacy Staff', 'Pharmacy management access', 'pharmacy,prescriptions'),
('lab_technician', 'Lab Technician', 'Laboratory test management', 'laboratory,lab_tests'),
('patient', 'Patient', 'Patient portal access', 'own_data');

-- Insert default admin user (password: admin123)
INSERT INTO `users` (`username`, `email`, `password_hash`, `role_id`, `first_name`, `last_name`, `phone`, `is_active`) VALUES
('admin', 'admin@hospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'System', 'Administrator', '1234567890', 1);

-- Insert default settings data
INSERT INTO `settings` (`setting_key`, `setting_value`, `setting_type`, `category`, `description`, `is_public`) VALUES
('site_name', 'Hospital CRM System', 'text', 'general', 'Hospital name', 1),
('site_description', 'Comprehensive Hospital Management System', 'text', 'general', 'Site description', 1),
('site_logo', '', 'file', 'general', 'Hospital logo', 1),
('site_favicon', '', 'file', 'general', 'Site favicon', 1),
('contact_email', 'info@hospital.com', 'text', 'contact', 'Contact email', 1),
('contact_phone', '+91-1234567890', 'text', 'contact', 'Contact phone', 1),
('contact_address', '123 Hospital Street, City, State, PIN', 'textarea', 'contact', 'Hospital address', 1),
('currency', 'INR', 'text', 'billing', 'Default currency', 0),
('tax_rate', '18', 'number', 'billing', 'Default tax rate (%)', 0),
('appointment_duration', '30', 'number', 'appointments', 'Default appointment duration (minutes)', 0),
('max_appointments_per_day', '50', 'number', 'appointments', 'Maximum appointments per day', 0),
('blood_expiry_days', '42', 'number', 'blood_bank', 'Blood expiry days', 0),
('pharmacy_low_stock_threshold', '10', 'number', 'pharmacy', 'Low stock threshold', 0),
('lab_result_days', '3', 'number', 'laboratory', 'Default lab result days', 0),
('enable_notifications', '1', 'boolean', 'system', 'Enable system notifications', 0),
('maintenance_mode', '0', 'boolean', 'system', 'Maintenance mode', 0),
('session_timeout', '3600', 'number', 'security', 'Session timeout (seconds)', 0),
('password_min_length', '6', 'number', 'security', 'Minimum password length', 0),
('file_upload_max_size', '5242880', 'number', 'system', 'Maximum file upload size (bytes)', 0),
('allowed_file_types', 'jpg,jpeg,png,gif,pdf,doc,docx', 'text', 'system', 'Allowed file types', 0);

-- Insert sample laboratory tests
INSERT INTO `laboratory` (`test_name`, `test_code`, `category`, `price`, `description`, `normal_range`, `unit`) VALUES
('Complete Blood Count', 'CBC001', 'Hematology', 500.00, 'Complete blood count test', '4.5-11.0', 'cells/μL'),
('Blood Glucose (Fasting)', 'BG001', 'Biochemistry', 300.00, 'Fasting blood glucose test', '70-100', 'mg/dL'),
('Lipid Profile', 'LP001', 'Biochemistry', 800.00, 'Complete lipid profile', 'Total: <200', 'mg/dL'),
('Liver Function Test', 'LFT001', 'Biochemistry', 600.00, 'Liver function tests', 'ALT: 7-55', 'U/L'),
('Kidney Function Test', 'KFT001', 'Biochemistry', 700.00, 'Kidney function tests', 'Creatinine: 0.7-1.3', 'mg/dL'),
('Urine Analysis', 'UA001', 'Urinalysis', 200.00, 'Complete urine analysis', 'pH: 4.5-8.0', ''),
('X-Ray Chest', 'XRC001', 'Radiology', 400.00, 'Chest X-Ray', 'Normal', ''),
('ECG', 'ECG001', 'Cardiology', 350.00, 'Electrocardiogram', 'Normal sinus rhythm', ''),
('Ultrasound Abdomen', 'US001', 'Radiology', 1200.00, 'Abdominal ultrasound', 'Normal', ''),
('MRI Brain', 'MRI001', 'Radiology', 5000.00, 'Brain MRI scan', 'Normal', '');

-- Insert sample pharmacy medicines
INSERT INTO `pharmacy` (`medicine_name`, `generic_name`, `category`, `manufacturer`, `unit_price`, `stock_quantity`, `min_stock_level`, `description`) VALUES
('Paracetamol 500mg', 'Acetaminophen', 'Pain Relief', 'Generic Pharma', 5.00, 1000, 50, 'Pain and fever relief'),
('Amoxicillin 500mg', 'Amoxicillin', 'Antibiotics', 'MediCorp', 15.00, 500, 25, 'Broad spectrum antibiotic'),
('Omeprazole 20mg', 'Omeprazole', 'Gastrointestinal', 'HealthCare Ltd', 25.00, 300, 20, 'Acid reflux medication'),
('Metformin 500mg', 'Metformin', 'Diabetes', 'DiabeCare', 12.00, 400, 30, 'Diabetes medication'),
('Amlodipine 5mg', 'Amlodipine', 'Cardiovascular', 'CardioPharm', 18.00, 250, 15, 'Blood pressure medication'),
('Cetirizine 10mg', 'Cetirizine', 'Allergy', 'AllerCare', 8.00, 600, 40, 'Allergy relief'),
('Ibuprofen 400mg', 'Ibuprofen', 'Pain Relief', 'PainFree Inc', 7.00, 800, 35, 'Anti-inflammatory pain relief'),
('Vitamin D3 1000IU', 'Cholecalciferol', 'Vitamins', 'VitaHealth', 20.00, 200, 10, 'Vitamin D supplement'),
('Calcium Carbonate 500mg', 'Calcium Carbonate', 'Minerals', 'MineralCorp', 30.00, 150, 8, 'Calcium supplement'),
('Iron Sulfate 325mg', 'Ferrous Sulfate', 'Minerals', 'IronHealth', 22.00, 180, 12, 'Iron supplement');

-- Insert sample equipment
INSERT INTO `equipment` (`equipment_name`, `equipment_code`, `category`, `manufacturer`, `model`, `status`, `location`) VALUES
('X-Ray Machine', 'XR001', 'Radiology', 'Siemens', 'YSIO Max', 'available', 'Radiology Department'),
('Ultrasound Machine', 'US001', 'Radiology', 'GE Healthcare', 'Voluson E10', 'available', 'Radiology Department'),
('ECG Machine', 'ECG001', 'Cardiology', 'Philips', 'PageWriter TC70', 'available', 'Cardiology Department'),
('Ventilator', 'VENT001', 'ICU', 'Dräger', 'Evita V500', 'available', 'ICU'),
('Patient Monitor', 'MON001', 'ICU', 'GE Healthcare', 'B650', 'available', 'ICU'),
('Surgical Table', 'SURG001', 'Operation Theater', 'Maquet', 'Alphamaxx', 'available', 'Operation Theater 1'),
('Anesthesia Machine', 'ANES001', 'Operation Theater', 'Datex-Ohmeda', 'Aisys CS2', 'available', 'Operation Theater 1'),
('Defibrillator', 'DEF001', 'Emergency', 'Philips', 'HeartStart MRx', 'available', 'Emergency Department'),
('Blood Pressure Monitor', 'BPM001', 'General', 'Omron', 'HEM-7320', 'available', 'General Ward'),
('Pulse Oximeter', 'POX001', 'General', 'Masimo', 'Rad-5', 'available', 'General Ward');

-- Insert sample insurance companies
INSERT INTO `insurance_companies` (`company_name`, `company_code`, `contact_person`, `contact_email`, `contact_phone`, `address`, `website`) VALUES
('HealthCare Insurance', 'HCI001', 'John Smith', 'john@healthcare.com', '+91-9876543210', '123 Insurance Street, Mumbai', 'www.healthcare.com'),
('MediShield Insurance', 'MSI001', 'Sarah Johnson', 'sarah@medishield.com', '+91-9876543211', '456 Medical Avenue, Delhi', 'www.medishield.com'),
('LifeCare Insurance', 'LCI001', 'Mike Wilson', 'mike@lifecare.com', '+91-9876543212', '789 Life Street, Bangalore', 'www.lifecare.com'),
('Family Health Insurance', 'FHI001', 'Lisa Brown', 'lisa@familyhealth.com', '+91-9876543213', '321 Family Road, Chennai', 'www.familyhealth.com'),
('Corporate Health Insurance', 'CHI001', 'David Lee', 'david@corporatehealth.com', '+91-9876543214', '654 Corporate Plaza, Hyderabad', 'www.corporatehealth.com');
