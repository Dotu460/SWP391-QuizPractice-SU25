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

@WebServlet("/home")
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
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("sliders", sliders);
            request.setAttribute("hotPosts", hotPosts);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("view/home/homepage.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in HomeController doGet: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home Controller";
    }
}
