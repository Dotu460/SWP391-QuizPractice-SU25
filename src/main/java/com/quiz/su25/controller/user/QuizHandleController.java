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
import com.quiz.su25.controller.QuizAttemptAnswerController;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.UserQuizAttempts;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
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
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.sql.Date;
import java.time.LocalDate;
import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.UserDAO;

/**
 *
 * @author quangmingdoc
 */
@WebServlet(name = "QuizHandleController", urlPatterns = {"/quiz-handle"})
public class QuizHandleController extends HttpServlet {

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
            UserDAO userDAO = new UserDAO();

            // Set user ID cứng là 10 và quiz ID là 1 (hoặc ID thực tế của quiz)
            Integer userId = 10;
            session.setAttribute(GlobalConfig.SESSION_ACCOUNT, userDAO.findById(userId));

            // Lấy quizId từ request thay vì gán cứng
            String quizIdParam = request.getParameter("id");
            Integer quizId = quizIdParam != null ? Integer.parseInt(quizIdParam) : 1;
            session.setAttribute("quizId", quizId);

            // Kiểm tra xem đã có attempt đang chạy chưa
            UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
            UserQuizAttempts currentAttempt = attemptsDAO.findLatestAttempt(userId, quizId);
            System.out.println("Current attempt: " + (currentAttempt != null ? currentAttempt.getId() : "null"));

            // Nếu chưa có attempt hoặc attempt cuối cùng đã hoàn thành, tạo attempt mới
            if (currentAttempt == null || GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED.equals(currentAttempt.getStatus())) {
                // Tạo attempt mới
                UserQuizAttempts newAttempt = UserQuizAttempts.builder()
                        .user_id(userId)
                        .quiz_id(quizId)
                        .start_time(Date.valueOf(LocalDate.now()))
                        .end_time(null)
                        .score(0.0)
                        .passed(false)
                        .status(GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS)
                        .created_at(Date.valueOf(LocalDate.now()))
                        .update_at(Date.valueOf(LocalDate.now()))
                        .build();

                int attemptId = attemptsDAO.insert(newAttempt);
                if (attemptId > 0) {
                    newAttempt.setId(attemptId);
                    currentAttempt = newAttempt;
                    System.out.println("Created new attempt with ID: " + currentAttempt.getId());
                    session.setAttribute("currentAttemptId", currentAttempt.getId());
                }
            } else {
                // Nếu có attempt đang chạy, sử dụng attempt đó
                session.setAttribute("currentAttemptId", currentAttempt.getId());
                System.out.println("Using existing attempt with ID: " + currentAttempt.getId());
            }

            // Lấy số thứ tự câu hỏi từ parameter, mặc định là 1
            String questionNumber = request.getParameter("questionNumber");
            int currentNumber = questionNumber != null ? Integer.parseInt(questionNumber) : 1;
            System.out.println("Current question number: " + currentNumber);

            // Lấy danh sách câu hỏi từ database theo quizId
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.findByQuizId(quizId);

            // Kiểm tra nếu có câu hỏi
            if (!questions.isEmpty() && currentNumber <= questions.size()) {
                // Lấy câu hỏi hiện tại
                Question currentQuestion = questions.get(currentNumber - 1);
                System.out.println("Current question ID: " + currentQuestion.getId());

                // Lấy các options cho câu hỏi hiện tại
                QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                List<QuestionOption> options = optionDAO.findByQuestionId(currentQuestion.getId());
                currentQuestion.setQuestionOptions(options);
                System.out.println("Found " + options.size() + " options for question " + currentQuestion.getId());

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
                System.out.println("Set all attributes for JSP");
            }

