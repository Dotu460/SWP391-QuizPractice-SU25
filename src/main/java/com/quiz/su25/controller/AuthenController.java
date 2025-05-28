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
    private UserDAO userDAO = new UserDAO();// Tạo đối tượng userDAO để xử lý logic đăng nhập

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");// Lấy giá trị action từ URL
        
        if ("logout".equals(action)) {// Nếu action=logout thì gọi hàm logout
            logout(request, response);
            return;// Dừng xử lý tiếp
        }

        // Xử lý đăng nhập bằng Google nếu có action=google
        if ("google".equals(action)) {
            response.sendRedirect("auth/google");// Chuyển hướng đến đường dẫn auth/google
            return;
        }
        // Nếu không có action, forward (chuyển tiếp) đến trang login (form nhập email & password)
        request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Lấy dữ liệu từ form gửi lên
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            User user = userDAO.login(email, password); // Gọi DAO để kiểm tra đăng nhập (email + password)
            
            if (user != null) {
                HttpSession session = request.getSession(); // Nếu đăng nhập thành công -> tạo session
                session.setAttribute("user", user);// Lưu user vào session
                response.sendRedirect("home");//Chuyển đến trang home
            } else {
                request.setAttribute("error", "Invalid email or password");// Nếu thông tin đăng nhập không hợp lệ
                request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
            }
        } catch (Exception e) {// Xử lý lỗi nếu có exception trong quá trình login
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("view/authen/login/userlogin.jsp").forward(request, response);
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    HttpSession session = request.getSession(false);// Lấy session hiện tại (nếu có)
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
