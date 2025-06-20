package com.quiz.su25.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;

    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);

            // Add salt to digest
            md.update(salt);

            // Add password bytes to digest
            md.update(password.getBytes());

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
        }
    }

    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Decode the stored hash
            byte[] combinedHash = Base64.getDecoder().decode(storedHash);

            // Extract salt and hash
            byte[] salt = new byte[SALT_LENGTH];
            byte[] hash = new byte[combinedHash.length - SALT_LENGTH];
            System.arraycopy(combinedHash, 0, salt, 0, SALT_LENGTH);
            System.arraycopy(combinedHash, SALT_LENGTH, hash, 0, hash.length);

            // Generate new hash with the same salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            md.update(password.getBytes());
            byte[] newHash = md.digest();

            // Compare the hashes
            return MessageDigest.isEqual(hash, newHash);
        } catch (NoSuchAlgorithmException | IllegalArgumentException e) {
            return false;
        }
    }
} 