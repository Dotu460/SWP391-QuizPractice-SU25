package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet("/practice")
public class PracticeController extends HttpServlet {

    private SubjectDAO subjectDAO;

    @Override
    public void init() {
        subjectDAO = new SubjectDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PracticeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PracticeController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra xem user đã login hay chưa
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy danh sách subjects mà user có quyền truy cập
        List<Subject> availableSubjects = subjectDAO.findAll(); // TODO: Filter by user access
        
        // Truyền dữ liệu vào JSP
        request.setAttribute("availableSubjects", availableSubjects);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("view/user/practice/practice-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String subjectIdParam = request.getParameter("subject");
            String numberOfQuestionsParam = request.getParameter("numberOfQuestions");
            String questionSelectionType = request.getParameter("questionSelectionType");
            String questionGroup = request.getParameter("questionGroup");

            // Validate dữ liệu
            if (subjectIdParam == null || numberOfQuestionsParam == null || 
                questionSelectionType == null) {
                request.setAttribute("error", "Please fill in all required fields!");
                doGet(request, response);
                return;
            }

            int subjectId = Integer.parseInt(subjectIdParam);
            int numberOfQuestions = Integer.parseInt(numberOfQuestionsParam);

            // Kiểm tra số lượng câu hỏi hợp lệ
            if (numberOfQuestions < 1 || numberOfQuestions > 100) {
                request.setAttribute("error", "Number of questions must be between 1 and 100!");
                doGet(request, response);
                return;
            }

            // TODO: Create practice session and redirect to quiz
            // For now, just redirect to a placeholder page
            response.sendRedirect("quiz-handle?subjectId=" + subjectId + 
                                 "&questions=" + numberOfQuestions + 
                                 "&type=" + questionSelectionType +
                                 "&group=" + (questionGroup != null ? questionGroup : ""));

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format!");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Practice Controller for handling practice sessions";
    }
} 