package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.Subject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.ArrayList;
import java.lang.StringBuilder;
import java.net.URLEncoder; // For encoding URL parameters

import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.SubjectDAO;

@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet {
    
    private static final int RECORDS_PER_PAGE = 5; // Or any number you prefer

    private RegistrationDAO myRegistrationDAO;
    private PricePackageDAO packageDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        myRegistrationDAO = new RegistrationDAO();
        packageDAO = new PricePackageDAO();
        subjectDAO = new SubjectDAO();

    }
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MyRegistrationController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyRegistrationController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
            default:
                listUserRegistrations(request, response);
                break;
            // Add other GET actions here if needed in the future
            // e.g., case "viewDetails": viewRegistrationDetails(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteUserRegistration(request, response);
        } else {
            // For unknown POST actions, redirect to the list view to avoid errors.
            // Preserve query parameters if possible, though this might require more context.
            // A simple redirect to the base page is often safest.
            response.sendRedirect(request.getContextPath() + "/my-registration");
        }
    }

    private void listUserRegistrations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        String searchName = request.getParameter("searchName");
        if (searchName != null && searchName.trim().isEmpty()) {
            searchName = null;
        }

        String subjectIdParam = request.getParameter("subjectId");
        Integer selectedSubjectId = null;
        if (subjectIdParam != null && !subjectIdParam.trim().isEmpty() && !"0".equals(subjectIdParam)) { // Treat "0" or empty as no filter
            try {
                selectedSubjectId = Integer.parseInt(subjectIdParam);
            } catch (NumberFormatException e) {
                selectedSubjectId = null; 
                System.err.println("Invalid subjectId parameter: " + subjectIdParam);
            }
        }

        List<Subject> allSubjects = subjectDAO.findAll(); 

        int totalRecords;
        List<Registration> listRegistration;
        
        // Use selectedSubjectId in DAO calls
        if (searchName != null) {
            totalRecords = myRegistrationDAO.countBySubjectNameSearch(searchName, selectedSubjectId);
        } else {
            totalRecords = myRegistrationDAO.countAll(selectedSubjectId);
        }
        
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);
        if (totalPages == 0) { 
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        int offset = (currentPage - 1) * RECORDS_PER_PAGE;

        if (searchName != null) {
            listRegistration = myRegistrationDAO.findBySubjectNameSearchPaginated(searchName, offset, RECORDS_PER_PAGE, selectedSubjectId);
        } else {
            listRegistration = myRegistrationDAO.findAllPaginated(offset, RECORDS_PER_PAGE, selectedSubjectId);
        }

        request.setAttribute("listRegistration", listRegistration);
        request.setAttribute("subjectDAO", subjectDAO);
        request.setAttribute("packageDAO", packageDAO);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentSearchName", searchName);
        request.setAttribute("allSubjects", allSubjects); 
        request.setAttribute("currentSubjectId", selectedSubjectId);

        request.getRequestDispatcher("view/user/registration/my-registration.jsp").forward(request, response);
    }

    private void deleteUserRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int registrationId = Integer.parseInt(idParam);
                Registration registrationToDelete = myRegistrationDAO.findById(registrationId);
                if (registrationToDelete != null) {
                    myRegistrationDAO.delete(registrationToDelete);
                } else {
                    System.err.println("Registration with ID " + registrationId + " not found for deletion.");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error parsing registration ID for delete: " + idParam);
                e.printStackTrace();
            }
        }

        // Preserve filter and pagination state on redirect
        String page = request.getParameter("page");
        String searchName = request.getParameter("searchName");
        String subjectId = request.getParameter("subjectId");

        StringBuilder redirectURL = new StringBuilder(request.getContextPath()).append("/my-registration");
        List<String> params = new ArrayList<>();
        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (searchName != null && !searchName.isEmpty()) {
            params.add("searchName=" + URLEncoder.encode(searchName, "UTF-8"));
        }
        if (subjectId != null && !subjectId.isEmpty() && !"0".equals(subjectId)) {
            params.add("subjectId=" + subjectId);
        }

        if (!params.isEmpty()) {
            redirectURL.append("?").append(String.join("&", params));
        }
        
        response.sendRedirect(redirectURL.toString());
    }

    @Override
    public String getServletInfo() {
        return "Manages display and actions for user registrations.";
    }

}
