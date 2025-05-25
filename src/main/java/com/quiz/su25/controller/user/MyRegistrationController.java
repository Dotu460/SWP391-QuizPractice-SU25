package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.User;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.SubjectDAO;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet {
    
    private static final int RECORDS_PER_PAGE = 5;

    private RegistrationDAO registrationDAO;
    private PricePackageDAO packageDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        packageDAO = new PricePackageDAO();
        subjectDAO = new SubjectDAO();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("currUser") == null) {
            request.getRequestDispatcher("SignIn.jsp").forward(request, response);
            return;
        }

        try {
            User user = (User) session.getAttribute("currUser");
            int userId = user.getId();

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
            
            int totalRecords = registrationDAO.countAll(userId);
            int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            if (totalPages == 0 && currentPage != 1) { 
                currentPage = 1;
            }

            int offset = (currentPage - 1) * RECORDS_PER_PAGE;
            
            List<Registration> listRegistration = registrationDAO.findAllPaginated(userId, offset, RECORDS_PER_PAGE);

            request.setAttribute("listRegistration", listRegistration);
            request.setAttribute("subjectDAO", subjectDAO);
            request.setAttribute("packageDAO", packageDAO);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("paginationURL", "my-registration?");

            request.getRequestDispatcher("view/user/registration/my-registration.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in MyRegistrationController doGet: " + e.getMessage());
            request.setAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại sau.");
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            // Handle different actions here
            processRequest(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "My Registration Controller";
    }
}
