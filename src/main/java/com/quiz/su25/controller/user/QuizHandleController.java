/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.quiz.su25.controller.QuizAttemptAnswerController;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import com.quiz.su25.entity.UserQuizAttempts;
import com.quiz.su25.dal.impl.UserQuizAttemptsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
            // In ra tất cả các tham số request để debug
            System.out.println("\n===== QUIZ HANDLE REQUEST PARAMS =====");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String name = paramNames.nextElement();
                System.out.println(name + ": " + request.getParameter(name));
            }
            System.out.println("====================================\n");
            
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

            // Tạo DAO để thao tác với attempt
            UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();

            // Kiểm tra xem đây có phải là request retake hay không
            String isRetake = request.getParameter("retake");
            String action = request.getParameter("action");
            
            // Xác định xem có cần tạo attempt mới không
            boolean shouldCreateNewAttempt = false;
            
            // TH1: Nếu là retake, luôn tạo attempt mới và đánh dấu tất cả các attempt đang in_progress thành abandoned
            if ("true".equals(isRetake)) {
                System.out.println("===== RETAKE QUIZ =====");
                // Clear all quiz related session attributes
                session.removeAttribute("userAnswers");
                session.removeAttribute("currentAttemptId");
                
                // Đánh dấu tất cả các attempt đang in_progress thành abandoned
                int markedCount = attemptsDAO.markAllInProgressAsAbandoned(userId, quizId);
                System.out.println("Marked " + markedCount + " in-progress attempts as abandoned before starting new attempt");
                
                // Đánh dấu cần tạo attempt mới
                shouldCreateNewAttempt = true;
            } 
            // TH2: Nếu không phải retake, kiểm tra có attempt đang chạy không
            else {
                // Lấy attempt hiện tại từ session
                Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
                UserQuizAttempts currentAttempt = null;
                
                // Nếu có attempt ID trong session, kiểm tra trong database
                if (currentAttemptId != null) {
                    currentAttempt = attemptsDAO.findById(currentAttemptId);
                    System.out.println("Found attempt in session: " + 
                                       (currentAttempt != null ? currentAttempt.getId() + ", status: " + currentAttempt.getStatus() : "null"));
                }
                
                // Nếu không tìm thấy attempt trong session hoặc attempt đã completed, tìm attempt in_progress mới nhất
                if (currentAttempt == null || !GlobalConfig.QUIZ_ATTEMPT_STATUS_IN_PROGRESS.equals(currentAttempt.getStatus())) {
                    // Tìm attempt in_progress mới nhất
                    UserQuizAttempts inProgressAttempt = attemptsDAO.findLatestInProgressAttempt(userId, quizId);
                    
                    if (inProgressAttempt != null) {
                        // Có attempt in_progress, sử dụng nó
                        currentAttempt = inProgressAttempt;
                        session.setAttribute("currentAttemptId", currentAttempt.getId());
                        System.out.println("Using existing in-progress attempt: " + currentAttempt.getId());
                    } else {
                        // Không có attempt in_progress, cần tạo mới
                        shouldCreateNewAttempt = true;
                    }
                }
            }
            
            // Nếu cần tạo attempt mới
            if (shouldCreateNewAttempt) {
                System.out.println("Creating new attempt...");
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
                    session.setAttribute("currentAttemptId", attemptId);
                    System.out.println("Created new attempt with ID: " + attemptId);
                } else {
                    System.out.println("Failed to create new attempt");
                }
            }
            
            // Lấy attempt ID hiện tại từ session để sử dụng
            Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
            if (currentAttemptId == null) {
                throw new IllegalStateException("No active attempt ID in session");
            }
            System.out.println("Using attempt ID: " + currentAttemptId);

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
            System.out.println("\n===== SCORE QUIZ ACTION =====");
            
            // 1. Lấy userAnswers từ request (JSON)
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

            // 2. Lấy thông tin attempt hiện tại từ session
            if (session == null) {
                throw new IllegalStateException("No active session found");
            }

            // Sử dụng user ID cứng là 10
            Integer userId = 10;
            Integer quizId = (Integer) session.getAttribute("quizId");
            if (quizId == null) {
                // Thử lấy từ parameter nếu không có trong session
                String quizIdParam = request.getParameter("quizId");
                quizId = quizIdParam != null ? Integer.parseInt(quizIdParam) : 1;
                System.out.println("Quiz ID from parameter: " + quizId);
            }

            System.out.println("User ID: " + userId);
            System.out.println("Quiz ID: " + quizId);

            // Validate attempt
            Integer currentAttemptId = (Integer) session.getAttribute("currentAttemptId");
            UserQuizAttemptsDAO attemptsDAO = new UserQuizAttemptsDAO();
            UserQuizAttempts attempt = null;

            if (currentAttemptId != null) {
                attempt = attemptsDAO.findById(currentAttemptId);
                System.out.println("Found attempt by ID from session: " + currentAttemptId);
            } 
            
            // Nếu không tìm thấy attempt từ session, thử tìm attempt đang in-progress mới nhất
            if (attempt == null) {
                System.out.println("No valid attempt found in session, searching for in-progress attempt");
                attempt = attemptsDAO.findLatestInProgressAttempt(userId, quizId);
                
                if (attempt != null) {
                    System.out.println("Found active in-progress attempt: " + attempt.getId());
                    // Cập nhật session với attempt ID mới tìm được
                    session.setAttribute("currentAttemptId", attempt.getId());
                } else {
                    // Nếu không tìm thấy attempt đang in-progress, tìm attempt mới nhất
                    attempt = attemptsDAO.findLatestAttempt(userId, quizId);
                    
                    if (attempt != null) {
                        System.out.println("Found latest attempt (any status): " + attempt.getId() + ", status: " + attempt.getStatus());
                        session.setAttribute("currentAttemptId", attempt.getId());
                    } else {
                        // Nếu không tìm thấy attempt nào, tạo mới
                        System.out.println("Creating new attempt as fallback");
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
                            attempt = newAttempt;
                            System.out.println("Created new attempt with ID: " + attempt.getId());
                            session.setAttribute("currentAttemptId", attempt.getId());
                        } else {
                            throw new IllegalStateException("Failed to create new attempt");
                        }
                    }
                }
            }
            
            if (attempt == null) {
                throw new IllegalStateException("Không tìm thấy attempt hoặc attempt không khớp với session");
            }
            
            System.out.println("Using attempt with ID: " + attempt.getId() + " with status: " + attempt.getStatus());

            int totalAnswered = 0;
            int totalCorrect = 0;
            int totalQuestionsInQuiz = new QuestionDAO().countQuestionsByQuizId(quizId);


            // 4. Gọi QuizAttemptAnswerController để lưu đáp án
            QuizAttemptAnswerController answerController = new QuizAttemptAnswerController();
            for (Map.Entry<String, JsonElement> entry : userAnswers.entrySet()) {
                try {
                    Integer questionId = Integer.parseInt(entry.getKey());
                    JsonArray selectedAnswers = entry.getValue().getAsJsonArray();
                    
                    System.out.println("\n--- Scoring Question ID: " + questionId + " ---");

                    totalAnswered++;
                    
                    // Kiểm tra đáp án đúng
                    QuestionOptionDAO optionDAO = new QuestionOptionDAO();
                    List<QuestionOption> correctOptions = optionDAO.findCorrectOptionsByQuestionId(questionId);

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


                    System.out.println("Comparison Result (isCorrect): " + isCorrect);
                    System.out.println("------------------------------------");


                    if (isCorrect) {
                        totalCorrect++;
                    }

                    // Xóa các câu trả lời cũ và lưu các câu trả lời mới
                    answerController.clearAnswersForQuestion(attempt.getId(), questionId);
                    if (!selectedOptionIds.isEmpty()) {
                        for (Integer answerId : selectedOptionIds) {
                            answerController.saveAnswer(attempt.getId(), questionId, answerId, isCorrect);
                        }
                    } else {
                        // Câu hỏi được xem là đã trả lời (nhưng sai) ngay cả khi không có lựa chọn nào
                        // nếu nó đã được người dùng tương tác. Dòng này không cần thiết nếu clear đã chạy.
                    }

                    System.out.println("Saved answer for question " + questionId + ", correct: " + isCorrect);

                } catch (Exception e) {
                    System.out.println("Error processing question: " + e.getMessage());
                    e.printStackTrace();
                }
            }

            System.out.println("\n=== Final Score Calculation ===");
            System.out.println("Total answered: " + totalAnswered);
            System.out.println("Total correct: " + totalCorrect);
            System.out.println("Total questions in quiz: " + totalQuestionsInQuiz);


            // 6. Tính điểm: score = (totalCorrect / totalQuestions) * 10
            double score = (totalQuestionsInQuiz > 0) ? ((double) totalCorrect / totalQuestionsInQuiz * 10.0) : 0.0;
            System.out.println("Calculated Score (before rounding): " + score);
            
            score = Math.round(score * 10.0) / 10.0; // Làm tròn đến 1 chữ số thập phân
            
            System.out.println("Final Score (after rounding): " + score);
            System.out.println("===============================\n");
            
            // 7. Cập nhật trạng thái attempt thành COMPLETED, lưu điểm
            attempt.setScore(score);
            attempt.setStatus(GlobalConfig.QUIZ_ATTEMPT_STATUS_COMPLETED);
            attempt.setEnd_time(Date.valueOf(LocalDate.now()));
            attempt.setUpdate_at(Date.valueOf(LocalDate.now()));
            
            // Sử dụng phương thức updateScore để đảm bảo cập nhật thành công
            boolean updateScoreResult = attemptsDAO.updateScore(attempt.getId(), score, score >= 5.0);
            
            if (updateScoreResult) {
                System.out.println("Successfully updated attempt status to COMPLETED with score: " + score);
            } else {
                // Thử dùng update() nếu updateScore() không thành công
                boolean updateResult = attemptsDAO.update(attempt);
                System.out.println("Updated attempt using update() method: " + updateResult);
            }
            
            // In ra thông tin của attempt sau khi cập nhật để kiểm tra
            UserQuizAttempts updatedAttempt = attemptsDAO.findById(attempt.getId());
            if (updatedAttempt != null) {
                System.out.println("Attempt after update - ID: " + updatedAttempt.getId() +
                                  ", Status: " + updatedAttempt.getStatus() +
                                  ", Score: " + updatedAttempt.getScore());
            }
            
            System.out.println("Final score: " + score);
            
            // 8. Lưu thông tin vào session (quizScore, totalCorrect, ...)
            session.setAttribute("quizScore", score);
            session.setAttribute("totalCorrect", totalCorrect);
            session.setAttribute("totalQuestions", totalQuestionsInQuiz);
            session.setAttribute("toastMessage", "Quiz submitted successfully!");
            session.setAttribute("toastType", "success");
            
            // 9. Xóa dữ liệu từ session để tránh việc retake quiz sẽ hiển thị dữ liệu cũ
            session.removeAttribute("userAnswers");
            
            // 10. Redirect về /quiz-handle-menu
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
               
        // Implement code để lưu câu hỏi tự luận vào DB
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
