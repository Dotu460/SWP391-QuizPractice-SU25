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
import java.util.List;

@WebServlet("/quizzes-list")
public class QuizzesListController extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 10;
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
        // Get all subjects and lessons for dropdowns
        //  List<Subject> subjectsList = subjectDAO.findAll();
        //List<Lesson> lessonsList = lessonDAO.findAll();
        List<Quizzes> quizzesList = quizzesDAO.findAll();
        // Set attributes for the view
        request.setAttribute("quizzesList", quizzesList);
        //request.setAttribute("subjectsList", subjectsList);
        //request.setAttribute("lessonsList", lessonsList);
        
        request.getRequestDispatcher("view/Expert/Quiz/quizzes-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
