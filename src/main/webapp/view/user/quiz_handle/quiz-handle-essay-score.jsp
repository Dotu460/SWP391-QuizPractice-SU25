<%-- 
    Document   : quiz-handle-essay-score
    Created on : Jun 30, 2025, 7:18:48 PM
    Author     : kenngoc
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Essay Question Grading</title>
        <meta name="description" content="SkillGro - Essay Question Grading">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        
        <style>
            .grading-container {
                max-width: 1000px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            
            .grading-header {
                background: #5751E1;
                color: white;
                padding: 20px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .grading-header h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
            }
            
            .grading-body {
                padding: 30px;
            }
            
            .question-section, .answer-section, .grading-section {
                margin-bottom: 30px;
                border-bottom: 1px solid #eee;
                padding-bottom: 20px;
            }
            
            .section-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
                display: flex;
                align-items: center;
            }
            
            .section-title i {
                margin-right: 10px;
                color: #5751E1;
            }
            
            .question-content {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 15px;
            }
            
            .answer-content {
                background: #f0f4f8;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 15px;
                border-left: 4px solid #5751E1;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
            }
            
            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 16px;
                transition: border-color 0.3s;
            }
            
            .form-control:focus {
                border-color: #5751E1;
                outline: none;
                box-shadow: 0 0 0 3px rgba(87, 81, 225, 0.1);
            }
            
            .score-input {
                max-width: 100px;
            }
            
            .btn-primary {
                background: #5751E1;
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 6px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
            }
            
            .btn-primary:hover {
                background: #4842c7;
                transform: translateY(-2px);
            }
            
            .btn-secondary {
                background: #f8f9fa;
                color: #333;
                border: 1px solid #ddd;
                padding: 12px 25px;
                border-radius: 6px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                margin-right: 10px;
            }
            
            .btn-secondary:hover {
                background: #e9ecef;
            }
            
            .actions {
                display: flex;
                justify-content: flex-end;
                margin-top: 30px;
            }
            
            .navigation {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                border-top: 1px solid #eee;
                padding-top: 20px;
            }
            
            .student-info {
                margin-bottom: 20px;
                padding: 15px;
                background: #f8f9fa;
                border-radius: 8px;
                display: flex;
                justify-content: space-between;
            }
            
            .student-info div {
                display: flex;
                flex-direction: column;
            }
            
            .student-info span {
                font-weight: 600;
                color: #5751E1;
            }
            
            .grading-progress {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .progress-bar {
                flex: 1;
                height: 8px;
                background: #eee;
                border-radius: 4px;
                overflow: hidden;
                margin: 0 15px;
            }
            
            .progress-fill {
                height: 100%;
                background: #5751E1;
                border-radius: 4px;
            }
            
            .media-container {
                margin: 15px 0;
                max-width: 100%;
            }
            
            .media-container img, .media-container video {
                max-width: 100%;
                border-radius: 8px;
            }
            
            @media (max-width: 768px) {
                .grading-container {
                    margin: 20px;
                }
                
                .grading-header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                
                .grading-header h2 {
                    margin-bottom: 10px;
                }
                
                .actions, .navigation {
                    flex-direction: column;
                }
                
                .btn-secondary, .btn-primary {
                    margin-bottom: 10px;
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../../common/user/header.jsp"></jsp:include>
        
        <div class="grading-container">
            <div class="grading-header">
                <h2>Essay Question Grading</h2>
                <div>
                    <span>Quiz: ${quiz.name}</span> | 
                    <span>Question ${currentNumber}/${fn:length(questions)}</span>
                </div>
            </div>
            
            <div class="grading-body">
                <div class="student-info">
                    <div>
                        <label>Student:</label>
                        <span>${user.full_name}</span>
                    </div>
                    <div>
                        <label>Attempt Date:</label>
                        <span><fmt:formatDate value="${attempt.start_time}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    <div>
                        <label>Status:</label>
                        <span>${attempt.status}</span>
                    </div>
                </div>
                
                <div class="grading-progress">
                    <span>Grading Progress: ${gradedCount}/${totalEssayQuestions}</span>
                </div>
                
                <div class="question-section">
                    <div class="section-title">
                        <i class="fas fa-question-circle"></i> Question
                    </div>
                    <div class="question-content">
                        ${question.content}
                    </div>
                    
                    <c:if test="${not empty question.media_url}">
                        <div class="media-container">
                            <c:choose>
                                <c:when test="${fn:endsWith(question.media_url, '.mp4') || fn:endsWith(question.media_url, '.webm') || fn:endsWith(question.media_url, '.ogg')}">
                                    <video controls>
                                        <source src="${pageContext.request.contextPath}/media/${question.media_url}" type="video/mp4">
                                        Your browser does not support the video tag.
                                    </video>
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/media/${question.media_url}" alt="Question media">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
                
                <div class="answer-section">
                    <div class="section-title">
                        <i class="fas fa-pen-alt"></i> Student's Answer
                    </div>
                    <div class="answer-content">
                        <c:choose>
                            <c:when test="${not empty answer.essay_answer}">
                                <p>${answer.essay_answer}</p>
                            </c:when>
                            <c:otherwise>
                                <p><em>No answer provided.</em></p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/essay-score" method="post">
                    <input type="hidden" name="attemptId" value="${attempt.id}">
                    <input type="hidden" name="questionId" value="${question.id}">
                    <input type="hidden" name="answerId" value="${answer.id}">
                    
                    <div class="grading-section">
                        <div class="section-title">
                            <i class="fas fa-star"></i> Grading
                        </div>
                        
                        <div class="form-group">
                            <label for="score">Score (0-10):</label>
                            <input type="number" id="score" name="score" class="form-control score-input" 
                                   min="0" max="10" step="0.1" value="${answer.essay_score}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="feedback">Feedback:</label>
                            <textarea id="feedback" name="feedback" class="form-control" rows="5">${answer.essay_feedback}</textarea>
                        </div>
                    </div>
                    
                    <div class="actions">
                        <button type="submit" name="action" value="save" class="btn-primary">
                            <i class="fas fa-save"></i> Save Grading
                        </button>
                    </div>
                    
                    <div class="navigation">
                        <div>
                            <c:if test="${currentNumber > 1}">
                                <a href="${pageContext.request.contextPath}/essay-score?attemptId=${attempt.id}&questionNumber=${currentNumber - 1}" class="btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Previous Question
                                </a>
                            </c:if>
                        </div>
                        <div>
                            <c:if test="${currentNumber < fn:length(questions)}">
                                <a href="${pageContext.request.contextPath}/essay-score?attemptId=${attempt.id}&questionNumber=${currentNumber + 1}" class="btn-secondary">
                                    Next Question <i class="fas fa-arrow-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
        
        <script>
            // Validate score input to ensure it's between 0 and 10
            document.getElementById('score').addEventListener('change', function(e) {
                const value = parseFloat(e.target.value);
                if (value < 0) {
                    e.target.value = 0;
                } else if (value > 10) {
                    e.target.value = 10;
                }
            });
        </script>
    </body>
</html>
