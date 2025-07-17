package com.quiz.su25.utils;

import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtils {
    private static final SecureRandom random = new SecureRandom();
    
    /**
     * Generates a random password with specified length
     * @param length Length of the password (default is 8 if not specified)
     * @return Random password string
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) length = 8; // Minimum length of 8 characters
        
        byte[] randomBytes = new byte[length];
        random.nextBytes(randomBytes);
        
        // Convert to Base64 and remove non-alphanumeric characters
        String password = Base64.getEncoder().encodeToString(randomBytes)
                .replaceAll("[^a-zA-Z0-9]", "")
                .substring(0, length);
        
        // Ensure at least one uppercase, one lowercase, and one number
        password = ensurePasswordRequirements(password);
        
        return password;
    }
    
    /**
     * Generates a random password with default length of 8 characters
     * @return Random password string
     */
    public static String generateRandomPassword() {
        return generateRandomPassword(8);
    }
    
    /**
     * Ensures password meets minimum requirements:
     * - At least one uppercase letter
     * - At least one lowercase letter
     * - At least one number
     */
    private static String ensurePasswordRequirements(String password) {
        if (!password.matches(".*[A-Z].*")) {
            // Add uppercase if missing
            password = "A" + password.substring(1);
        }
        if (!password.matches(".*[a-z].*")) {
            // Add lowercase if missing
            password = "a" + password.substring(1);
        }
        if (!password.matches(".*[0-9].*")) {
            // Add number if missing
            password = "1" + password.substring(1);
        }
        return password;
    }
    
    /**
     * Generates a note with password information
     * @param password The generated password
     * @return Formatted note with password information
     */
    public static String generatePasswordNote(String password) {
        return "Generated password: " + password + "\n" +
               "Please save this password securely. It will not be shown again.";
    }
}
