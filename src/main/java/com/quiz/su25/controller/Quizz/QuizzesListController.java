/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.Quizz;

import com.quiz.su25.dal.impl.QuizzesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.entity.Quizzes;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.Lesson;
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

    private static final int RECORDS_PER_PAGE = 5;
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
        } else {
            response.sendRedirect(request.getContextPath() + "/quizzes-list");
        }
    }

    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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

            // Handle pagination
            int currentPage = 1;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid page number format: " + e.getMessage());
            }

            // Calculate total pages
            int totalRecords = quizzesDAO.getTotalFilteredQuizzes(quizName, subjectId, null, quizType);
            int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

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
                quizName, subjectId, null, quizType, currentPage, RECORDS_PER_PAGE
            );

            // Get all subjects for dropdown
            List<Subject> subjectsList = subjectDAO.findAll();

            // Set attributes for the view
            request.setAttribute("quizzesList", quizzesList);
            request.setAttribute("subjectsList", subjectsList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
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
                    request.setAttribute("successMessage", "Quiz deleted successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete quiz!");
                }
            } else {
                request.setAttribute("errorMessage", "Quiz not found!");
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
            request.setAttribute("errorMessage", "Invalid quiz ID!");
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

            // Check if quiz with same information exists
            List<Quizzes> allQuizzes = quizzesDAO.findAll();
            boolean isDuplicate = false;
            for (Quizzes quiz : allQuizzes) {
                if (quiz.getName().equals(name) 
                    && quiz.getLesson_id() == lessonId
                    && quiz.getLevel().equals(level)
                    && quiz.getQuiz_type().equals(quizType)
                    && quiz.getDuration_minutes() == durationMinutes
                    && quiz.getNumber_of_questions_target() == numberOfQuestions) {
                    isDuplicate = true;
                    break;
                }
            }

            if (isDuplicate) {
                request.setAttribute("error", "A quiz with identical information already exists!");
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
            newQuiz.setStatus("active");

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
}
