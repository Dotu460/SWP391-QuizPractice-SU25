package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.User;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.Date;
import java.util.List;

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
        
        int totalRecords = myRegistrationDAO.countAll();
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (totalPages == 0 && currentPage != 1) { 
            currentPage = 1;
        }

        int offset = (currentPage - 1) * RECORDS_PER_PAGE;
        
        List<Registration> listRegistration = myRegistrationDAO.findAllPaginated(offset, RECORDS_PER_PAGE);

        request.setAttribute("listRegistration", listRegistration);
        request.setAttribute("subjectDAO", subjectDAO);
        request.setAttribute("packageDAO", packageDAO);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("view/user/registration/my-registration.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

       
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
