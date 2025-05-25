/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.User;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 *
 * @author FPT
 */
public class UserProfileController extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserProfileController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserProfileController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login"); // Redirect to login if not logged in
            return;
        }

        if (action == null) {
            // Default action - show profile
            User currentUser = userDAO.findById(user.getId());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("userProfile.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");
        
        if (sessionUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, response, sessionUser);
                    break;
                case "changePicture":
                    changePicture(request, response, sessionUser);
                    break;
                case "deletePicture":
                    deletePicture(request, response, sessionUser);
                    break;
                default:
                    response.sendRedirect("userProfile");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("userProfile.jsp").forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User sessionUser) 
            throws ServletException, IOException {
        // Get updated information from form
        String fullName = request.getParameter("full_name");
        String mobile = request.getParameter("mobile");
        Integer gender = Integer.parseInt(request.getParameter("gender"));
        
        // Create updated user object - giữ nguyên email, không lấy từ form
        User updatedUser = User.builder()
                .id(sessionUser.getId())
                .full_name(fullName)
                .email(sessionUser.getEmail())  // Giữ nguyên email cũ
                .mobile(mobile)
                .gender(gender)
                .avatar_url(sessionUser.getAvatar_url())
                .password(sessionUser.getPassword()) 
                .role_id(sessionUser.getRole_id()) 
                .status(sessionUser.getStatus()) 
                .build();
        
        // Update in database
        boolean success = userDAO.update(updatedUser);
        
        if (success) {
            request.setAttribute("message", "Profile updated successfully!");
            // Update session user
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to update profile!");
        }
        
        response.sendRedirect("userProfile");
    }

    private void changePicture(HttpServletRequest request, HttpServletResponse response, User sessionUser) 
            throws ServletException, IOException {
        // Get the uploaded file
        Part filePart = request.getPart("avatar");
        String fileName = getSubmittedFileName(filePart);
        
        if (fileName != null && !fileName.isEmpty()) {
            // Define the path where the file will be saved
            String uploadPath = getServletContext().getRealPath("/uploads/avatars/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            // Generate unique filename
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + uniqueFileName;
            
            // Save the file
            filePart.write(filePath);
            
            // Update user's avatar_url in database
            User updatedUser = User.builder()
                    .id(sessionUser.getId())
                    .full_name(sessionUser.getFull_name())
                    .email(sessionUser.getEmail())
                    .password(sessionUser.getPassword())
                    .gender(sessionUser.getGender())
                    .mobile(sessionUser.getMobile())
                    .avatar_url("/uploads/avatars/" + uniqueFileName)
                    .role_id(sessionUser.getRole_id())
                    .status(sessionUser.getStatus())
                    .build();
            
            boolean success = userDAO.update(updatedUser);
            
            if (success) {
                request.setAttribute("message", "Profile picture updated successfully!");
                request.getSession().setAttribute("user", updatedUser);
            } else {
                request.setAttribute("error", "Failed to update profile picture!");
            }
        }
        
        response.sendRedirect("userProfile");
    }

    private void deletePicture(HttpServletRequest request, HttpServletResponse response, User sessionUser) 
            throws ServletException, IOException {
        // Delete existing avatar file if exists
        if (sessionUser.getAvatar_url() != null && !sessionUser.getAvatar_url().isEmpty()) {
            String filePath = getServletContext().getRealPath(sessionUser.getAvatar_url());
            File avatarFile = new File(filePath);
            if (avatarFile.exists()) {
                avatarFile.delete();
            }
        }
        
        // Update user with default avatar
        User updatedUser = User.builder()
                .id(sessionUser.getId())
                .full_name(sessionUser.getFull_name())
                .email(sessionUser.getEmail())
                .password(sessionUser.getPassword())
                .gender(sessionUser.getGender())
                .mobile(sessionUser.getMobile())
                .avatar_url("/images/default-avatar.jpg") // Set default avatar
                .role_id(sessionUser.getRole_id())
                .status(sessionUser.getStatus())
                .build();
        
        boolean success = userDAO.update(updatedUser);
        
        if (success) {
            request.setAttribute("message", "Profile picture removed successfully!");
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to remove profile picture!");
        }
        
        response.sendRedirect("userProfile");
    }

    // Helper method to get file name from Part
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1)
                        .substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

}
