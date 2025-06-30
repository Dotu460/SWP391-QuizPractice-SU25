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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .otp-container {
            background: white;
            padding: 48px 40px;
            border-radius: 24px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            width: 100%;
            max-width: 440px;
            text-align: center;
        }
        
        .otp-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
            letter-spacing: -0.025em;
        }
        
        .otp-header p {
            color: #6b7280;
            font-size: 16px;
            line-height: 1.5;
            margin-bottom: 8px;
        }
        
        .email-display {
            color: #374151;
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 40px;
        }
        
        .otp-inputs-container {
            margin-bottom: 32px;
        }
        
        .otp-inputs {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-bottom: 24px;
        }
        
        .otp-input {
            width: 56px;
            height: 56px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            color: #374151;
            background: #f9fafb;
            transition: all 0.2s ease;
            outline: none;
        }
        
        .otp-input:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .otp-input.filled {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .timer-section {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 20px;
            color: #374151;
            font-size: 15px;
        }
        
        .timer-icon {
            color: #6b7280;
        }
        
        .countdown {
            font-weight: 600;
            color: #667eea;
        }
        
        .resend-section {
            margin-bottom: 32px;
        }
        
        .resend-button {
            background: none;
            border: none;
            color: #667eea;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        
        .resend-button:hover:not(:disabled) {
            color: #5a67d8;
            transform: translateY(-1px);
        }
        
        .resend-button:disabled {
            color: #9ca3af;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .verify-button {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
            margin-bottom: 24px;
        }
        
        .verify-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .verify-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .back-link {
            color: #667eea;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }
        
        .back-link:hover {
            color: #5a67d8;
            transform: translateY(-1px);
        }
        
        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .success-message {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #16a34a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .loading-message {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #2563eb;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .fa-spin {
            animation: spin 1s linear infinite;
        }
        
        @media (max-width: 480px) {
            .otp-container {
                padding: 32px 24px;
                margin: 0 16px;
            }
            
            .otp-inputs {
                gap: 8px;
            }
            
            .otp-input {
                width: 48px;
                height: 48px;
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <div class="otp-container">
        <div class="otp-header">
            <h1>OTP Verification</h1>
            <p>Enter the verification code we sent to</p>
            <div class="email-display">
                <c:choose>
                    <c:when test="${not empty email}">
                        ${email}
                    </c:when>
                    <c:otherwise>
                        your email address
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <form id="otpForm" action="${pageContext.request.contextPath}/registerverifyOTP" method="post">
            <div class="otp-inputs-container">
                <div class="otp-inputs">
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                </div>
                <input type="hidden" name="otp" id="otpValue">
                <input type="hidden" name="isRegistration" value="true">
            </div>
            
            <c:if test="${error != null}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <div id="messageContainer"></div>
            
            <div class="timer-section">
                <i class="fas fa-clock timer-icon"></i>
                <span>Time remaining:</span>
                <span class="countdown" id="countdown">01:00</span>
            </div>
            
            <div class="resend-section">
                <button type="button" class="resend-button" id="resendButton" onclick="resendOTP()">
                    <i class="fas fa-redo"></i>
                    Resend OTP
                </button>
            </div>
            
            <button type="submit" class="verify-button" id="verifyButton">
                <i class="fas fa-check"></i>
                Verify OTP
            </button>
            
            <a href="${pageContext.request.contextPath}/register" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Back to register
            </a>
        </form>
    </div>
    
    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.otp-input');
            const form = document.getElementById('otpForm');
            const otpValue = document.getElementById('otpValue');
            const resendButton = document.getElementById('resendButton');
            const verifyButton = document.getElementById('verifyButton');
            const countdownEl = document.getElementById('countdown');
            const messageContainer = document.getElementById('messageContainer');
            
            let timeLeft = 60; // 1 minute
            let timerInterval;
            
            // Auto focus first input
            inputs[0].focus();
            
            // Handle OTP input functionality
            inputs.forEach((input, index) => {
                input.addEventListener('input', function(e) {
                    const value = e.target.value;
                    
                    // Only allow numbers
                    if (!/^[0-9]$/.test(value) && value !== '') {
                        e.target.value = '';
                        return;
                    }
                    
                    // Update visual state
                    if (value) {
                        input.classList.add('filled');
                        // Move to next input
                        if (index < inputs.length - 1) {
                            inputs[index + 1].focus();
                        }
                    } else {
                        input.classList.remove('filled');
                    }
                    
                    updateVerifyButton();
                });
                
                input.addEventListener('keydown', function(e) {
                    // Handle backspace
                    if (e.key === 'Backspace') {
                        if (!this.value && index > 0) {
                            inputs[index - 1].focus();
                            inputs[index - 1].value = '';
                            inputs[index - 1].classList.remove('filled');
                        } else {
                            this.value = '';
                            this.classList.remove('filled');
                        }
                        updateVerifyButton();
                    }
                });
                
                // Handle paste
                input.addEventListener('paste', function(e) {
                    e.preventDefault();
                    const pastedData = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6);
                    
                    if (pastedData.length > 0) {
                        for (let i = 0; i < pastedData.length && i < inputs.length; i++) {
                            inputs[i].value = pastedData[i];
                            inputs[i].classList.add('filled');
                        }
                        
                        // Focus next empty input or last input
                        const nextEmptyIndex = pastedData.length < inputs.length ? pastedData.length : inputs.length - 1;
                        inputs[nextEmptyIndex].focus();
                        
                        updateVerifyButton();
                    }
                });
            });
            
            // Update verify button state
            function updateVerifyButton() {
                const otp = Array.from(inputs).map(input => input.value).join('');
                verifyButton.disabled = otp.length !== 6;
            }
            
            // Handle form submission
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const otp = Array.from(inputs).map(input => input.value).join('');
                
                if (otp.length === 6) {
                    otpValue.value = otp;
                    this.submit();
                }
            });
            
            // Timer functionality
            function startTimer() {
                resendButton.disabled = true;
                timeLeft = 60;
                
                timerInterval = setInterval(() => {
                    timeLeft--;
                    const minutes = Math.floor(timeLeft / 60);
                    const seconds = timeLeft % 60;
                    countdownEl.textContent = minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
                    
                    if (timeLeft <= 0) {
                        clearInterval(timerInterval);
                        resendButton.disabled = false;
                        countdownEl.textContent = '00:00';
                    }
                }, 1000);
            }
            
            // Show message function
            function showMessage(type, text, icon) {
                messageContainer.innerHTML = 
                    '<div class="' + type + '-message">' +
                        '<i class="' + icon + '"></i>' +
                        text +
                    '</div>';
                
                if (type !== 'loading') {
                    setTimeout(() => {
                        messageContainer.innerHTML = '';
                    }, 4000);
                }
            }
            
            // Resend OTP function
            window.resendOTP = function() {
                if (resendButton.disabled) return;
                
                // Clear inputs
                inputs.forEach(input => {
                    input.value = '';
                    input.classList.remove('filled');
                });
                inputs[0].focus();
                updateVerifyButton();
                
                // Show loading message
                showMessage('loading', 'Sending new OTP...', 'fas fa-spinner fa-spin');
                
                // Send request
                fetch(contextPath + '/resendOTP', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'isRegistration=true',
                    credentials: 'same-origin',
                    cache: 'no-cache'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(result => {
                    if (result.trim() === 'success') {
                        showMessage('success', 'New OTP has been sent to your email', 'fas fa-check-circle');
                        startTimer();
                    } else {
                        showMessage('error', 'Failed to resend OTP. Please try again.', 'fas fa-exclamation-circle');
                    }
                })
                .catch(error => {
                    showMessage('error', 'Network error. Please check your connection and try again.', 'fas fa-exclamation-circle');
                });
            };
            
            // Initialize timer on page load
            startTimer();
            updateVerifyButton();
        });
    </script>
</body>
</html>