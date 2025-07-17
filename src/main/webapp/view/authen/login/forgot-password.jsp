<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Forgot Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
            <style>
                .forgot-container {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                    padding: 20px;
                }
                .forgot-box {
                    background: rgba(255, 255, 255, 0.95);
                    padding: 40px;
                    border-radius: 20px;
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                    width: 100%;
                    max-width: 450px;
                    backdrop-filter: blur(10px);
                }
                .forgot-header {
                    text-align: center;
                    margin-bottom: 35px;
                }
                .forgot-header h2 {
                    font-size: 32px;
                    font-weight: 700;
                    color: #2D3748;
                    margin-bottom: 15px;
                    letter-spacing: -0.5px;
                }
                .forgot-header p {
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
                .continue-btn {
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
                .continue-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 7px 14px rgba(0, 13, 255, 0.1);
                }
                .login-link {
                    text-align: center;
                    color: #4A5568;
                    font-size: 15px;
                }
                .login-link a {
                    color: #6B73FF;
                    text-decoration: none;
                    font-weight: 600;
                    margin-left: 4px;
                    transition: color 0.3s ease;
                }
                .login-link a:hover {
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
                .alert-success {
                    background-color: #F0FDF4;
                    border: 1px solid #86EFAC;
                    color: #16A34A;
                }
            </style>
        </head>

        <body>
            <div class="forgot-container">
                <div class="forgot-box">
                    <div class="forgot-header">
                        <h2>Forgot Password</h2>
                        <p>Enter your email to receive a verification code</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post" onsubmit="return validateForm()">
                    <c:if test="${error != null}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="Enter your email">
                        <span id="email-error" style="color:red;"></span>
                    </div>

                    <button type="submit" class="continue-btn">Continue</button>

                    <div class="login-link">
                        Remember your password? <a href="${pageContext.request.contextPath}/login">Sign in</a>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function validateForm() {
                const emailInput = document.getElementById('email');
                const errorSpan = document.getElementById('email-error');
                const emailValue = emailInput.value.trim();

                // Regex kiểm tra định dạng email
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                // Reset lỗi
                errorSpan.textContent = "";

                if (emailValue === '') {
                    errorSpan.textContent = "Email is required.";
                    emailInput.focus();
                    return false;
                }

                if (!emailRegex.test(emailValue)) {
                    errorSpan.textContent = "Invalid email format.";
                    emailInput.focus();
                    return false;
                }

                return true;
            }

            // Kiểm tra realtime khi nhập
            document.addEventListener("DOMContentLoaded", function () {
                const emailInput = document.getElementById('email');
                const errorSpan = document.getElementById('email-error');
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                emailInput.addEventListener("input", function () {
                    const emailValue = emailInput.value.trim();

                    if (emailValue === '') {
                        errorSpan.textContent = "Email is required.";
                    } else if (!emailRegex.test(emailValue)) {
                        errorSpan.textContent = "Invalid email format.";
                    } else {
                        errorSpan.textContent = "";
                    }
                });
            });
        </script>
    </body>
</html> 