            // Forward to the quiz handle page
            String forwardPath = "/view/user/quizHandle/quiz-handle.jsp";
            System.out.println("Forwarding to: " + forwardPath);
            request.getRequestDispatcher(forwardPath).forward(request, response);

        } catch (Exception e) {
            System.out.println("=== Error in QuizHandleController ===");
            System.out.println("Error message: " + e.getMessage());
            System.out.println("Error class: " + e.getClass().getName());
            e.printStackTrace();

            // Hiển thị lỗi
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Error occurred:</h1>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
            response.getWriter().println("<p>Please check server logs for more details.</p>");
            response.getWriter().println("</body></html>");
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
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        System.out.println("Received action: " + action);

        // Check if action is null
        if (action == null) {
            sendErrorResponse(response, "Action parameter is required");
            return;
        }

        try {
            switch (action) {
                case "score":
                    handleScoreAction(request, response, out);
                    break;
                case "saveAnswer":
                    handleSaveAnswerAction(request, response, out);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action specified: " + action);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in switch-case handling: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Internal server error: " + e.getMessage());
        }
    }

    private void handleScoreAction(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws IOException {
        try {
            HttpSession session = request.getSession();
            String userAnswersJson = request.getParameter("userAnswers");

            if (userAnswersJson == null || userAnswersJson.isEmpty()) {
                throw new IllegalArgumentException("userAnswers parameter is required and cannot be empty.");
            }
            
            System.out.println("Received userAnswers from parameter: " + userAnswersJson);

            // Parse JSON từ request parameter
            JsonObject userAnswers = JsonParser.parseString(userAnswersJson).getAsJsonObject();
            if (userAnswers == null) {
                throw new IllegalArgumentException("Invalid JSON format in userAnswers parameter");
            }

            System.out.println("Parsed user answers: " + userAnswers.toString());

            // Get session and validate required parameters
            if (session == null) {
                throw new IllegalStateException("No active session found");
            }

            // Sử dụng user ID cứng là 10
            Integer userId = 10;
            Integer quizId = (Integer) session.getAttribute("quizId");
            if (quizId == null) {
                quizId = 1; // Mặc định quiz ID = 1 nếu không có trong session
            }

            System.out.println("User ID: " + userId);
            System.out.println("Quiz ID: " + quizId);

            // Validate attempt
            Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
            if (currentAttemptId == null) {
                throw new IllegalStateException("No active attempt found in session");
            }

            // Tạo QuizAttemptController để xử lý chấm điểm
            UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
            UserQuizAttempts attempt = attemptsDAO.findById(currentAttemptId);

            if (attempt == null) {
                throw new IllegalStateException("Không tìm thấy attempt hoặc attempt không khớp với session");
            }

            System.out.println("Using attempt with ID: " + attempt.getId());

            int totalAnswered = 0;
            int totalCorrect = 0;
            int totalQuestionsInQuiz = new QuestionDAO().countQuestionsByQuizId(quizId);


            // Lưu các câu trả lời
            QuizAttemptAnswerController answerController = new QuizAttemptAnswerController();
            for (Map.Entry<String, JsonElement> entry : userAnswers.entrySet()) {
                try {
                    Integer questionId = Integer.parseInt(entry.getKey());
                    JsonArray selectedAnswers = entry.getValue().getAsJsonArray();
                    System.out.println("Processing question " + questionId + " with answers: " + selectedAnswers);
                    totalAnswered++;
                    
                    // Kiểm tra đáp án đúng
                    QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                    List<QuestionOption> correctOptions = optionDAO.findCorrectOptionsByQuestionId(questionId);
                    System.out.println("Correct options for question " + questionId + ": " + correctOptions);

                    // So sánh đáp án đã chọn với đáp án đúng
                    boolean isCorrect = false;
                    List<Integer> selectedOptionIds = new ArrayList<>();
                    if (selectedAnswers.size() > 0) {
                        for (JsonElement answer : selectedAnswers) {
                            selectedOptionIds.add(answer.getAsInt());
                        }

                        // Lấy set ID của các đáp án đúng
                        var correctOptionIds = correctOptions.stream()
                                .map(QuestionOption::getId)
                                .collect(Collectors.toSet());
                        
                        // Lấy set ID của các đáp án đã chọn
                        var selectedOptionIdsSet = selectedOptionIds.stream()
                                .collect(Collectors.toSet());

                        // Câu trả lời đúng khi và chỉ khi hai set bằng nhau
                        isCorrect = correctOptionIds.equals(selectedOptionIdsSet);
                    }


                    System.out.println("Question " + questionId + " scoring:");
                    System.out.println("Selected options: " + selectedOptionIds);
                    System.out.println("Correct options: " + correctOptions.stream().map(QuestionOption::getId).collect(Collectors.toList()));
                    System.out.println("Is correct: " + isCorrect);

                    if (isCorrect) {
                        totalCorrect++;
                    }

//                    // Lưu câu trả lời
//                    if (!selectedOptionIds.isEmpty()) {
//                        for (Integer answerId : selectedOptionIds) {
//                            answerController.saveAnswer(attempt.getId(), questionId, answerId, isCorrect);
//                        }
//                    } else {
//                        // Lưu câu trả lời rỗng nếu người dùng không chọn gì
//                        answerController.saveAnswer(attempt.getId(), questionId, null, false);
//                    }


                    System.out.println("Saved answer for question " + questionId + ", correct: " + isCorrect);

                } catch (Exception e) {
                    System.out.println("Error processing question: " + e.getMessage());
                    e.printStackTrace();
                }
            }

            System.out.println("Total answered: " + totalAnswered);
            System.out.println("Total correct: " + totalCorrect);
            System.out.println("Total questions in quiz: " + totalQuestionsInQuiz);


            // Hoàn thành bài thi và tính điểm
            double score = (totalQuestionsInQuiz > 0) ? ((double) totalCorrect / totalQuestionsInQuiz * 10.0) : 0.0;
            score = Math.round(score * 10.0) / 10.0; // Làm tròn đến 1 chữ số thập phân
            
            attempt.setScore(score);
            attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
            attempt.setEnd_time(Date.valueOf(LocalDate.now()));
            attempt.setUpdate_at(Date.valueOf(LocalDate.now()));
            attemptsDAO.update(attempt);

            System.out.println("Final score: " + score);

            // Lưu điểm và các thông tin khác vào session để hiển thị ở trang sau
            session.setAttribute("quizScore", score);
            session.setAttribute("totalCorrect", totalCorrect);
            session.setAttribute("totalQuestions", totalQuestionsInQuiz);
            session.setAttribute("toastMessage", "Quiz submitted successfully!");
            session.setAttribute("toastType", "success");
            
            // Redirect to the quiz menu page
            response.sendRedirect(request.getContextPath() + "/quiz-handle-menu");

        } catch (Exception e) {
            handleError(response, e);
        }
    }

    private void handleSaveAnswerAction(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws IOException {
        try {
            // Lấy thông tin câu hỏi và câu trả lời
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String nextAction = request.getParameter("nextAction");
            int currentNumber = Integer.parseInt(request.getParameter("questionNumber"));

            System.out.println("Saving answer for question ID: " + questionId);

            // Lấy câu hỏi để kiểm tra type
            QuestionDAO questionDAO = new QuestionDAO();
            Question question = questionDAO.findById(questionId);

            // Lấy attempt ID từ session
            HttpSession session = request.getSession();
            Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
            if (currentAttemptId == null) {
                throw new IllegalStateException("Không tìm thấy attempt đang hoạt động trong session");
            }

            // Lấy hoặc tạo mới map lưu câu trả lời trong session
            Map<Integer, Object> userAnswers = (Map<Integer, Object>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                System.out.println("Created new userAnswers map");
            }

            // Tạo QuizAttemptAnswerController để xử lý lưu câu trả lời
            QuizAttemptAnswerController answerController = new QuizAttemptAnswerController();

            switch (question.getType()) {
                case "multiple":
                    handleMultipleChoiceAnswer(request, response, questionId, currentAttemptId, userAnswers, answerController);
                    break;
                case "essay":
                    handleEssayAnswer(request, questionId, userAnswers);
                    break;
                default:
                    throw new IllegalArgumentException("Unsupported question type: " + question.getType());
            }

            // Cập nhật session
            session.setAttribute("userAnswers", userAnswers);
            System.out.println("Updated session with answers: " + userAnswers);

            // Xác định số câu hỏi tiếp theo
            int nextNumber = currentNumber;
            switch (nextAction) {
                case "next":
                    nextNumber++;
                    break;
                case "previous":
                    nextNumber--;
                    break;
            }

            // Chuyển hướng đến câu hỏi tiếp theo
            response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=" + nextNumber);

        } catch (Exception e) {
            handleSaveAnswerError(request, response, e);
        }
    }

    private void handleMultipleChoiceAnswer(HttpServletRequest request, HttpServletResponse response, 
            int questionId, int currentAttemptId, Map<Integer, Object> userAnswers, 
            QuizAttemptAnswerController answerController) throws Exception {
        
        String[] selectedAnswerIds = request.getParameterValues("answer");
        List<Integer> answers = new ArrayList<>();
        
        if (selectedAnswerIds != null) {
            for (String answerId : selectedAnswerIds) {
                answers.add(Integer.parseInt(answerId));
            }
            System.out.println("Saved multiple choice answers: " + answers);

            // Kiểm tra đáp án đúng
            QuestionOptionDAO optionDAO = new QuestionOptionDAO();
            List<QuestionOption> correctOptions = optionDAO.findCorrectOptionsByQuestionId(questionId);

            // So sánh đáp án đã chọn với đáp án đúng
            boolean allCorrectOptionsSelected = true;
            boolean hasIncorrectSelection = false;

            // Kiểm tra từng đáp án được chọn
            for (Integer selectedId : answers) {
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
                if (!answers.contains(correctOption.getId())) {
                    allCorrectOptionsSelected = false;
                    break;
                }
            }

            // Câu trả lời chỉ đúng khi chọn đủ và đúng tất cả các đáp án
            boolean isCorrect = allCorrectOptionsSelected && !hasIncorrectSelection;

            // Gọi answerController.saveAnswer cho từng đáp án
            for (Integer answerId : answers) {
                request.setAttribute("attemptId", currentAttemptId);
                request.setAttribute("questionId", questionId);
                request.setAttribute("selectedOptionId", answerId);
                request.setAttribute("isCorrect", isCorrect);
                request.setAttribute("action", "save_answer");
                answerController.saveAnswer(request, response, UserQuizAttempts.builder().id(currentAttemptId).build());
            }
        }
        userAnswers.put(questionId, answers);
    }

    private void handleEssayAnswer(HttpServletRequest request, int questionId, Map<Integer, Object> userAnswers) {
        String essayAnswer = request.getParameter("essay_answer");
        if (essayAnswer == null) {
            essayAnswer = "";
        }
        userAnswers.put(questionId, essayAnswer);
        System.out.println("Saved essay answer with length: " + essayAnswer.length());
        // TODO: Implement essay answer saving logic
    }

    private void handleError(HttpServletResponse response, Exception e) throws IOException {
        System.out.println("\n=== ERROR DETAILS ===");
        System.out.println("Error Type: " + e.getClass().getName());
        System.out.println("Error Message: " + e.getMessage());
        e.printStackTrace(System.out);

        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json");
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", "Lỗi khi chấm điểm: " + e.getMessage());
        response.getWriter().write(errorResponse.toString());
    }

    private void handleSaveAnswerError(HttpServletRequest request, HttpServletResponse response, Exception e) throws IOException {
        System.out.println("Error in saveAnswer: " + e.getMessage());
        e.printStackTrace();
        
        String requestedWith = request.getHeader("X-Requested-With");
        if (requestedWith != null && requestedWith.equals("XMLHttpRequest")) {
            // Nếu là AJAX request, trả về JSON lỗi
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi khi lưu đáp án: " + e.getMessage() + "\"}");
        } else if (!response.isCommitted()) {
            // Nếu là submit form thông thường, redirect
            response.sendRedirect(request.getContextPath() + "/quiz-handle?questionNumber=1");
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("application/json");
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", message);
        response.getWriter().write(errorResponse.toString());
    }

}
