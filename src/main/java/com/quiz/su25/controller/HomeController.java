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
            // Get active sliders
            List<Slider> sliders = sliderDAO.getActiveSliders();
            request.setAttribute("sliders", sliders);

            // Get hot posts (top 2)
            List<Post> hotPosts = postDAO.getHotPosts();
            request.setAttribute("hotPosts", hotPosts);

            // Get latest posts (top 4)
            List<Post> latestPosts = postDAO.getLatestPosts(4);
            request.setAttribute("latestPosts", latestPosts);

            // Get featured subjects
            List<Subject> featuredSubjects = subjectDAO.getFeaturedSubjects();
            request.setAttribute("featuredSubjects", featuredSubjects);

            request.getRequestDispatcher("view/home/homepage.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in HomeController: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
            
            // Set error attribute and forward to homepage instead of redirecting to error.jsp
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            try {
                request.getRequestDispatcher("view/home/homepage.jsp").forward(request, response);
            } catch (Exception ex) {
                // If forwarding fails, simply redirect to the context root
                response.sendRedirect(request.getContextPath());
            }
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
