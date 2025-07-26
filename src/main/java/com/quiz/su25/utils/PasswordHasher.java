package com.quiz.su25.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;

    
    public static String hashPassword(String password){
    // Thêm null check
    if (password == null || password.isEmpty()) {
        throw new IllegalArgumentException("Password cannot be null or empty");
    }
    
    try {
        // Generate a random salt
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);

        // Create MessageDigest instance for SHA-256
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);

        // Add salt to digest
        md.update(salt);

        // Add password bytes to digest - thêm encoding
        md.update(password.getBytes("UTF-8"));

        // Get the hashed password bytes
        byte[] hashedPassword = md.digest();

        // Combine salt and password bytes
        byte[] combinedHash = new byte[salt.length + hashedPassword.length];
        System.arraycopy(salt, 0, combinedHash, 0, salt.length);
        System.arraycopy(hashedPassword, 0, combinedHash, salt.length, hashedPassword.length);

        // Convert to base64 for storage
        return Base64.getEncoder().encodeToString(combinedHash);
    } catch (NoSuchAlgorithmException e) {
        throw new RuntimeException("Error hashing password", e);
    } catch (UnsupportedEncodingException e) {
        throw new RuntimeException("Error encoding password", e);
    }
}


public static boolean verifyPassword(String password, String storedHash) {
    if (password == null || storedHash == null) {
        return false;
    }
    
    try {
        System.out.println("=== DEBUG VERIFY ===");
        System.out.println("Input password: " + password);
        System.out.println("Stored hash: " + storedHash);
        System.out.println("Hash length: " + storedHash.length());
        
        // Decode the stored hash
        byte[] combinedHash = Base64.getDecoder().decode(storedHash);
        System.out.println("Combined hash length: " + combinedHash.length);

        // Extract salt and hash
        byte[] salt = new byte[SALT_LENGTH];
        byte[] hash = new byte[combinedHash.length - SALT_LENGTH];
        System.arraycopy(combinedHash, 0, salt, 0, SALT_LENGTH);
        System.arraycopy(combinedHash, SALT_LENGTH, hash, 0, hash.length);
        
        System.out.println("Salt length: " + salt.length);
        System.out.println("Hash length: " + hash.length);

        // Generate new hash with the same salt
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);
        md.update(salt);
        md.update(password.getBytes("UTF-8"));
        byte[] newHash = md.digest();
        
        System.out.println("New hash length: " + newHash.length);
        
        // Compare the hashes
        boolean result = MessageDigest.isEqual(hash, newHash);
        System.out.println("Hash equal: " + result);
        System.out.println("=== END DEBUG ===");
        
        return result;
    } catch (NoSuchAlgorithmException | IllegalArgumentException e) {
        System.out.println("Exception in verifyPassword: " + e.getMessage());
        return false;
    } catch (UnsupportedEncodingException e) {
        System.out.println("Encoding error: " + e.getMessage());
        return false;
    }
}
} 