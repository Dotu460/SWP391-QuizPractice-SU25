package com.quiz.su25.controller.admin;

import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.dal.impl.SubjectDAO;
import com.quiz.su25.dal.impl.UserDAO;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.Subject;
import com.quiz.su25.entity.User;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.utils.PasswordUtils;
import com.quiz.su25.utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.*;

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
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        // Get dynamic configuration parameters
        String[] selectedColumns = request.getParameterValues("selectedColumns");
        String pageSizeParam = request.getParameter("pageSize");
        
        // Get page parameters
        int page = 1;
        int pageSize = 10; // Default page size
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Keep default value
        }
        
        // Parse custom page size
        try {
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                int customPageSize = Integer.parseInt(pageSizeParam);
                if (customPageSize > 0 && customPageSize <= 1000) { // Limit max page size to 1000
                    pageSize = customPageSize;
                } else if (customPageSize > 1000) {
                    pageSize = 1000; // Set to max if exceeded
                    request.setAttribute("pageSizeWarning", "Page size limited to maximum 1000 rows");
                } else {
                    request.setAttribute("pageSizeWarning", "Page size must be greater than 0");
                }
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

        // Get filtered and paginated registrations
        List<Registration> registrations;
        if (selectedColumns != null && selectedColumns.length > 0) {
            registrations = registrationDAO.findRegistrationsWithDynamicColumns(
                emailSearch, subjectSearch, status, fromDateObj, toDateObj, 
                sortBy, sortOrder, page, pageSize, selectedColumns
            );
        } else {
            registrations = registrationDAO.findRegistrationsWithFilters(
                emailSearch, subjectSearch, status, fromDateObj, toDateObj, 
                sortBy, sortOrder, page, pageSize
            );
        }

        // Get all registration statuses for filter dropdown
        List<String> allStatuses = registrationDAO.getAllStatuses();
        request.setAttribute("allStatuses", allStatuses);

        // Get total count for pagination
        int totalRegistrations = registrationDAO.countFilteredRegistrations(
            emailSearch, subjectSearch, status, fromDateObj, toDateObj
        );
        int totalPages = (int) Math.ceil((double) totalRegistrations / pageSize);

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
        try {
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String mobile = request.getParameter("mobile");
            String genderParam = request.getParameter("gender");
            String status = request.getParameter("status");
            
            int userId = -1;
            
            // Check if user exists by email
            User existingUser = null;
            try {
                // Find user by email
                List<User> allUsers = userDAO.findAll();
                for (User u : allUsers) {
                    if (u.getEmail().equals(email)) {
                        existingUser = u;
                        break;
                    }
                }
            } catch (Exception e) {
                System.out.println("Error checking existing user: " + e.getMessage());
            }
            
            String generatedPassword = null;
            String passwordNote = null;
            
            if (existingUser != null) {
                userId = existingUser.getId();
            } else {
                // Generate random password for new user
                generatedPassword = PasswordUtils.generateRandomPassword();
                passwordNote = PasswordUtils.generatePasswordNote(generatedPassword);
                
                // Create new user
                User newUser = User.builder()
                    .full_name(fullName)
                    .email(email)
                    .mobile(mobile)
                    .gender(genderParam != null ? Integer.parseInt(genderParam) : 1)
                    .password(generatedPassword) // Use generated password
                    .role_id(2) // Default role for regular users
                    .status("active")
                    .build();
                
                userId = userDAO.insert(newUser);
                if (userId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/registrations?error=userCreateFailed");
                    return;
                }
            }
            
            // Get package price for total cost
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            PricePackage pricePackage = pricePackageDAO.findById(packageId);
            double totalCost = pricePackage != null ? pricePackage.getSale_price() : 0.0;
            
            // Get subject title for email
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            Subject subject = subjectDAO.findById(subjectId);
            String subjectTitle = subject != null ? subject.getTitle() : "Unknown Subject";
            
            Registration registration = new Registration();
            registration.setUser_id(userId);
            registration.setSubject_id(subjectId);
            registration.setPackage_id(packageId);
            registration.setTotal_cost(totalCost);
            registration.setStatus(status);
            registration.setValid_from(Date.valueOf(request.getParameter("validFrom")));
            registration.setValid_to(Date.valueOf(request.getParameter("validTo")));
            registration.setRegistration_time(new Date(System.currentTimeMillis()));
            
            int newId = registrationDAO.insert(registration);
            if (newId > 0) {
                String successParam = existingUser == null ? "added&userCreated=true" : "added";
                if (generatedPassword != null) {
                    // Add password note to the success message
                    request.getSession().setAttribute("passwordNote", passwordNote);
                    
                    // Send welcome email with login information
                    try {
                        EmailUtils.sendRegistrationEmail(
                            email,
                            fullName,
                            generatedPassword,
                            subjectTitle,
                            registration.getValid_from().toString(),
                            registration.getValid_to().toString()
                        );
                    } catch (Exception e) {
                        System.out.println("Error sending welcome email: " + e.getMessage());
                        // Don't fail the registration if email fails
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/registrations?success=" + successParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/registrations?error=addFailed");
            }
        } catch (Exception e) {
            System.out.println("Error in addRegistration: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=invalidData");
        }
    }

    private void updateRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Registration registration = registrationDAO.findById(id);
            
            if (registration != null) {
                // Update registration properties from request parameters
                registration.setUser_id(Integer.parseInt(request.getParameter("userId")));
                registration.setSubject_id(Integer.parseInt(request.getParameter("subjectId")));
                registration.setPackage_id(Integer.parseInt(request.getParameter("packageId")));
                registration.setTotal_cost(Double.parseDouble(request.getParameter("totalCost")));
                registration.setStatus(request.getParameter("status"));
                registration.setValid_from(Date.valueOf(request.getParameter("validFrom")));
                registration.setValid_to(Date.valueOf(request.getParameter("validTo")));
                
                if (registrationDAO.update(registration)) {
                    response.sendRedirect(request.getContextPath() + "/admin/registrations?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/registrations?error=updateFailed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/registrations?error=notFound");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/registrations?error=invalidData");
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
