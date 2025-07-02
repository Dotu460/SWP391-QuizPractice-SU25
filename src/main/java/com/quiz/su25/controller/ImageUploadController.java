package com.quiz.su25.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import com.google.gson.JsonObject;

@WebServlet("/upload-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ImageUploadController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/content-images";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        
        try {
            // Get the file part from the request
            Part filePart = request.getPart("file");
            if (filePart == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "No file uploaded");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            String fileName = getFileName(filePart);
            if (fileName == null || fileName.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Invalid file name");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            // Validate file extension
            if (!isValidFileExtension(fileName)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Invalid file type. Only image files are allowed.");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            // Validate file size
            if (filePart.getSize() > MAX_FILE_SIZE) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "File size exceeds 10MB limit");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generate unique filename
            String fileExtension = getFileExtension(fileName);
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            // Save the file
            filePart.write(filePath);
            
            // Return success response with file URL
            String fileUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("location", fileUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Server error: " + e.getMessage());
        }
        
        response.getWriter().write(jsonResponse.toString());
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
    
    private boolean isValidFileExtension(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (extension.equals(allowedExt)) {
                return true;
            }
        }
        return false;
    }
    
    private String getFileExtension(String fileName) {
        int lastIndexOf = fileName.lastIndexOf(".");
        if (lastIndexOf == -1) {
            return ""; // empty extension
        }
        return fileName.substring(lastIndexOf);
    }
} 