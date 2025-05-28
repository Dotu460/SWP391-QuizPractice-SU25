/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.PracticeDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.entity.Practice;
import com.quiz.su25.entity.Subject;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@WebServlet("/practice-details")
public class PracticeDetailController extends HttpServlet {
    
    private PracticeDAO practiceDAO;
    private SubjectDAO subjectDAO;
    
    @Override
    public void init() {
        practiceDAO = new PracticeDAO();
        subjectDAO = new SubjectDAO();
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
            out.println("<title>Servlet PracticeDetailController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PracticeDetailController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Tạm thời lấy practice có id = 1
        Practice practice = practiceDAO.findById(1);
        
        // Get available subjects
        List<Subject> availableSubjects = subjectDAO.findAll();
        
        // Set attributes for JSP
        request.setAttribute("practice", practice);
        request.setAttribute("availableSubjects", availableSubjects);
        
        request.getRequestDispatcher("view/user/Practice/practice-details.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }
}
