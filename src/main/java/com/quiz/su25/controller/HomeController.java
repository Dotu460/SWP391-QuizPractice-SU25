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
   
    private SliderDAO sliderDAO;// DAO để lấy danh sách slider
    private PostDAO postDAO;// DAO để lấy danh sách bài viết
    private SubjectDAO subjectDAO;// DAO để lấy danh sách môn học
    private List<Slider> sliders;// Danh sách slider (banner)
    private List<Post> hotPosts; // Danh sách bài viết nổi bật
    private List<Subject> subjects;// Danh sách môn học
    // Phương thức init() chạy khi Servlet được khởi tạo
    @Override
    public void init() throws ServletException {
        sliderDAO = new SliderDAO();// Khởi tạo DAO slider
        postDAO = new PostDAO();// Khởi tạo DAO bài viết
        subjectDAO = new SubjectDAO();// Khởi tạo DAO môn học
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
            // Gán danh sách slider, hotPosts, subjects vào request để truyền sang JSP
            request.setAttribute("sliders", sliders);
            request.setAttribute("hotPosts", hotPosts);
            request.setAttribute("subjects", subjects);
            // Chuyển tiếp đến trang JSP giao diện chính
            request.getRequestDispatcher("view/home/homepage.jsp").forward(request, response);
        } catch (Exception e) {// Bắt lỗi, in log và chuyển hướng đến trang lỗi
            System.out.println("Error in HomeController doGet: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);// Gọi lại doGet để xử lý giống nhau
    }

    @Override
    public String getServletInfo() {
        return "Home Controller";
    }
}
