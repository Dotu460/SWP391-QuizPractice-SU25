package com.quiz.su25.controller.Expert.essay_grading;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptAnswersDAO;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.UserQuizAttemptAnswers;
import com.quiz.su25.entity.UserQuizAttempts;
import com.quiz.su25.entity.Quizzes;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller để xử lý việc chấm điểm câu hỏi tự luận
 */
@WebServlet(name = "EssayScoreController", urlPatterns = {"/essay-score"})
public class EssayScoreController extends HttpServlet {

    private final UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
    private final UserQuizAttemptAnswersDAO answersDAO = new UserQuizAttemptAnswersDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuizzesDAO quizDAO = new QuizzesDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String attemptIdStr = request.getParameter("attemptId");
        String questionNumberStr = request.getParameter("questionNumber");
        
        if (attemptIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int attemptId = Integer.parseInt(attemptIdStr);
            int questionNumber = questionNumberStr != null ? Integer.parseInt(questionNumberStr) : 1;
            
            // Lấy thông tin về attempt
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            if (attempt == null) {
                request.setAttribute("errorMessage", "Attempt không tồn tại");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Lấy thông tin về quiz
            Quizzes quiz = quizDAO.findById(attempt.getQuiz_id());
            
            // Lấy thông tin về user
            User user = userDAO.findById(attempt.getUser_id());
            
            // Lấy danh sách câu hỏi tự luận trong quiz
            List<Question> allQuestions = questionDAO.findByQuizId(attempt.getQuiz_id());
            List<Question> essayQuestions = new ArrayList<>();
            
            for (Question q : allQuestions) {
                if ("essay".equals(q.getType())) {
                    essayQuestions.add(q);
                }
            }
            
            if (essayQuestions.isEmpty()) {
                request.setAttribute("errorMessage", "Không có câu hỏi tự luận trong bài thi này");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Đảm bảo questionNumber hợp lệ
            if (questionNumber < 1 || questionNumber > essayQuestions.size()) {
                questionNumber = 1;
            }
            
            // Lấy câu hỏi hiện tại
            Question currentQuestion = essayQuestions.get(questionNumber - 1);
            
            // Lấy câu trả lời của người dùng
            UserQuizAttemptAnswers answer = answersDAO.findEssayAnswerByAttemptAndQuestionId(attemptId, currentQuestion.getId());
            
            // Đếm số câu hỏi đã chấm điểm
            int gradedCount = 0;
            for (Question q : essayQuestions) {
                UserQuizAttemptAnswers ans = answersDAO.findEssayAnswerByAttemptAndQuestionId(attemptId, q.getId());
                if (ans != null && ans.getEssay_score() != null) {
                    gradedCount++;
                }
            }
            
            // Set attributes cho JSP
            request.setAttribute("attempt", attempt);
            request.setAttribute("quiz", quiz);
            request.setAttribute("user", user);
            request.setAttribute("questions", essayQuestions);
            request.setAttribute("question", currentQuestion);
            request.setAttribute("answer", answer);
            request.setAttribute("currentNumber", questionNumber);
            request.setAttribute("gradedCount", gradedCount);
            request.setAttribute("totalEssayQuestions", essayQuestions.size());
            
            // Forward đến trang chấm điểm với đường dẫn tuyệt đối
            request.getRequestDispatcher("/view/Expert/essay-grading/quiz-handle-essay-score.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Tham số không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.out.println("Lỗi trong EssayScoreController: " + e.getMessage());
            e.printStackTrace(); // In ra stack trace để debug
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String attemptIdStr = request.getParameter("attemptId");
        String questionIdStr = request.getParameter("questionId");
        String answerIdStr = request.getParameter("answerId");
        String scoreStr = request.getParameter("score");
        String feedback = request.getParameter("feedback");
        String action = request.getParameter("action");
        
        System.out.println("Essay Score POST - attemptId: " + attemptIdStr + ", questionId: " + questionIdStr + 
                          ", score: " + scoreStr + ", action: " + action + ", feedback length: " + (feedback != null ? feedback.length() : 0));
        
        if (attemptIdStr == null || questionIdStr == null || scoreStr == null) {
            System.out.println("Missing required parameters, redirecting to home");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int attemptId = Integer.parseInt(attemptIdStr);
            int questionId = Integer.parseInt(questionIdStr);
            double score = Double.parseDouble(scoreStr);
            
            // Validate score
            if (score < 0) score = 0;
            if (score > 10) score = 10;
            
            // Lấy thông tin về attempt
            UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
            if (attempt == null) {
                System.out.println("Attempt not found: " + attemptId);
                request.setAttribute("errorMessage", "Attempt không tồn tại");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Lưu điểm và feedback
            System.out.println("Saving essay score: " + score + " for question: " + questionId + " in attempt: " + attemptId);
            boolean success = answersDAO.updateEssayScore(attemptId, questionId, score, feedback);
            
            if (!success) {
                System.out.println("Failed to save essay score");
                request.setAttribute("errorMessage", "Không thể lưu điểm");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            System.out.println("Essay score saved successfully: " + score);
            
            // Kiểm tra xem đã chấm điểm tất cả câu hỏi tự luận chưa
            boolean allEssayQuestionsGraded = true;
            List<Question> essayQuestions = questionDAO.findEssayQuestionsByQuizId(attempt.getQuiz_id());
            
            for (Question q : essayQuestions) {
                UserQuizAttemptAnswers ans = answersDAO.findEssayAnswerByAttemptAndQuestionId(attemptId, q.getId());
                if (ans == null || ans.getEssay_score() == null) {
                    allEssayQuestionsGraded = false;
                    System.out.println("Question " + q.getId() + " not graded yet");
                    break;
                }
            }
            
            System.out.println("All essay questions graded: " + allEssayQuestionsGraded);
            
            // Nếu đã chấm điểm tất cả câu hỏi tự luận, cập nhật trạng thái attempt thành COMPLETED
            if (allEssayQuestionsGraded) {
                // Tính toán lại điểm tổng kết (kết hợp điểm trắc nghiệm và tự luận)
                double totalScore = calculateFinalScore(attemptId);
                
                // Cập nhật trạng thái và điểm
                attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
                attempt.setScore(totalScore);
                attempt.setPassed(totalScore >= 5.0); // Giả sử điểm đạt là 5.0
                
                boolean updated = attemptsDAO.update(attempt);
                System.out.println("Attempt updated with final score " + totalScore + ": " + updated);
            }
            
            // Nếu action là "save", luôn chuyển về trang danh sách chấm điểm
            if ("save".equals(action)) {
                System.out.println("Redirecting to essay grading list page");
                response.sendRedirect(request.getContextPath() + "/admin/essay-grading");
                return;
            }
            
            // Nếu không, tiếp tục chấm điểm câu hỏi tiếp theo
            String questionNumberStr = request.getParameter("questionNumber");
            int currentNumber = questionNumberStr != null ? Integer.parseInt(questionNumberStr) : 1;
            
            // Luôn redirect về essay-score với attempt ID
            response.sendRedirect(request.getContextPath() + "/essay-score?attemptId=" + attemptId + "&questionNumber=" + currentNumber);
            
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException in EssayScoreController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Tham số không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/essay-grading");
        } catch (Exception e) {
            System.out.println("Exception in EssayScoreController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/essay-grading");
        }
    }
    
    /**
     * Tính toán điểm tổng kết của một attempt, kết hợp điểm trắc nghiệm và tự luận
     */
    private double calculateFinalScore(int attemptId) throws Exception {
        UserQuizAttempts attempt = attemptsDAO.findById(attemptId);
        if (attempt == null) {
            throw new Exception("Attempt không tồn tại");
        }
        
        // Lấy tất cả câu hỏi trong quiz
        List<Question> allQuestions = questionDAO.findByQuizId(attempt.getQuiz_id());
        int totalQuestions = allQuestions.size();
        
        if (totalQuestions == 0) {
            return 0.0;
        }
        
        // Tính điểm cho các câu hỏi trắc nghiệm
        int correctMultipleChoice = 0;
        int totalMultipleChoice = 0;
        
        // Tính điểm cho các câu hỏi tự luận
        double totalEssayScore = 0.0;
        int totalEssayQuestions = 0;
        
        for (Question q : allQuestions) {
            if ("multiple".equals(q.getType())) {
                totalMultipleChoice++;
                
                // Kiểm tra xem câu trả lời có đúng không
                List<UserQuizAttemptAnswers> answers = answersDAO.findByAttemptAndQuestionId(attemptId, q.getId());
                if (!answers.isEmpty() && answers.get(0).getCorrect()) {
                    correctMultipleChoice++;
                }
            } else if ("essay".equals(q.getType())) {
                totalEssayQuestions++;
                
                // Lấy điểm của câu hỏi tự luận
                UserQuizAttemptAnswers answer = answersDAO.findEssayAnswerByAttemptAndQuestionId(attemptId, q.getId());
                if (answer != null && answer.getEssay_score() != null) {
                    totalEssayScore += answer.getEssay_score();
                }
            }
        }
        
        // Tính điểm tổng kết
        double multipleChoiceScore = totalMultipleChoice > 0 ? 
                (double) correctMultipleChoice / totalMultipleChoice * 10.0 : 0.0;
        
        double essayScore = totalEssayQuestions > 0 ? 
                totalEssayScore / totalEssayQuestions : 0.0;
        
        // Tính điểm trung bình có trọng số (giả sử trắc nghiệm và tự luận có trọng số bằng nhau)
        double weightMultipleChoice = (double) totalMultipleChoice / totalQuestions;
        double weightEssay = (double) totalEssayQuestions / totalQuestions;
        
        double finalScore = (multipleChoiceScore * weightMultipleChoice) + (essayScore * weightEssay);
        
        // Làm tròn đến 1 chữ số thập phân
        finalScore = Math.round(finalScore * 10.0) / 10.0;
        
        return finalScore;
    }
} 