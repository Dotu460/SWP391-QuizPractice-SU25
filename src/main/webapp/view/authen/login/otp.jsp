<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>OTP Verification - SkillGro</title>
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
            .otp-inputs {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-bottom: 24px;
            }
            .otp-inputs input {
                width: 50px;
                height: 50px;
                text-align: center;
                font-size: 24px;
                border: 2px solid #E2E8F0;
                border-radius: 12px;
                transition: all 0.3s ease;
            }
            .otp-inputs input:focus {
                border-color: #6B73FF;
                box-shadow: 0 0 0 3px rgba(107, 115, 255, 0.1);
                outline: none;
            }
            .timer {
                text-align: center;
                color: #4A5568;
                font-size: 15px;
                margin-bottom: 16px;
            }
            .resend-button {
                background: none;
                border: none;
                color: #6B73FF;
                font-weight: 600;
                font-size: 15px;
                cursor: pointer;
                transition: color 0.3s ease;
            }
            .resend-button:hover:not(:disabled) {
                color: #000DFF;
            }

            .verify-btn {
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
            .verify-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 7px 14px rgba(0, 13, 255, 0.1);
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
                    <h2>OTP Verification</h2>
                    <p>Enter the verification code we sent to<br>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty email}">
                                    ${email}
                                </c:when>
                                <c:otherwise>
                                    your email
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/verifyOTP" method="post" id="otpForm">
                    <div class="otp-inputs">
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="text" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        <input type="hidden" name="otp" id="otpValue">
                    </div>

                    <c:if test="${error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <div class="timer" id="timer">
                        <i class="fas fa-clock me-2"></i><span id="countdown">01:00</span>
                    </div>

                    <div class="text-center mb-4">
                        <button type="button" class="resend-button" id="resendButton" onclick="resendOTP()">
                            <i class="fas fa-redo me-2"></i>Resend OTP
                        </button>
                    </div>

                    <button type="submit" class="verify-btn">
                        <i class="fas fa-check me-2"></i>Verify OTP
                    </button>

                    <div class="back-link">
                        <a href="${pageContext.request.contextPath}/authen?action=login">
                            <i class="fas fa-arrow-left me-2"></i>Back to login
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const inputs = document.querySelectorAll('.otp-inputs input[type="text"]');
                const form = document.getElementById('otpForm');
                const otpValue = document.getElementById('otpValue');
                const resendButton = document.getElementById('resendButton');

                // Auto-focus first input on page load
                inputs[0].focus();

                // Auto-focus next input
                inputs.forEach((input, index) => {
                    input.addEventListener('input', function() {
                        if (this.value.length === 1) {
                            if (index < inputs.length - 1) {
                                inputs[index + 1].focus();
                            }
                        }
                    });

                    // Handle backspace
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Backspace' && !this.value && index > 0) {
                            inputs[index - 1].focus();
                        }
                    });

                    // Allow only numbers
                    input.addEventListener('keypress', function(e) {
                        if (!/[0-9]/.test(e.key)) {
                            e.preventDefault();
                        }
                    });
                });

                // Handle form submission
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    let otp = '';
                    inputs.forEach(input => {
                        otp += input.value;
                    });
                    otpValue.value = otp;
                    if (otp.length === 6) {
                        this.submit();
                    }
                });

                // Timer functionality
                let timeLeft = 300; // 5 minutes
                const countdownEl = document.getElementById('countdown');
                resendButton.disabled = true;

                const timer = setInterval(() => {
                    timeLeft--;
                    const minutes = Math.floor(timeLeft / 60);
                    const seconds = timeLeft % 60;
                    countdownEl.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

                    if (timeLeft <= 0) {
                        clearInterval(timer);
                        resendButton.disabled = false;
                    }
                }, 1000);
            });

            function resendOTP() {
                const resendButton = document.getElementById('resendButton');
                const form = document.getElementById('otpForm');
                resendButton.disabled = true;

                // Gửi request để resend OTP
                fetch('${pageContext.request.contextPath}/resendOTP', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(result => {
                    if (result === 'success') {
                        // Reset timer
                        let timeLeft = 60; // 1 phút
                        const countdownEl = document.getElementById('countdown');
                        
                        const timer = setInterval(() => {
                            timeLeft--;
                            countdownEl.textContent = `00:${timeLeft.toString().padStart(2, '0')}`;

                            if (timeLeft <= 0) {
                                clearInterval(timer);
                                resendButton.disabled = false;
                            }
                        }, 1000);

                        // Xóa các ô input
                        const inputs = document.querySelectorAll('.otp-inputs input[type="text"]');
                        inputs.forEach(input => input.value = '');
                        inputs[0].focus();

                        // Hiển thị thông báo thành công
                        const successDiv = document.createElement('div');
                        successDiv.className = 'alert alert-success';
                        successDiv.style.backgroundColor = '#F0FDF4';
                        successDiv.style.borderColor = '#86EFAC';
                        successDiv.style.color = '#16A34A';
                        successDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>OTP mới đã được gửi đến email của bạn';
                        form.insertBefore(successDiv, form.firstChild);

                        // Xóa thông báo sau 3 giây
                        setTimeout(() => {
                            successDiv.remove();
                        }, 3000);
                    } else {
                        // Hiển thị thông báo lỗi
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-danger';
                        errorDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi gửi lại OTP';
                        form.insertBefore(errorDiv, form.firstChild);

                        // Xóa thông báo sau 3 giây
                        setTimeout(() => {
                            errorDiv.remove();
                        }, 3000);

                        resendButton.disabled = false;
                    }
                })
                .catch(error => {
                    // Hiển thị thông báo lỗi
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-danger';
                    errorDiv.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi gửi lại OTP';
                    form.insertBefore(errorDiv, form.firstChild);

                    // Xóa thông báo sau 3 giây
                    setTimeout(() => {
                        errorDiv.remove();
                    }, 3000);

                    resendButton.disabled = false;
                });
            }
        </script>
    </body>
</html> 