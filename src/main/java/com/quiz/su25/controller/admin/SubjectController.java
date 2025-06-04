package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.SubjectCategoriesDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.SubjectCategories;

import com.quiz.su25.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SubjectController", urlPatterns = {"/subjects", "/subject/*"})
public class SubjectController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 8;
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final SubjectCategoriesDAO categoryDAO = new SubjectCategoriesDAO();
//    private final PricePackageDAO packageDAO = new PricePackageDAO();
    private final UserDAO userDAO = new UserDAO();

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
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "active"; // Default to active subjects if not specified
        }
        String searchTerm = request.getParameter("search");

        // Set default sort
        String sortBy = "updated_at";
        String sortOrder = "desc";

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

        // Get all categories for sidebar
        List<SubjectCategories> categories = categoryDAO.findAll();

        // Get featured subjects for sidebar (limit to 5)
        List<Subject> featuredSubjects = getFeaturedSubjects();

        // Get lowest price package for each subject
//        Map<Integer, PricePackage> lowestPricePackages = getLowestPricePackages(subjects);

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
        request.setAttribute("featuredSubjects", featuredSubjects);
//        request.setAttribute("lowestPricePackages", lowestPricePackages);

        // Forward to the view
        request.getRequestDispatcher("/view/admin/list.jsp").forward(request, response);
    }

    private void viewSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = getIntParameter(request, "id", 0);

        if (subjectId > 0) {
            Subject subject = subjectDAO.findById(subjectId);

            if (subject != null) {
                // Get all packages for this subject
//                List<PricePackage> packages = packageDAO.findBySubjectId(subjectId);

                // Get the subject's category
                SubjectCategories category = categoryDAO.findById(subject.getId());

                request.setAttribute("subject", subject);
//                request.setAttribute("packages", packages);
                request.setAttribute("category", category);

                request.getRequestDispatcher("/view/admin/details.jsp").forward(request, response);
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
//                List<PricePackage> packages = packageDAO.findBySubjectId(subjectId);

                // If packageId is provided, pre-select that package
                PricePackage selectedPackage = null;
//                if (packageId > 0) {
//                    for (PricePackage pkg : packages) {
//                        if (pkg.getId() == packageId) {
//                            selectedPackage = pkg;
//                            break;
//                        }
//                    }
//                }

                request.setAttribute("subject", subject);
//                request.setAttribute("packages", packages);
                request.setAttribute("selectedPackage", selectedPackage);

                request.getRequestDispatcher("/view/admin/registration.jsp").forward(request, response);
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
        return subjectDAO.getFeaturedSubjects();
    }

//    private Map<Integer, PricePackage> getLowestPricePackages(List<Subject> subjects) {
//        Map<Integer, PricePackage> lowestPricePackages = new HashMap<>();
//
//        for (Subject subject : subjects) {
//            PricePackage lowestPricePackage = packageDAO.findLowestPricePackageBySubjectId(subject.getId());
//            if (lowestPricePackage != null) {
//                lowestPricePackages.put(subject.getId(), lowestPricePackage);
//            }
//        }
//
//        return lowestPricePackages;
//    }

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

    public static void main(String[] args) {
        // Create test instances
        SubjectDAO subjectDAO = new SubjectDAO();
        UserDAO userDAO = new UserDAO();

        // Get some subjects to test with (or create mock subjects)
        List<Subject> subjects = subjectDAO.findAll();

        // Create and populate the ownerNames map
        Map<Integer, String> ownerNames = new HashMap<>();
        for (Subject subject : subjects) {
            if (subject.getOwner_id() != null && !ownerNames.containsKey(subject.getOwner_id())) {
                User owner = userDAO.findById(subject.getOwner_id());
                if (owner != null) {
                    ownerNames.put(subject.getOwner_id(), owner.getFull_name());
                    System.out.println("Added owner: ID=" + subject.getOwner_id() +
                            ", Name=" + owner.getFull_name());
                } else {
                    System.out.println("Owner not found for ID: " + subject.getOwner_id());
                }
            } else if (subject.getOwner_id() != null) {
                System.out.println("Owner ID " + subject.getOwner_id() +
                        " already in map with name: " + ownerNames.get(subject.getOwner_id()));
            } else {
                System.out.println("Subject has null owner_id: " + subject.getTitle());
            }
        }

        // Print the final map contents
        System.out.println("\n--- Final Owner Names Map ---");
        if (ownerNames.isEmpty()) {
            System.out.println("Map is empty!");
        } else {
            for (Map.Entry<Integer, String> entry : ownerNames.entrySet()) {
                System.out.println("Owner ID: " + entry.getKey() + ", Name: " + entry.getValue());
            }
        }

        // Print how many unique owners were found
        System.out.println("\nTotal unique owners: " + ownerNames.size());
    }



}