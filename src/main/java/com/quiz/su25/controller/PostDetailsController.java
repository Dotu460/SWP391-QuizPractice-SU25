/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.controller;

/**
 *
 * @author LENOVO
 */
import com.quiz.su25.dal.impl.PostDAO;
import com.quiz.su25.entity.Post;
import com.quiz.su25.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import java.io.PrintWriter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.UUID;

@WebServlet(name = "PostDetailsController", urlPatterns = {"/post-details","/upload-medias"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 1024,      // 1024MB
    maxRequestSize = 1024 * 1024 * 1024   // 1024MB
)
public class PostDetailsController extends HttpServlet {

    private PostDAO postDAO;
    private static final String UPLOAD_DIRECTORY = "uploads/medias";

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String postIdParam = request.getParameter("id");
        
        // If no ID provided, show form for creating new post
        if (postIdParam == null || postIdParam.isEmpty()) {
            // Create empty post object for new post form
            Post newPost = new Post();
            request.setAttribute("post", newPost);
            request.setAttribute("isNewPost", true);
            request.getRequestDispatcher("/view/post/post-details.jsp").forward(request, response);
            return;
        }

        // If ID provided, load existing post for editing
        try {
            int postId = Integer.parseInt(postIdParam);
            Post post = postDAO.findById(postId);
            
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/blog?error=post_not_found");
                return;
            }

            request.setAttribute("post", post);
            request.setAttribute("isNewPost", false);
            request.getRequestDispatcher("/view/post/post-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/blog?error=invalid_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String path = request.getServletPath();  
        // Handle delete action
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            handleDeletePost(request, response);
            return;
        }
        //Xử lý upload media
        if ("/upload-medias".equals(path)) {
            handleMediaUpload(request, response);
            return;
        }
        try {
            // Get form parameters
            String postIdParam = request.getParameter("postId");
            String title = request.getParameter("title");
            String category = request.getParameter("category");
            String author = request.getParameter("author");
            String briefInfo = request.getParameter("briefInfo");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            boolean featuredFlag = request.getParameter("featuredFlag") != null;

            

            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                System.out.println("ERROR: Title is required!");
                response.sendRedirect(request.getContextPath() + "/post-details" + 
                    (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "") + 
                    "&error=title_required");
                return;
            }

            if (category == null || category.trim().isEmpty()) {
                System.out.println("ERROR: Category is required!");
                response.sendRedirect(request.getContextPath() + "/post-details" + 
                    (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "") + 
                    "&error=category_required");
                return;
            }
            if (author == null || author.trim().isEmpty()) {
                System.out.println("ERROR: Author is required!");
                response.sendRedirect(request.getContextPath() + "/post-details" + 
                    (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "") + 
                    "&error=author_required");
                return;
            }
            // THÊM VALIDATION CHO AUTHOR LENGTH
            if (author.trim().length() > 100) {
                System.out.println("ERROR: Author name too long!");
                response.sendRedirect(request.getContextPath() + "/post-details"
                        + (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "")
                        + "&error=author_too_long");
                return;
            }

            Post post;
            boolean isNewPost = (postIdParam == null || postIdParam.isEmpty());
            System.out.println("Is new post: " + isNewPost);
            
            if (isNewPost) {
                System.out.println("Creating new post...");
                // Create new post
                post = new Post();
                post.setCreated_at(new Date(System.currentTimeMillis()));
                post.setUpdated_at(new Date(System.currentTimeMillis()));
                
                // Set default values for new post
                if (status == null || status.trim().isEmpty()) {
                    status = "draft";
                    System.out.println("Status set to default: draft");
                }

                // Set published_at if status is published
                if ("published".equals(status)) {
                    post.setPublished_at(new Date(System.currentTimeMillis()));
                    System.out.println("Post status is published, setting published_at");
                } else {
                    post.setPublished_at(null); // Keep null for draft posts
                    System.out.println("Post status is not published, published_at = null");
                }
                post.setCategory_id(1); 
                // TODO: Set author from session when authentication is implemented
                // For now, set a default author (you should change this)
                post.setAuthor(author.trim());
                System.out.println("Author set from form: " + author.trim());
                
            } else {
                System.out.println("Updating existing post...");
                // Update existing post
                int postId = Integer.parseInt(postIdParam);
                post = postDAO.findById(postId);
                if (post == null) {
                    System.out.println("ERROR: Post not found with ID: " + postId);
                    response.sendRedirect(request.getContextPath() + "/blog?error=post_not_found");
                    return;
                }
                post.setUpdated_at(new Date(System.currentTimeMillis()));
                if ("published".equals(status) && post.getPublished_at() == null) {
                    post.setPublished_at(new Date(System.currentTimeMillis()));
                }

                // Update category_id if category changed
                // Option 1: Set default category_id
                post.setCategory_id(1);
                
                //Set author cho update
                post.setAuthor(author.trim());  
                System.out.println("Author updated from form: " + author.trim());
            }

            // Handle thumbnail upload
            Part thumbnailPart = request.getPart("thumbnail");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                System.out.println("Processing thumbnail upload...");
                String thumbnailPath = handleFileUpload(thumbnailPart, "thumbnails", request);
                if (thumbnailPath != null) {
                    post.setThumbnail_url(thumbnailPath);
                    System.out.println("Thumbnail uploaded: " + thumbnailPath);
                }
            } else {
                System.out.println("No thumbnail uploaded");
            }

            // Content is handled directly by TinyMCE
            String processedDescription = description;

            // Update post object with form data
            post.setTitle(title.trim());
            post.setCategory(category.trim());
            post.setAuthor(author.trim());
            post.setBrief_info(briefInfo != null ? briefInfo.trim() : "");
            post.setContent(processedDescription);
            post.setStatus(status);
            post.setFeatured_flag(Boolean.valueOf(featuredFlag));

            // DEBUGGING: Print final post object
            System.out.println("Final post object before save:");
            System.out.println("  ID: " + post.getId());
            System.out.println("  Title: " + post.getTitle());
            System.out.println("  Category: " + post.getCategory());
            System.out.println("  Category_id: " + post.getCategory_id());
            System.out.println("  Author: " + post.getAuthor());
            System.out.println("  Status: " + post.getStatus());
            System.out.println("  Featured_flag: " + post.getFeatured_flag());
            System.out.println("  Created_at: " + post.getCreated_at());
            System.out.println("  Updated_at: " + post.getUpdated_at());
            System.out.println("  Published_at: " + post.getPublished_at());

            // Save to database
            boolean success;
            if (isNewPost) {
                System.out.println("Calling postDAO.insert()...");
                int result = postDAO.insert(post);
                success = (result > 0);
                System.out.println("Insert result: " + result + ", success: " + success);
                
                if (success) {
                    System.out.println("Post created successfully! Redirecting to blog...");
                    // Get the ID of the newly created post for redirect
                    response.sendRedirect(request.getContextPath() + "/blog?success=post_created");
                } else {
                    System.out.println("ERROR: Post creation failed!");
                    response.sendRedirect(request.getContextPath() + "/post-details?error=create_failed");
                }
            } else {
                System.out.println("Calling postDAO.update()...");
                boolean result = postDAO.update(post);
                success = (result);
                System.out.println("Update result: " + result + ", success: " + success);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/post-details?id=" + post.getId() + "&success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/post-details?id=" + post.getId() + "&error=update_failed");
                }
            }

        } catch (Exception e) {
            System.out.println("EXCEPTION in PostDetailsController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/blog?error=system_error");
        }
        
        System.out.println("=== POST DETAILS CONTROLLER DEBUG END ===");
        }
    
    private void handleMediaUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");

        try {
            Part filePart = request.getPart("file");

            if (filePart == null) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"No file found in the request\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }

            String fileName = getFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"Invalid file name\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }

            // Validate file type
            String fileType = filePart.getContentType();
            if (!fileType.startsWith("image/") && !fileType.startsWith("video/")) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"Only image and video files are allowed\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }
             // Create year/month based subdirectories
            String timestamp = String.valueOf(System.currentTimeMillis());
            String uniqueFileName = timestamp + "_" + fileName;

            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("/" + UPLOAD_DIRECTORY);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            String fileUrl = "/SWP391_QUIZ_PRACTICE_SU25/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;

            // Return response based on TinyMCE requirements
            if (fileType.startsWith("image/")) {
                jsonResponse.append("\"location\": \"").append(fileUrl).append("\"");
            } else {
                // For video, return both location and additional info
                jsonResponse.append("\"location\": \"").append(fileUrl).append("\",");
                jsonResponse.append("\"title\": \"").append(fileName).append("\",");
                jsonResponse.append("\"success\": true");
            }

        } catch (Exception e) {
            jsonResponse.append("\"success\": false,");
            jsonResponse.append("\"message\": \"Error uploading file: ").append(e.getMessage()).append("\"");
            e.printStackTrace();
        }

        jsonResponse.append("}");
        out.print(jsonResponse.toString());
    }

    // ✅ THÊM: Method getFileName (copy từ QuestionListController)
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");

        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }

        return null;
    }

    private String handleFileUpload(Part filePart, String subfolder, HttpServletRequest request) {
        try {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Create upload directory
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + subfolder;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save file
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Return relative path for database
            return "/uploads/" + subfolder + "/" + uniqueFileName;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
        // Add new method to handle delete
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is manager (role_id = 4)
        User account = (User) request.getSession().getAttribute("account");
        if (account == null || account.getRole_id() != 4) {
            response.sendRedirect(request.getContextPath() + "/blog?error=delete_unauthorized");
            return;
        }

        String postIdParam = request.getParameter("postId");

        try {
            int postId = Integer.parseInt(postIdParam);
            boolean success = postDAO.deleteById(postId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/blog?success=post_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/blog?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/blog?error=invalid_id");
        } catch (Exception e) {
            System.out.println("Error deleting post: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/blog?error=system_error");
        }
    }
}
