//package com.quiz.su25.controller.admin;
//
//import com.quiz.su25.dal.impl.RegistrationDAO;
//import com.quiz.su25.dal.impl.SubjectDAO;
//import com.quiz.su25.dal.impl.UserDAO;
//import com.quiz.su25.entity.Registration;
//import com.quiz.su25.entity.Subject;
//import com.quiz.su25.entity.User;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.io.IOException;
//import java.sql.Date;
//import java.util.List;
//
//@WebServlet(name = "RegistrationController", urlPatterns = {"/admin/registrations"})
//public class RegistrationController extends HttpServlet {
//    private RegistrationDAO registrationDAO;
//    private UserDAO userDAO;
//    private SubjectDAO subjectDAO;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        registrationDAO = new RegistrationDAO();
//        userDAO = new UserDAO();
//        subjectDAO = new SubjectDAO();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "list";
//        }
//
//        switch (action) {
//            case "list":
//                listRegistrations(request, response);
//                break;
//            case "add":
//                showAddForm(request, response);
//                break;
//            case "edit":
//                showEditForm(request, response);
//                break;
//            default:
//                listRegistrations(request, response);
//        }
//    }
//
//    private void listRegistrations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Get filter parameters
//        String subjectSearch = request.getParameter("subjectSearch");
//        String email = request.getParameter("email");
//        String status = request.getParameter("status");
//        String fromDate = request.getParameter("fromDate");
//        String toDate = request.getParameter("toDate");
//        String sortBy = request.getParameter("sortBy");
//        String sortOrder = request.getParameter("sortOrder");
//
//        // Get pagination parameters
//        int page = 1;
//        int pageSize = 10;
//        try {
//            page = Integer.parseInt(request.getParameter("page"));
//        } catch (NumberFormatException e) {
//            // Use default value
//        }
//        try {
//            pageSize = Integer.parseInt(request.getParameter("pageSize"));
//        } catch (NumberFormatException e) {
//            // Use default value
//        }
//
//        // Convert dates if provided
//        Date from = null;
//        Date to = null;
//        try {
//            if (fromDate != null && !fromDate.isEmpty()) {
//                from = Date.valueOf(fromDate);
//            }
//            if (toDate != null && !toDate.isEmpty()) {
//                to = Date.valueOf(toDate);
//            }
//        } catch (IllegalArgumentException e) {
//            // Handle invalid date format
//            request.setAttribute("error", "Invalid date format");
//        }
//
//        // Get filtered and sorted registrations
//        List<Registration> registrations = registrationDAO.findRegistrationsWithFilters(
//                subjectSearch, email, status, from, to, sortBy, sortOrder, page, pageSize);
//
//        // Get total count for pagination
//        int totalRegistrations = registrationDAO.countTotalRegistrations(
//                subjectSearch, email, status, from, to);
//        int totalPages = (int) Math.ceil((double) totalRegistrations / pageSize);
//
//        // Get subjects for filter dropdown
//        List<Subject> subjects = subjectDAO.findAll();
//
//        // Set attributes for the view
//        request.setAttribute("registrations", registrations);
//        request.setAttribute("subjects", subjects);
//        request.setAttribute("page", page);
//        request.setAttribute("pageSize", pageSize);
//        request.setAttribute("totalPages", totalPages);
//        request.setAttribute("subjectSearch", subjectSearch);
//        request.setAttribute("email", email);
//        request.setAttribute("status", status);
//        request.setAttribute("fromDate", fromDate);
//        request.setAttribute("toDate", toDate);
//        request.setAttribute("sortBy", sortBy);
//        request.setAttribute("sortOrder", sortOrder);
//
//        // Forward to the list view
//        request.getRequestDispatcher("/view/admin/registration/list.jsp").forward(request, response);
//    }
//
//    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Get lists for dropdowns
//        List<Subject> subjects = subjectDAO.findAll();
//        List<User> users = userDAO.findAll();
//
//        request.setAttribute("subjects", subjects);
//        request.setAttribute("users", users);
//        request.getRequestDispatcher("/view/admin/registration/form.jsp").forward(request, response);
//    }
//
//    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int id = Integer.parseInt(request.getParameter("id"));
//        Registration registration = registrationDAO.findById(id);
//
//        if (registration != null) {
//            List<Subject> subjects = subjectDAO.findAll();
//            List<User> users = userDAO.findAll();
//
//            request.setAttribute("registration", registration);
//            request.setAttribute("subjects", subjects);
//            request.setAttribute("users", users);
//            request.getRequestDispatcher("/view/admin/registration/form.jsp").forward(request, response);
//        } else {
//            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=notFound");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action");
//        if (action == null) {
//            response.sendRedirect(request.getContextPath() + "/admin/registrations");
//            return;
//        }
//
//        switch (action) {
//            case "add":
//                addRegistration(request, response);
//                break;
//            case "edit":
//                updateRegistration(request, response);
//                break;
//            default:
//                response.sendRedirect(request.getContextPath() + "/admin/registrations");
//        }
//    }
//
//    private void addRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        // Implementation for adding a new registration
//        // To be implemented based on your requirements
//    }
//
//    private void updateRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        // Implementation for updating an existing registration
//        // To be implemented based on your requirements
//    }
//}
