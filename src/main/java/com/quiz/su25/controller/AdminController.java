package com.quiz.su25.controller;

import com.quiz.su25.entity.User;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.impl.RoleDAO;
import com.quiz.su25.entity.impl.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/users"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("user");

        // Check if user is logged in and has admin role
//        if (currentUser == null || !currentUser.getRole().getRole_name().equals("ADMIN")) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        // Get all users from database
        UserDAO userDAO = new UserDAO();
        List<User> allUsers = userDAO.findAll();

        // Get filter parameters
        String genderFilter = request.getParameter("gender");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        String searchTerm = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Apply filters and search
        List<User> filteredUsers = filterUsers(allUsers, genderFilter, roleFilter, statusFilter, searchTerm);

        // Sort users
        sortUsers(filteredUsers, sortBy, sortOrder);

        // Pagination
        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int totalRecords = filteredUsers.size();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        // Get users for current page
        int start = (page - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, totalRecords);
        List<User> usersForCurrentPage = filteredUsers.subList(start, end);

        // Get all roles for filter dropdown
        RoleDAO roleDAO = new RoleDAO();
        List<Role> allRoles = roleDAO.findAll();

        // Set attributes for JSP
        request.setAttribute("users", usersForCurrentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("roles", allRoles);
        request.setAttribute("genderFilter", genderFilter);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        // Forward to JSP page
        request.getRequestDispatcher("/WEB-INF/view/admin/users.jsp").forward(request, response);
    }

    private List<User> filterUsers(List<User> users, String genderFilter, String roleFilter, String statusFilter, String searchTerm) {
        List<User> result = new ArrayList<>();

        for (User user : users) {
            // Apply gender filter
            if (genderFilter != null && !genderFilter.isEmpty()) {
                boolean gender = genderFilter.equals("male");
                if (user.isGender() != gender) {
                    continue;
                }
            }

            // Apply role filter
            if (roleFilter != null && !roleFilter.isEmpty()) {
                if (user.getRole() == null || !String.valueOf(user.getRole().getId()).equals(roleFilter)) {
                    continue;
                }
            }

            // Apply status filter
            if (statusFilter != null && !statusFilter.isEmpty()) {
                if (user.getStatus() == null || !user.getStatus().equals(statusFilter)) {
                    continue;
                }
            }

            // Apply search term
            if (searchTerm != null && !searchTerm.isEmpty()) {
                searchTerm = searchTerm.toLowerCase();
                boolean matchesSearch = false;

                // Search in full name
                if (user.getFull_name() != null && user.getFull_name().toLowerCase().contains(searchTerm)) {
                    matchesSearch = true;
                }

                // Search in email
                if (user.getEmail() != null && user.getEmail().toLowerCase().contains(searchTerm)) {
                    matchesSearch = true;
                }

                // Search in mobile
                if (user.getMobile() != null && user.getMobile().toLowerCase().contains(searchTerm)) {
                    matchesSearch = true;
                }

                if (!matchesSearch) {
                    continue;
                }
            }

            // User passed all filters
            result.add(user);
        }

        return result;
    }

    private void sortUsers(List<User> users, String sortBy, String sortOrder) {
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "user_id"; // Default sort by ID
        }

        boolean ascending = !"desc".equals(sortOrder);

        Comparator<User> comparator;

        switch (sortBy) {
            case "full_name":
                comparator = Comparator.comparing(User::getFull_name, Comparator.nullsLast(String::compareTo));
                break;
            case "gender":
                comparator = Comparator.comparing(User::isGender);
                break;
            case "email":
                comparator = Comparator.comparing(User::getEmail, Comparator.nullsLast(String::compareTo));
                break;
            case "mobile":
                comparator = Comparator.comparing(User::getMobile, Comparator.nullsLast(String::compareTo));
                break;
            case "role":
                comparator = Comparator.comparing(
                        u -> u.getRole() != null ? u.getRole().getRole_name() : "",
                        Comparator.nullsLast(String::compareTo)
                );
                break;
            case "status":
                comparator = Comparator.comparing(User::getStatus, Comparator.nullsLast(String::compareTo));
                break;
            default: // user_id
                comparator = Comparator.comparing(User::getUser_id, Comparator.nullsLast(Integer::compareTo));
                break;
        }

        if (!ascending) {
            comparator = comparator.reversed();
        }

        Collections.sort(users, comparator);
    }
}