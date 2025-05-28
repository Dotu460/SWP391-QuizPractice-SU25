package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.SubjectCategoriesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.SubjectCategories;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SubjectController", urlPatterns = {"/subjects", "/subject/*"})
public class SubjectController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 8;
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final SubjectCategoriesDAO categoryDAO = new SubjectCategoriesDAO();
    private final PricePackageDAO packageDAO = new PricePackageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/subjects")) {
            listSubjects(request, response);
        } else if (path.equals("/subject")) {
            if (pathInfo != null && pathInfo.equals("/details")) {
                viewSubject(request, response);
            } else if (pathInfo != null && pathInfo.equals("/register")) {
                showRegistrationForm(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/subject") && pathInfo != null && pathInfo.equals("/register")) {
            registerForSubject(request, response);
        }
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

        // Get filter parameters
        String categoryFilter = request.getParameter("category");
        String statusFilter = "active"; // Only show active subjects
        String searchTerm = request.getParameter("search");

        // Set default sort to updated_at descending
        String sortBy = "updated_at";
        String sortOrder = "desc";

        // Get paginated subjects from database
        List<Subject> subjects = subjectDAO.getPaginatedSubjects(
                page, pageSize, categoryFilter, statusFilter, searchTerm, sortBy, sortOrder);

        // Get total count for pagination
        int totalSubjects = subjectDAO.countTotalSubjects(categoryFilter, statusFilter, searchTerm);
        int totalPages = (int) Math.ceil((double) totalSubjects / pageSize);

        // Get all categories for sidebar
        List<SubjectCategories> categories = categoryDAO.findAll();

        // Get featured subjects for sidebar (limit to 5)
        List<Subject> featuredSubjects = getFeaturedSubjects();

        // Get lowest price package for each subject
        Map<Integer, PricePackage> lowestPricePackages = getLowestPricePackages(subjects);

        // Set attributes for the view
        request.setAttribute("subjects", subjects);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSubjects", totalSubjects);
        request.setAttribute("categoryFilter", categoryFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categories", categories);
        request.setAttribute("featuredSubjects", featuredSubjects);
        request.setAttribute("lowestPricePackages", lowestPricePackages);

        // Forward to the view
        request.getRequestDispatcher("/WEB-INF/view/subjects/list.jsp").forward(request, response);
    }

    private void viewSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                // Get all packages for this subject
                List<PricePackage> packages = packageDAO.findBySubjectId(subjectId);

                // Get the subject's category
                SubjectCategories category = categoryDAO.findById(subject.getCategoryId());

                request.setAttribute("subject", subject);
                request.setAttribute("packages", packages);
                request.setAttribute("category", category);

                request.getRequestDispatcher("/WEB-INF/view/subjects/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/subjects?error=invalidId");
        }
    }

    private void showRegistrationForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);
        int packageId = getIntParameter(request, "packageId", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                List<PricePackage> packages = packageDAO.findBySubjectId(subjectId);

                // If packageId is provided, pre-select that package
                PricePackage selectedPackage = null;
                if (packageId > 0) {
                    for (PricePackage pkg : packages) {
                        if (pkg.getId() == packageId) {
                            selectedPackage = pkg;
                            break;
                        }
                    }
                }

                request.setAttribute("subject", subject);
                request.setAttribute("packages", packages);
                request.setAttribute("selectedPackage", selectedPackage);

                request.getRequestDispatcher("/WEB-INF/view/subjects/registration.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/subjects?error=subjectNotFound");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/subjects?error=invalidId");
        }
    }

    private void registerForSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This would connect to a registration or order service
        // For now, just implement basic functionality

        int subjectId = getIntParameter(request, "subjectId", 0);
        int packageId = getIntParameter(request, "packageId", 0);

        if (subjectId > 0 && packageId > 0) {
            // In a real application, you would:
            // 1. Verify the user is logged in
            // 2. Create an order/registration record
            // 3. Process payment if needed

            // For now, redirect with success message
            response.sendRedirect(request.getContextPath() +
                "/subject/details?id=" + subjectId + "&success=registered");
        } else {
            response.sendRedirect(request.getContextPath() + "/subjects?error=invalidData");
        }
    }

    // In SubjectController
    private List<Subject> getFeaturedSubjects() {
        return subjectDAO.getFeaturedSubjects(5);
    }

    private Map<Integer, PricePackage> getLowestPricePackages(List<Subject> subjects) {
        Map<Integer, PricePackage> lowestPricePackages = new HashMap<>();

        for (Subject subject : subjects) {
            PricePackage lowestPricePackage = packageDAO.findLowestPricePackageBySubjectId(subject.getSubjectId());
            if (lowestPricePackage != null) {
                lowestPricePackages.put(subject.getSubjectId(), lowestPricePackage);
            }
        }

        return lowestPricePackages;
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




}