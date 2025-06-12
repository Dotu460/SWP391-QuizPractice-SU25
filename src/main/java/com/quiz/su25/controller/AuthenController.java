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

import com.quiz.su25.config.GlobalConfig;
@WebServlet({"/login", "/logout"})
public class AuthenController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("view/authen/register/userregister.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
                break;
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                login(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
//                register(request, response);
                break;
            default :
                login(request, response);
                break;
        }
    }

    public void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            User user = userDAO.findByEmailAndPassword(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Lấy URL redirect từ session
                String redirectURL = (String) session.getAttribute("redirectURL");
                
                // Khôi phục trạng thái quiz nếu có
                if (session.getAttribute("tempQuizId") != null) {
                    session.setAttribute("quizId", session.getAttribute("tempQuizId"));
                    session.removeAttribute("tempQuizId");
                }
                
                if (session.getAttribute("tempUserAnswers") != null) {
                    session.setAttribute("userAnswers", session.getAttribute("tempUserAnswers"));
                    session.removeAttribute("tempUserAnswers");
                }
                
                if (session.getAttribute("tempCurrentNumber") != null) {
                    session.setAttribute("currentNumber", session.getAttribute("tempCurrentNumber"));
                    session.removeAttribute("tempCurrentNumber");
                }
                
                // Xóa URL redirect và các thông tin tạm khỏi session
                session.removeAttribute("redirectURL");
                
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    // Nếu có URL redirect, chuyển hướng về trang đó
                    response.sendRedirect(redirectURL);
                } else {
                    // Nếu không có URL redirect, chuyển về trang mặc định
                    response.sendRedirect("home");
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("view/common/authen/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println(e);
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng nhập!");
            request.getRequestDispatcher("view/common/authen/login.jsp").forward(request, response);
        }
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Check if it's an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            // For AJAX requests, send a 200 OK status
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            // For regular requests, redirect to home
            response.sendRedirect("home");
        }
    }
}
