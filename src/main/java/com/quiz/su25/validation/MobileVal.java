package com.quiz.su25.validation;

/**
 * Utility class for mobile number validation.
 * Provides methods to validate Vietnamese mobile numbers according to standard format:
 * - Must start with 03, 05, 07, 08, or 09
 * - Must have exactly 10 digits
 */
public class MobileVal {
    /**
     * Validates a Vietnamese mobile number
     * @param mobile Mobile number to validate
     * @return null if mobile number is valid, error message if invalid
     */
    public static String validate(String mobile) {
        // Check if mobile is null or empty
        if (mobile == null || mobile.trim().isEmpty()) {
            return "Mobile number is required";
        }

        // Remove all spaces and special characters
        // This allows for flexible input format (e.g., "03-1234-5678" or "03 1234 5678")
        String cleanMobile = mobile.replaceAll("[\\s\\-\\(\\)]", "");

        // Check if it's a valid Vietnamese mobile number using regex pattern
        // Pattern requires:
        // - Starts with 03, 05, 07, 08, or 09
        // - Followed by exactly 8 digits
        if (!cleanMobile.matches("^(0[3|5|7|8|9])+([0-9]{8})$")) {
            return "Mobile number must start with 03, 05, 07, 08, 09 and have 10 digits";
        }

        return null; // Return null if validation passes
    }
}