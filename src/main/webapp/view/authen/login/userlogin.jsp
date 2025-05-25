<%-- 
    Document   : userlogin
    Created on : May 25, 2025, 6:15:21 PM
    Author     : LENOVO
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login - QuizPractice</title>
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
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                padding: 20px;
            }
            .login-box {
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
                transform: translateY(0);
                transition: all 0.3s ease;
            }
            .login-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            }
            .login-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .login-header h2 {
                font-size: 32px;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
            }
            .login-header p {
                color: #666;
                font-size: 16px;
                line-height: 1.6;
            }
            .form-group {
                margin-bottom: 25px;
            }
            .form-group label {
                display: block;
                margin-bottom: 10px;
                color: #333;
                font-weight: 600;
                font-size: 15px;
            }
            .form-control {
                width: 100%;
                padding: 15px;
                border: 2px solid #eee;
                border-radius: 12px;
                font-size: 15px;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }
            .form-control:focus {
                border-color: #4A90E2;
                background: white;
                box-shadow: 0 0 0 4px rgba(74, 144, 226, 0.1);
            }
            .form-control::placeholder {
                color: #aaa;
            }
            .form-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .remember-me {
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
            }
            .remember-me input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }
            .remember-me span {
                color: #555;
                font-size: 14px;
            }
            .forgot-password {
                color: #4A90E2;
                text-decoration: none;
                font-size: 14px;
                font-weight: 600;
                transition: color 0.3s ease;
            }
            .forgot-password:hover {
                color: #357ABD;
                text-decoration: underline;
            }
            .sign-in-btn {
                width: 100%;
                padding: 16px;
                background: #4A90E2;
                color: white;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }
            .sign-in-btn:hover {
                background: #357ABD;
                transform: translateY(-2px);
            }
            .sign-in-btn:active {
                transform: translateY(0);
            }
            .signup-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }
            .signup-link a {
                color: #4A90E2;
                text-decoration: none;
                font-weight: 600;
                margin-left: 5px;
                transition: color 0.3s ease;
            }
            .signup-link a:hover {
                color: #357ABD;
                text-decoration: underline;
            }
            .alert {
                padding: 16px;
                border-radius: 12px;
                margin-bottom: 25px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .alert::before {
                content: '';
                width: 24px;
                height: 24px;
                background-position: center;
                background-repeat: no-repeat;
                background-size: contain;
            }
            .alert-danger {
                background-color: #FEF2F2;
                border: 1px solid #FEE2E2;
                color: #DC2626;
            }
            .alert-danger::before {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23DC2626'%3E%3Cpath d='M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm-1-7v2h2v-2h-2zm0-8v6h2V7h-2z'/%3E%3C/svg%3E");
            }
            .alert-success {
                background-color: #F0FDF4;
                border: 1px solid #DCFCE7;
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
            .login-box {
                animation: fadeIn 0.6s ease-out;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <div class="login-box">
                <div class="login-header">
                    <h2>Welcome Back!</h2>
                    <p>Please sign in to continue</p>
                </div>
                
                <form action="login" method="post">
                    <c:if test="${message != null}">
                        <div class="alert alert-${type}">
                            ${message}
                        </div>
                    </c:if>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                    
                    <div class="form-footer">
                        <label class="remember-me">
                            <input type="checkbox" name="remember">
                            <span>Remember me</span>
                        </label>
                        <a href="#" class="forgot-password">Forgot Password?</a>
                    </div>
                    
                    <button type="submit" class="sign-in-btn">Sign In</button>
                    
                    <div class="signup-link">
                        Don't have an account? <a href="register">Sign up</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>
