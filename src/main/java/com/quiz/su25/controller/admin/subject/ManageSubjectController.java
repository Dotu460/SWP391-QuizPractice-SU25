package com.quiz.su25.controller.admin.subject;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.quiz.su25.dal.impl.PackageLessonDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.PackageLesson;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.LessonDAO;
import com.quiz.su25.entity.Lesson;

import java.util.List;

@WebServlet(name = "ManageSubjectController", 
        urlPatterns = {"/admin/subject-lesson",
                        "/admin/subject-lesson/add", 
                        "/admin/subject-lesson/edit", 
                        "/admin/subject-lesson/delete"})
public class ManageSubjectController extends HttpServlet {

    private PackageLessonDAO packageLessonDAO;
    private SubjectDAO subjectDAO;
    private LessonDAO lessonDAO;
    private PricePackageDAO pricePackageDAO;

    @Override
    public void init() throws ServletException {
        packageLessonDAO = new PackageLessonDAO();
        subjectDAO = new SubjectDAO();
        lessonDAO = new LessonDAO();
        pricePackageDAO = new PricePackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/admin/subject-lesson":
                listSubjectLesson(request, response);
                break;
            case "/admin/subject-lesson/add":
                showAddLessonForm(request, response);
                break;
            case "/admin/subject-lesson/edit":
                showEditLessonForm(request, response);
                break;
            default:
                listSubjectLesson(request, response);
                break;
        }
    }

    private void listSubjectLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get filter parameters
            String subjectIdParam = request.getParameter("subjectId");
            String statusFilter = request.getParameter("status");
            String searchFilter = request.getParameter("search");
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageStr = request.getParameter("page");
            String pageSizeStr = request.getParameter("pageSize");
            
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Max limit
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            // Load all subjects for selector
            List<Subject> subjects = subjectDAO.findAll();
            request.setAttribute("subjects", subjects);

            Integer subjectId = null;
            Subject currentSubject = null;

            // Parse subject ID
            if (subjectIdParam != null && !subjectIdParam.isEmpty()) {
                try {
                    subjectId = Integer.parseInt(subjectIdParam);
                    currentSubject = subjectDAO.findById(subjectId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid subject ID");
                }
            }

            // Get filtered and paginated lessons
            List<Lesson> lessons = lessonDAO.findLessonsWithFilters(
                statusFilter, searchFilter, subjectId, page, pageSize);
            
            // Get total count for pagination
            int totalLessons = lessonDAO.getTotalFilteredLessons(
                statusFilter, searchFilter, subjectId);
            
            int totalPages = (int) Math.ceil((double) totalLessons / pageSize);

            // Set attributes for JSP
            request.setAttribute("lessons", lessons);
            request.setAttribute("currentSubject", currentSubject);
            
            // Pagination attributes
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalLessons", totalLessons);
            request.setAttribute("startRecord", totalLessons > 0 ? (page - 1) * pageSize + 1 : 0);
            request.setAttribute("endRecord", Math.min(page * pageSize, totalLessons));

            // Filter attributes for maintaining state
            request.setAttribute("selectedSubjectId", subjectId);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchFilter", searchFilter);

            request.getRequestDispatcher("/view/admin/subject/subject-lesson-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/admin/subject/subject-lesson-list.jsp").forward(request, response);
        }
    }

    private void showAddLessonForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Load subjects and price packages for form
        List<Subject> subjects = subjectDAO.findAll();
        List<PricePackage> pricePackages = pricePackageDAO.findAll();
        
        request.setAttribute("subjects", subjects);
        request.setAttribute("pricePackages", pricePackages);
        request.getRequestDispatcher("/view/admin/subject/add-lesson.jsp").forward(request, response);
    }

    private void showEditLessonForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int lessonId = Integer.parseInt(idParam);
                Lesson lesson = lessonDAO.findById(lessonId);
                if (lesson != null) {
                    List<Subject> subjects = subjectDAO.findAll();
                    List<PricePackage> pricePackages = pricePackageDAO.findAll();
                    List<PackageLesson> packageLessons = packageLessonDAO.findByLessonId(lessonId);
                    
                    request.setAttribute("lesson", lesson);
                    request.setAttribute("subjects", subjects);
                    request.setAttribute("pricePackages", pricePackages);
                    request.setAttribute("packageLessons", packageLessons);
                    request.getRequestDispatcher("/view/admin/subject/edit-lesson.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Lesson not found");
                    response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid lesson ID");
                response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addLesson(request, response);
        } else if ("edit".equals(action)) {
            updateLesson(request, response);
        } else if ("delete".equals(action)) {
            deleteLesson(request, response);
        } else if ("activate".equals(action)) {
            changeStatus(request, response, "active");
        } else if ("deactivate".equals(action)) {
            changeStatus(request, response, "inactive");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
        }
    }

    private void addLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Implementation for adding lesson
        response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
    }

    private void updateLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Implementation for updating lesson
        response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Implementation for deleting lesson
        response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response, String newStatus) throws ServletException, IOException {
        // Implementation for changing lesson status
        response.sendRedirect(request.getContextPath() + "/admin/subject-lesson");
    }
}
