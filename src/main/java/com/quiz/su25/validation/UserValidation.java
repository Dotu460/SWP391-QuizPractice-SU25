package com.quiz.su25.validation;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class for user validation.
 * Provides basic validation for user management fields using existing validation classes.
 */
public class UserValidation {
    
    /**
     * Validates all user fields and returns any validation errors
     * @param fullName User's full name
     * @param email User's email address
     * @param mobile User's mobile number (optional)
     * @param gender User's gender (0 for female, 1 for male)
     * @param roleId User's role ID
     * @param status User's status
     * @return Map containing field names and their error messages (empty if all valid)
     */
    public static Map<String, String> validateUser(
            String fullName,
            String email,
            String mobile,
            Integer gender,
            Integer roleId,
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
        
        // Validate mobile number using MobileVal (optional)
        if (mobile != null && !mobile.trim().isEmpty()) {
            String mobileError = MobileVal.validate(mobile);
            if (mobileError != null) {
                errors.put("mobile", mobileError);
            }
        }
        
        // Validate gender
        if (gender == null || (gender != 0 && gender != 1)) {
            errors.put("gender", "Please select a valid gender");
        }
        
        // Validate role
        if (roleId == null || (roleId != 2 && roleId != 3)) {
            errors.put("role", "Please select a valid role (Student or Expert)");
        }
        
        // Validate status
        if (status == null || status.trim().isEmpty()) {
            errors.put("status", "Status is required");
        } else if (!status.matches("^(active|inactive|pending)$")) {
            errors.put("status", "Please select a valid status");
        }
        
        return errors;
    }
} 