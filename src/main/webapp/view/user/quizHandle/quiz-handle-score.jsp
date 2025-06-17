<%-- 
    Document   : quiz-handle-score
    Created on : 6 thg 6, 2025, 16:15:30
    Author     : kenngoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quiz Result</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .score-container {
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                text-align: center;
                max-width: 600px;
                width: 90%;
            }
            
            .score-circle {
                width: 200px;
                height: 200px;
                border-radius: 50%;
                background: #f8f7ff;
                border: 10px solid #5751E1;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                position: relative;
            }
            
            #finalScore {
                font-size: 64px;
                font-weight: bold;
                color: #5751E1;
            }
            
            .score-label {
                font-size: 32px;
                color: #666;
                margin-left: 8px;
            }
            
            .score-message {
                font-size: 24px;
                color: #1A1B3D;
                margin: 30px 0;
                padding: 20px;
                border-radius: 12px;
            }
            
            .btn-container {
                display: flex;
                gap: 20px;
                justify-content: center;
                margin-top: 40px;
            }
            
            .btn-action {
                padding: 15px 30px;
                border-radius: 12px;
                font-weight: 500;
                font-size: 18px;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
            }
            
            .btn-review {
                background: #5751E1;
                color: white;
                border: none;
            }
            
            .btn-review:hover {
                background: #7A6DC0;
                color: white;
            }
            
            .btn-dashboard {
                background: white;
                color: #5751E1;
                border: 2px solid #5751E1;
            }
            
            .btn-dashboard:hover {
                background: #f8f7ff;
                color: #5751E1;
            }
            
            @media (max-width: 576px) {
                .score-container {
                    padding: 20px;
                }
                
                .score-circle {
                    width: 150px;
                    height: 150px;
                    border-width: 8px;
                }
                
                #finalScore {
                    font-size: 48px;
                }
                
                .score-label {
                    font-size: 24px;
                }
                
                .score-message {
                    font-size: 20px;
                    padding: 15px;
                }
                
                .btn-container {
                    flex-direction: column;
                }
                
                .btn-action {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="score-container">
            <div class="score-circle">
                <span id="finalScore">0</span>
                <span class="score-label">/10</span>
            </div>
            <div id="scoreMessage" class="score-message"></div>
            <div class="btn-container">
                <button class="btn-action btn-review" onclick="reviewAnswers()">
                    <i class="fas fa-search"></i>
                    Review Answers
                </button>
                <button class="btn-action btn-dashboard" onclick="returnToDashboard()">
                    <i class="fas fa-home"></i>
                    Return to Dashboard
                </button>
            </div>
        </div>

        <script>
            // Lấy điểm số từ sessionStorage
            const score = parseFloat(sessionStorage.getItem('quizScore') || '0');
            
            // Hiển thị điểm số
            document.getElementById('finalScore').textContent = score.toFixed(1);
            
            // Cập nhật thông điệp dựa trên điểm số
            const scoreMessage = document.getElementById('scoreMessage');
            if (score >= 8) {
                scoreMessage.textContent = "Xuất sắc! Thành tích tuyệt vời!";
                scoreMessage.style.backgroundColor = "#e6f7e6";
                scoreMessage.style.color = "#28a745";
            } else if (score >= 6.5) {
                scoreMessage.textContent = "Tốt! Bạn đã làm rất tốt!";
                scoreMessage.style.backgroundColor = "#fff3cd";
                scoreMessage.style.color = "#856404";
            } else if (score >= 5) {
                scoreMessage.textContent = "Đạt! Hãy tiếp tục luyện tập để cải thiện!";
                scoreMessage.style.backgroundColor = "#fff3cd";
                scoreMessage.style.color = "#856404";
            } else {
                scoreMessage.textContent = "Cố gắng lên! Bạn có thể làm tốt hơn!";
                scoreMessage.style.backgroundColor = "#f8d7da";
                scoreMessage.style.color = "#dc3545";
            }
            
            // Hàm xem lại câu trả lời
            function reviewAnswers() {
                window.location.href = '${pageContext.request.contextPath}/quiz-review';
            }
            
            // Hàm quay về dashboard
            function returnToDashboard() {
                // Xóa điểm số khỏi sessionStorage
                sessionStorage.removeItem('quizScore');
                window.location.href = '${pageContext.request.contextPath}/quiz-handle-menu';
            }
        </script>
    </body>
</html>
