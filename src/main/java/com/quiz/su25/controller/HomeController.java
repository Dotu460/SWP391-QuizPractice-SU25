/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quiz.su25.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quiz.su25.dal.impl.PostDAO;
import com.quiz.su25.dal.impl.SliderDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.Post;
import com.quiz.su25.entity.Slider;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;
/**
 *
 * @author FPT
 */
@WebServlet("/my-home")
public class HomeController extends HttpServlet {
   
    private SliderDAO sliderDAO;
    private PostDAO postDAO;
    private SubjectDAO subjectDAO;
    private List<Slider> sliders;
    private List<Post> hotPosts;
    private List<Subject> subjects;
    
    @Override
    public void init() throws ServletException {
        sliderDAO = new SliderDAO();
        postDAO = new PostDAO();
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
            out.println("<title>Servlet HomeController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("sliders", sliders);
            request.setAttribute("hotPosts", hotPosts);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("home.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in HomeController doGet: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
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
        doGet(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Home Controller";
    }// </editor-fold>

}
