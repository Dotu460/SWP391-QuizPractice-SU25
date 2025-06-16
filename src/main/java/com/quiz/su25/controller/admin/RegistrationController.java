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
import jakarta.servlet.http.HttpSession;

/**
 * Controller class for handling registration management in the admin panel.
 * This controller handles all CRUD operations for registrations including:
 * - Listing registrations with filtering and pagination
 * - Adding new registrations
 * - Editing existing registrations
 * - Viewing registration details
 * - Checking user existence by email
 */
@WebServlet(name = "RegistrationController", urlPatterns = {"/admin/registrations"})
public class RegistrationController extends HttpServlet {
    // DAO instances for database operations
    private RegistrationDAO registrationDAO;
    private UserDAO userDAO;
    private SubjectDAO subjectDAO;
    private PricePackageDAO pricePackageDAO;

    @Override
    public void init() throws ServletException {
        // Initialize all required DAOs
        registrationDAO = new RegistrationDAO();
        userDAO = new UserDAO();
        subjectDAO = new SubjectDAO();
        pricePackageDAO = new PricePackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the action parameter to determine which operation to perform
        String action = request.getParameter("action");

        if (action == null) {
            // If no action specified, show the list of registrations
            listRegistrations(request, response);
        } else {
            // Route to appropriate handler based on action
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
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
    }

    /**
     * Handles the display of registration list with filtering and pagination
     * Features:
     * - Email and subject search
     * - Status filtering
     * - Date range filtering
     * - Column selection
     * - Sorting
     * - Pagination
     */
    private void listRegistrations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all filter parameters from request
            String emailSearch = request.getParameter("emailSearch");
            String subjectSearch = request.getParameter("subjectSearch");
            String status = request.getParameter("status");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            
            // Get selected columns for display
            String[] selectedColumns = request.getParameterValues("selectedColumns");
            if (selectedColumns == null || selectedColumns.length == 0) {
                // Default columns if none selected
                selectedColumns = new String[]{"id", "email", "subject", "package", "total_cost", "status", "valid_from", "valid_to", "registration_time"};
            }
            
            // Handle pagination parameters
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // Default to page 1 if invalid
            }
            
