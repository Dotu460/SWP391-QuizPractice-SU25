/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.RoleDAO;
import com.quiz.su25.entity.Role;
import com.quiz.su25.entity.User;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/my-profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB
public class UserProfileController extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserProfileController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserProfileController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (currentUser == null) {
            // Nếu user chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set roleDAO vào request để JSP có thể sử dụng
        request.setAttribute("roleDAO", roleDAO);

        // JSP sử dụng sessionScope.user, nên set vào session
        session.setAttribute("user", currentUser);
        request.getRequestDispatcher("view/user/myprofile/my-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        // Kiểm tra user authentication
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, response, sessionUser);
                    break;
                case "changePicture":
                    changePicture(request, response, sessionUser);
                    break;
                case "deletePicture":
                    deletePicture(request, response, sessionUser);
                    break;
                default:
                    response.sendRedirect("my-profile");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("view/user/myprofile/my-profile.jsp").forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        // Get updated information from form
        String fullName = request.getParameter("full_name");
        String mobile = request.getParameter("mobile");
        Integer gender = Integer.parseInt(request.getParameter("gender"));

        // Validate full name
        if (!isValidName(fullName)) {
            request.setAttribute("error", "Tên không hợp lệ! Tên chỉ được chứa chữ cái, khoảng trắng, dấu nháy đơn và dấu gạch ngang. Độ dài từ 2-50 ký tự.");
            doGet(request, response);
            return;
        }

        // Validate phone number
        if (!isValidPhoneNumber(mobile)) {
            request.setAttribute("phoneError", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại 10 chữ số, bắt đầu bằng số 0.");
            request.setAttribute("invalidPhone", mobile);
            doGet(request, response);
            return;
        }

        // Create updated user object - giữ nguyên email, không lấy từ form
        User updatedUser = User.builder()
                .id(sessionUser.getId())
                .full_name(fullName)
                .email(sessionUser.getEmail()) // Giữ nguyên email cũ
                .mobile(mobile)
                .gender(gender)
                .avatar_url(sessionUser.getAvatar_url())
                .password(sessionUser.getPassword())
                .role_id(sessionUser.getRole_id())
                .status(sessionUser.getStatus())
                .build();

        // Update in database
        boolean success = userDAO.update(updatedUser);

        if (success) {
            request.setAttribute("message", "Profile updated successfully!");
            // Update session user
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to update profile!");
        }

        response.sendRedirect("my-profile");
    }

