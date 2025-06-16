package com.quiz.su25.validation;

/**
 * Utility class for full name validation.
 * Provides methods to validate full names according to specific rules:
 * - Must contain at least 2 words
 * - Each word must be at least 2 characters
 * - Only allows letters, accents, and spaces
 */
public class FullnameVal {
    /**
     * Validates a full name
     * @param fullName Full name to validate
     * @return null if name is valid, error message if invalid
     */
    public static String validate(String fullName) {
        // Check if name is null or empty
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name cannot be empty";
        }
        
        // Remove extra spaces and normalize
        String cleanName = fullName.trim().replaceAll("\\s+", " ");
        
        // Check minimum length
        if (cleanName.length() < 2) {
            return "Full name must be at least 2 characters long";
        }
        
        // Check name format using regex pattern
        // Pattern allows:
        // - Letters (a-z, A-Z)
        // - Vietnamese accents
        // - Spaces
        String nameRegex = "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\\s]+$";
        if (!cleanName.matches(nameRegex)) {
            return "Full name can only contain letters and accents";
        }
        
        // Check number of words
        String[] words = cleanName.split("\\s+");
        if (words.length < 2) {
            return "Full name must contain at least 2 words";
        }
        
        // Check each word length
        for (String word : words) {
            if (word.length() < 2) {
                return "Each word in full name must be at least 2 characters long";
            }
        }
        
        return null; // No error
    }
}
