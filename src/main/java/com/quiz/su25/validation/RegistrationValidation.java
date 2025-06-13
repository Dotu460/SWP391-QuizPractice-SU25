package com.quiz.su25.validation;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class RegistrationValidation {
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
        
        // Validate full name
        String fullNameError = FullnameVal.validate(fullName);
        if (fullNameError != null) {
            errors.put("fullName", fullNameError);
        }
        
        // Validate email
        String emailError = EmaliVal.validate(email);
        if (emailError != null) {
            errors.put("email", emailError);
        }
        
        // Validate mobile
        String mobileError = MobileVal.validate(mobile);
        if (mobileError != null) {
            errors.put("mobile", mobileError);
        }
        
        // Validate subject
        if (subjectId == null || subjectId <= 0) {
            errors.put("subject", "Please select a subject");
        }
        
        // Validate package
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
        if (status == null || status.trim().isEmpty()) {
            errors.put("status", "Status is required");
        } else if (!status.matches("^(pending|paid|cancelled)$")) {
            errors.put("status", "Invalid status value");
        }
        
        return errors;
    }
} 