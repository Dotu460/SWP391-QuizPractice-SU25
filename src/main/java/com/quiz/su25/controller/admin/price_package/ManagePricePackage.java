package com.quiz.su25.controller.admin.price_package;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.PricePackage;
import java.util.List;


@WebServlet(name = "ManagePricePackage", urlPatterns = {"/admin/pricepackage"})
public class ManagePricePackage extends HttpServlet {
    private PricePackageDAO pricePackageDAO;

    @Override
    public void init() throws ServletException {
        pricePackageDAO = new PricePackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            handleEdit(request, response);
        } else if ("details".equals(action)) {
            handleDetails(request, response);
        } else {
            handleListWithFilters(request, response);
        }
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                PricePackage pricePackage = pricePackageDAO.findById(id);
                if (pricePackage != null) {
                    request.setAttribute("pricePackage", pricePackage);
                    request.setAttribute("action", "edit");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid package ID");
            }
        }
        
        // Load all packages for listing
        List<PricePackage> pricePackages = pricePackageDAO.findAll();
        request.setAttribute("pricePackages", pricePackages);
        request.getRequestDispatcher("/view/admin/price_package/listPricePackage.jsp").forward(request, response);
    }
    
    private void handleDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                PricePackage pricePackage = pricePackageDAO.findById(id);
                if (pricePackage != null) {
                    request.setAttribute("pricePackage", pricePackage);
                    request.getRequestDispatcher("/view/admin/price_package/pricePackageDetails.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid package ID");
            }
        }
        
        // If package not found or invalid ID, redirect to list
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }
    
    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String minPriceFilter = request.getParameter("minPrice");
        String maxPriceFilter = request.getParameter("maxPrice");
        
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
        
        List<PricePackage> pricePackages = pricePackageDAO.findPricePackagesWithFilters(
                statusFilter, searchFilter, minPriceFilter, maxPriceFilter, page, pageSize);
        
        int totalPackages = pricePackageDAO.getTotalFilteredPricePackages(
                statusFilter, searchFilter, minPriceFilter, maxPriceFilter);
        int totalPages = (int) Math.ceil((double) totalPackages / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("pricePackages", pricePackages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPackages", totalPackages);
        request.setAttribute("pageSize", pageSize);
        
        // Set filter values for maintaining state
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);
        request.setAttribute("minPriceFilter", minPriceFilter);
        request.setAttribute("maxPriceFilter", maxPriceFilter);
        
        request.getRequestDispatcher("/view/admin/price_package/listPricePackage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createPricePackage(request, response);
        } else if ("update".equals(action)) {
            updatePricePackage(request, response);
        } else if ("delete".equals(action)) {
            deletePricePackage(request, response);
        } else if ("activate".equals(action)) {
            activatePricePackage(request, response);
        } else if ("deactivate".equals(action)) {
            deactivatePricePackage(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
        }
    }
    
    private void createPricePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get parameters from request
            String name = request.getParameter("name");
            String accessDurationStr = request.getParameter("access_duration_months");
            String listPriceStr = request.getParameter("list_price");
            String salePriceStr = request.getParameter("sale_price");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                accessDurationStr == null || accessDurationStr.trim().isEmpty() ||
                listPriceStr == null || listPriceStr.trim().isEmpty() ||
                salePriceStr == null || salePriceStr.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled");
                doGet(request, response);
                return;
            }
            
            // Parse numeric values
            int accessDuration = Integer.parseInt(accessDurationStr);
            int listPrice = Integer.parseInt(listPriceStr);
            int salePrice = Integer.parseInt(salePriceStr);
            
            // Validate business rules
            if (accessDuration <= 0) {
                request.setAttribute("error", "Access duration must be greater than 0");
                doGet(request, response);
                return;
            }
            
            if (listPrice <= 0 || salePrice <= 0) {
                request.setAttribute("error", "Prices must be greater than 0");
                doGet(request, response);
                return;
            }
            
            if (salePrice > listPrice) {
                request.setAttribute("error", "Sale price cannot be greater than list price");
                doGet(request, response);
                return;
            }
            
            // Create PricePackage object
            PricePackage pricePackage = PricePackage.builder()
                    .name(name.trim())
                    .access_duration_months(accessDuration)
                    .list_price(listPrice)
                    .sale_price(salePrice)
                    .status(status.trim())
                    .description(description != null ? description.trim() : "")
                    .build();
            
            // Save to database
            boolean success = pricePackageDAO.create(pricePackage);
            
            if (success) {
                request.setAttribute("success", "Price package created successfully");
            } else {
                request.setAttribute("error", "Failed to create price package");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric values provided");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        // Redirect to avoid form resubmission
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }
    
    private void updatePricePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get ID parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "Package ID is required for update");
                doGet(request, response);
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // Get other parameters
            String name = request.getParameter("name");
            String accessDurationStr = request.getParameter("access_duration_months");
            String listPriceStr = request.getParameter("list_price");
            String salePriceStr = request.getParameter("sale_price");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                accessDurationStr == null || accessDurationStr.trim().isEmpty() ||
                listPriceStr == null || listPriceStr.trim().isEmpty() ||
                salePriceStr == null || salePriceStr.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled");
                doGet(request, response);
                return;
            }
            
            // Parse numeric values
            int accessDuration = Integer.parseInt(accessDurationStr);
            int listPrice = Integer.parseInt(listPriceStr);
            int salePrice = Integer.parseInt(salePriceStr);
            
            // Validate business rules
            if (accessDuration <= 0) {
                request.setAttribute("error", "Access duration must be greater than 0");
                doGet(request, response);
                return;
            }
            
            if (listPrice <= 0 || salePrice <= 0) {
                request.setAttribute("error", "Prices must be greater than 0");
                doGet(request, response);
                return;
            }
            
            if (salePrice > listPrice) {
                request.setAttribute("error", "Sale price cannot be greater than list price");
                doGet(request, response);
                return;
            }
            
            // Create PricePackage object with ID
            PricePackage pricePackage = PricePackage.builder()
                    .id(id)
                    .name(name.trim())
                    .access_duration_months(accessDuration)
                    .list_price(listPrice)
                    .sale_price(salePrice)
                    .status(status.trim())
                    .description(description != null ? description.trim() : "")
                    .build();
            
            // Update in database
            boolean success = pricePackageDAO.update(pricePackage);
            
            if (success) {
                request.setAttribute("success", "Price package updated successfully");
            } else {
                request.setAttribute("error", "Failed to update price package");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric values provided");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        // Redirect to avoid form resubmission
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }
    
    private void deletePricePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "Package ID is required for deletion");
                doGet(request, response);
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // Find the package first to ensure it exists
            PricePackage pricePackage = pricePackageDAO.findById(id);
            if (pricePackage == null) {
                request.setAttribute("error", "Price package not found");
                doGet(request, response);
                return;
            }
            
            // For now, we'll implement soft delete by changing status to "inactive"
            // since the DAO delete method is not implemented
            pricePackage.setStatus("inactive");
            boolean success = pricePackageDAO.update(pricePackage);
            
            if (success) {
                request.setAttribute("success", "Price package deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete price package");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid package ID");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        // Redirect to avoid form resubmission
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }

    private void activatePricePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Package ID is required");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            PricePackage pricePackage = pricePackageDAO.findById(id);
            if (pricePackage == null) {
                request.getSession().setAttribute("toastMessage", "Price package not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
                return;
            }
            
            // Update status to active
            pricePackage.setStatus("active");
            boolean success = pricePackageDAO.update(pricePackage);
            
            if (success) {
                request.getSession().setAttribute("toastMessage", "Price package activated successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to activate price package");
                request.getSession().setAttribute("toastType", "error");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid package ID");
            request.getSession().setAttribute("toastType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }

    private void deactivatePricePackage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Package ID is required");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            PricePackage pricePackage = pricePackageDAO.findById(id);
            if (pricePackage == null) {
                request.getSession().setAttribute("toastMessage", "Price package not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
                return;
            }
            
            // Update status to inactive
            pricePackage.setStatus("inactive");
            boolean success = pricePackageDAO.update(pricePackage);
            
            if (success) {
                request.getSession().setAttribute("toastMessage", "Price package deactivated successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to deactivate price package");
                request.getSession().setAttribute("toastType", "error");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid package ID");
            request.getSession().setAttribute("toastType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/pricepackage");
    }
}

