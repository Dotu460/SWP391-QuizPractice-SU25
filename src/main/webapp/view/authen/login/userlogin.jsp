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
        <title>Login - SkillGro</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .login-popup {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
                z-index: 1000;
            }
            .login-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
            }
            .close-btn {
                position: absolute;
                top: 10px;
                right: 10px;
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .form-control {
                border-radius: 5px;
                padding: 10px;
                border: 1px solid #ddd;
            }
            .btn-login {
                width: 100%;
                padding: 12px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                margin-top: 10px;
                cursor: pointer;
            }
            .btn-login:hover {
                background: #0056b3;
            }
            .login-options {
                text-align: center;
                margin-top: 20px;
            }
            .login-options a {
                color: #007bff;
                text-decoration: none;
                margin: 0 10px;
            }
            .login-options a:hover {
                text-decoration: underline;
            }
            .alert {
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
            }
            .alert-danger {
                background-color: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }
            .alert-success {
                background-color: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }
        </style>
    </head>

    <body>
        <div class="login-overlay"></div>
        <div class="login-popup">
            <button class="close-btn" onclick="window.history.back()">&times;</button>
            <div class="text-center mb-4">
                <h4>Login to Your Account</h4>
                <p>Welcome back! Please enter your details</p>
            </div>
            
            <form action="login" method="post" id="loginForm">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ${success}
                    </div>
                </c:if>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required 
                           placeholder="Enter your email">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required 
                           placeholder="Enter your password">
                </div>
                
                <div class="form-group d-flex justify-content-between align-items-center">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember">
                        <label class="form-check-label" for="remember">Remember me</label>
                    </div>
                </div>
                
                <button type="submit" class="btn-login">Login</button>
            </form>
            
            <div class="login-options">
                <a href="register">Register New Account</a>
                <span>|</span>
                <a href="forgot-password">Forgot Password?</a>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
    </body>
</html>
