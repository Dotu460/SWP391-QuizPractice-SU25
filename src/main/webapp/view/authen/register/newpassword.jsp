<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Set New Password - SkillGro</title>
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
                .password-requirements {
                    margin-top: 12px;
                    padding: 16px;
                    background-color: #F8FAFC;
                    border-radius: 12px;
                    font-size: 14px;
                }
                .requirement-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin-bottom: 8px;
                    color: #64748B;
                }
                .requirement-item:last-child {
                    margin-bottom: 0;
                }
                .requirement-item.valid {
                    color: #16A34A;
                }
                .requirement-item.invalid {
                    color: #DC2626;
                }
                .requirement-item i {
                    width: 16px;
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
                        <h2>Set New Password</h2>
                        <p>Create a strong password for your account</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/newpassword" method="post" id="resetForm">
                    <c:if test="${error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="password">New Password</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Enter your new password">
                        <span id="password-error" class="error-text"></span>
                    </div>

                    <div class="form-group">
                        <label for="confirm_password">Confirm Password</label>
                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" 
                               placeholder="Confirm your new password">
                        <span id="confirm-password-error" class="error-text"></span>
                    </div>

                    <button type="submit" class="reset-btn" id="resetBtn" onclick="newPassword() >
                                <i class="fas fa-key me-2"></i>Set Password
                    </button>

                    <div class="back-link">
                    <a href="${pageContext.request.contextPath}/register">
                                    <i class="fas fa-arrow-left me-2"></i>Back to register
                            </a>
                    </div>
                </form>
            </div>
        </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
                                const password = document.getElementById('password');
                                const confirmPassword = document.getElementById('confirm_password');
                                const resetBtn = document.getElementById('resetBtn');
                                const requirements = {
                                length: document.getElementById('length'),
                                        uppercase: document.getElementById('uppercase'),
                                        lowercase: document.getElementById('lowercase'),
                                        number: document.getElementById('number'),
                                        special: document.getElementById('special')
                                };
                                function validatePassword() {
                                const value = password.value;
                                        const checks = {
                                        length: value.length >= 8,
                                                uppercase: /[A-Z]/.test(value),
                                                lowercase: /[a-z]/.test(value),
                                                number: /[0-9]/.test(value),
                                                special: /[!@#$%^&*(),.?":{}|<>]/.test(value)
                                        };
                                        // Update requirement list styles and icons
                                        Object.keys(checks).forEach(check => {
                                if (checks[check]) {
                                requirements[check].classList.remove('invalid');
                                        requirements[check].classList.add('valid');
                                } else {
                                requirements[check].classList.remove('valid');
                                        requirements[check].classList.add('invalid');
                                }
                                });
                                        // Enable/disable submit button
                                        const allValid = Object.values(checks).every(Boolean);
                                        const passwordsMatch = password.value === confirmPassword.value;
                                        const notEmpty = password.value.trim() !== "" && confirmPassword.value.trim() !== "";
                                        resetBtn.disabled = !(allValid && passwordsMatch && confirmPassword.value && notEmpty);
                                }

                        password.addEventListener('input', validatePassword);
                                confirmPassword.addEventListener('input', validatePassword);
                                // Form submission
                                document.getElementById('resetForm').addEventListener('submit', function(e) {
                        // Xoá lỗi cũ (nếu có)
                        const existingError = this.querySelector('.alert.alert-danger');
                                if (existingError) {
                        existingError.remove();
                        }


                        if (password.value.trim() === "" || confirmPassword.value.trim() === "") {
                        e.preventDefault();
                                const errorDiv = document.createElement('div');
                                errorDiv.className = 'alert alert-danger';
                                errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i>Passwords is required.';
                                this.insertBefore(errorDiv, this.firstChild);
                                return;
                        }

                        if (password.value !== confirmPassword.value) {
                        e.preventDefault();
                                const errorDiv = document.createElement('div');
                                errorDiv.className = 'alert alert-danger';
                                errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i>Passwords do not match';
                                this.insertBefore(errorDiv, this.firstChild);
                        }
                        });
                });
            </script>
        </body>
    </html> 