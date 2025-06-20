package com.quiz.su25.validation;

/**
 * Utility class for email validation.
 * Provides methods to validate email addresses according to standard format.
 */
public class EmaliVal {
    /**
     * Validates an email address
     * @param email Email address to validate
     * @return null if email is valid, error message if invalid
     */
    public static String validate(String email) {
        // Check if email is null or empty
        if (email == null || email.trim().isEmpty()) {
            return "Email cannot be empty";
        }
        
        // Check email format using regex pattern
        // Pattern allows:
        // - Letters (a-z, A-Z)
        // - Numbers (0-9)
        // - Special characters (+._-)
        // - Must contain @ symbol
        // - Must have domain after @
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!email.matches(emailRegex)) {
            return "Please enter a valid email address";
        }
        
        return null; // No error
    }
}
