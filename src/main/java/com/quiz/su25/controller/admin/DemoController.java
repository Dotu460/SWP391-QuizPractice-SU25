package com.quiz.su25.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DemoController", urlPatterns = {"/admin/demo/registrations"})
public class DemoController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        
        System.out.println("Action: " + action); // Debug log
        System.out.println("ID: " + id); // Debug log
        
        if (action == null) {
            // Default to list view
            request.getRequestDispatcher("/view/admin/registration/list.jsp").forward(request, response);
            return;
        }
        
        switch (action) {
            case "view":
            case "edit":
                // Forward to details page
                System.out.println("Forwarding to details.jsp"); // Debug log
                request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
                break;
            case "add":
                // Forward to details page for new registration
                System.out.println("Forwarding to details.jsp for new registration"); // Debug log
                request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
                break;
            default:
                // Default to list view
                System.out.println("Forwarding to list.jsp"); // Debug log
                request.getRequestDispatcher("/view/admin/registration/list.jsp").forward(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            // Handle form submission
            // For demo purposes, we'll just redirect back to the list with a success message
            response.sendRedirect(request.getContextPath() + "/admin/demo/registrations?success=added");
        } else {
            // Default to list view
            response.sendRedirect(request.getContextPath() + "/admin/demo/registrations");
        }
    }
}