            // Get and validate page size
            int pageSize = 10; // Default page size
            try {
                String pageSizeStr = request.getParameter("pageSize");
                if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeStr);
                }
            } catch (NumberFormatException e) {
                // Default to 10 if invalid
            }
            
            // Convert date strings to Date objects
            Date fromDate = null;
            Date toDate = null;
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                toDate = Date.valueOf(toDateStr);
            }
            
            // Get total records count for pagination
            int totalRecords = registrationDAO.countFilteredRegistrations(
                emailSearch, subjectSearch, status, fromDate, toDate);
                
            // Calculate pagination details
            Map<String, Integer> pagination = registrationDAO.calculatePagination(totalRecords, pageSize);
            pageSize = pagination.get("pageSize");
            int totalPages = pagination.get("totalPages");
            
            // Adjust page if it exceeds total pages
            if (page > totalPages) {
                page = totalPages;
            }
            
            // Get registrations for current page with selected columns
            List<Registration> registrations = registrationDAO.findRegistrationsWithDynamicColumns(
                emailSearch, subjectSearch, status, fromDate, toDate,
                sortBy, sortOrder, page, pageSize, selectedColumns);
                
            // Get all statuses for filter dropdown
            List<String> allStatuses = registrationDAO.getAllStatuses();
            
            // Get user emails and subject titles for display
            Map<Integer, String> userEmails = new HashMap<>();
            Map<Integer, String> subjectTitles = new HashMap<>();
            Map<Integer, String> packageNames = new HashMap<>();
            
            // Populate display maps with user, subject and package information
            for (Registration reg : registrations) {
                User user = userDAO.findById(reg.getUser_id());
                if (user != null) {
                    userEmails.put(reg.getUser_id(), user.getEmail());
                }
                
                Subject subject = subjectDAO.findById(reg.getSubject_id());
                if (subject != null) {
                    subjectTitles.put(reg.getSubject_id(), subject.getTitle());
                }
                
                PricePackage pkg = pricePackageDAO.findById(reg.getPackage_id());
                if (pkg != null) {
                    packageNames.put(reg.getPackage_id(), pkg.getName());
                }
            }
            
            // Set all necessary attributes for JSP
            request.setAttribute("registrations", registrations);
            request.setAttribute("userEmails", userEmails);
            request.setAttribute("subjectTitles", subjectTitles);
            request.setAttribute("packageNames", packageNames);
            request.setAttribute("allStatuses", allStatuses);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("emailSearch", emailSearch);
            request.setAttribute("subjectSearch", subjectSearch);
            request.setAttribute("status", status);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("selectedColumns", selectedColumns);
            
            // Forward to list JSP
            request.getRequestDispatcher("/view/admin/registration/list.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=system");
        }
    }

    /**
     * Displays the form for editing an existing registration
     * Loads all necessary data including:
     * - Registration details
     * - User information
     * - Available subjects
     * - Available price packages
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get registration ID
        Integer id = Integer.parseInt(request.getParameter("id"));

        // Get registration details
        Registration registration = registrationDAO.findById(id);
        if (registration == null) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations");
            return;
        }

        // Get user information
        User user = userDAO.findById(registration.getUser_id());

        // Get all subjects and price packages for dropdowns
        List<Subject> subjects = subjectDAO.findAll();
        List<PricePackage> pricePackages = pricePackageDAO.findAll();

        // Set all necessary attributes
        request.setAttribute("registration", registration);
        request.setAttribute("user", user);
        request.setAttribute("subjects", subjects);
        request.setAttribute("pricePackages", pricePackages);
        request.setAttribute("isViewMode", false);

        // Forward to form JSP
        request.getRequestDispatcher("/view/admin/registration/new.jsp").forward(request, response);
    }

    /**
     * Displays the form for adding a new registration
     * Loads all necessary data including:
     * - Available subjects
     * - Available price packages
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all subjects and price packages for dropdowns
        List<Subject> subjects = subjectDAO.findAll();
        List<PricePackage> pricePackages = pricePackageDAO.findAll();

        // Set all necessary attributes
        request.setAttribute("subjects", subjects);
        request.setAttribute("pricePackages", pricePackages);
        request.setAttribute("registration", null);
        request.setAttribute("isViewMode", false);

        // Forward to form JSP
        request.getRequestDispatcher("/view/admin/registration/new.jsp").forward(request, response);
    }

    /**
     * Displays the details of a registration in view-only mode
     * Loads all necessary data including:
     * - Registration details
     * - User information
     * - Subject information
     * - Package information
     */
    private void showViewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Clear any existing errors from session
        clearSessionErrors(request.getSession());
        
        Integer id = Integer.parseInt(request.getParameter("id"));
        Registration registration = registrationDAO.findById(id);
        
        if (registration != null) {
            // Get user information
            User user = userDAO.findById(registration.getUser_id());
            
            // Get all subjects and price packages for dropdowns
            List<Subject> subjects = subjectDAO.findAll();
            List<PricePackage> pricePackages = pricePackageDAO.findAll();
            
            // Set all necessary attributes
            request.setAttribute("registration", registration);
            request.setAttribute("user", user);
            request.setAttribute("subjects", subjects);
            request.setAttribute("pricePackages", pricePackages);
            request.setAttribute("isViewMode", true);
            
            // Forward to view page
            request.getRequestDispatcher("/view/admin/registration/details.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/registrations");
        }
    }

    /**
     * Checks if a user exists by email address
     * Returns JSON response with user details if found
     */
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
        // Get the action parameter to determine which operation to perform
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations");
            return;
        }

        // Route to appropriate handler based on action
        switch (action) {
            case "add":
                addRegistration(request, response);
                break;
            case "edit":
                updateRegistration(request, response);
                break;
            case "clear-errors":
                clearSessionErrors(request.getSession());
                response.setStatus(HttpServletResponse.SC_OK);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/registrations");
                break;
        }
    }

    /**
     * Handles the creation of a new registration
     * Features:
     * - Validates input data
     * - Creates new user if not exists
     * - Sends welcome email with login credentials
     * - Creates registration record
     */
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

        // Parse dates
        Date validFrom = null;
        Date validTo = null;
        try {
            validFrom = Date.valueOf(validFromStr);
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Invalid date format");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=add");
            return;
        }

        // Validate input data
        Map<String, String> errors = RegistrationValidation.validateRegistration(
                fullName, email, mobile, subjectId, packageId, validFrom, validTo, status);

        if (!errors.isEmpty()) {
            // Store error messages in session
            request.getSession().setAttribute("fullNameError", errors.get("fullName"));
            request.getSession().setAttribute("emailError", errors.get("email"));
            request.getSession().setAttribute("mobileError", errors.get("mobile"));
            request.getSession().setAttribute("subjectError", errors.get("subject"));
            request.getSession().setAttribute("packageError", errors.get("package"));
            request.getSession().setAttribute("dateError", errors.get("date"));
            request.getSession().setAttribute("statusError", errors.get("status"));

            // Store form data in session for repopulating form
            request.getSession().setAttribute("fullName", fullName);
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("mobile", mobile);
            request.getSession().setAttribute("gender", gender);
            request.getSession().setAttribute("subjectId", subjectId);
            request.getSession().setAttribute("packageId", packageId);
            request.getSession().setAttribute("validFrom", validFromStr);
            request.getSession().setAttribute("validTo", validToStr);
            request.getSession().setAttribute("status", status);

            // Redirect back to form with errors
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=add");
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
                    ""
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

        // Get package price for total cost
        PricePackage pricePackage = pricePackageDAO.findById(packageId);
        if (pricePackage != null) {
            registration.setTotal_cost(pricePackage.getSale_price());
        } else {
            request.getSession().setAttribute("error", "Invalid package selected");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=add");
            return;
        }

        // Insert registration
        int registrationId = registrationDAO.insert(registration);
        if (registrationId > 0) {
            // Clear any error messages from session
            clearSessionErrors(request.getSession());
            // Redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/admin/registrations?success=added");
        } else {
            request.getSession().setAttribute("error", "Failed to add registration");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=add");
        }
    }

    /**
     * Handles the update of an existing registration
     * Features:
     * - Validates input data
     * - Updates user information
     * - Updates registration details
     * - Sends confirmation email if status changes to "paid"
     */
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
        String emailContent = request.getParameter("notes"); // Get email content from notes field

        // Parse dates
        Date validFrom = null;
        Date validTo = null;
        try {
            validFrom = Date.valueOf(validFromStr);
            validTo = Date.valueOf(validToStr);
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Invalid date format");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=edit&id=" + id);
            return;
        }

        // Validate input data
        Map<String, String> errors = RegistrationValidation.validateRegistration(
                fullName, email, mobile, subjectId, packageId, validFrom, validTo, status);

        if (!errors.isEmpty()) {
            // Store error messages in session
            request.getSession().setAttribute("fullNameError", errors.get("fullName"));
            request.getSession().setAttribute("emailError", errors.get("email"));
            request.getSession().setAttribute("mobileError", errors.get("mobile"));
            request.getSession().setAttribute("subjectError", errors.get("subject"));
            request.getSession().setAttribute("packageError", errors.get("package"));
            request.getSession().setAttribute("dateError", errors.get("date"));
            request.getSession().setAttribute("statusError", errors.get("status"));

            // Store form data in session for repopulating form
            request.getSession().setAttribute("fullName", fullName);
            request.getSession().setAttribute("email", email);
            request.getSession().setAttribute("mobile", mobile);
            request.getSession().setAttribute("gender", gender);
            request.getSession().setAttribute("subjectId", subjectId);
            request.getSession().setAttribute("packageId", packageId);
            request.getSession().setAttribute("validFrom", validFromStr);
            request.getSession().setAttribute("validTo", validToStr);
            request.getSession().setAttribute("status", status);

            // Redirect back to form with errors
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=edit&id=" + id);
            return;
        }

        // Get existing registration
        Registration registration = registrationDAO.findById(id);
        if (registration == null) {
            request.getSession().setAttribute("error", "Registration not found");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=edit&id=" + id);
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

        // Update total cost if package changed
        PricePackage pricePackage = pricePackageDAO.findById(packageId);
        if (pricePackage != null) {
            registration.setTotal_cost(pricePackage.getSale_price());
        } else {
            request.getSession().setAttribute("error", "Invalid package selected");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=edit&id=" + id);
            return;
        }

        if (registrationDAO.update(registration)) {
            // Check if status changed to "paid" and send email
            if ("paid".equals(status)) {
                // Get subject title
                Subject subject = subjectDAO.findById(subjectId);
                String subjectTitle = subject != null ? subject.getTitle() : "Unknown Subject";
                
                // Send confirmation email
                EmailUtils.sendRegistrationEmail(
                    email,
                    fullName,
                    null, // No password needed for existing users
                    subjectTitle,
                    validFrom.toString(),
                    validTo.toString(),
                    emailContent // Use the custom email content
                );
            }
            
            // Clear any error messages from session
            clearSessionErrors(request.getSession());
            // Redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/admin/registrations?success=updated");
        } else {
            request.getSession().setAttribute("error", "Failed to update registration");
            response.sendRedirect(request.getContextPath() + "/admin/registrations?action=edit&id=" + id);
        }
    }

    /**
     * Clears all error messages and form data from session
     */
    private void clearSessionErrors(HttpSession session) {
        session.removeAttribute("error");
        session.removeAttribute("fullNameError");
        session.removeAttribute("emailError");
        session.removeAttribute("mobileError");
        session.removeAttribute("subjectError");
        session.removeAttribute("packageError");
        session.removeAttribute("dateError");
        session.removeAttribute("statusError");
        session.removeAttribute("fullName");
        session.removeAttribute("email");
        session.removeAttribute("mobile");
        session.removeAttribute("gender");
        session.removeAttribute("subjectId");
        session.removeAttribute("packageId");
        session.removeAttribute("validFrom");
        session.removeAttribute("validTo");
        session.removeAttribute("status");
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
