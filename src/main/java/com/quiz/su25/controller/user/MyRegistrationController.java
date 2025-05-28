package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.Subject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.ArrayList;
import java.lang.StringBuilder;
import java.net.URLEncoder; // For encoding URL parameters
import java.sql.Date; // Import java.sql.Date
import java.text.SimpleDateFormat; // Import for date parsing
import java.text.ParseException; // Import for date parsing exception

import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.SubjectDAO;

@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 5; // Or any number you prefer

    private RegistrationDAO myRegistrationDAO;
    private PricePackageDAO packageDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        myRegistrationDAO = new RegistrationDAO();
        packageDAO = new PricePackageDAO();
        subjectDAO = new SubjectDAO();

    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MyRegistrationController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyRegistrationController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
            default:
                listUserRegistrations(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteUserRegistration(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/my-registration");
        }
    }

    private void listUserRegistrations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập kiểu nội dung trả về là HTML và mã hóa UTF-8
        response.setContentType("text/html;charset=UTF-8");   
        // Lấy thông tin user từ session (comment lại để test)
        // com.quiz.su25.entity.User currentUser = (com.quiz.su25.entity.User) request.getSession().getAttribute("user");
        // if (currentUser == null) {
        //     // Nếu user chưa đăng nhập, chuyển hướng về trang login
        //     response.sendRedirect(request.getContextPath() + "/login");
        //     return;
        // }        
        // Lấy user ID từ user hiện tại (comment lại để test)
        // Integer userId = currentUser.getId();
        // request.setAttribute("currentUser", currentUser);      
        // Tạm thời dùng ID cố định để test
        Integer userId = 10; // Thay đổi ID này tùy theo user ID có trong database của bạn
        // Tạo một user object tạm để hiển thị
        com.quiz.su25.entity.User tempUser = new com.quiz.su25.entity.User();
        // tempUser.setId(userId);
        // tempUser.setFull_name("Test User");
        request.setAttribute("currentUser", tempUser);

        // Lấy số trang hiện tại từ request, mặc định là 1
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam); // Chuyển sang số nguyên
                if (currentPage < 1) {
                    currentPage = 1; // Không cho nhỏ hơn 1
                }
            } catch (NumberFormatException e) {
                currentPage = 1; // Nếu lỗi parse thì về trang 1
            }
        }

        // Lấy từ khóa tìm kiếm tên môn học
        String searchName = request.getParameter("searchName");
        if (searchName != null && searchName.trim().isEmpty()) {
            searchName = null; // Nếu rỗng thì bỏ lọc
        }

        // Lấy bộ lọc theo môn học (subjectId)
        String subjectIdParam = request.getParameter("subjectId");
        Integer selectedSubjectId = null;
        if (subjectIdParam != null && !subjectIdParam.trim().isEmpty() && !"0".equals(subjectIdParam)) {
            try {
                selectedSubjectId = Integer.parseInt(subjectIdParam); // Parse thành số nguyên
            } catch (NumberFormatException e) {
                selectedSubjectId = null; // Nếu lỗi thì bỏ lọc
                System.err.println("Invalid subjectId parameter: " + subjectIdParam);
            }
        }
        // Lọc theo trạng thái đăng ký
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.trim().isEmpty()) {
            statusFilter = null; // Bỏ lọc nếu trống
        }
        // Lấy ngày bắt đầu và kết thúc từ request để lọc theo ngày
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        Date fromDate = null;
        Date toDate = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                fromDate = new Date(sdf.parse(fromDateStr).getTime()); // Parse ngày bắt đầu
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                toDate = new Date(sdf.parse(toDateStr).getTime()); // Parse ngày kết thúc
            }
        } catch (ParseException e) {
            System.err.println("Error parsing date for filtering: " + e.getMessage());
        }
        // Lấy tất cả các môn học (dùng để hiển thị trong bộ lọc)
        List<Subject> allSubjects = subjectDAO.findAll();
        int totalRecords;
        List<Registration> listRegistration;
        // Đếm số bản ghi của user hiện tại dựa trên điều kiện tìm kiếm
        if (searchName != null) {
            totalRecords = myRegistrationDAO.countByUserIdAndSubjectNameSearch(userId, searchName, selectedSubjectId, statusFilter, fromDate, toDate);
        } else {
            totalRecords = myRegistrationDAO.countByUserId(userId, selectedSubjectId, statusFilter, fromDate, toDate);
        }
        // Tính tổng số trang cần hiển thị
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);
        if (totalPages == 0) {
            totalPages = 1; // Luôn có ít nhất 1 trang
        }
        if (currentPage > totalPages) {
            currentPage = totalPages; // Nếu lớn hơn tổng trang thì gán bằng tổng trang
        }
        int offset = (currentPage - 1) * RECORDS_PER_PAGE; // Vị trí bắt đầu của trang hiện tại

        // Lấy danh sách đăng ký của user hiện tại theo phân trang và điều kiện lọc
        if (searchName != null) {
            listRegistration = myRegistrationDAO.findByUserIdAndSubjectNameSearchPaginated(
                    userId, searchName, offset, RECORDS_PER_PAGE, selectedSubjectId, statusFilter, fromDate, toDate);
        } else {
            listRegistration = myRegistrationDAO.findByUserIdPaginated(
                    userId, offset, RECORDS_PER_PAGE, selectedSubjectId, statusFilter, fromDate, toDate);
        }
        // Gán dữ liệu vào request để truyền sang JSP
        request.setAttribute("listRegistration", listRegistration);
        request.setAttribute("subjectDAO", subjectDAO);
        request.setAttribute("packageDAO", packageDAO);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentSearchName", searchName);
        request.setAttribute("allSubjects", allSubjects);
        request.setAttribute("currentSubjectId", selectedSubjectId);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("currentFromDate", fromDateStr); // Truyền lại chuỗi gốc để hiển thị lại form lọc
        request.setAttribute("currentToDate", toDateStr);
        // Chuyển tiếp sang JSP để hiển thị dữ liệu
        request.getRequestDispatcher("view/user/registration/my-registration.jsp").forward(request, response);
    }

    private void deleteUserRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số "id" từ request, đây là ID của bản đăng ký cần xóa
        String idParam = request.getParameter("id");
        if (idParam != null) { // Kiểm tra nếu có tham số id truyền vào
            try {
                // Chuyển id từ chuỗi sang số nguyên
                int registrationId = Integer.parseInt(idParam);

                // Tìm bản đăng ký trong cơ sở dữ liệu theo ID
                Registration registrationToDelete = myRegistrationDAO.findById(registrationId);

                if (registrationToDelete != null) {
                    // Nếu tìm thấy, tiến hành xóa bản đăng ký khỏi cơ sở dữ liệu
                    myRegistrationDAO.delete(registrationToDelete);
                } else {
                    // Nếu không tìm thấy, ghi log để lập trình viên biết
                    System.err.println("Registration with ID " + registrationId + " not found for deletion.");
                }
            } catch (NumberFormatException e) {
                // Nếu ID truyền vào không hợp lệ (không phải số), báo lỗi và in stack trace để debug
                System.err.println("Error parsing registration ID for delete: " + idParam);
                e.printStackTrace();
            }
        }
        // === BẢO TOÀN TRẠNG THÁI BỘ LỌC VÀ PHÂN TRANG SAU KHI XÓA ===
        // Lấy lại các tham số lọc từ request để có thể chuyển hướng sau khi xóa mà vẫn giữ nguyên bộ lọc hiện tại
        String page = request.getParameter("page");               // Trang hiện tại
        String searchName = request.getParameter("searchName");   // Tên học viên tìm kiếm
        String subjectId = request.getParameter("subjectId");     // Môn học lọc
        String status = request.getParameter("status");           // Trạng thái lọc
        String fromDate = request.getParameter("fromDate");       // Ngày bắt đầu lọc
        String toDate = request.getParameter("toDate");           // Ngày kết thúc lọc
        // Tạo URL redirect về trang danh sách đăng ký
        StringBuilder redirectURL = new StringBuilder(request.getContextPath()).append("/my-registration");
        // Danh sách tham số cần thêm vào URL
        List<String> params = new ArrayList<>();

        // Gắn các tham số nếu có vào danh sách
        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (searchName != null && !searchName.isEmpty()) {
            // Mã hóa tên tìm kiếm để URL an toàn
            params.add("searchName=" + URLEncoder.encode(searchName, "UTF-8"));
        }
        if (subjectId != null && !subjectId.isEmpty() && !"0".equals(subjectId)) {
            // Bỏ qua subjectId nếu bằng "0" (tức là không chọn môn nào)
            params.add("subjectId=" + subjectId);
        }
        if (status != null && !status.isEmpty()) {
            // Mã hóa trạng thái để an toàn khi truyền qua URL
            params.add("status=" + URLEncoder.encode(status, "UTF-8"));
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            params.add("fromDate=" + URLEncoder.encode(fromDate, "UTF-8"));
        }
        if (toDate != null && !toDate.isEmpty()) {
            params.add("toDate=" + URLEncoder.encode(toDate, "UTF-8"));
        }
        // Nếu có bất kỳ tham số nào, thêm vào URL để redirect đúng trạng thái trước đó
        if (!params.isEmpty()) {
            redirectURL.append("?").append(String.join("&", params));
        }
        // Gửi redirect đến client, chuyển hướng về trang danh sách với bộ lọc giữ nguyên
        response.sendRedirect(redirectURL.toString());
    }
    
    //Để chuyển hướng người dùng quay lại trang danh sách đăng ký học sau khi xóa,
    //mà vẫn giữ nguyên các bộ lọc và phân trang trước đó.

}
