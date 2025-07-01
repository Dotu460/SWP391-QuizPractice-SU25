package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;

@WebServlet(name = "QuizHandleMenuController", urlPatterns = {"/quiz-handle-menu"})
public class QuizHandleMenuController extends HttpServlet {
    
    private final QuizzesDAO quizzesDAO = new QuizzesDAO();
    private final UserQuizAttemptsDAO userQuizAttemptsDAO = new UserQuizAttemptsDAO();
    
    //all
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== Starting QuizHandleMenuController ===");
            
            // Auto set session with user id = 10
            HttpSession session = request.getSession(true);
            int userId = 10; // Hardcoded user id for testing
            session.setAttribute("user", userId);
            System.out.println("Set session with user id = " + userId);
            
            // Get all available quizzes
            System.out.println("Fetching quizzes from database...");
            try {
                List<Quizzes> quizzesList = quizzesDAO.findAll();
                System.out.println("Found " + (quizzesList != null ? quizzesList.size() : "null") + " quizzes");
                
                if (quizzesList == null) {
                    throw new Exception("quizzesList is null");
                }
                
                // Get user's quiz attempts
                List<UserQuizAttempts> userAttempts = userQuizAttemptsDAO.findByUserId(userId);
                
                // Create a map of quiz_id to score
                Map<Integer, Double> quizScores = new HashMap<>();
                for (Quizzes quiz : quizzesList) {
                    UserQuizAttempts latestAttempt = userQuizAttemptsDAO.findLatestAttempt(userId, quiz.getId());
                    if (latestAttempt != null && 
                        (GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED.equals(latestAttempt.getStatus()) || 
                         GlobalConfig.QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED.equals(latestAttempt.getStatus()))) {
                        // Lấy điểm từ attempt đã hoàn thành hoặc partially_graded
                        quizScores.put(quiz.getId(), latestAttempt.getScore());
                        System.out.println("Quiz " + quiz.getId() + " has score: " + latestAttempt.getScore() + 
                                          " with status: " + latestAttempt.getStatus());
                    } else {
                        // Nếu chưa có attempt nào hoàn thành, đặt điểm là null hoặc giá trị mặc định
                        quizScores.put(quiz.getId(), null);
                        System.out.println("Quiz " + quiz.getId() + " has no completed/partially_graded attempt");
                    }
                }
                
                // Set the quizzes list and scores as attributes
                request.setAttribute("quizzesList", quizzesList);
                request.setAttribute("quizScores", quizScores);
                System.out.println("Set quizzesList and quizScores attributes");
                
                // Forward to the quiz menu page
                String forwardPath = "view/user/quiz_handle/quiz-handle-menu.jsp";
                System.out.println("Attempting to forward to: " + forwardPath);
                
                try {
                    request.getRequestDispatcher(forwardPath).forward(request, response);
                    System.out.println("Forward successful");
                } catch (ServletException | IOException e) {
                    System.out.println("Forward failed: " + e.getMessage());
                    throw e;
                }
            } catch (Exception e) {
                System.out.println("Error while fetching quizzes: " + e.getMessage());
                e.printStackTrace();
                throw e;
            }
            
        } catch (Exception e) {
            System.out.println("=== Error in QuizHandleMenuController ===");
            System.out.println("Error message: " + e.getMessage());
            System.out.println("Error class: " + e.getClass().getName());
            System.out.println("Stack trace:");
            e.printStackTrace();
            
            // Thay vì redirect về home, hãy hiển thị lỗi
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Error occurred:</h1>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
            response.getWriter().println("<p>Please check server logs for more details.</p>");
            response.getWriter().println("</body></html>");
        }
    }
} 