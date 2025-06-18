<%-- 
    Document   : changepassword
    Created on : Jun 18, 2025, 4:45:53 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in
    if (session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Change Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
            <style>
                .login-container {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                    padding: 20px;
                }
                .login-box {
                    background: rgba(255, 255, 255, 0.95);
                    padding: 40px;
                    border-radius: 20px;
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                    width: 100%;
                    max-width: 450px;
                    backdrop-filter: blur(10px);
                }
                .login-header {
                    text-align: center;
                    margin-bottom: 35px;
                }
                .login-header h2 {
                    font-size: 32px;
                    font-weight: 700;
                    color: #2D3748;
                    margin-bottom: 15px;
                    letter-spacing: -0.5px;
                }
                .login-header p {
                    color: #718096;
                    font-size: 16px;
                    line-height: 1.6;
                }
                .form-group {
                    margin-bottom: 24px;
                }
                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    color: #4A5568;
                    font-weight: 600;
                    font-size: 15px;
                }
                .form-control {
                    width: 100%;
                    padding: 14px 16px;
                    border: 2px solid #E2E8F0;
                    border-radius: 12px;
                    font-size: 16px;
                    transition: all 0.3s ease;
                    color: #2D3748;
                }
                .form-control:focus {
                    border-color: #6B73FF;
                    box-shadow: 0 0 0 3px rgba(107, 115, 255, 0.1);
                    outline: none;
                }
                .form-control::placeholder {
                    color: #A0AEC0;
                }
                .reset-btn {
                    width: 100%;
                    padding: 16px;
                    background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                    color: white;
                    border: none;
                    border-radius: 12px;
                    font-weight: 600;
                    font-size: 16px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    margin-bottom: 24px;
                }
                .reset-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 7px 14px rgba(0, 13, 255, 0.1);
                }
                .reset-btn:disabled {
                    background: #E2E8F0;
                    cursor: not-allowed;
                    transform: none;
                    box-shadow: none;
                }
                .back-link {
                    text-align: center;
                    color: #4A5568;
                    font-size: 15px;
                }
                .back-link a {
                    color: #6B73FF;
                    text-decoration: none;
                    font-weight: 600;
                    transition: color 0.3s ease;
                }
                .back-link a:hover {
                    color: #000DFF;
                    text-decoration: none;
                }
                .alert {
                    padding: 16px;
                    border-radius: 12px;
                    margin-bottom: 24px;
                    font-size: 15px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .alert-danger {
                    background-color: #FEF2F2;
                    border: 1px solid #FCA5A5;
                    color: #DC2626;
                }
            </style>
        </head>
        <body>
            <div class="login-container">
                <div class="login-box">
                    <div class="login-header">
                        <h2>Change Password</h2>
                        <p>Please enter your current password and new password</p>
                    </div>

                    <form action="change-password" method="post" id="changePasswordForm" onsubmit="return validateForm()">
                    <c:if test="${error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${message != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            ${message}
                        </div>
                    </c:if>
                    
                    <div id="form-errors"></div>
                    <div class="form-group">
                        <label for="current_password">Current Password</label>
                        <input type="password" class="form-control" id="current_password" name="current_password" 
                               placeholder="Enter your current password" >
                        <span id="current-password-error" class="error-text"></span>
                    </div>

                    <div class="form-group">
                        <label for="new_password">New Password</label>
                        <input type="password" class="form-control" id="new_password" name="new_password" 
                               placeholder="Enter your new password" >
                        <span id="new-password-error" class="error-text"></span>
                    </div>

                    <div class="form-group">
                        <label for="confirm_password">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" 
                               placeholder="Confirm your new password" >
                        <span id="confirm-password-error" class="error-text"></span>
                    </div>

                    <button type="submit" class="reset-btn" id="changePasswordBtn">
                        <i class="fas fa-key me-2"></i>Change Password
                    </button>

                    <div class="back-link">
                        <a href="${pageContext.request.contextPath}/my-profile">
                            <i class="fas fa-arrow-left me-2"></i>Back to Profile
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const currentPassword = document.getElementById('current_password');
                const newPassword = document.getElementById('new_password');
                const confirmPassword = document.getElementById('confirm_password');
                const changePasswordBtn = document.getElementById('changePasswordBtn');

                function validateForm() {
                    const errorContainer = document.getElementById('form-errors');
                    errorContainer.innerHTML = ""; // Clear previous errors
                    
                    // Check if all fields are filled
                    if (currentPassword.value.trim() === "" || newPassword.value.trim() === "" || confirmPassword.value.trim() === "") {
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-danger';
                        errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i>All password fields are required.';
                        errorContainer.appendChild(errorDiv);
                        return false;
                    }

                    // Check if new password matches confirm password
                    if (newPassword.value !== confirmPassword.value) {
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-danger';
                        errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i>New passwords do not match.';
                        errorContainer.appendChild(errorDiv);
                        return false;
                    }

                    // Check if new password is different from current password
                    if (currentPassword.value === newPassword.value) {
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-danger';
                        errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i>New password must be different from current password.';
                        errorContainer.appendChild(errorDiv);
                        return false;
                    }

                    return true;
                }

                // Add form validation on submit
                document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
                    if (!validateForm()) {
                        e.preventDefault();
                    }
                });
            });
        </script>
    </body>
</html>
