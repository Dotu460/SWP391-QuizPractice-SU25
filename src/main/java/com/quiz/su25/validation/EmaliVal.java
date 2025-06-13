package com.quiz.su25.validation;

public class EmaliVal {
    public static String validate(String email) {
        if (email == null || email.trim().isEmpty()) {
            return "Email cannot be empty";
        }
        
        // Check email format
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!email.matches(emailRegex)) {
            return "Please enter a valid email address";
        }
        
        return null; // No error
    }
}
