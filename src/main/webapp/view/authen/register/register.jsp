<%-- 
    Document   : register
    Created on : Jun 3, 2025, 6:10:15 PM
    Author     : LENOVO
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Register - SkillGro</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .register-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                padding: 20px;
            }
            .register-box {
                background: rgba(255, 255, 255, 0.95);
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 450px;
                backdrop-filter: blur(10px);
            }
            .register-header {
                text-align: center;
                margin-bottom: 35px;
            }
            .register-header h2 {
                font-size: 32px;
                font-weight: 700;
                color: #2D3748;
                margin-bottom: 15px;
                letter-spacing: -0.5px;
            }
            .register-header p {
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
            .gender-options {
                display: flex;
                gap: 20px;
            }
            .gender-option {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .gender-option input[type="radio"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }
            .gender-option span {
                color: #4A5568;
                font-size: 15px;
            }
            .sign-up-btn {
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
            .sign-up-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 7px 14px rgba(0, 13, 255, 0.1);
            }
            .register-link {
                text-align: center;
                color: #4A5568;
                font-size: 15px;
            }
            .register-link a {
                color: #6B73FF;
                text-decoration: none;
                font-weight: 600;
                margin-left: 4px;
                transition: color 0.3s ease;
            }
            .register-link a:hover {
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
            .alert::before {
                content: "";
                width: 24px;
                height: 24px;
                background-position: center;
                background-repeat: no-repeat;
                background-size: contain;
            }
            .alert-danger {
                background-color: #FEF2F2;
                border: 1px solid #FCA5A5;
                color: #DC2626;
            }
            .alert-danger::before {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23DC2626'%3E%3Cpath d='M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm-1-7v2h2v-2h-2zm0-8v6h2V7h-2z'/%3E%3C/svg%3E");
            }
            .alert-success {
                background-color: #F0FDF4;
                border: 1px solid #86EFAC;
                color: #16A34A;
            }
            .alert-success::before {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2316A34A'%3E%3Cpath d='M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm-.997-6l7.07-7.071-1.414-1.414-5.656 5.657-2.829-2.829-1.414 1.414L11.003 16z'/%3E%3C/svg%3E");
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .register-box {
                animation: fadeIn 0.6s ease-out;
            }
        </style>
    </head>

    <body>
        <div class="register-container">
            <div class="register-box">
                <div class="register-header">
                    <h2>Create Account</h2>
                    <p>Please fill in your information to register</p>
                </div>
                
                <form action="register" method="post">
                    <c:if test="${message != null}">
                        <div class="alert alert-${type}">
                            ${message}
                        </div>
                    </c:if>
                    
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Gender</label>
                        <div class="gender-options">
                            <div class="gender-option">
                                <input type="radio" id="male" name="gender" value="male" required>
                                <span>Male</span>
                            </div>
                            <div class="gender-option">
                                <input type="radio" id="female" name="gender" value="female" required>
                                <span>Female</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="mobile">Mobile</label>
                        <input type="tel" class="form-control" id="mobile" name="mobile" placeholder="Enter your mobile number" required>
                    </div>
                    
                    <button type="submit" class="sign-up-btn">Register</button>
                    
                    <div class="register-link">
                        Already have an account? <a href="login">Sign in</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>