    /**
     * Validate tên người dùng
     *
     * @param name tên cần validate
     * @return true nếu tên hợp lệ, false nếu không hợp lệ
     */
    private boolean isValidName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }

        String trimmedName = name.trim();

        // Kiểm tra độ dài
        if (trimmedName.length() < 2 || trimmedName.length() > 50) {
            return false;
        }

        // Kiểm tra không được bắt đầu hoặc kết thúc bằng khoảng trắng, dấu nháy đơn, hoặc dấu gạch ngang
        if (trimmedName.startsWith(" ") || trimmedName.endsWith(" ")
                || trimmedName.startsWith("'") || trimmedName.endsWith("'")
                || trimmedName.startsWith("-") || trimmedName.endsWith("-")) {
            return false;
        }

        // Kiểm tra không có nhiều khoảng trắng liên tiếp
        if (trimmedName.contains("  ")) {
            return false;
        }

        // Kiểm tra từng ký tự: chỉ cho phép chữ cái, khoảng trắng, dấu nháy đơn, dấu gạch ngang
        for (int i = 0; i < trimmedName.length(); i++) {
            char c = trimmedName.charAt(i);

            // Cho phép chữ cái (bao gồm cả có dấu), khoảng trắng, dấu nháy đơn, dấu gạch ngang
            if (!Character.isLetter(c) && c != ' ' && c != '\'' && c != '-') {
                return false;
            }
        }

        return true;
    }

    /**
     * Validate số điện thoại
     *
     * @param phone số điện thoại cần validate
     * @return true nếu số điện thoại hợp lệ, false nếu không hợp lệ
     */
    private boolean isValidPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }

        // Kiểm tra độ dài phải là 10 số và bắt đầu bằng số 0
        if (!phone.matches("^0\\d{9}$")) {
            return false;
        }

        return true;
    }

    private void changePicture(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {

        // Lấy file ảnh đại diện được gửi từ form có name="avatar"
        Part filePart = request.getPart("avatar");

        // Lấy tên file gốc mà người dùng upload
        String fileName = getSubmittedFileName(filePart);

        // Kiểm tra xem file có tồn tại không
        if (fileName != null && !fileName.isEmpty()) {

            // Lấy đường dẫn thực tế tới thư mục lưu ảnh trên server
            String uploadPath = getServletContext().getRealPath("/uploads/avatars/");

            // Tạo thư mục nếu chưa tồn tại
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Tạo tất cả thư mục cha nếu cần
            }

            // Tạo tên file mới đảm bảo duy nhất (dựa trên thời gian)
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Đường dẫn đầy đủ để lưu file vào ổ đĩa
            String filePath = uploadPath + uniqueFileName;

            // Ghi file vào ổ đĩa (server)
            filePart.write(filePath);

            // Tạo đối tượng User mới từ sessionUser với avatar_url mới
            User updatedUser = User.builder()
                    .id(sessionUser.getId())
                    .full_name(sessionUser.getFull_name())
                    .email(sessionUser.getEmail())
                    .password(sessionUser.getPassword())
                    .gender(sessionUser.getGender())
                    .mobile(sessionUser.getMobile())
                    .avatar_url("/uploads/avatars/" + uniqueFileName) // Đường dẫn ảnh để hiển thị trên web
                    .role_id(sessionUser.getRole_id())
                    .status(sessionUser.getStatus())
                    .build();

            // Cập nhật thông tin người dùng trong database
            boolean success = userDAO.update(updatedUser);

            // Nếu cập nhật thành công
            if (success) {
                // Gửi thông báo thành công
                request.setAttribute("message", "Profile picture updated successfully!");
                // Cập nhật thông tin user trong session
                request.getSession().setAttribute("user", updatedUser);
            } else {
                // Gửi thông báo lỗi
                request.setAttribute("error", "Failed to update profile picture!");
            }
        }

        // Điều hướng lại trang hồ sơ cá nhân
        response.sendRedirect("my-profile");
    }

    private void deletePicture(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {

        // Kiểm tra nếu người dùng đang có avatar (khác null và không rỗng)
        if (sessionUser.getAvatar_url() != null && !sessionUser.getAvatar_url().isEmpty()) {

            // Lấy đường dẫn thực tế tới file ảnh trên ổ đĩa
            String filePath = getServletContext().getRealPath(sessionUser.getAvatar_url());

            // Tạo đối tượng File từ đường dẫn
            File avatarFile = new File(filePath);

            // Nếu file tồn tại, thì xóa
            if (avatarFile.exists()) {
                avatarFile.delete();
            }
        }

        // Tạo đối tượng User mới với avatar là ảnh mặc định
        User updatedUser = User.builder()
                .id(sessionUser.getId())
                .full_name(sessionUser.getFull_name())
                .email(sessionUser.getEmail())
                .password(sessionUser.getPassword())
                .gender(sessionUser.getGender())
                .mobile(sessionUser.getMobile())
                .avatar_url("/images/default-avatar.jpg") // Gán ảnh đại diện mặc định
                .role_id(sessionUser.getRole_id())
                .status(sessionUser.getStatus())
                .build();

        // Cập nhật thông tin người dùng trong database
        boolean success = userDAO.update(updatedUser);

        // Nếu cập nhật thành công
        if (success) {
            // Gửi thông báo thành công
            request.setAttribute("message", "Profile picture removed successfully!");
            // Cập nhật thông tin user trong session
            request.getSession().setAttribute("user", updatedUser);
        } else {
            // Gửi thông báo lỗi
            request.setAttribute("error", "Failed to remove profile picture!");
        }

        // Điều hướng lại trang hồ sơ cá nhân
        response.sendRedirect("my-profile");
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1)
                        .substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

}
