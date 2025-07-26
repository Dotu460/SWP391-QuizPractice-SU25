package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.RoleDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.User;
import com.quiz.su25.utils.EmailUtils;
import com.quiz.su25.utils.PasswordUtils;
import com.quiz.su25.validation.UserValidation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/users", "/admin/user", "/admin/user/*"})
public class AdminController extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 10;
    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");

        if (path.equals("/admin/users")) {
            listUsers(request, response);
        } else if (path.equals("/admin/user")) {
            if ("view".equals(action)) {
                viewUser(request, response);
            } else if ("edit".equals(action) || "add".equals(action)) {
                showUserForm(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

        // Get filter parameters
        String genderFilter = request.getParameter("gender");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        String searchTerm = request.getParameter("search");

        // Get sort parameters
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Get paginated users directly from database
        List<User> users = userDAO.getPaginatedUsers(page, pageSize, genderFilter, roleFilter,
                                                    statusFilter, searchTerm, sortBy, sortOrder);

        // Get total count for pagination
        int totalUsers = userDAO.countTotalUsers(genderFilter, roleFilter, statusFilter, searchTerm);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        // Get all roles for filter dropdown
        List<Role> roles = roleDAO.findAll();

        // Set attributes for the view
        request.setAttribute("users", users);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("genderFilter", genderFilter);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("roles", roles);

        // Forward to the view
        request.getRequestDispatcher("/view/admin/users.jsp").forward(request, response);
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = getIntParameter(request, "id", 0);

        if (userId > 0) {
            User user = userDAO.findById(userId);

            if (user != null) {
                // Fetch role information
                Role role = null;
                if (user.getRole_id() != null) {
                    role = roleDAO.findById(user.getRole_id());
                }
                
                request.setAttribute("user", user);
                request.setAttribute("userRole", role);
                request.getRequestDispatcher("/view/admin/user-view.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=userNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalidId");
        }
    }

    private void showUserForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get all roles for dropdown
        List<Role> roles = roleDAO.findAll();
        request.setAttribute("roles", roles);

        if ("edit".equals(action)) {
            int userId = getIntParameter(request, "id", 0);

            if (userId > 0) {
                User user = userDAO.findById(userId);

                if (user != null) {
                    // Fetch role information for display
                    Role userRole = null;
                    if (user.getRole_id() != null) {
                        userRole = roleDAO.findById(user.getRole_id());
                    }
                    
                    request.setAttribute("user", user);
                    request.setAttribute("userRole", userRole);
                    request.setAttribute("action", "update");
                    // Use admin-specific form that only allows role and status editing
                    request.getRequestDispatcher("/view/admin/user-admin-edit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=userNotFound");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalidId");
            }
        } else { // "add" action
            request.setAttribute("action", "add");
            request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        
        // Handle gender properly
        Integer gender = null;
        String genderParam = request.getParameter("gender");
        if ("male".equals(genderParam)) {
            gender = 1;
        } else if ("female".equals(genderParam)) {
            gender = 0;
        }
        
        Integer roleId = null;
        try {
            roleId = Integer.parseInt(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            // Will be handled by validation
        }
        String status = request.getParameter("status");

        // Validate input data
        Map<String, String> errors = UserValidation.validateUser(fullName, email, mobile, gender, roleId, status);

        if (!errors.isEmpty()) {
            // Create detailed error message
            StringBuilder detailedError = new StringBuilder();
            detailedError.append("Validation failed. Please correct the following errors:\n\n");
            
            for (Map.Entry<String, String> error : errors.entrySet()) {
                detailedError.append("• ").append(error.getValue()).append("\n");
            }
            
            // Store detailed error message
            request.setAttribute("error", detailedError.toString());
            
            // Store form data for repopulating form
            request.setAttribute("user", createUserFromFormData(fullName, email, mobile, gender, roleId, status));
            request.setAttribute("action", "add");
            request.setAttribute("roles", roleDAO.findAll());
            request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setMobile(mobile);
        user.setGender(gender);
        user.setRole_id(roleId);
        user.setStatus(status);

        // Generate password for new user (no encryption needed)
        String generatedPassword = PasswordUtils.generateRandomPassword();
        user.setPassword(generatedPassword);

        // Insert user
        int userId = userDAO.insert(user);

        if (userId > 0) {
            // Send welcome email with login credentials
            try {
                EmailUtils.sendRegistrationEmail(
                    user.getEmail(),
                    user.getFull_name(),
                    generatedPassword,
                    "Quiz Practice System", // Subject title
                    new java.util.Date().toString(), // Valid from
                    "Unlimited access", // Valid to
                    "Welcome to Quiz Practice System! Your account has been created by an administrator. Please change your password after your first login for security."
                );
                
                response.sendRedirect(request.getContextPath() + "/admin/users?success=userAddedWithEmail");
            } catch (Exception e) {
                System.err.println("Failed to send welcome email: " + e.getMessage());
                
                response.sendRedirect(request.getContextPath() + "/admin/users?success=userAddedNoEmail");
            }
        } else {
            // Determine the specific reason for failure
            String errorMessage = determineAddUserError(user);
            request.setAttribute("error", errorMessage);
            request.setAttribute("user", user);
            request.setAttribute("action", "add");
            request.setAttribute("roles", roleDAO.findAll());
            request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = getIntParameter(request, "userId", 0);
        
        if (userId > 0) {
            User existingUser = userDAO.findById(userId);
            
            if (existingUser != null) {
                // Admin can only update role and status
                String newRoleIdStr = request.getParameter("roleId");
                String newStatus = request.getParameter("status");
                
                if (newRoleIdStr != null && !newRoleIdStr.isEmpty()) {
                    try {
                        int newRoleId = Integer.parseInt(newRoleIdStr);
                        // Validate role ID - only allow existing roles (2 or 3)
                        if (newRoleId == 2 || newRoleId == 3) {
                            existingUser.setRole_id(newRoleId);
                        }
                    } catch (NumberFormatException e) {
                        // Keep existing role if invalid input
                    }
                }
                
                if (newStatus != null && !newStatus.isEmpty()) {
                    existingUser.setStatus(newStatus);
                }
                
                boolean success = userDAO.update(existingUser);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=userUpdated");
                } else {
                    request.setAttribute("error", "Failed to update user");
                    request.setAttribute("user", existingUser);
                    request.setAttribute("action", "update");
                    request.setAttribute("roles", roleDAO.findAll());
                    request.getRequestDispatcher("/view/admin/user-admin-edit.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=userNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalidId");
        }
    }

    private User createUserFromFormData(String fullName, String email, String mobile, Integer gender, Integer roleId, String status) {
        User user = new User();
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setMobile(mobile);
        user.setGender(gender);
        user.setRole_id(roleId);
        user.setStatus(status);
        return user;
    }

    /**
     * Determines the specific reason why adding a user failed
     * @param user The user object that failed to be added
     * @return Detailed error message explaining the failure reason
     */
    private String determineAddUserError(User user) {
        StringBuilder errorMessage = new StringBuilder();
        errorMessage.append("Failed to add user. Possible reasons:\n\n");

        // Check if email already exists
        if (user.getEmail() != null) {
            User existingUser = userDAO.findByEmail(user.getEmail());
            if (existingUser != null) {
                errorMessage.append("• Email address '").append(user.getEmail()).append("' already exists in the system.\n");
                errorMessage.append("  Please use a different email address.\n\n");
            }
        }

        // Check if mobile number already exists (if provided)
        // Note: findByMobile method doesn't exist in UserDAO, so we'll skip this check
        // TODO: Add findByMobile method to UserDAO if mobile uniqueness is required

        // Check database constraints
        errorMessage.append("• Database constraints:\n");
        errorMessage.append("  - Full name cannot be null or empty\n");
        errorMessage.append("  - Email cannot be null or empty\n");
        errorMessage.append("  - Role ID must be valid (2 for Student, 3 for Expert)\n");
        errorMessage.append("  - Status must be valid (active, inactive, pending)\n");
        errorMessage.append("  - Gender must be 0 (Female) or 1 (Male)\n\n");

        // Check for null or invalid values
        if (user.getFull_name() == null || user.getFull_name().trim().isEmpty()) {
            errorMessage.append("• Full name is missing or empty.\n");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            errorMessage.append("• Email is missing or empty.\n");
        }
        if (user.getRole_id() == null || (user.getRole_id() != 2 && user.getRole_id() != 3)) {
            errorMessage.append("• Invalid role ID. Must be 2 (Student) or 3 (Expert).\n");
        }
        if (user.getStatus() == null || user.getStatus().trim().isEmpty()) {
            errorMessage.append("• Status is missing or empty.\n");
        }
        if (user.getGender() == null || (user.getGender() != 0 && user.getGender() != 1)) {
            errorMessage.append("• Invalid gender value. Must be 0 (Female) or 1 (Male).\n");
        }

        // Add general database error message
        errorMessage.append("\n• Database connection or constraint violation may have occurred.\n");
        errorMessage.append("  Please check all required fields and try again.\n");

        return errorMessage.toString();
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
}