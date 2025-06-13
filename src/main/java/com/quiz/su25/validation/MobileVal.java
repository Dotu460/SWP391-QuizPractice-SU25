package com.quiz.su25.validation;

public class MobileVal {
    public static String validate(String mobile) {
        if (mobile == null || mobile.trim().isEmpty()) {
            return "Mobile number is required";
        }

        // Remove all spaces and special characters
        String cleanMobile = mobile.replaceAll("[\\s\\-\\(\\)]", "");

        // Check if it's a valid Vietnamese mobile number
        if (!cleanMobile.matches("^(0[3|5|7|8|9])+([0-9]{8})$")) {
            return "Mobile number must start with 03, 05, 07, 08, 09 and have 10 digits";
        }

        return null; // Return null if validation passes
    }
}