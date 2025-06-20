package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.RoleDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.User;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/users", "/admin/user"})
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
                request.setAttribute("user", user);
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
                    request.setAttribute("user", user);
                    request.setAttribute("action", "update");
                    request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
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
        User user = getUserFromRequest(request);

        if (user != null) {
            int userId = userDAO.insert(user);

            if (userId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=userAdded");
            } else {
                request.setAttribute("error", "Failed to add user");
                request.setAttribute("user", user);
                request.setAttribute("action", "add");
                request.setAttribute("roles", roleDAO.findAll());
                request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid user data");
            request.setAttribute("action", "add");
            request.setAttribute("roles", roleDAO.findAll());
            request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = getUserFromRequest(request);

        if (user != null && user.getId() != null) {
            boolean success = userDAO.update(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=userUpdated");
            } else {
                request.setAttribute("error", "Failed to update user");
                request.setAttribute("user", user);
                request.setAttribute("action", "update");
                request.setAttribute("roles", roleDAO.findAll());
                request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalidData");
        }
    }

    private User getUserFromRequest(HttpServletRequest request) {
        try {
            User user = new User();

            // Get user ID for updates
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                user.setId(Integer.parseInt(userIdParam));
            }

            user.setFull_name(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));

            // Password handling
            String password = request.getParameter("password");
            if (password != null && !password.isEmpty()) {
                // In a real application, you should hash the password
                user.setPassword(password);
            } else if (user.getId() != null) {
                // If updating and no password provided, keep existing password
                User existingUser = userDAO.findById(user.getId());
                user.setPassword(existingUser.getPassword());
            }

            user.setGender("male".equals(request.getParameter("gender")) ? 1 : 0);
            user.setMobile(request.getParameter("mobile"));
            user.setAvatar_url(request.getParameter("avatarUrl"));
            user.setStatus(request.getParameter("status"));

            // Set role
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            // Validate role ID - only allow existing roles (2 or 3)
            if (roleId != 2 && roleId != 3) {
                roleId = 2; // Default to role 2 if invalid role ID provided
            }
            user.setRole_id(roleId);

            return user;
        } catch (Exception e) {
            System.out.println("Error parsing user data: " + e.getMessage());
            return null;
        }
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