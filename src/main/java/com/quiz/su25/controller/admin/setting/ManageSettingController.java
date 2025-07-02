package com.quiz.su25.controller.admin.setting;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.quiz.su25.dal.impl.SettingDAO;
import com.quiz.su25.entity.Setting;
import com.quiz.su25.listener.AppContextListener;
import java.util.List;

@WebServlet(name = "ManageSettingController", urlPatterns = {"/setting"})
public class ManageSettingController extends HttpServlet {
    private SettingDAO settingDAO;

    @Override
    public void init() throws ServletException {
        settingDAO = new SettingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            handleEdit(request, response);
        } else if ("details".equals(action)) {
            handleDetails(request, response);
        } else if ("add".equals(action)) {
            handleAdd(request, response);
        } else {
            handleListWithFilters(request, response);
        }
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Setting setting = settingDAO.findById(id);
                if (setting != null) {
                    request.setAttribute("setting", setting);
                    request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid setting ID");
            }
        }
        
        // If setting not found or invalid ID, redirect to list
        response.sendRedirect(request.getContextPath() + "/setting");
    }
    
    private void handleDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Setting setting = settingDAO.findById(id);
                if (setting != null) {
                    request.setAttribute("setting", setting);
                    request.getRequestDispatcher("/view/admin/setting/settingDetails.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid setting ID");
            }
        }
        
        // If setting not found or invalid ID, redirect to list
        response.sendRedirect(request.getContextPath() + "/setting");
    }
    
    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get filter parameters
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
        
        List<Setting> settings;
        int totalSettings;
        
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            // Simple search by key or value
            settings = settingDAO.findAll().stream()
                    .filter(s -> s.getKey().toLowerCase().contains(searchFilter.toLowerCase()) ||
                               s.getValue().toLowerCase().contains(searchFilter.toLowerCase()))
                    .skip((long) (page - 1) * pageSize)
                    .limit(pageSize)
                    .toList();
            
            totalSettings = (int) settingDAO.findAll().stream()
                    .filter(s -> s.getKey().toLowerCase().contains(searchFilter.toLowerCase()) ||
                               s.getValue().toLowerCase().contains(searchFilter.toLowerCase()))
                    .count();
        } else {
            settings = settingDAO.findAll();
            totalSettings = settings.size();
            
            // Apply pagination
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, settings.size());
            settings = settings.subList(fromIndex, toIndex);
        }
        
        int totalPages = (int) Math.ceil((double) totalSettings / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("settings", settings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSettings", totalSettings);
        request.setAttribute("pageSize", pageSize);
        
        // Set filter values for maintaining state
        request.setAttribute("searchFilter", searchFilter);
        
        request.getRequestDispatcher("/view/admin/setting/listSetting.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createSetting(request, response);
        } else if ("update".equals(action)) {
            updateSetting(request, response);
        } else if ("delete".equals(action)) {
            deleteSetting(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/setting");
        }
    }
    
    private void createSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get parameters from request
            String key = request.getParameter("key");
            String value = request.getParameter("value");
            
            // Validate required fields
            if (key == null || key.trim().isEmpty() ||
                value == null || value.trim().isEmpty()) {
                
                request.setAttribute("error", "All required fields must be filled");
                request.getRequestDispatcher("/view/admin/setting/addSetting.jsp").forward(request, response);
                return;
            }
            
            // Check if key already exists
            if (settingDAO.isKeyExist(key.trim())) {
                request.setAttribute("error", "Setting key already exists");
                request.setAttribute("key", key);
                request.setAttribute("value", value);
                request.getRequestDispatcher("/view/admin/setting/addSetting.jsp").forward(request, response);
                return;
            }
            
            // Create Setting object
            Setting setting = Setting.builder()
                    .key(key.trim())
                    .value(value.trim())
                    .build();
            
            // Save to database
            int generatedId = settingDAO.insert(setting);
            
            if (generatedId > 0) {
                // Refresh cached settings after successful creation
                AppContextListener.refreshSettings(getServletContext());
                
                request.getSession().setAttribute("toastMessage", "Setting created successfully");
                request.getSession().setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/setting");
            } else {
                request.setAttribute("error", "Failed to create setting");
                request.setAttribute("key", key);
                request.setAttribute("value", value);
                request.getRequestDispatcher("/view/admin/setting/addSetting.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/admin/setting/addSetting.jsp").forward(request, response);
        }
    }
    
    private void updateSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get ID parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "Setting ID is required for update");
                response.sendRedirect(request.getContextPath() + "/setting");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // Get other parameters
            String key = request.getParameter("key");
            String value = request.getParameter("value");
            
            // Validate required fields
            if (key == null || key.trim().isEmpty() ||
                value == null || value.trim().isEmpty()) {
                
                // Get the setting for redisplaying the form
                Setting setting = settingDAO.findById(id);
                request.setAttribute("setting", setting);
                request.setAttribute("error", "All required fields must be filled");
                request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
                return;
            }
            
            // Check if key already exists (for other settings)
            Setting existingByKey = settingDAO.findByKey(key.trim());
            if (existingByKey != null && !existingByKey.getId().equals(id)) {
                Setting setting = settingDAO.findById(id);
                request.setAttribute("setting", setting);
                request.setAttribute("error", "Setting key already exists");
                request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
                return;
            }
            
            // Create Setting object with ID
            Setting setting = Setting.builder()
                    .id(id)
                    .key(key.trim())
                    .value(value.trim())
                    .build();
            
            // Update in database
            boolean success = settingDAO.update(setting);
            
            if (success) {
                // Refresh cached settings after successful update
                AppContextListener.refreshSettings(getServletContext());
                
                request.getSession().setAttribute("toastMessage", "Setting updated successfully");
                request.getSession().setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/setting");
            } else {
                request.setAttribute("setting", setting);
                request.setAttribute("error", "Failed to update setting");
                request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            // Get the setting for redisplaying the form
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Setting setting = settingDAO.findById(id);
                    request.setAttribute("setting", setting);
                } catch (NumberFormatException ex) {
                    // If we can't get the setting, redirect to list
                    response.sendRedirect(request.getContextPath() + "/setting");
                    return;
                }
            }
            request.setAttribute("error", "Invalid setting ID provided");
            request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
        } catch (Exception e) {
            // Get the setting for redisplaying the form
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Setting setting = settingDAO.findById(id);
                    request.setAttribute("setting", setting);
                } catch (NumberFormatException ex) {
                    // If we can't get the setting, redirect to list
                    response.sendRedirect(request.getContextPath() + "/setting");
                    return;
                }
            }
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/admin/setting/editSetting.jsp").forward(request, response);
        }
    }
    
    private void deleteSetting(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Setting ID is required for deletion");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/setting");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // Find the setting first to ensure it exists
            Setting setting = settingDAO.findById(id);
            if (setting == null) {
                request.getSession().setAttribute("toastMessage", "Setting not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/setting");
                return;
            }
            
            // Perform hard delete
            boolean success = settingDAO.delete(setting);
            
            if (success) {
                // Refresh cached settings after successful deletion
                AppContextListener.refreshSettings(getServletContext());
                
                request.getSession().setAttribute("toastMessage", "Setting deleted successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to delete setting");
                request.getSession().setAttribute("toastType", "error");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid setting ID");
            request.getSession().setAttribute("toastType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect to avoid form resubmission
        response.sendRedirect(request.getContextPath() + "/setting");
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/setting/addSetting.jsp").forward(request, response);
    }
} 