package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.utils.PasswordUtils;
import com.quiz.su25.utils.EmailUtils;
import com.quiz.su25.validation.RegistrationValidation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import java.text.SimpleDateFormat;
import java.text.ParseException;

@WebServlet(name = "RegistrationController", urlPatterns = {"/admin/registrations"})
public class RegistrationController extends HttpServlet {
    private RegistrationDAO registrationDAO;
    private UserDAO userDAO;
    private SubjectDAO subjectDAO;
    private PricePackageDAO pricePackageDAO;

    @Override
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        userDAO = new UserDAO();
        subjectDAO = new SubjectDAO();
        pricePackageDAO = new PricePackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listRegistrations(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "view":
                showViewForm(request, response);
                break;
            case "check-user":
                checkUserByEmail(request, response);
                break;
            default:
                listRegistrations(request, response);
                break;
        }
    }

    private void listRegistrations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String emailSearch = request.getParameter("emailSearch");
        String subjectSearch = request.getParameter("subjectSearch");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        // Get the last sort parameters (in case of multiple)
        String[] sortByParams = request.getParameterValues("sortBy");
        String[] sortOrderParams = request.getParameterValues("sortOrder");
        String sortBy = (sortByParams != null && sortByParams.length > 0) ? sortByParams[sortByParams.length - 1] : null;
        String sortOrder = (sortOrderParams != null && sortOrderParams.length > 0) ? sortOrderParams[sortOrderParams.length - 1] : null;
        
        // Get dynamic configuration parameters
        String[] selectedColumns = request.getParameterValues("selectedColumns");
        
        // If no columns selected, show all columns by default
        if (selectedColumns == null || selectedColumns.length == 0) {
            selectedColumns = new String[]{"id", "email", "subject", "package", "total_cost", "status", "valid_from", "valid_to", "registration_time"};
        }
        
        // Get page parameters
        int page = 1;
        int desiredRows = 10; // Default desired rows
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Keep default value
        }
        
        // Parse desired rows
        try {
            if (request.getParameter("pageSize") != null && !request.getParameter("pageSize").trim().isEmpty()) {
                desiredRows = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("pageSizeWarning", "Invalid page size format. Using default value.");
        }

        // Convert date strings to Date objects if provided
        Date fromDateObj = null;
        Date toDateObj = null;
        try {
            if (fromDate != null && !fromDate.isEmpty()) {
                fromDateObj = Date.valueOf(fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                toDateObj = Date.valueOf(toDate);
            }
        } catch (IllegalArgumentException e) {
            // Handle invalid date format
            request.setAttribute("error", "Invalid date format");
        }

        // Get total count for pagination
        int totalRegistrations = registrationDAO.countFilteredRegistrations(
            emailSearch, subjectSearch, status, fromDateObj, toDateObj
        );

        // Calculate pagination
        Map<String, Integer> pagination = registrationDAO.calculatePagination(totalRegistrations, desiredRows);
        int pageSize = pagination.get("pageSize");
        int totalPages = pagination.get("totalPages");

        // Get filtered and paginated registrations
        List<Registration> registrations = registrationDAO.findRegistrationsWithDynamicColumns(
            emailSearch, subjectSearch, status, fromDateObj, toDateObj, 
            sortBy, sortOrder, page, pageSize, selectedColumns
        );

        // Get all registration statuses for filter dropdown
        List<String> allStatuses = registrationDAO.getAllStatuses();
        request.setAttribute("allStatuses", allStatuses);

        // Load related data for display
        Map<Integer, String> userEmails = new HashMap<>();
        Map<Integer, String> subjectTitles = new HashMap<>();
        Map<Integer, String> packageNames = new HashMap<>();

        for (Registration reg : registrations) {
            // Load user email
            User user = userDAO.findById(reg.getUser_id());
            if (user != null) {
                userEmails.put(reg.getUser_id(), user.getEmail());
            }

            // Load subject title
            Subject subject = subjectDAO.findById(reg.getSubject_id());
            if (subject != null) {
                subjectTitles.put(reg.getSubject_id(), subject.getTitle());
            }

            // Load package name
            PricePackage pricePackage = pricePackageDAO.findById(reg.getPackage_id());
            if (pricePackage != null) {
                packageNames.put(reg.getPackage_id(), pricePackage.getName());
            }
        }

        // Set attributes for the view
        request.setAttribute("registrations", registrations);
        request.setAttribute("userEmails", userEmails);
        request.setAttribute("subjectTitles", subjectTitles);
        request.setAttribute("packageNames", packageNames);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRegistrations);
        request.setAttribute("emailSearch", emailSearch);
        request.setAttribute("subjectSearch", subjectSearch);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("selectedColumns", selectedColumns);

        // Forward to the view
        request.getRequestDispatcher("/view/admin/registration/list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Registration registration = registrationDAO.findById(id);
            
            if (registration != null) {
                // Load related data
                User user = userDAO.findById(registration.getUser_id());
                Subject subject = subjectDAO.findById(registration.getSubject_id());
                PricePackage pricePackage = pricePackageDAO.findById(registration.getPackage_id());
                
                // Set attributes
                request.setAttribute("registration", registration);
                request.setAttribute("user", user);
                request.setAttribute("subject", subject);
                request.setAttribute("pricePackage", pricePackage);
                
                // Load lists for dropdowns
                List<Subject> subjects = subjectDAO.findAll();
                List<PricePackage> pricePackages = pricePackageDAO.findAll();
                
                request.setAttribute("subjects", subjects);
                request.setAttribute("pricePackages", pricePackages);
                
                request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/registrations?error=notFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=invalidId");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load lists for dropdowns
        request.setAttribute("subjects", subjectDAO.findAll());
        request.setAttribute("pricePackages", pricePackageDAO.findAll());
        
        request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
    }

    private void showViewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Registration registration = registrationDAO.findById(id);
            
            if (registration != null) {
                // Load related data
                User user = userDAO.findById(registration.getUser_id());
                Subject subject = subjectDAO.findById(registration.getSubject_id());
                PricePackage pricePackage = pricePackageDAO.findById(registration.getPackage_id());
                
                // Set attributes
                request.setAttribute("registration", registration);
                request.setAttribute("user", user);
                request.setAttribute("subject", subject);
                request.setAttribute("pricePackage", pricePackage);
                request.setAttribute("isViewMode", true);
                
                // Load lists for dropdowns
                request.setAttribute("subjects", subjectDAO.findAll());
                request.setAttribute("pricePackages", pricePackageDAO.findAll());
                
                request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/registrations?error=notFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=invalidId");
        }
    }

    private void checkUserByEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            User user = userDAO.findByEmail(email);
            if (user != null) {
                response.getWriter().write(String.format(
                    "{\"exists\": true, \"user\": {\"full_name\": \"%s\", \"gender\": %d, \"mobile\": \"%s\"}}",
                    user.getFull_name(),
                    user.getGender(),
                    user.getMobile()
                ));
            } else {
                response.getWriter().write("{\"exists\": false}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations");
            return;
        }

        switch (action) {
            case "add":
                addRegistration(request, response);
                break;
            case "edit":
                updateRegistration(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/registrations");
                break;
        }
    }

    private void addRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        Integer gender = Integer.parseInt(request.getParameter("gender"));
        Integer subjectId = Integer.parseInt(request.getParameter("subjectId"));
        Integer packageId = Integer.parseInt(request.getParameter("packageId"));
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        // Parse dates
        Date validFrom = null;
        Date validTo = null;
        try {
            validFrom = Date.valueOf(validFromStr);
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/view/admin/registration/new.jsp").forward(request, response);
            return;
        }

        // Validate data
        Map<String, String> errors = RegistrationValidation.validateRegistration(
                fullName, email, mobile, subjectId, packageId, validFrom, validTo, status);

        if (!errors.isEmpty()) {
            // Set error messages
            request.setAttribute("fullNameError", errors.get("fullName"));
            request.setAttribute("emailError", errors.get("email"));
            request.setAttribute("mobileError", errors.get("mobile"));
            request.setAttribute("subjectError", errors.get("subject"));
            request.setAttribute("packageError", errors.get("package"));
            request.setAttribute("dateError", errors.get("date"));
            request.setAttribute("statusError", errors.get("status"));

            // Set form data back
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("mobile", mobile);
            request.setAttribute("gender", gender);
            request.setAttribute("subjectId", subjectId);
            request.setAttribute("packageId", packageId);
            request.setAttribute("validFrom", validFromStr);
            request.setAttribute("validTo", validToStr);
            request.setAttribute("status", status);
            request.setAttribute("notes", notes);

            // Get required data for form
            request.setAttribute("subjects", subjectDAO.findAll());
            request.setAttribute("pricePackages", pricePackageDAO.findAll());

            // Forward back to form with errors
            request.getRequestDispatcher("/view/admin/registration/new.jsp").forward(request, response);
            return;
        }

        // Check if user exists
        User user = userDAO.findByEmail(email);
        if (user == null) {
            // Create new user
            user = new User();
            user.setFull_name(fullName);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setGender(gender);
            user.setRole_id(2); // Student role
            user.setStatus("active");

            // Generate random password
            String password = PasswordUtils.generateRandomPassword();
            user.setPassword(password);

            // Insert user
            int userId = userDAO.insert(user);
            if (userId > 0) {
                user.setId(userId);
                // Send email with login information
                EmailUtils.sendRegistrationEmail(
                    email,
                    fullName,
                    password,
                    subjectDAO.findById(subjectId).getTitle(),
                    validFrom.toString(),
                    validTo.toString(),
                    notes
                );
                // Store password note in session
                request.getSession().setAttribute("passwordNote", 
                    "A new user account has been created with the following credentials:\n" +
                    "Email: " + email + "\n" +
                    "Password: " + password + "\n" +
                    "Please inform the user to change their password upon first login.");
            }
        }

        // Create registration
        Registration registration = new Registration();
        registration.setUser_id(user.getId());
        registration.setSubject_id(subjectId);
        registration.setPackage_id(packageId);
        registration.setValid_from(validFrom);
        registration.setValid_to(validTo);
        registration.setRegistration_time(new Date(System.currentTimeMillis()));
        registration.setStatus(status);


        // Insert registration
        int registrationId = registrationDAO.insert(registration);
        if (registrationId > 0) {
            // Redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/admin/registrations?success=added");
        } else {
            request.setAttribute("error", "Failed to add registration");
            request.getRequestDispatcher("/view/admin/registration/new.jsp").forward(request, response);
        }
    }

    private void updateRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        Integer id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        Integer gender = Integer.parseInt(request.getParameter("gender"));
        Integer subjectId = Integer.parseInt(request.getParameter("subjectId"));
        Integer packageId = Integer.parseInt(request.getParameter("packageId"));
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        // Parse dates
        Date validFrom = null;
        Date validTo = null;
        try {
            validFrom = Date.valueOf(validFromStr);
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
            return;
        }

        // Validate data
        Map<String, String> errors = RegistrationValidation.validateRegistration(
                fullName, email, mobile, subjectId, packageId, validFrom, validTo, status);

        if (!errors.isEmpty()) {
            // Set error messages
            request.setAttribute("fullNameError", errors.get("fullName"));
            request.setAttribute("emailError", errors.get("email"));
            request.setAttribute("mobileError", errors.get("mobile"));
            request.setAttribute("subjectError", errors.get("subject"));
            request.setAttribute("packageError", errors.get("package"));
            request.setAttribute("dateError", errors.get("date"));
            request.setAttribute("statusError", errors.get("status"));

            // Set form data back
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("mobile", mobile);
            request.setAttribute("gender", gender);
            request.setAttribute("subjectId", subjectId);
            request.setAttribute("packageId", packageId);
            request.setAttribute("validFrom", validFromStr);
            request.setAttribute("validTo", validToStr);
            request.setAttribute("status", status);
            request.setAttribute("notes", notes);

            // Get required data for form
            request.setAttribute("subjects", subjectDAO.findAll());
            request.setAttribute("pricePackages", pricePackageDAO.findAll());

            // Forward back to form with errors
            request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
            return;
        }

        // Get existing registration
        Registration registration = registrationDAO.findById(id);
        if (registration == null) {
            request.setAttribute("error", "Registration not found");
            request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
            return;
        }

        // Update user information
        User user = userDAO.findById(registration.getUser_id());
        if (user != null) {
            user.setFull_name(fullName);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setGender(gender);
            userDAO.update(user);
        }

        // Update registration
        registration.setSubject_id(subjectId);
        registration.setPackage_id(packageId);
        registration.setValid_from(validFrom);
        registration.setValid_to(validTo);
        registration.setStatus(status);
        

        if (registrationDAO.update(registration)) {
            // Redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/admin/registrations?success=updated");
        } else {
            request.setAttribute("error", "Failed to update registration");
            request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
        }
    }

    public static void main(String[] args) {
        // Create controller and initialize
        RegistrationController controller = new RegistrationController();
        try {
            controller.init();
            System.out.println("Controller initialized successfully");
        } catch (Exception e) {
            System.out.println("Initialization failed: " + e.getMessage());
            return;
        }

        // Test both methods to see differences
        RegistrationDAO registrationDAO = new RegistrationDAO();

        // 1. Test findAll directly - should work
        System.out.println("\n===== TESTING findAll() =====");
        List<Registration> allRegs = registrationDAO.findAll();
        System.out.println("findAll found " + allRegs.size() + " registrations");

        // 2. Test the controller's filter method with no filters
        System.out.println("\n===== TESTING findRegistrationsWithFilters() =====");
        List<Registration> filteredRegs = registrationDAO.findRegistrationsWithFilters(
                null, null, null, null, null, null, null, 1, 10);
        System.out.println("findRegistrationsWithFilters found " + filteredRegs.size() + " registrations");

        // 3. Print IDs that are missing in the filtered results
        System.out.println("\n===== MISSING REGISTRATIONS =====");
        if (filteredRegs.size() < allRegs.size()) {
            System.out.println("Missing " + (allRegs.size() - filteredRegs.size()) + " registrations");

            // Create a set of IDs from filtered results for quick lookup
            Set<Integer> filteredIds = new HashSet<>();
            for (Registration reg : filteredRegs) {
                filteredIds.add(reg.getId());
            }

            // Find which registrations are missing
            for (Registration reg : allRegs) {
                if (!filteredIds.contains(reg.getId())) {
                    System.out.println("Missing ID: " + reg.getId() +
                            " (user_id: " + reg.getUser_id() +
                            ", subject_id: " + reg.getSubject_id() + ")");

                    // Check if the user exists
                    User user = new UserDAO().findById(reg.getUser_id());
                    System.out.println("  User exists: " + (user != null));

                    // Check if the subject exists
                    Subject subject = new SubjectDAO().findById(reg.getSubject_id());
                    System.out.println("  Subject exists: " + (subject != null));
                }
            }
        }
    }
}
