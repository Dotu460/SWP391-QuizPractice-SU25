package com.quiz.su25.controller.admin;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptAnswersDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller để quản lý danh sách các bài thi cần chấm điểm tự luận
 */
@WebServlet(name = "EssayGradingController", urlPatterns = {"/admin/essay-grading"})
public class EssayGradingController extends HttpServlet {

    private final UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
    private final UserQuizAttemptAnswersDAO answersDAO = new UserQuizAttemptAnswersDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuizzesDAO quizDAO = new QuizzesDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin phân trang
            int page = 1;
            int pageSize = 10;
            
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
            
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeStr);
                if (pageSize < 1) pageSize = 10;
                if (pageSize > 50) pageSize = 50;
            }
            
            // Lấy thông tin lọc
            Integer quizId = null;
            String quizIdStr = request.getParameter("quizId");
            if (quizIdStr != null && !quizIdStr.isEmpty()) {
                quizId = Integer.parseInt(quizIdStr);
            }
            
            Integer userId = null;
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }
            
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = GlobalConfig.QUIZ_ATTEMPT_STATUS_PARTIALLY_GRADED;
            }
            
            System.out.println("===== DEBUG INFO =====");
            System.out.println("Page: " + page);
            System.out.println("PageSize: " + pageSize);
            System.out.println("QuizId: " + quizId);
            System.out.println("UserId: " + userId);
            System.out.println("Status: " + status);
            
            // Lấy danh sách các attempt cần chấm điểm
            List<UserQuizAttempts> attempts = attemptsDAO.findAttemptsByFilters(quizId, userId, status, page, pageSize);
            System.out.println("Attempts found: " + (attempts != null ? attempts.size() : "null"));
            
            // Tính tổng số attempt để phân trang
            int totalAttempts = attemptsDAO.countAttemptsByFilters(quizId, userId, status);
            int totalPages = (int) Math.ceil((double) totalAttempts / pageSize);
            System.out.println("Total attempts: " + totalAttempts);
            System.out.println("Total pages: " + totalPages);
            
            // Lấy thông tin bổ sung cho mỗi attempt
            Map<Integer, User> userMap = new HashMap<>();
            Map<Integer, Quizzes> quizMap = new HashMap<>();
            Map<Integer, Integer> essayCountMap = new HashMap<>();
            Map<Integer, Integer> gradedEssayCountMap = new HashMap<>();
            
            if (attempts != null) {
                for (UserQuizAttempts attempt : attempts) {
                    try {
                        // Lấy thông tin user
                        if (!userMap.containsKey(attempt.getUser_id())) {
                            User user = userDAO.findById(attempt.getUser_id());
                            if (user != null) {
                                userMap.put(attempt.getUser_id(), user);
                            } else {
                                System.out.println("WARNING: User not found for ID: " + attempt.getUser_id());
                            }
                        }
                        
                        // Lấy thông tin quiz
                        if (!quizMap.containsKey(attempt.getQuiz_id())) {
                            Quizzes quiz = quizDAO.findById(attempt.getQuiz_id());
                            if (quiz != null) {
                                quizMap.put(attempt.getQuiz_id(), quiz);
                            } else {
                                System.out.println("WARNING: Quiz not found for ID: " + attempt.getQuiz_id());
                            }
                        }
                        
                        // Đếm số câu hỏi tự luận và số câu đã chấm điểm
                        List<Question> essayQuestions = questionDAO.findEssayQuestionsByQuizId(attempt.getQuiz_id());
                        if (essayQuestions != null) {
                            essayCountMap.put(attempt.getId(), essayQuestions.size());
                            
                            int gradedCount = 0;
                            for (Question q : essayQuestions) {
                                UserQuizAttemptAnswers answer = answersDAO.findEssayAnswerByAttemptAndQuestionId(attempt.getId(), q.getId());
                                if (answer != null && answer.getEssay_score() != null) {
                                    gradedCount++;
                                }
                            }
                            gradedEssayCountMap.put(attempt.getId(), gradedCount);
                        } else {
                            System.out.println("WARNING: No essay questions found for quiz ID: " + attempt.getQuiz_id());
                            essayCountMap.put(attempt.getId(), 0);
                            gradedEssayCountMap.put(attempt.getId(), 0);
                        }
                    } catch (Exception e) {
                        System.out.println("ERROR processing attempt ID " + attempt.getId() + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
            
            // Lấy danh sách tất cả các quiz để hiển thị trong dropdown filter
            List<Quizzes> allQuizzes = quizDAO.findAll();
            System.out.println("All quizzes found: " + (allQuizzes != null ? allQuizzes.size() : "null"));
            
            // Set attributes cho JSP
            request.setAttribute("attempts", attempts);
            request.setAttribute("userMap", userMap);
            request.setAttribute("quizMap", quizMap);
            request.setAttribute("essayCountMap", essayCountMap);
            request.setAttribute("gradedEssayCountMap", gradedEssayCountMap);
            request.setAttribute("allQuizzes", allQuizzes);
            
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalAttempts", totalAttempts);
            
            request.setAttribute("selectedQuizId", quizId);
            request.setAttribute("selectedUserId", userId);
            request.setAttribute("selectedStatus", status);
            
            // Kiểm tra thông báo thành công
            String success = request.getParameter("success");
            if ("true".equals(success)) {
                request.setAttribute("successMessage", "Chấm điểm thành công!");
            }
            
            System.out.println("===== END DEBUG INFO =====");
            System.out.println("Forwarding to JSP...");
            
            // Forward đến trang danh sách chấm điểm
            request.getRequestDispatcher("/view/admin/essay-grading/essay-grading-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Tham số không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/essay-grading");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/essay-grading");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 