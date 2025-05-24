/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet {
    
    private RegistrationDAO myRegistrationDAO;

    @Override
    public void init() throws ServletException {
        myRegistrationDAO = new RegistrationDAO();
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        List<Registration> listRegistration = myRegistrationDAO.findAll();

        request.setAttribute("listRegistration", listRegistration);

        request.getRequestDispatcher("view/user/registration/my-registration.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action != null) {
                switch (action) {
                    case "edit":
                        int id = Integer.parseInt(request.getParameter("id"));
                        int userId = Integer.parseInt(request.getParameter("user_id"));
                        int subjectId = Integer.parseInt(request.getParameter("subject_id"));
                        int packageId = Integer.parseInt(request.getParameter("package_id"));
                        Date registrationTime = java.sql.Date.valueOf(request.getParameter("registration_time"));
                        double totalCost = Double.parseDouble(request.getParameter("total_cost"));
                        String status = request.getParameter("status");
                        Date validFrom = java.sql.Date.valueOf(request.getParameter("valid_from"));
                        Date validTo = java.sql.Date.valueOf(request.getParameter("valid_to"));

                        Registration registration = Registration.builder()
                                .id(id)
                                .user_id(userId)
                                .subject_id(subjectId)
                                .package_id(packageId)
                                .registration_time(registrationTime)
                                .total_cost(totalCost)
                                .status(status)
                                .valid_from(validFrom)
                                .valid_to(validTo)
                                .build();

                        boolean updateSuccess = myRegistrationDAO.update(registration);
                        if (updateSuccess) {
                            request.setAttribute("message", "Update registration successfully!");
                        } else {
                            request.setAttribute("error", "Failed to update registration!");
                        }
                        break;

                    case "cancel":
                        int registrationId = Integer.parseInt(request.getParameter("id"));
                        Registration regToDelete = myRegistrationDAO.findById(registrationId);

                        if (regToDelete != null) {
                            boolean deleteSuccess = myRegistrationDAO.delete(regToDelete);
                            if (deleteSuccess) {
                                request.setAttribute("message", "Cancel registration successfully!");
                            } else {
                                request.setAttribute("error", "Failed to cancel registration!");
                            }
                        } else {
                            request.setAttribute("error", "Registration not found!");
                        }
                        break;
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input data!");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format!");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect("MyRegistration");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
