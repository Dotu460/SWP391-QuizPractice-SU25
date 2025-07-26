/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.quiz.su25.config.GlobalConfig;
import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.dal.impl.RegistrationDAO;
import com.quiz.su25.entity.PricePackage;
import com.quiz.su25.entity.Registration;
import com.quiz.su25.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author kenngoc
 */
@WebServlet(name = "PricePackageMenuController", urlPatterns = {"/price-package-menu"})
public class PricePackageMenuController extends HttpServlet {
    private PricePackageDAO pricePackageDAO;
    private RegistrationDAO registrationDAO;

    @Override
    public void init() throws ServletException {
        pricePackageDAO = new PricePackageDAO();
        registrationDAO = new RegistrationDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                PricePackage pricePackage = pricePackageDAO.findById(id);
                if (pricePackage != null) {
                    // 🔧 Add userPurchases check for detail page
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
                    Map<Integer, Registration> userPurchases = new HashMap<>();
                    boolean isPurchased = false;
                    
                    if (user != null) {
                        List<Registration> userRegistrations = registrationDAO.findByUserId(user.getId());
                        Date currentDate = new Date(System.currentTimeMillis());
                        
                        for (Registration reg : userRegistrations) {
                            if (("paid".equals(reg.getStatus()) || "active".equals(reg.getStatus()) || "Approved".equals(reg.getStatus())) && 
                                reg.getValid_to() != null && 
                                reg.getValid_to().after(currentDate)) {
                                userPurchases.put(reg.getPackage_id(), reg);
                                if (id == reg.getPackage_id()) {
                                    isPurchased = true;
                                }
                            }
                        }
                        
                        System.out.println("🔍 Detail Page - User " + user.getId() + " checking package " + id);
                        System.out.println("   isPurchased: " + isPurchased);
                        System.out.println("   userPurchases size: " + userPurchases.size());
                    }
                    
                    request.setAttribute("pricePackage", pricePackage);
                    request.setAttribute("userPurchases", userPurchases);
                    request.setAttribute("currentUser", user);
                    request.setAttribute("isPurchased", isPurchased);
                    request.getRequestDispatcher("/view/user/price_package/price-package-learn-more.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Price package not found");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid package ID");
            }
        }
        // --- PHÂN TRANG ---
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        String showAllParam = request.getParameter("showAll");
        int page = 1;
        int pageSize = 10; // default 10 items/page
        boolean showAll = "true".equals(showAllParam);
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); if (page < 1) page = 1; } catch (NumberFormatException e) { page = 1; }
        }
        if (showAll) {
            pageSize = Integer.MAX_VALUE;
            page = 1;
        } else if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            try { pageSize = Integer.parseInt(pageSizeStr); if (pageSize < 1) pageSize = 10; if (pageSize > 100) pageSize = 100; } catch (NumberFormatException e) { pageSize = 10; }
        }
        // Lấy tổng số packages
        int totalPackages = pricePackageDAO.getTotalFilteredPricePackages("active", null, null, null);
        int totalPages = showAll ? 1 : (int) Math.ceil((double) totalPackages / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        // Lấy danh sách packages theo trang
        List<PricePackage> pricePackages = pricePackageDAO.findPricePackagesWithFilters(
            "active", null, null, null, page, pageSize
        );
        // Check user login status and get purchased packages
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        Map<Integer, Registration> userPurchases = new HashMap<>();
        if (user != null) {
            List<Registration> userRegistrations = registrationDAO.findByUserId(user.getId());
            Date currentDate = new Date(System.currentTimeMillis());
            for (Registration reg : userRegistrations) {
                if (("paid".equals(reg.getStatus()) || "active".equals(reg.getStatus()) || "Approved".equals(reg.getStatus())) && 
                    reg.getValid_to() != null && reg.getValid_to().after(currentDate)) {
                    userPurchases.put(reg.getPackage_id(), reg);
                }
            }
        }
        request.setAttribute("pricePackages", pricePackages);
        request.setAttribute("userPurchases", userPurchases);
        request.setAttribute("currentUser", user);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", showAll ? 10 : pageSize);
        request.setAttribute("showAll", showAll);
        request.setAttribute("totalPackages", totalPackages);
        request.getRequestDispatcher("/view/user/price_package/price-package-menu.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}


