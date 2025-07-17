/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quiz.su25.controller.user;

import com.quiz.su25.dal.impl.PricePackageDAO;
import com.quiz.su25.entity.PricePackage;
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
@WebServlet(name = "PricePackageMenuController", urlPatterns = {"/price-package-menu"})
public class PricePackageMenuController extends HttpServlet {
    private PricePackageDAO pricePackageDAO;

    @Override
    public void init() throws ServletException {
        pricePackageDAO = new PricePackageDAO();
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
                    request.setAttribute("pricePackage", pricePackage);
                    request.getRequestDispatcher("/view/user/price_package/price-package-learn-more.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Price package not found");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid package ID");
            }
        }
        // Nếu không có id, hiển thị danh sách như cũ
        List<PricePackage> pricePackages = pricePackageDAO.findPricePackagesWithFilters(
            "active", null, null, null, 1, Integer.MAX_VALUE
        );
        request.setAttribute("pricePackages", pricePackages);
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
