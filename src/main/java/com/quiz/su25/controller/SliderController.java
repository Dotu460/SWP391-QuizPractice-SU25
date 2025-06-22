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
        
        // For now, we only handle listing with filters.
        // Add, Edit, Details can be added later.
        handleListWithFilters(request, response);
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
        // For now, POST requests can be redirected to GET for simplicity
        // Later, this will handle create, update, delete actions
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Controller for managing sliders, handles listing, filtering, and pagination.";
    }
}
