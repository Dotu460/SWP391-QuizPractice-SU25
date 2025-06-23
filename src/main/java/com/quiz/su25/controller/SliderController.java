/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller;

import com.quiz.su25.dal.impl.SliderDAO;
import com.quiz.su25.entity.Slider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author kenngoc
 */
@WebServlet(name = "SliderController", urlPatterns = {"/slider-list"})
public class SliderController extends HttpServlet {
    private SliderDAO sliderDAO;

    @Override
    public void init() throws ServletException {
        sliderDAO = new SliderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/view/Slider/slider-add.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            handleEdit(request, response);
        } else if ("details".equals(action)) {
            handleDetails(request, response);
        } else {
            // For now, we only handle listing with filters.
            // Add, Edit, Details can be added later.
            handleListWithFilters(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Slider slider = sliderDAO.findById(id);
                if (slider != null) {
                    request.setAttribute("slider", slider);
                    request.setAttribute("returnQueryString", buildReturnQueryString(request));
                    request.getRequestDispatcher("/view/Slider/slider-edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("toastMessage", "Invalid slider ID");
                request.getSession().setAttribute("toastType", "error");
            }
        }
        // If slider not found or invalid ID, redirect to list
        response.sendRedirect(request.getContextPath() + "/slider-list");
    }

    private void handleDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Slider slider = sliderDAO.findById(id);
                if (slider != null) {
                    request.setAttribute("slider", slider);
                    request.setAttribute("returnQueryString", buildReturnQueryString(request));
                    request.getRequestDispatcher("/view/Slider/slider-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("toastMessage", "Invalid slider ID");
                request.getSession().setAttribute("toastType", "error");
            }
        }
        // If slider not found or invalid ID, redirect to list
        response.sendRedirect(request.getContextPath() + "/slider-list");
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 5; // Default page size
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
                if (pageSize < 1) pageSize = 5;
                if (pageSize > 50) pageSize = 50; // Max limit
            } catch (NumberFormatException e) {
                pageSize = 5;
            }
        }
        
        // Fetch data from DAO
        List<Slider> sliders = sliderDAO.findSlidersWithFilters(
                statusFilter, searchFilter, page, pageSize);
        
        int totalSliders = sliderDAO.getTotalFilteredSliders(
                statusFilter, searchFilter);
        
        int totalPages = (int) Math.ceil((double) totalSliders / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("sliders", sliders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSliders", totalSliders);
        request.setAttribute("pageSize", pageSize);
        
        // Maintain filter values in the view
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);
        
        request.getRequestDispatcher("/view/Slider/slider-list.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createSlider(request, response);
        } else if ("update".equals(action)) {
            updateSlider(request, response);
        } else {
            // For now, POST requests can be redirected to GET for simplicity
            // Later, this will handle create, update, delete actions
            doGet(request, response);
        }
    }

    private void updateSlider(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String returnQueryString = request.getParameter("returnQueryString");
        try {
            // Get ID parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Slider ID is required for update.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/slider-list");
                return;
            }

            int id = Integer.parseInt(idStr);

            // Get other parameters
            String title = request.getParameter("title");
            String imageUrl = request.getParameter("image_url");
            String backlinkUrl = request.getParameter("backlink_url");
            String statusStr = request.getParameter("status");
            String notes = request.getParameter("notes");

            // Validate required fields
            if (title == null || title.trim().isEmpty()
                    || imageUrl == null || imageUrl.trim().isEmpty()
                    || backlinkUrl == null || backlinkUrl.trim().isEmpty()
                    || statusStr == null || statusStr.trim().isEmpty()) {

                Slider slider = sliderDAO.findById(id);
                request.setAttribute("slider", slider);
                request.setAttribute("error", "All required fields must be filled");
                request.setAttribute("returnQueryString", returnQueryString);
                request.getRequestDispatcher("/view/Slider/slider-edit.jsp").forward(request, response);
                return;
            }

            boolean status = "active".equalsIgnoreCase(statusStr);

            // Create Slider object with ID
            Slider slider = Slider.builder()
                    .id(id)
                    .title(title.trim())
                    .image_url(imageUrl.trim())
                    .backlink_url(backlinkUrl.trim())
                    .status(status)
                    .notes(notes != null ? notes.trim() : "")
                    .build();

            // Update in database
            boolean success = sliderDAO.update(slider);

            if (success) {
                request.getSession().setAttribute("toastMessage", "Slider updated successfully");
                request.getSession().setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/slider-list?" + (returnQueryString != null ? returnQueryString : ""));
            } else {
                request.setAttribute("slider", slider);
                request.setAttribute("error", "Failed to update slider");
                request.setAttribute("returnQueryString", returnQueryString);
                request.getRequestDispatcher("/view/Slider/slider-edit.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid Slider ID format.");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/slider-list");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            // To retain data on error, we should refetch the slider and forward
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Slider slider = sliderDAO.findById(id);
                    request.setAttribute("slider", slider);
                } catch (NumberFormatException nfe) {
                    /* ignore */ }
            }
            request.setAttribute("returnQueryString", returnQueryString);
            request.getRequestDispatcher("/view/Slider/slider-edit.jsp").forward(request, response);
        }
    }

    private void createSlider(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get parameters from request
            String title = request.getParameter("title");
            String imageUrl = request.getParameter("image_url");
            String backlinkUrl = request.getParameter("backlink_url");
            String statusStr = request.getParameter("status");
            String notes = request.getParameter("notes");

            // Validate required fields
            if (title == null || title.trim().isEmpty()
                    || imageUrl == null || imageUrl.trim().isEmpty()
                    || backlinkUrl == null || backlinkUrl.trim().isEmpty()
                    || statusStr == null || statusStr.trim().isEmpty()) {

                request.setAttribute("error", "All required fields must be filled");
                request.getRequestDispatcher("/view/Slider/slider-add.jsp").forward(request, response);
                return;
            }

            boolean status = "active".equalsIgnoreCase(statusStr);

            // Create Slider object
            Slider slider = Slider.builder()
                    .title(title.trim())
                    .image_url(imageUrl.trim())
                    .backlink_url(backlinkUrl.trim())
                    .status(status)
                    .notes(notes != null ? notes.trim() : "")
                    .build();

            // Save to database
            int generatedId = sliderDAO.insert(slider);

            if (generatedId != -1) {
                request.getSession().setAttribute("toastMessage", "Slider created successfully");
                request.getSession().setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/slider-list");
            } else {
                request.setAttribute("error", "Failed to create slider");
                request.getRequestDispatcher("/view/Slider/slider-add.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/Slider/slider-add.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing sliders, handles listing, filtering, and pagination.";
    }

    private String buildReturnQueryString(HttpServletRequest request) {
        try {
            String status = request.getParameter("status");
            String search = request.getParameter("search");
            String pageSize = request.getParameter("pageSize");
            String page = request.getParameter("page");

            List<String> params = new ArrayList<>();
            if (status != null && !status.isEmpty()) {
                params.add("status=" + URLEncoder.encode(status, "UTF-8"));
            }
            if (search != null && !search.isEmpty()) {
                params.add("search=" + URLEncoder.encode(search, "UTF-8"));
            }
            if (pageSize != null && !pageSize.isEmpty()) {
                params.add("pageSize=" + pageSize);
            }
            if (page != null && !page.isEmpty()) {
                params.add("page=" + page);
            }

            return String.join("&", params);
        } catch (UnsupportedEncodingException e) {
            // This should not happen with UTF-8
            return "";
        }
    }
}
