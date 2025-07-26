/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.Expert;

import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.Lesson;
import com.quiz.su25.entity.User;
import com.quiz.su25.config.GlobalConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/quizzes-list")
public class QuizzesListController extends HttpServlet {

    private static final String LIST_PAGE = "view/Expert/Quiz/quizzes-list.jsp";
    private QuizzesDAO quizzesDAO;
    private SubjectDAO subjectDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        quizzesDAO = new QuizzesDAO();
        subjectDAO = new SubjectDAO();
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                showAddQuizForm(request, response);
                break;
            case "details":
                showQuizDetails(request, response);
                break;
            case "list":
            default:
                listQuizzes(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteQuiz(request, response);
        } else if ("create".equals(action)) {
            createQuiz(request, response);
        } else if ("update".equals(action)) {
            updateQuiz(request, response);
        } else if ("checkName".equals(action)) {
            checkQuizName(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        }
    }

    /**
     * AJAX endpoint to check if quiz name exists in lesson
     */
    private void checkQuizName(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String name = request.getParameter("name");
            String lessonIdStr = request.getParameter("lessonId");
            
            if (name == null || name.trim().isEmpty() || lessonIdStr == null || lessonIdStr.isEmpty()) {
                response.getWriter().write("{\"valid\": true, \"message\": \"\"}");
                return;
            }
            
            int lessonId = Integer.parseInt(lessonIdStr);
            boolean exists = quizzesDAO.isNameExistsInLesson(name.trim(), lessonId);
            
            if (exists) {
                response.getWriter().write("{\"valid\": false, \"message\": \"Quiz name already exists in this lesson\"}");
            } else {
                response.getWriter().write("{\"valid\": true, \"message\": \"Quiz name is available\"}");
            }
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"valid\": true, \"message\": \"\"}");
        } catch (Exception e) {
            System.out.println("Error in checkQuizName: " + e.getMessage());
            response.getWriter().write("{\"valid\": true, \"message\": \"\"}");
        }
    }

    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin user từ session
            User currentUser = (User) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);
            request.setAttribute("currentUser", currentUser);
            
            // Get and validate filter parameters
            String quizName = request.getParameter("quizName");
            if (quizName != null && quizName.trim().isEmpty()) {
                quizName = null;
            }

            String quizType = request.getParameter("quizType");
            if (quizType != null && quizType.trim().isEmpty()) {
                quizType = null;
            }

            // Parse subject ID if provided
            Integer subjectId = null;
            try {
                String subjectIdStr = request.getParameter("subjectId");
                if (subjectIdStr != null && !subjectIdStr.trim().isEmpty() && !"0".equals(subjectIdStr)) {
                    subjectId = Integer.parseInt(subjectIdStr);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid subject ID format: " + e.getMessage());
            }

            // Get total records count
            int totalRecords = quizzesDAO.getTotalFilteredQuizzes(quizName, subjectId, null, quizType);

            // Handle records per page - default to total records count
            int recordsPerPage = 5;
            String recordsPerPageStr = request.getParameter("recordsPerPage");
            if (recordsPerPageStr != null && !recordsPerPageStr.trim().isEmpty()) {
                try {
                    recordsPerPage = Integer.parseInt(recordsPerPageStr);
                    if (recordsPerPage < 1) {
                        recordsPerPage = 5;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Invalid records per page format: " + e.getMessage());
                }
            }

            // Always show page 1 when showing all records
            int currentPage = (recordsPerPage == totalRecords) ? 1 : 1;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty() && recordsPerPage != totalRecords) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid page number format: " + e.getMessage());
            }

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // Validate page number
            if (totalPages == 0) {
                totalPages = 1;
            }
            if (currentPage < 1) {
                currentPage = 1;
            } else if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            // Get filtered quizzes with pagination
            List<Quizzes> quizzesList = quizzesDAO.findQuizzesWithFilters(
                quizName, subjectId, null, quizType, currentPage, recordsPerPage
            );

            // Get all subjects for dropdown
            List<Subject> subjectsList = subjectDAO.findAll();

            // Set attributes for the view
            request.setAttribute("quizzesList", quizzesList);
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("quizName", quizName);
            request.setAttribute("subjectId", subjectId);
            request.setAttribute("quizType", quizType);
            request.setAttribute("lessonDAO", lessonDAO);
            request.setAttribute("subjectDAO", subjectDAO);

            // Forward to the list page
            request.getRequestDispatcher(LIST_PAGE).forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in QuizzesListController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher(LIST_PAGE).forward(request, response);
        }
    }

    private void deleteQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get quiz ID from request
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            Quizzes quiz = quizzesDAO.findById(quizId);

            if (quiz != null) {
                boolean deleted = quizzesDAO.delete(quiz);
                if (deleted) {
                    request.getSession().setAttribute("successMessage", "Quiz deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete quiz!");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Quiz not found!");
            }

            // Preserve filter state after deletion
            StringBuilder redirectURL = new StringBuilder(request.getContextPath()).append("/quizzes-list");
            List<String> params = new ArrayList<>();

            // Add filter parameters if they exist
            String page = request.getParameter("page");
            String quizName = request.getParameter("quizName");
            String subjectId = request.getParameter("subjectId");
            String quizType = request.getParameter("quizType");

            if (page != null && !page.isEmpty()) {
                params.add("page=" + page);
            }
            if (quizName != null && !quizName.isEmpty()) {
                params.add("quizName=" + URLEncoder.encode(quizName, "UTF-8"));
            }
            if (subjectId != null && !subjectId.isEmpty() && !"0".equals(subjectId)) {
                params.add("subjectId=" + subjectId);
            }
            if (quizType != null && !quizType.isEmpty()) {
                params.add("quizType=" + URLEncoder.encode(quizType, "UTF-8"));
            }

            // Add parameters to URL
            if (!params.isEmpty()) {
                redirectURL.append("?").append(String.join("&", params));
            }

            // Redirect back to list with preserved filters
            response.sendRedirect(redirectURL.toString());

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid quiz ID!");
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        }
    }

    private void showAddQuizForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all lessons and subjects
            List<Subject> subjectsList = subjectDAO.findAll();
            List<Lesson> lessonsList = lessonDAO.findAll();
            
            // Set attributes for JSP
            request.setAttribute("lessonsList", lessonsList);
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("subjectDAO", subjectDAO);
            
            // Forward to the add quiz page
            request.getRequestDispatcher("view/Expert/Quiz/addQuiz.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in showAddQuizForm: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the page.");
            request.getRequestDispatcher("view/Expert/Quiz/addQuiz.jsp").forward(request, response);
        }
    }

    private void createQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from form
            String name = request.getParameter("name");
            int lessonId = Integer.parseInt(request.getParameter("lesson_id"));
            String level = request.getParameter("level");
            String quizType = request.getParameter("quiz_type");
            int durationMinutes = Integer.parseInt(request.getParameter("duration_minutes"));
            int numberOfQuestions = Integer.parseInt(request.getParameter("number_of_questions"));
            String status = request.getParameter("status");

            // Validate quiz name is not empty
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Quiz name is required!");
                showAddQuizForm(request, response);
                return;
            }

            // Validate status is not empty
            if (status == null || status.trim().isEmpty()) {
                request.setAttribute("error", "Status is required!");
                showAddQuizForm(request, response);
                return;
            }

            // Check if quiz name already exists in the same lesson
            if (quizzesDAO.isNameExistsInLesson(name.trim(), lessonId)) {
                request.setAttribute("error", "Quiz name '" + name.trim() + "' already exists in this lesson. Please choose a different name.");
                showAddQuizForm(request, response);
                return;
            }

            // Create new quiz
            Quizzes newQuiz = new Quizzes();
            newQuiz.setName(name);
            newQuiz.setLesson_id(lessonId);
            newQuiz.setNumber_of_questions_target(numberOfQuestions);
            newQuiz.setLevel(level);
            newQuiz.setQuiz_type(quizType);
            newQuiz.setDuration_minutes(durationMinutes);
            newQuiz.setStatus(status);

            // Insert into database
            int result = quizzesDAO.insertNewQuiz(newQuiz);

            if (result > 0) {
                // Redirect to quiz list with success message
                request.getSession().setAttribute("successMessage", "Quiz created successfully!");
                response.sendRedirect(request.getContextPath() + "/quizzes-list");
            } else {
                request.setAttribute("error", "Failed to create quiz!");
                showAddQuizForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in form data!");
            showAddQuizForm(request, response);
        } catch (Exception e) {
            System.out.println("Error in createQuiz: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the quiz!");
            showAddQuizForm(request, response);
        }
    }

    private void updateQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from form
            int quizId = Integer.parseInt(request.getParameter("quiz_id"));
            String name = request.getParameter("name");
            int lessonId = Integer.parseInt(request.getParameter("lesson_id"));
            String level = request.getParameter("level");
            String quizType = request.getParameter("quiz_type");
            int durationMinutes = Integer.parseInt(request.getParameter("duration_minutes"));
            int numberOfQuestions = Integer.parseInt(request.getParameter("number_of_questions"));
            String redirect = request.getParameter("redirect");
            String status = request.getParameter("status");

            // Get existing quiz
            Quizzes existingQuiz = quizzesDAO.findById(quizId);
            if (existingQuiz == null) {
                request.setAttribute("error", "Quiz not found!");
                response.sendRedirect(request.getContextPath() + "/quizzes-list");
                return;
            }

            // Validate status is not empty
            if (status == null || status.trim().isEmpty()) {
                request.setAttribute("error", "Status is required!");
                response.sendRedirect(request.getContextPath() + "/QuizDetails?id=" + quizId);
                return;
            }

            // Check for duplicate quiz
            List<Quizzes> allQuizzes = quizzesDAO.findAll();
            boolean isDuplicate = false;
            for (Quizzes quiz : allQuizzes) {
                if (quiz.getId() != quizId && // Skip the current quiz being updated
                    quiz.getName().equals(name) &&
                    quiz.getLesson_id() == lessonId &&
                    quiz.getLevel().equals(level) &&
                    quiz.getQuiz_type().equals(quizType) &&
                    quiz.getDuration_minutes() == durationMinutes &&
                    quiz.getNumber_of_questions_target() == numberOfQuestions &&
                    quiz.getStatus().equals(status)) {
                    isDuplicate = true;
                    break;
                }
            }

            if (isDuplicate) {
                request.setAttribute("error", "A quiz with identical information already exists!");
                response.sendRedirect(request.getContextPath() + "/QuizDetails?id=" + quizId);
                return;
            }

            // Update quiz object
            existingQuiz.setName(name);
            existingQuiz.setLesson_id(lessonId);
            existingQuiz.setLevel(level);
            existingQuiz.setQuiz_type(quizType);
            existingQuiz.setDuration_minutes(durationMinutes);
            existingQuiz.setNumber_of_questions_target(numberOfQuestions);
            existingQuiz.setStatus(status);

            // Update in database
            boolean updated = quizzesDAO.update(existingQuiz);

            if (updated) {
                request.getSession().setAttribute("successMessage", "Quiz updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update quiz!");
            }

            // Redirect based on the redirect parameter
            if ("list".equals(redirect)) {
                response.sendRedirect(request.getContextPath() + "/quizzes-list");
            } else {
                response.sendRedirect(request.getContextPath() + "/QuizDetails?id=" + quizId);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in form data!");
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        } catch (Exception e) {
            System.out.println("Error in updateQuiz: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the quiz!");
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        }
    }

    private void showQuizDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get quiz ID from request
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quizzes quiz = quizzesDAO.findById(quizId);

            if (quiz == null) {
                request.setAttribute("error", "Quiz not found!");
                response.sendRedirect(request.getContextPath() + "/quizzes-list");
                return;
            }

            // Get all lessons and subjects for dropdowns
            List<Subject> subjectsList = subjectDAO.findAll();
            List<Lesson> lessonsList = lessonDAO.findAll();
            
            // Set attributes for JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("lessonsList", lessonsList);
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("subjectDAO", subjectDAO);
            request.setAttribute("lessonDAO", lessonDAO);
            
            // Forward to the quiz details page
            request.getRequestDispatcher("view/Expert/Quiz/QuizDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quiz ID!");
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        } catch (Exception e) {
            System.out.println("Error in showQuizDetails: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the quiz details.");
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        }
    }
}
