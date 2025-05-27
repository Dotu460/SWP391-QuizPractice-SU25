package com.quiz.su25.controller;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class AuthenController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
            return;
        }

        // 👉 Xử lý đăng nhập bằng Google nếu có action=google
        if ("google".equals(action)) {
            response.sendRedirect("auth/google");
            return;
        }
        
        request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        
        try {
            User user = userDAO.login(email, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    HttpSession session = request.getSession(false);
    if (session != null) {
        session.invalidate(); // Xóa session
    }
    String referer = request.getHeader("Referer"); // Lấy trang trước đó
    if (referer != null && !referer.isEmpty()) {
        response.sendRedirect(referer); // Quay về trang cũ
    } else {
        response.sendRedirect("home"); // Nếu không có referer thì về home
    }
}
}
