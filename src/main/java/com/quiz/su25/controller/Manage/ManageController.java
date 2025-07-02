/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quiz.su25.controller.Manage;

import com.quiz.su25.dal.impl.SubjectCategoriesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.QuestionDAO;
import com.quiz.su25.dal.impl.QuestionOptionDAO;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.SubjectCategories;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.Lesson;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.Question;
import com.quiz.su25.entity.QuestionOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import org.json.JSONObject;
import java.util.stream.Collectors;

@WebServlet(name = "ManageController", urlPatterns = {"/manage-subjects/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ManageController extends HttpServlet {
    private static final int DEFAULT_PAGE_SIZE = 8;
    private static final String UPLOAD_DIRECTORY = "uploads/media";
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final SubjectCategoriesDAO categoryDAO = new SubjectCategoriesDAO();
    private final UserDAO userDAO = new UserDAO();
    private final LessonDAO lessonDAO = new LessonDAO();
    private final QuizzesDAO quizzesDAO = new QuizzesDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final QuestionOptionDAO questionOptionDAO = new QuestionOptionDAO();

    @Override
    public void init() throws ServletException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            listSubjects(request, response);
        } else if (pathInfo.equals("/view")) {
            viewSubject(request, response);
        } else if (pathInfo.equals("/delete")) {
            deleteSubject(request, response);
        } else if (pathInfo.equals("/view-quiz")) {
            viewQuiz(request, response);
        } else if (pathInfo.equals("/add-lesson")) {
            showAddLessonForm(request, response);
        } else if (pathInfo.equals("/edit-lesson")) {
            showEditLessonForm(request, response);
        } else if (pathInfo.equals("/add-quiz")) {
            showAddQuizForm(request, response);
        } else if (pathInfo.equals("/delete-lesson")) {
            deleteLesson(request, response);
        } else if (pathInfo.equals("/delete-quiz")) {
            deleteQuiz(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo.equals("/update-quiz")) {
            updateQuiz(request, response);
        } else if (pathInfo.equals("/upload-media")) {
            handleMediaUpload(request, response);
        } else if (pathInfo.equals("/delete-question")) {
            deleteQuestion(request, response);
        } else if (pathInfo.equals("/delete-option")) {
            deleteOption(request, response);
        } else if (pathInfo.equals("/add-lesson")) {
            addLesson(request, response);
        } else if (pathInfo.equals("/edit-lesson")) {
            updateLesson(request, response);
        } else if (pathInfo.equals("/add-quiz")) {
            addQuiz(request, response);
        }
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

        // Get filter parameters
        String categoryFilter = request.getParameter("category");
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "active"; // Default to active subjects
        }
        String searchTerm = request.getParameter("search");

        // Set default sort
        String sortBy = "updated_at";
        String sortOrder = "ASC";

        // Get paginated subjects using the filters
        List<Subject> subjects = subjectDAO.getPaginatedSubjects(
                page, pageSize, categoryFilter, statusFilter, searchTerm, sortBy, sortOrder);

        // Get owner names for the subjects
        Map<Integer, String> ownerNames = new HashMap<>();
        for (Subject subject : subjects) {
            if (subject.getOwner_id() != null && !ownerNames.containsKey(subject.getOwner_id())) {
                User owner = userDAO.findById(subject.getOwner_id());
                if (owner != null) {
                    ownerNames.put(subject.getOwner_id(), owner.getFull_name());
                }
            }
        }
        request.setAttribute("ownerNames", ownerNames);

        // Get total count for pagination
        int totalSubjects = subjectDAO.countTotalSubjects(categoryFilter, statusFilter, searchTerm);
        int totalPages = (int) Math.ceil((double) totalSubjects / pageSize);

        // Get all categories for filter
        List<SubjectCategories> categories = categoryDAO.findAll();

        // Set attributes for the view
        request.setAttribute("subjects", subjects);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSubjects", totalSubjects);
        request.setAttribute("categoryFilter", categoryFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categories", categories);

        // Forward to the view
        request.getRequestDispatcher("/view/admin/Manage/manage-subject.jsp").forward(request, response);
    }

    private void viewSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                // Get the subject's category
                SubjectCategories category = categoryDAO.findById(subject.getCategory_id());
                
                // Get all lessons for this subject
                List<Lesson> lessons = lessonDAO.findBySubjectId(subjectId);
                
                // Get all quizzes for the lessons
                List<Quizzes> quizzes = new ArrayList<>();
                for (Lesson lesson : lessons) {
                    // Assuming you have a method in QuizzesDAO to find quizzes by lesson_id
                    List<Quizzes> lessonQuizzes = quizzesDAO.findQuizzesWithFilters(null, null, lesson.getId(), null, 1, 100);
                    quizzes.addAll(lessonQuizzes);
                }

                // Set attributes for the view
                request.setAttribute("subject", subject);
                request.setAttribute("category", category);
                request.setAttribute("lessons", lessons);
                request.setAttribute("quizzes", quizzes);
                request.setAttribute("questionDAO", questionDAO);

                // Forward to the lesson management page
                request.getRequestDispatcher("/view/admin/Manage/manage-lesson.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/manage/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/manage/subjects?error=invalidId");
        }
    }

    private void deleteSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            boolean success = subjectDAO.deleteById(subjectId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manage/subjects?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/manage/subjects?error=deleteFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/manage/subjects?error=invalidId");
        }
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    private void updateQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get quiz info
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String name = request.getParameter("name");
            String level = request.getParameter("level");
            int durationMinutes = Integer.parseInt(request.getParameter("duration_minutes"));
            String status = request.getParameter("status");
            
            // Get existing quiz
            Quizzes existingQuiz = quizzesDAO.findById(quizId);
            if (existingQuiz == null) {
                throw new Exception("Quiz not found");
            }

            // Update quiz with new values
            existingQuiz.setName(name);
            existingQuiz.setLesson_id(lessonId);
            existingQuiz.setLevel(level);
            existingQuiz.setDuration_minutes(durationMinutes);
            existingQuiz.setStatus(status);
            
            // Preserve existing values for required fields
            if (existingQuiz.getQuiz_type() == null) {
                existingQuiz.setQuiz_type("multiple"); // Set default value
            }
            if (existingQuiz.getNumber_of_questions_target() <= 0) {
                existingQuiz.setNumber_of_questions_target(10); // Set default value
            }
            
            // Update quiz
            boolean quizUpdated = quizzesDAO.update(existingQuiz);
            if (!quizUpdated) {
                throw new Exception("Failed to update quiz");
            }

            // Get all question IDs from the form
            Map<String, String[]> parameters = request.getParameterMap();
            
            // Process each question
            for (String paramName : parameters.keySet()) {
                if (paramName.matches("questions\\[\\d+\\]\\.content")) {
                    //int index = Integer.parseInt(paramName.replaceAll("\\D+", ""));
                    String indexStr = paramName.substring(paramName.indexOf('[') + 1, paramName.indexOf(']'));
                    int index = Integer.parseInt(indexStr);
                    String content = request.getParameter(paramName);
                    String mediaUrl = request.getParameter("questions[" + index + "].media_url");
                    String questionType = request.getParameter("questions[" + index + "].type");
                    String questionLevel = request.getParameter("questions[" + index + "].level");
                    String explanation = request.getParameter("questions[" + index + "].explanation");
                    String questionIdStr = request.getParameter("questions[" + index + "].id");
                    
                    Question question;
                    int questionId = 0;
                    
                    if (questionIdStr != null && !questionIdStr.isEmpty()) {
                        questionId = Integer.parseInt(questionIdStr);
                        question = questionDAO.findById(questionId);
                        if (question == null) {
                            throw new Exception("Question not found: " + questionId);
                        }
                    } else {
                        question = new Question();
                        question.setQuiz_id(quizId);
                    }
                    
                    // Update question
                    question.setContent(content);
                    question.setMedia_url(mediaUrl);
                    question.setType(questionType);
                    question.setLevel(questionLevel);
                    question.setExplanation(explanation);
                    question.setStatus("active");
                    
                    if (questionIdStr != null && !questionIdStr.isEmpty()) {
                        boolean questionUpdated = questionDAO.update(question);
                        if (!questionUpdated) {
                            throw new Exception("Failed to update question: " + questionId);
                        }
                        questionId = question.getId();
                    } else {
                        questionId = questionDAO.insert(question);
                        if (questionId <= 0) {
                            throw new Exception("Failed to create new question");
                        }
                        question.setId(questionId);
                    }

                    // Process options - only if they exist in the form
                    List<QuestionOption> oldOptions = questionOptionDAO.findByQuestionId(questionId);
                    List<Integer> formOptionIds = new ArrayList<>();
                    
                    // Check if this question has any options in the form
                    boolean hasOptionsInForm = request.getParameter("questions[" + index + "].options[0].option_text") != null || 
                                             request.getParameter("questions[" + index + "].options[0].answer_text") != null;
                    
                    if (hasOptionsInForm) {
                        // Get number of options from form
                        int optionIndex = 0;
                        String optionParam;
                        String[] selectedCorrectAnswers = request.getParameterValues("questions[" + index + "].correctAnswers");
                        
                        // Convert to Set for easier lookup
                        java.util.Set<Integer> correctAnswerSet = new java.util.HashSet<>();
                        if (selectedCorrectAnswers != null) {
                            for (String answerStr : selectedCorrectAnswers) {
                                correctAnswerSet.add(Integer.parseInt(answerStr));
                            }
                        }
                        
                        while ((optionParam = request.getParameter("questions[" + index + "].options[" + optionIndex + "].option_text")) != null ||
                               (optionParam = request.getParameter("questions[" + index + "].options[" + optionIndex + "].answer_text")) != null) {
                            String optionIdStr = request.getParameter("questions[" + index + "].options[" + optionIndex + "].id");
                            String currentOptionText = optionParam;
                            
                            int optionId = 0;
                            try {
                                if (optionIdStr != null && !optionIdStr.isEmpty()) {
                                    optionId = Integer.parseInt(optionIdStr);
                                }
                            } catch (Exception ignore) {}
                            formOptionIds.add(optionId);
                            
                            QuestionOption option;
                            if (optionId != 0) {
                                // Update existing option
                                option = questionOptionDAO.findById(optionId);
                                if (option == null) {
                                    option = new QuestionOption();
                                    option.setQuestion_id(questionId);
                                }
                            } else {
                                // Create new option
                                option = new QuestionOption();
                                option.setQuestion_id(questionId);
                            }
                            
                            // Set display order
                            option.setDisplay_order(optionIndex + 1);
                            
                            // Set correct_key based on checkbox selection
                            boolean isCorrect = correctAnswerSet.contains(optionIndex);
                            option.setCorrect_key(isCorrect);
                            
                            // Lấy giá trị từ form
                            String optionText = request.getParameter("questions[" + index + "].options[" + optionIndex + "].option_text");
                            String answerText = request.getParameter("questions[" + index + "].options[" + optionIndex + "].answer_text");
                            String answerType = request.getParameter("questions[" + index + "].answer_type");
                            
                            // Nếu không có answer_type từ form, mặc định là option_text
                            if (answerType == null || answerType.isEmpty()) {
                                answerType = "option_text";
                            }
                            
                            if (optionId != 0) {
                                // Update existing option
                                QuestionOption existingOption = questionOptionDAO.findById(optionId);
                                if (existingOption != null) {
                                    // Dựa vào answer_type đã chọn để quyết định lưu vào field nào
                                    if ("answer_text".equals(answerType)) {
                                        existingOption.setAnswer_text(answerText);
                                        existingOption.setOption_text(null);
                                    } else {
                                        // option_text
                                        existingOption.setOption_text(optionText);
                                        existingOption.setAnswer_text(null);
                                    }
                                    existingOption.setCorrect_key(isCorrect);
                                    existingOption.setDisplay_order(optionIndex + 1);
                                    questionOptionDAO.update(existingOption);
                                }
                            } else {
                                // For new option
                                QuestionOption newOption = new QuestionOption();
                                newOption.setQuestion_id(questionId);
                                
                                // Dựa vào answer_type đã chọn để quyết định lưu vào field nào
                                if ("answer_text".equals(answerType)) {
                                    newOption.setAnswer_text(answerText);
                                    newOption.setOption_text(null);
                                } else {
                                    // option_text (default)
                                    newOption.setOption_text(optionText);
                                    newOption.setAnswer_text(null);
                                }
                                
                                newOption.setCorrect_key(isCorrect);
                                newOption.setDisplay_order(optionIndex + 1);
                                questionOptionDAO.insert(newOption);
                            }
                            
                            optionIndex++;
                        }
                        
                        // Delete options that are no longer in the form - only if we processed options
                        for (QuestionOption oldOpt : oldOptions) {
                            if (!formOptionIds.contains(oldOpt.getId())) {
                                questionOptionDAO.delete(oldOpt);
                            }
                        }
                    }
                    // If no options in form, don't delete existing options (leave them as is)
                }
            }

            // Get lesson and subject info for redirect
            Lesson lesson = lessonDAO.findById(lessonId);
            int subjectId = lesson.getSubject_id();

            // Redirect to manage-lesson page with success message
            response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=quiz_updated");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            viewQuiz(request, response);
        }
    }

    private void handleMediaUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the file part
            Part filePart = request.getPart("file");
            String fileName = getSubmittedFileName(filePart);
            
            // Generate unique filename
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
            // Get upload directory
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save file
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Return file URL
            String fileUrl = "/SWP391_QUIZ_PRACTICE_SU25/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;
            
            // Send JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"location\":\"" + fileUrl + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

    private void viewQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int quizId = Integer.parseInt(request.getParameter("id"));
            
            // Get quiz information
            Quizzes quiz = quizzesDAO.findById(quizId);
            if (quiz != null) {
                // Get lesson information
                Lesson lesson = lessonDAO.findById(quiz.getLesson_id());
                if (lesson != null) {
                    // Get subject information
                    Subject subject = subjectDAO.findById(lesson.getSubject_id());
                    
                    // Get all questions for this quiz
                    List<Question> questions = questionDAO.findByQuizId(quizId);
                    
                    // Get options for each question
                    for (Question question : questions) {
                        List<QuestionOption> options = questionOptionDAO.findByQuestionId(question.getId());
                        question.setQuestionOptions(options);
                    }
                    
                    // Set attributes for the view
                    request.setAttribute("quiz", quiz);
                    request.setAttribute("lesson", lesson);
                    request.setAttribute("subject", subject);
                    request.setAttribute("questions", questions);
                    
                    // Forward to the quiz management page
                    request.getRequestDispatcher("/view/admin/Manage/manage-quiz.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/manage-subjects?error=lessonNotFound");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=quizNotFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidQuizId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=" + e.getMessage());
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            Question question = questionDAO.findById(questionId);
            // Delete all options first
            questionOptionDAO.deleteByQuestionId(questionId);
            
            // Then delete the question
            boolean success = questionDAO.delete(question);
            
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", success);
            if (!success) {
                jsonResponse.put("message", "Failed to delete question");
            }
            
            response.getWriter().write(jsonResponse.toString());
            
        } catch (Exception e) {
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);
            jsonResponse.put("message", e.getMessage());
            response.getWriter().write(jsonResponse.toString());
        }
    }

    private void deleteOption(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();
        
        try {
            int optionId = Integer.parseInt(request.getParameter("optionId"));
            QuestionOption option = questionOptionDAO.findById(optionId);
            
            if (option == null) {
                throw new Exception("Option not found");
            }
            
            // Delete the option
            boolean success = questionOptionDAO.delete(option);
            jsonResponse.put("success", success);
            
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", e.getMessage());
        }
        
        response.getWriter().write(jsonResponse.toString());
    }

    private void showAddLessonForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            Subject subject = subjectDAO.findById(subjectId);
            
            if (subject == null) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=subjectNotFound");
                return;
            }
            
            request.setAttribute("subject", subject);
            request.getRequestDispatcher("/view/admin/Manage/manage-add-lesson.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidSubjectId");
        }
    }

    private void addLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String title = request.getParameter("title");
            String contentText = request.getParameter("content_text");
            String status = request.getParameter("status");
            
            // Validate input
            if (title == null || title.trim().isEmpty()) {
                throw new Exception("Lesson title is required");
            }
            
            // Get next order number for this subject
            List<Lesson> existingLessons = lessonDAO.findBySubjectId(subjectId);
            int nextOrder = existingLessons.size() + 1;
            
            // Create new lesson
            Lesson lesson = new Lesson();
            lesson.setSubject_id(subjectId);
            lesson.setTitle(title);
            lesson.setContent_text(contentText);
            lesson.setOrder_in_subject(nextOrder);
            lesson.setStatus(status != null ? status : "active");
            
            // Insert lesson
            int lessonId = lessonDAO.insert(lesson);
            if (lessonId > 0) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=lesson_added");
            } else {
                throw new Exception("Failed to create lesson");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            int subjectId = getIntParameter(request, "subjectId", 0);
            request.setAttribute("errorMessage", e.getMessage());
            showAddLessonForm(request, response);
        }
    }

    private void showEditLessonForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));
            Lesson lesson = lessonDAO.findById(lessonId);
            
            if (lesson == null) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=lessonNotFound");
                return;
            }
            
            // Get subject info
            Subject subject = subjectDAO.findById(lesson.getSubject_id());
            
            request.setAttribute("lesson", lesson);
            request.setAttribute("subject", subject);
            request.getRequestDispatcher("/view/admin/Manage/manage-edit-lesson.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidLessonId");
        }
    }

    private void updateLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String contentText = request.getParameter("content_text");
            String status = request.getParameter("status");
            
            // Validate input
            if (title == null || title.trim().isEmpty()) {
                throw new Exception("Lesson title is required");
            }
            
            // Get existing lesson
            Lesson lesson = lessonDAO.findById(lessonId);
            if (lesson == null) {
                throw new Exception("Lesson not found");
            }
            
            // Update lesson properties
            lesson.setTitle(title);
            lesson.setContent_text(contentText);
            lesson.setStatus(status != null ? status : "active");
            
            // Update lesson
            boolean success = lessonDAO.update(lesson);
            if (success) {
                int subjectId = lesson.getSubject_id();
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=lesson_updated");
            } else {
                throw new Exception("Failed to update lesson");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            int lessonId = getIntParameter(request, "lessonId", 0);
            request.setAttribute("errorMessage", e.getMessage());
            if (lessonId > 0) {
                // Set id parameter for showEditLessonForm
                request.setAttribute("id", String.valueOf(lessonId));
                showEditLessonForm(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidLessonId");
            }
        }
    }

    private void showAddQuizForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            Lesson lesson = lessonDAO.findById(lessonId);
            
            if (lesson == null) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=lessonNotFound");
                return;
            }
            
            // Get subject info
            Subject subject = subjectDAO.findById(lesson.getSubject_id());
            
            request.setAttribute("lesson", lesson);
            request.setAttribute("subject", subject);
            request.getRequestDispatcher("/view/admin/Manage/manage-add-quiz.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidLessonId");
        }
    }

    private void addQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String name = request.getParameter("name");
            String level = request.getParameter("level");
            int durationMinutes = Integer.parseInt(request.getParameter("duration_minutes"));
            String status = request.getParameter("status");
            
            // Validate input
            if (name == null || name.trim().isEmpty()) {
                throw new Exception("Quiz name is required");
            }
            
            // Get lesson to verify it exists and get subject info
            Lesson lesson = lessonDAO.findById(lessonId);
            if (lesson == null) {
                throw new Exception("Lesson not found");
            }
            
            // Create new quiz
            Quizzes quiz = new Quizzes();
            quiz.setName(name);
            quiz.setLesson_id(lessonId);
            quiz.setLevel(level);
            quiz.setDuration_minutes(durationMinutes);
            quiz.setStatus(status != null ? status : "active");
            quiz.setQuiz_type("multiple"); // Default type
            quiz.setNumber_of_questions_target(10); // Default target
            
            // Insert quiz
            int quizId = quizzesDAO.insertNewQuiz(quiz);
            if (quizId > 0) {
                int subjectId = lesson.getSubject_id();
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=quiz_added");
            } else {
                throw new Exception("Failed to create quiz");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            int lessonId = getIntParameter(request, "lessonId", 0);
            request.setAttribute("errorMessage", e.getMessage());
            if (lessonId > 0) {
                request.setAttribute("lessonId", String.valueOf(lessonId));
                showAddQuizForm(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidLessonId");
            }
        }
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));
            Lesson lesson = lessonDAO.findById(lessonId);
            
            if (lesson == null) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=lessonNotFound");
                return;
            }
            
            int subjectId = lesson.getSubject_id();
            
            // Delete all quizzes in this lesson first
            List<Quizzes> quizzes = quizzesDAO.findQuizzesWithFilters(null, null, lessonId, null, 1, 1000);
            for (Quizzes quiz : quizzes) {
                // Delete all questions and options for each quiz
                List<Question> questions = questionDAO.findByQuizId(quiz.getId());
                for (Question question : questions) {
                    questionOptionDAO.deleteByQuestionId(question.getId());
                    questionDAO.delete(question);
                }
                quizzesDAO.delete(quiz);
            }
            
            // Delete the lesson
            boolean success = lessonDAO.delete(lesson);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=lesson_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidLessonId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=" + e.getMessage());
        }
    }

    private void deleteQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quizzes quiz = quizzesDAO.findById(quizId);
            
            if (quiz == null) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects?error=quizNotFound");
                return;
            }
            
            // Get lesson and subject info for redirect
            Lesson lesson = lessonDAO.findById(quiz.getLesson_id());
            int subjectId = lesson.getSubject_id();
            
            // Delete all questions and options for this quiz first
            List<Question> questions = questionDAO.findByQuizId(quizId);
            for (Question question : questions) {
                questionOptionDAO.deleteByQuestionId(question.getId());
                questionDAO.delete(question);
            }
            
            // Delete the quiz
            boolean success = quizzesDAO.delete(quiz);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&success=quiz_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-subjects/view?id=" + subjectId + "&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=invalidQuizId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manage-subjects?error=" + e.getMessage());
        }
    }

}
