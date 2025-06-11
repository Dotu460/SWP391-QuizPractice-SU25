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
                .google-btn {
                    width: 100%;
                    padding: 14px;
                    border: 2px solid #E2E8F0;
                    border-radius: 12px;
                    background: white;
                    color: #4A5568;
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 12px;
                    cursor: pointer;
                    margin-bottom: 24px;
                    transition: all 0.3s ease;
                }
                .google-btn:hover {
                    background: #F7FAFC;
                    border-color: #CBD5E0;
                    transform: translateY(-1px);
                }
                .google-btn img {
                    width: 24px;
                    height: 24px;
                }
                .divider {
                    text-align: center;
                    position: relative;
                    margin: 24px 0;
                    color: #A0AEC0;
                }
                .divider::before,
                .divider::after {
                    content: "";
                    position: absolute;
                    top: 50%;
                    width: 45%;
                    height: 1px;
                    background: #E2E8F0;
                }
                .divider::before {
                    left: 0;
                }
                .divider::after {
                    right: 0;
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
                .form-footer {
                    display: flex;
                    justify-content: flex-end;
                    margin-bottom: 24px;
                }
                .remember-me {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }
                .remember-me input[type="checkbox"] {
                    width: 18px;
                    height: 18px;
                    border: 2px solid #E2E8F0;
                    border-radius: 4px;
                    cursor: pointer;
                }
                .remember-me span {
                    color: #4A5568;
                    font-size: 15px;
                }
                .forgot-password {
                    color: #6B73FF;
                    text-decoration: none;
                    font-weight: 600;
                    font-size: 15px;
                    transition: color 0.3s ease;
                }
                .forgot-password:hover {
                    color: #000DFF;
                    text-decoration: none;
                }
                .sign-in-btn {
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
                .sign-in-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 7px 14px rgba(0, 13, 255, 0.1);
                }
                .signup-link {
                    text-align: center;
                    color: #4A5568;
                    font-size: 15px;
                }
                .signup-link a {
                    color: #6B73FF;
                    text-decoration: none;
                    font-weight: 600;
                    margin-left: 4px;
                    transition: color 0.3s ease;
                }
                .signup-link a:hover {
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
                .login-box {
                    animation: fadeIn 0.6s ease-out;
                }
            </style>
        </head>

        <body>
            <div class="login-container">
                <div class="login-box">
                    <div class="login-header">
                        <p>Please sign in to continue</p>
                    </div>

                    <form action="login" method="post" onsubmit="return validateForm()">
                    <c:if test="${message != null}">
                        <div class="alert alert-${type}">
                            ${message}
                        </div>
                    </c:if>

                    <div class="form-group">
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" >
                        <span id="email-error" style="color:red;"></span>

                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Enter your password">
                        <span id="password-error" class="error-text"></span>
                    </div>

                    <div class="form-footer">
                        <a href="forgot-password" class="forgot-password">Forgot password?</a>
                    </div>

                    <button type="submit" class="sign-in-btn">Sign in to your account</button>

                    <div class="signup-link">
                        Don't have an account? <a href="register">Sign up</a>
                    </div>
                </form>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // EMAIL realtime
                const emailInput = document.getElementById('email');
                const emailError = document.getElementById('email-error');
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                emailInput.addEventListener("input", function () {
                    const emailValue = emailInput.value.trim();
                    if (emailValue === '') {
                        emailError.textContent = "Email is required.";
                    } else if (!emailRegex.test(emailValue)) {
                        emailError.textContent = "Invalid email format.";
                    } else {
                        emailError.textContent = "";
                    }
                });

                // PASSWORD realtime
                const passwordInput = document.getElementById("password");
                const passwordError = document.getElementById("password-error");

                passwordInput.addEventListener("input", function () {
                    const passwordValue = passwordInput.value.trim();
                    if (passwordValue === "") {
                        passwordError.textContent = "Password is required.";
                    } else {
                        passwordError.textContent = "";
                    }
                });
            });

            function validateForm() {
                let isValid = true;

                // EMAIL validation
                const emailInput = document.getElementById('email');
                const emailError = document.getElementById('email-error');
                const emailValue = emailInput.value.trim();
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                emailError.textContent = "";
                if (emailValue === '') {
                    emailError.textContent = "Email is required.";
                    emailInput.focus();
                    isValid = false;
                } else if (!emailRegex.test(emailValue)) {
                    emailError.textContent = "Invalid email format.";
                    emailInput.focus();
                    isValid = false;
                }

                // PASSWORD validation
                const passwordInput = document.getElementById("password");
                const passwordError = document.getElementById("password-error");
                const passwordValue = passwordInput.value.trim();

                passwordError.textContent = "";
                if (passwordValue === "") {
                    passwordError.textContent = "Password is required.";
                    if (isValid)
                        passwordInput.focus();
                    isValid = false;
                }

                return isValid;
            }
        </script>

        <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>
