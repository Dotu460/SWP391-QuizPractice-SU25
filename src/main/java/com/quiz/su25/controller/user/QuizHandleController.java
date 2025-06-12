/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.quiz.su25.controller.QuizAttemptController;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.UserQuizAttempts;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
            // Tạo attempt mới khi bắt đầu quiz
            HttpSession session = request.getSession();
            
            // Set user ID cứng là 10 và quiz ID là 1 (hoặc ID thực tế của quiz)
            Integer userId = 10;
            Integer quizId = 1; // Thay đổi theo quiz ID thực tế
            session.setAttribute("quizId", quizId);
            
            // Kiểm tra xem đã có attempt đang chạy chưa
            QuizAttemptController attemptController = new QuizAttemptController();
            UserQuizAttempts currentAttempt = attemptController.getLatestAttempt(userId, quizId);
            
            // Nếu chưa có attempt hoặc attempt cuối cùng đã hoàn thành, tạo attempt mới
            if (currentAttempt == null || "completed".equals(currentAttempt.getStatus())) {
                currentAttempt = attemptController.startQuizAttempt(userId, quizId);
                System.out.println("Created new attempt with ID: " + currentAttempt.getId());
                session.setAttribute("currentAttemptId", currentAttempt.getId());
            } else {
                // Nếu có attempt đang chạy, sử dụng attempt đó
                session.setAttribute("currentAttemptId", currentAttempt.getId());
            }
            
            // Lấy số thứ tự câu hỏi từ parameter, mặc định là 1
            String questionNumber = request.getParameter("questionNumber");
            int currentNumber = questionNumber != null ? Integer.parseInt(questionNumber) : 1;
            
            // Lấy danh sách câu hỏi từ database
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.findAll();
            
            // Kiểm tra nếu có câu hỏi
            if (!questions.isEmpty() && currentNumber <= questions.size()) {
                // Lấy câu hỏi hiện tại
                Question currentQuestion = questions.get(currentNumber - 1);
                
                // Lấy các options cho câu hỏi hiện tại
                QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                List<QuestionOption> options = optionDAO.findByQuestionId(currentQuestion.getId());
                currentQuestion.setQuestionOptions(options);
                
                // Lấy câu trả lời đã chọn từ session
                Map<Integer, Object> userAnswers = (Map<Integer, Object>) session.getAttribute("userAnswers");
                
                if (userAnswers != null && userAnswers.containsKey(currentQuestion.getId())) {
                    Object answer = userAnswers.get(currentQuestion.getId());
                    if ("multiple".equals(currentQuestion.getType())) {
                        // Nếu là câu hỏi trắc nghiệm, cast về List<Integer>
                        request.setAttribute("selectedAnswers", (List<Integer>) answer);
                    } else {
                        // Nếu là câu hỏi tự luận, cast về String
                        request.setAttribute("selectedAnswers", (String) answer);
                    }
                }
                
                // Set attributes cho JSP
                request.setAttribute("question", currentQuestion);
                request.setAttribute("currentNumber", currentNumber);
                request.setAttribute("totalQuestions", questions.size());
                request.setAttribute("questions", questions);
            }
            
            request.getRequestDispatcher("view/user/quizHandle/quiz-handle.jsp").forward(request, response);
        } catch (NumberFormatException e) {
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        System.out.println("Received action: " + action);
        
        if ("score".equals(action)) {
            try {
                // Đọc dữ liệu từ request
                BufferedReader reader = request.getReader();
                StringBuilder requestData = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    requestData.append(line);
                }
                
                System.out.println("Raw request data: " + requestData.toString());
                
                // Parse JSON từ request body
                JsonObject jsonRequest = JsonParser.parseString(requestData.toString()).getAsJsonObject();
                JsonObject userAnswers = jsonRequest.getAsJsonObject("userAnswers");
                
                if (userAnswers == null) {
                    throw new IllegalArgumentException("Không tìm thấy dữ liệu câu trả lời trong request");
                }
                
                System.out.println("Parsed user answers: " + userAnswers.toString());
                
                // Sử dụng user ID cứng là 10
                Integer userId = 10;
                HttpSession session = request.getSession();
                Integer quizId = (Integer) session.getAttribute("quizId");
                if (quizId == null) {
                    quizId = 1; // Mặc định quiz ID = 1 nếu không có trong session
                }
                
                System.out.println("User ID: " + userId);
                System.out.println("Quiz ID: " + quizId);

                // Tạo QuizAttemptController để xử lý chấm điểm
                QuizAttemptController attemptController = new QuizAttemptController();
                
                // Lấy attempt hiện tại từ session hoặc tạo mới
                Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
                UserQuizAttempts attempt = null;
                
                if (currentAttemptId != null) {
                    attempt = attemptController.getLatestAttempt(userId, quizId);
                }
                
                // Nếu không có attempt hoặc không tìm thấy, tạo mới
                if (attempt == null) {
                    attempt = attemptController.startQuizAttempt(userId, quizId);
                    session.setAttribute("currentAttemptId", attempt.getId());
                }
                
                System.out.println("Using attempt with ID: " + attempt.getId());
                
                int totalAnswered = 0;
                int totalCorrect = 0;
                
                // Lưu các câu trả lời
                for (Map.Entry<String, JsonElement> entry : userAnswers.entrySet()) {
                    try {
                        Integer questionId = Integer.parseInt(entry.getKey());
                        JsonArray selectedAnswers = entry.getValue().getAsJsonArray();
                        System.out.println("Processing question " + questionId + " with answers: " + selectedAnswers);
                        
                        // Kiểm tra đáp án đúng
                        QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                        List<QuestionOption> correctOptions = optionDAO.findCorrectOptionsByQuestionId(questionId);
                        System.out.println("Correct options for question " + questionId + ": " + correctOptions);
                        
                        // So sánh đáp án đã chọn với đáp án đúng
                        boolean isCorrect = false;
                        List<Integer> selectedOptionIds = new ArrayList<>();
                        for (JsonElement answer : selectedAnswers) {
                            selectedOptionIds.add(answer.getAsInt());
                        }
                        
                        // Kiểm tra xem tất cả các đáp án đúng đã được chọn chưa
                        boolean allCorrectOptionsSelected = true;
                        boolean hasIncorrectSelection = false;
                        
                        // Kiểm tra từng đáp án được chọn
                        for (Integer selectedId : selectedOptionIds) {
                            boolean isCorrectOption = false;
                            for (QuestionOption correctOption : correctOptions) {
                                if (correctOption.getId().equals(selectedId)) {
                                    isCorrectOption = true;
                                    break;
                                }
                            }
                            if (!isCorrectOption) {
                                hasIncorrectSelection = true;
                                break;
                            }
                        }
                        
                        // Kiểm tra xem đã chọn đủ tất cả đáp án đúng chưa
                        for (QuestionOption correctOption : correctOptions) {
                            if (!selectedOptionIds.contains(correctOption.getId())) {
                                allCorrectOptionsSelected = false;
                                break;
                            }
                        }
                        
                        // Câu trả lời chỉ đúng khi chọn đủ và đúng tất cả các đáp án
                        isCorrect = allCorrectOptionsSelected && !hasIncorrectSelection;
                        
                        System.out.println("Question " + questionId + " scoring:");
                        System.out.println("Selected options: " + selectedOptionIds);
                        System.out.println("Correct options: " + correctOptions.stream().map(QuestionOption::getId).collect(Collectors.toList()));
                        System.out.println("All correct selected: " + allCorrectOptionsSelected);
                        System.out.println("Has incorrect: " + hasIncorrectSelection);
                        System.out.println("Is correct: " + isCorrect);
                        
                        if (isCorrect) {
                            totalCorrect++;
                        }
                        totalAnswered++;
                        
                        // Lưu câu trả lời
                        for (JsonElement answer : selectedAnswers) {
                            attemptController.saveAnswer(attempt.getId(), questionId, answer.getAsInt(), isCorrect);
                        }
                        
                        System.out.println("Saved answer for question " + questionId + ", correct: " + isCorrect);
                        
                    } catch (Exception e) {
                        System.out.println("Error processing question: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                System.out.println("Total answered: " + totalAnswered);
                System.out.println("Total correct: " + totalCorrect);
                
                // Hoàn thành bài thi và tính điểm
                double score = attemptController.completeQuizAttempt(attempt.getId());
                System.out.println("Final score: " + score);
                
                // Trả về kết quả
                JsonObject result = new JsonObject();
                result.addProperty("score", score);
                result.addProperty("totalAnswered", totalAnswered);
                result.addProperty("totalCorrect", totalCorrect);
                out.write(result.toString());
                
            } catch (Exception e) {
                System.out.println("\n=== ERROR DETAILS ===");
                System.out.println("Error Type: " + e.getClass().getName());
                System.out.println("Error Message: " + e.getMessage());
                e.printStackTrace(System.out);
                
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("error", "Lỗi khi chấm điểm: " + e.getMessage());
                out.write(errorResponse.toString());
            }
        } else if ("saveAnswer".equals(action)) {
            try {
                // Lấy thông tin câu hỏi và câu trả lời
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                String nextAction = request.getParameter("nextAction");
                int currentNumber = Integer.parseInt(request.getParameter("questionNumber"));
                
                System.out.println("Saving answer for question ID: " + questionId);
                
                // Lấy câu hỏi để kiểm tra type
                QuestionDAO questionDAO = new QuestionDAO();
                Question question = questionDAO.findById(questionId);
                
                // Lấy hoặc tạo mới map lưu câu trả lời trong session
                HttpSession session = request.getSession();
                Map<Integer, Object> userAnswers = (Map<Integer, Object>) session.getAttribute("userAnswers");
                if (userAnswers == null) {
                    userAnswers = new HashMap<>();
                    System.out.println("Created new userAnswers map");
                }
                
                if ("multiple".equals(question.getType())) {
                    // Xử lý câu hỏi trắc nghiệm
                    String[] selectedAnswerIds = request.getParameterValues("answer");
                    List<Integer> answers = new ArrayList<>();
                    if (selectedAnswerIds != null) {
                        for (String answerId : selectedAnswerIds) {
                            answers.add(Integer.parseInt(answerId));
                        }
                        System.out.println("Saved multiple choice answers: " + answers);
                    }
                    userAnswers.put(questionId, answers);
                } else if ("essay".equals(question.getType())) {
                    // Xử lý câu hỏi tự luận
                    String essayAnswer = request.getParameter("essay_answer");
                    if (essayAnswer == null) essayAnswer = "";
                    userAnswers.put(questionId, essayAnswer);
                    System.out.println("Saved essay answer with length: " + essayAnswer.length());
                }
                
                // Cập nhật session
                session.setAttribute("userAnswers", userAnswers);
                System.out.println("Updated session with answers: " + userAnswers);
                
                // Xác định số câu hỏi tiếp theo
                int nextNumber = currentNumber;
                if ("next".equals(nextAction)) {
                    nextNumber++;
                } else if ("previous".equals(nextAction)) {
                    nextNumber--;
                }
                
                // Chuyển hướng đến câu hỏi tiếp theo
                response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=" + nextNumber);
            } catch (Exception e) {
                System.out.println("Error in saveAnswer: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=1");
            }
        }
    }

}
