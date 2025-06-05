/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.entity.Question;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author quangmingdoc
 */
@WebServlet(name = "QuizHandleController", urlPatterns = {"/quiz-handle"})
public class QuizHandleController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet QuizHandleController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizHandleController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy số thứ tự câu hỏi từ parameter, mặc định là 1
            String questionNumber = request.getParameter("questionNumber");
            int currentNumber = questionNumber != null ? Integer.parseInt(questionNumber) : 1;
            
            // Lấy danh sách câu hỏi từ database
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.findAll(); // Hoặc findByQuizId() nếu bạn muốn lọc theo quiz
            
            // Kiểm tra nếu có câu hỏi
            if (!questions.isEmpty() && currentNumber <= questions.size()) {
                // Lấy câu hỏi hiện tại (trừ 1 vì index bắt đầu từ 0)
                Question currentQuestion = questions.get(currentNumber - 1);
                
                // Set attributes cho JSP
                request.setAttribute("question", currentQuestion);
                request.setAttribute("currentNumber", currentNumber);
                request.setAttribute("totalQuestions", questions.size());
            }
            
            // Forward to JSP
            request.getRequestDispatcher("view/user/quizHandle/quiz-handle.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu questionNumber không phải số
            response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=1");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST request (lưu câu trả lời, etc.)
        String action = request.getParameter("action");
        
        if ("saveAnswer".equals(action)) {
            // TODO: Implement save answer logic
            String questionNumber = request.getParameter("questionNumber");
            String selectedAnswer = request.getParameter("answer");
            
            // Sau khi lưu, redirect về GET với câu hỏi tiếp theo
            response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=" + 
                    (Integer.parseInt(questionNumber) + 1));
        }
    }

}
