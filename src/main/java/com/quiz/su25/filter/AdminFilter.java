/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quiz.su25.filter;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter để kiểm tra xem người dùng có phải là Admin không.
 * Chỉ xử lý các trang thuần Admin.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {
    "/admin/*", "/admin/users", "/admin/subjects", "/admin/registrations"
})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute(GlobalConfig.SESSION_ACCOUNT) != null);
        
        if (isLoggedIn) {
            User user = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            if (user.getRole_id() == GlobalConfig.ROLE_ADMIN) {
                // Người dùng là Admin, cho phép truy cập
                chain.doFilter(request, response);
            } else {
                // Không phải Admin, chuyển hướng đến trang chủ với thông báo lỗi
                //session.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            }
        } else {
            // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/authen?action=login");
        }
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp
    }
}
