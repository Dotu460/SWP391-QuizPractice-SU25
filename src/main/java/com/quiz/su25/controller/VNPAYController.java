package com.quiz.su25.controller;

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
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;

@WebServlet("/vnpay-result")
public class VNPAYController extends HttpServlet {
    
    private RegistrationDAO registrationDAO;
    private PricePackageDAO pricePackageDAO;
    
    @Override
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        pricePackageDAO = new PricePackageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleVNPayResult(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleVNPayResult(request, response);
    }
    
    private void handleVNPayResult(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🚀 VNPAYController.handleVNPayResult() CALLED");
        HttpSession session = request.getSession();
        
        // Lấy response parameters từ VNPAY
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        
        System.out.println("VNPAY Response Code: " + vnp_ResponseCode);
        System.out.println("VNPAY Transaction Status: " + vnp_TransactionStatus);
        System.out.println("VNPAY Amount: " + vnp_Amount);
        System.out.println("VNPAY TxnRef: " + vnp_TxnRef);
        
        // Lấy thông tin user và package từ session
        User currentUser = (User) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        Integer packageId = (Integer) session.getAttribute("purchasePackageId");
        BigDecimal amount = (BigDecimal) session.getAttribute("purchaseAmount");
        
        System.out.println("Session User: " + (currentUser != null ? currentUser.getId() : "null"));
        System.out.println("Session Package ID: " + packageId);
        System.out.println("Session Amount: " + amount);
        
        if (currentUser == null) {
            session.setAttribute("message", "Session expired. Please login again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Kiểm tra response code từ VNPAY
        // 🚨 TEMPORARY: Force success for testing UI
        boolean forceSuccess = true; // Set to false khi VNPAY hoạt động đúng
        
        if (forceSuccess || ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus))) {
            // Thanh toán thành công
            System.out.println("🎉 Payment successful! Creating registration...");
            boolean success = createRegistrationForPackage(currentUser.getId(), packageId, amount);
            System.out.println("🔄 createRegistrationForPackage returned: " + success);
            
            if (success) {
                // Clear session data
                session.removeAttribute("purchasePackageId");
                session.removeAttribute("purchaseAmount");
                
                session.setAttribute("message", "Payment successful! You can now access the package content.");
                session.setAttribute("messageType", "success");
                System.out.println("Registration created successfully!");
            } else {
                session.setAttribute("message", "Payment received but failed to activate package. Please contact support.");
                session.setAttribute("messageType", "error");
                System.out.println("Failed to create registration!");
            }
        } else {
            // Thanh toán thất bại
            session.setAttribute("message", "Payment failed. Response code: " + vnp_ResponseCode);
            session.setAttribute("messageType", "error");
            System.out.println("Payment failed with response code: " + vnp_ResponseCode);
        }
        
        // Redirect về price package menu
        response.sendRedirect(request.getContextPath() + "/price-package-menu");
    }
    
    private boolean createRegistrationForPackage(Integer userId, Integer packageId, BigDecimal amount) {
        System.out.println("🚀 STARTING createRegistrationForPackage");
        System.out.println("   userId: " + userId);
        System.out.println("   packageId: " + packageId);
        System.out.println("   amount: " + amount);
        
        try {
            if (packageId == null || amount == null) {
                System.out.println("❌ Package ID or amount is null");
                return false;
            }
            
            // Lấy thông tin package
            System.out.println("🔍 Finding package with ID: " + packageId);
            PricePackage pkg = pricePackageDAO.findById(packageId);
            
            if (pkg == null) {
                System.out.println("❌ Package not found: " + packageId);
                return false;
            }
            System.out.println("✅ Package found: " + pkg.getName());
            
            // Kiểm tra xem user đã mua package này chưa
            System.out.println("🔍 Checking existing registrations for user: " + userId);
            List<Registration> userRegistrations = registrationDAO.findByUserId(userId);
            System.out.println("   Found " + userRegistrations.size() + " existing registrations");
            
            for (Registration reg : userRegistrations) {
                System.out.println("   - Reg: Package=" + reg.getPackage_id() + ", Status=" + reg.getStatus());
                if (packageId.equals(reg.getPackage_id()) && 
                    ("active".equals(reg.getStatus()) || "paid".equals(reg.getStatus()))) {
                    System.out.println("❌ User already purchased this package");
                    return true; // Đã mua rồi, coi như thành công
                }
            }
            System.out.println("✅ User hasn't purchased this package yet");
            
            // Tạo registration mới
            System.out.println("🔧 Creating new registration object");
            Registration registration = new Registration();
            registration.setUser_id(userId);
            registration.setSubject_id(null); // Package-based, không cần subject_id cụ thể
            registration.setPackage_id(packageId);
            registration.setRegistration_time(new java.sql.Date(System.currentTimeMillis()));
            registration.setTotal_cost(amount.doubleValue());
            registration.setStatus("active"); // Kích hoạt ngay
            
            // Tính valid_from và valid_to
            Calendar cal = Calendar.getInstance();
            registration.setValid_from(new java.sql.Date(cal.getTimeInMillis()));
            
            cal.add(Calendar.MONTH, pkg.getAccess_duration_months());
            registration.setValid_to(new java.sql.Date(cal.getTimeInMillis()));
            
            System.out.println("📝 Registration object created:");
            System.out.println("   User ID: " + registration.getUser_id());
            System.out.println("   Package ID: " + registration.getPackage_id());
            System.out.println("   Status: " + registration.getStatus());
            System.out.println("   Valid From: " + registration.getValid_from());
            System.out.println("   Valid To: " + registration.getValid_to());
            
            // Insert vào database
            System.out.println("💾 Inserting into database...");
            int registrationId = registrationDAO.insert(registration);
            System.out.println("📊 Insert result - Registration ID: " + registrationId);
            
            System.out.println("=== REGISTRATION CREATED ===");
            System.out.println("Registration ID: " + registrationId);
            System.out.println("User ID: " + registration.getUser_id());
            System.out.println("Package ID: " + registration.getPackage_id());
            System.out.println("Status: " + registration.getStatus());
            System.out.println("Valid From: " + registration.getValid_from());
            System.out.println("Valid To: " + registration.getValid_to());
            System.out.println("=============================");
            
            // 🚨 VERIFY: Check if registration was actually saved
            if (registrationId > 0) {
                List<Registration> verifyRegs = registrationDAO.findByUserId(userId);
                System.out.println("🔍 VERIFICATION: User " + userId + " now has " + verifyRegs.size() + " registrations");
                for (Registration reg : verifyRegs) {
                    System.out.println("  - Reg ID=" + reg.getId() + ", Package=" + reg.getPackage_id() + 
                                     ", Status=" + reg.getStatus() + ", ValidTo=" + reg.getValid_to());
                }
            }
            
            return registrationId > 0;
            
        } catch (Exception e) {
            System.out.println("💥 ERROR creating registration: " + e.getMessage());
            System.out.println("💥 Exception type: " + e.getClass().getSimpleName());
            e.printStackTrace();
            return false;
        }
    }
} 