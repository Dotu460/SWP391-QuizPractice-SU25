package com.quiz.su25.validation;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Utility class for registration validation.
 * Provides comprehensive validation for all registration-related fields:
 * - Full name validation
 * - Email validation
 * - Mobile number validation
 * - Subject and package selection
 * - Date validation
 * - Status validation
 */
public class RegistrationValidation {
    /**
     * Validates all registration fields and returns any validation errors
     * @param fullName User's full name
     * @param email User's email address
     * @param mobile User's mobile number
     * @param subjectId Selected subject ID
     * @param packageId Selected package ID
     * @param validFrom Registration validity start date
     * @param validTo Registration validity end date
     * @param status Registration status
     * @return Map containing field names and their error messages (empty if all valid)
     */
    public static Map<String, String> validateRegistration(
            String fullName,
            String email,
            String mobile,
            Integer subjectId,
            Integer packageId,
            Date validFrom,
            Date validTo,
            String status) {
        
        Map<String, String> errors = new HashMap<>();
        
        // Validate full name using FullnameVal
        String fullNameError = FullnameVal.validate(fullName);
        if (fullNameError != null) {
            errors.put("fullName", fullNameError);
        }
        
        // Validate email using EmaliVal
        String emailError = EmaliVal.validate(email);
        if (emailError != null) {
            errors.put("email", emailError);
        }
        
        // Validate mobile number using MobileVal
        String mobileError = MobileVal.validate(mobile);
        if (mobileError != null) {
            errors.put("mobile", mobileError);
        }
        
        // Validate subject selection
        if (subjectId == null || subjectId <= 0) {
            errors.put("subject", "Please select a subject");
        }
        
        // Validate package selection
        if (packageId == null || packageId <= 0) {
            errors.put("package", "Please select a package");
        }
        
        // Validate dates
        if (validFrom == null) {
            errors.put("date", "Valid From date is required");
        } else if (validTo == null) {
            errors.put("date", "Valid To date is required");
        } else if (validFrom.after(validTo)) {
            errors.put("date", "Valid From date must be before Valid To date");
        }
        
        // Validate status
        // Status must be one of: pending, paid, cancelled
        if (status == null || status.trim().isEmpty()) {
            errors.put("status", "Status is required");
        } else if (!status.matches("^(pending|paid|cancelled)$")) {
            errors.put("status", "Invalid status value");
        }
        
        return errors;
    }
} 