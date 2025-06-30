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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.UUID;

@WebServlet(name = "PostDetailsController", urlPatterns = {"/post-details"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class PostDetailsController extends HttpServlet {

    private PostDAO postDAO;

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
        
        try {
            // Get form parameters
            String postIdParam = request.getParameter("postId");
            String title = request.getParameter("title");
            String category = request.getParameter("category");
            String briefInfo = request.getParameter("briefInfo");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            boolean featuredFlag = request.getParameter("featuredFlag") != null;

            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/post-details" + 
                    (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "") + 
                    "&error=title_required");
                return;
            }

            if (category == null || category.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/post-details" + 
                    (postIdParam != null && !postIdParam.isEmpty() ? "?id=" + postIdParam : "") + 
                    "&error=category_required");
                return;
            }

            Post post;
            boolean isNewPost = (postIdParam == null || postIdParam.isEmpty());
            
            if (isNewPost) {
                // Create new post
                post = new Post();
                post.setCreated_at(new Date(System.currentTimeMillis()));
                post.setUpdated_at(new Date(System.currentTimeMillis()));
                
                // Set default values for new post
                if (status == null || status.trim().isEmpty()) {
                    status = "draft";
                }

                // Set published_at if status is published
                if ("published".equals(status)) {
                    post.setPublished_at(new Date(System.currentTimeMillis()));
                } else {
                    post.setPublished_at(null); // Keep null for draft/archived posts
                }
                post.setCategory_id(1); 
                // TODO: Set author from session when authentication is implemented
                // For now, set a default author (you should change this)
                post.setAuthor("Admin");
                
            } else {
                // Update existing post
                int postId = Integer.parseInt(postIdParam);
                post = postDAO.findById(postId);
                if (post == null) {
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
            }

            // Handle thumbnail upload
            Part thumbnailPart = request.getPart("thumbnail");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                String thumbnailPath = handleFileUpload(thumbnailPart, "thumbnails", request);
                if (thumbnailPath != null) {
                    post.setThumbnail_url(thumbnailPath);
                }
            }

            // Content is handled directly by TinyMCE
            String processedDescription = description;

            // Update post object with form data
            post.setTitle(title.trim());
            post.setCategory(category.trim());
            post.setBrief_info(briefInfo != null ? briefInfo.trim() : "");
            post.setContent(processedDescription);
            post.setStatus(status);
            post.setFeatured_flag(Boolean.valueOf(featuredFlag));

            // Save to database
            boolean success;
            if (isNewPost) {
                int result = postDAO.insert(post);
                success = (result > 0);
                if (success) {
                    // Get the ID of the newly created post for redirect
                    response.sendRedirect(request.getContextPath() + "/blog?success=post_created");
                } else {
                    response.sendRedirect(request.getContextPath() + "/post-details?error=create_failed");
                }
            } else {
                boolean result = postDAO.update(post);
                success = (result);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/post-details?id=" + post.getId() + "&success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/post-details?id=" + post.getId() + "&error=update_failed");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/blog?error=system_error");
        }
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
}
