<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Reset Password</title>
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
                .form-control.is-invalid {
                    border-color: #dc3545;
                    background-color: #fff5f5;
                    box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                }

                .form-control.is-invalid:focus {
                    border-color: #dc3545;
                    box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
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

                /* Override tất cả CSS khác với độ ưu tiên cao nhất */
                .alert {
                    padding: 16px;
                    border-radius: 12px;
                    margin-bottom: 24px;
                    font-size: 15px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    opacity: 1;
                    transition: opacity 0.5s ease;
                    color: #721c24 !important;
                    --bs-alert-color: #721c24 !important;
                }

                .alert.alert-danger,
                .alert.alert-danger *,
                .alert.alert-danger span,
                .alert.alert-danger i {
                    color: #721c24 !important;
                    --bs-alert-color: #721c24 !important;
                }

                .alert.alert-danger {
                    background-color: #f8d7da !important;
                    border: 1px solid #f5c6cb !important;
                    --bs-alert-bg: #f8d7da !important;
                    --bs-alert-border-color: #f5c6cb !important;
                }
               
                /* Thêm vào phần CSS, trước #unified-error-container */

                #password-match-error {
                    display: none;
                    align-items: center;
                    padding: 16px;
                    border-radius: 12px;
                    margin-bottom: 24px;
                    font-size: 15px;
                    background-color: #FEF2F2 !important; /* Thêm !important */
                    border: 1px solid #FCA5A5 !important; /* Thêm !important */
                    color: #DC2626 !important; /* Thêm !important */
                }

                #password-match-error i {
                    margin-right: 12px;
                    color: #DC2626 !important; /* Thêm !important */
                }

                #password-match-error span {
                    color: #DC2626 !important; /* Thêm !important */
                }
                /* Gộp 3 khai báo input:invalid */
                input:invalid {
                    box-shadow: none !important;
                    -moz-box-shadow: none !important;
                    -ms-box-shadow: none !important;
                }

                input:invalid:focus {
                    box-shadow: none !important;
                }

                /* Ẩn validation bubble của browser */
                input::-webkit-validation-bubble-message {
                    display: none;
                }

                input::-webkit-validation-bubble-arrow {
                    display: none;
                }

                /* Ẩn tất cả validation messages */
                input:invalid::before,
                input:invalid::after {
                    display: none !important;
                }



                #unified-error-container {
                    margin-bottom: 20px;
                    width: 100%;
                }
            </style>
        </head>
        <body>
            <div class="login-container">
                <div class="login-box">
                    <div class="login-header">
                        <h2>Reset Password</h2>
                        <p>Please enter your new password</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm" novalidate>
                    <!-- Sửa HTML -->
                    <div id="unified-error-container">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger" style="color: #721c24 !important;">
                                <i class="fas fa-exclamation-circle" style="color: #721c24 !important;"></i>
                                <span style="color: #721c24 !important;"><c:out value="${error}"/></span>
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="password">New Password</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Enter your new password">
                    </div>

                    <div class="form-group">
                        <label for="confirm_password">Confirm Password</label>
                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" 
                               placeholder="Confirm your new password">
                    </div>
                    <div id="password-match-error" class="alert alert-danger" style="display: none;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Passwords do not match!</span>
                    </div>

                    <button type="submit" class="reset-btn" id="resetBtn" >
                        <i class="fas fa-key me-2"></i>Reset Password
                    </button>

                    <div class="back-link">
                        <a href="${pageContext.request.contextPath}/login">
                            <i class="fas fa-arrow-left me-2"></i>Back to login
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirm_password');
                const resetBtn = document.getElementById('resetBtn');
                const resetForm = document.getElementById('resetForm');
                const errorContainer = document.getElementById('unified-error-container');
                const passwordMatchError = document.getElementById('password-match-error');

                function showError(message) {
                    console.log('Showing error:', message); // Debug log
                    errorContainer.innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${message}</span>
                        </div>`;
                    }
                    // Force set color bằng JavaScript
                    const errorDiv = errorContainer.querySelector('.alert');
                    if (errorDiv) {
                        errorDiv.style.setProperty('color', '#721c24', 'important');
                        errorDiv.style.setProperty('--bs-alert-color', '#721c24', 'important');

                        const span = errorDiv.querySelector('span');
                        if (span) {
                            span.style.setProperty('color', '#721c24', 'important');
                        }

                        const icon = errorDiv.querySelector('i');
                        if (icon) {
                            icon.style.setProperty('color', '#721c24', 'important');
                        }
                    }

                    setTimeout(() => {
                        errorDiv.style.opacity = '0';
                        setTimeout(() => {
                            errorContainer.innerHTML = '';
                        }, 500);
                    }, 3000);
                }

function checkPasswordMatch() {
    console.log('checkPasswordMatch called'); // Debug log
    console.log('password length:', password.value.length); // Debug log
    console.log('confirmPassword length:', confirmPassword.value.length); // Debug log
    console.log('passwordMatchError element:', passwordMatchError); // Debug log

    // Chỉ check và hiển thị khi confirm password đã được nhập (từ ký tự đầu tiên)
    if (confirmPassword.value.length > 0) {
        if (password.value !== confirmPassword.value) {
            console.log('Passwords do not match, showing error'); // Debug log
            passwordMatchError.style.setProperty('display', 'flex', 'important'); // Force display
            resetBtn.disabled = true;
        } else {
            console.log('Passwords match, hiding error'); // Debug log
            passwordMatchError.style.setProperty('display', 'none', 'important'); // Force hide
            resetBtn.disabled = false;
        }
    } else {
        // Nếu confirm password chưa được nhập thì ẩn thông báo
        console.log('Confirm password empty, hiding error'); // Debug log
        passwordMatchError.style.setProperty('display', 'none', 'important'); // Force hide
        resetBtn.disabled = false;
    }
}

                // Thêm event listeners cho password match
                password.addEventListener('input', checkPasswordMatch);
                confirmPassword.addEventListener('input', checkPasswordMatch);

                resetForm.addEventListener('submit', async function (e) {
                    e.preventDefault();

                    console.log('Form submitted'); // Debug log
                    console.log('Password:', password.value); // Debug log
                    console.log('Confirm password:', confirmPassword.value); // Debug log

                    // Clear previous errors
                    errorContainer.innerHTML = '';
                    passwordMatchError.style.display = 'none';

                    // Remove any invalid classes
                    password.classList.remove('is-invalid');
                    confirmPassword.classList.remove('is-invalid');

                    // Check if fields are empty
                    if (password.value.trim() === "") {
                        console.log('Password is empty, showing error'); // Debug log
                        showError('New password is required.');
                        password.classList.add('is-invalid');
                        return false;
                    }

                    if (confirmPassword.value.trim() === "") {
                        console.log('Confirm password is empty, showing error'); // Debug log
                        showError('Confirm password is required.');
                        confirmPassword.classList.add('is-invalid');
                        return false;
                    }

                    // Check if passwords match
                    if (password.value !== confirmPassword.value) {
                        console.log('Passwords do not match, showing error'); // Debug log
                        showError('Passwords do not match.');
                        confirmPassword.classList.add('is-invalid');
                        return false;
                    }

                    console.log('All validations passed, submitting form'); // Debug log

                    // If all validations pass, proceed with form submission
                    try {
                        const response = await fetch(this.action, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: new URLSearchParams({
                                'password': password.value,
                                'confirm_password': confirmPassword.value
                            })
                        });

                        const data = await response.text();
                        console.log('Server response:', data); // Debug log

                        if (data.includes('success')) {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        } else {
                            showError(data || 'Failed to reset password. Please try again.');
                        }
                    } catch (error) {
                        console.error('Error:', error);
                        showError('An error occurred. Please try again.');
                    }
                });

                const serverErrorData = document.getElementById('server-error-data');
                if (serverErrorData && serverErrorData.textContent.trim()) {
                    showError(serverErrorData.textContent.trim());
                }

            });
        </script>
    </body>
</html> 