package com.quiz.su25.validation;

public class FullnameVal {
    public static String validate(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name cannot be empty";
        }
        
        // Remove extra spaces
        String cleanName = fullName.trim().replaceAll("\\s+", " ");
        
        // Check minimum length
        if (cleanName.length() < 2) {
            return "Full name must be at least 2 characters long";
        }
        
        // Check name format (only letters and accents)
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
