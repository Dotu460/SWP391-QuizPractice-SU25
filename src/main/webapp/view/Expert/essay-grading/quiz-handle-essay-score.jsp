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
            
            /* HTML Media Content Styles */
            .html-media-content {
                max-width: 100%;
                overflow: hidden;
            }
            
            .html-media-content video {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
            }
            
            .html-media-content img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                display: block;
                margin: 10px 0;
            }
            
            .html-media-content p {
                margin: 10px 0;
                line-height: 1.6;
                color: #1A1B3D;
            }
            
            .html-media-content div {
                margin: 10px 0;
            }
            
            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 8px;
            }
            
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
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
                <!-- Hiển thị thông báo thành công nếu có -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>
                
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
                                <c:when test="${fn:contains(question.media_url, '<') && (fn:contains(question.media_url, 'video') || fn:contains(question.media_url, 'img') || fn:contains(question.media_url, '<p>'))}">
                                    <!-- HTML Content - render directly -->
                                    <div class="html-media-content">
                                        ${question.media_url}
                                    </div>
                                </c:when>
                                <c:when test="${fn:contains(question.media_url, 'youtube.com') || fn:contains(question.media_url, 'youtu.be')}">
                                    <!-- YouTube Video Embed -->
                                    <div class="youtube-embed-container" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px;">
                                        <iframe 
                                            style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border-radius: 8px;"
                                            src="${fn:replace(fn:replace(question.media_url, 'watch?v=', 'embed/'), 'youtu.be/', 'youtube.com/embed/')}" 
                                            frameborder="0" 
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                            allowfullscreen>
                                        </iframe>
                                    </div>
                                </c:when>
                                <c:when test="${fn:endsWith(question.media_url, '.mp4') 
                                            || fn:endsWith(question.media_url, '.webm') 
                                            || fn:endsWith(question.media_url, '.ogg')
                                            || fn:endsWith(question.media_url, '.mov')
                                            || fn:endsWith(question.media_url, '.MOV')}">
                                    <video controls playsinline style="max-width:100%; border-radius:8px;">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(question.media_url, 'http://') || fn:startsWith(question.media_url, 'https://')}">
                                                <source src="${question.media_url}" type="video/mp4">
                                            </c:when>
                                            <c:otherwise>
                                                <source src="${pageContext.request.contextPath}/media/${question.media_url}" type="video/mp4">
                                            </c:otherwise>
                                        </c:choose>
                                        <p>Your browser does not support HTML5 video.</p>
                                    </video>
                                    
                                    <div id="videoError" style="display:none; color: red; margin-top: 10px; padding: 10px; background: #fff5f5; border-radius: 4px;"></div>
                                    
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function() {
                                            const video = document.querySelector('video');
                                            const errorDiv = document.getElementById('videoError');
                                            
                                            if (video) {
                                                video.addEventListener('error', function(e) {
                                                    console.error('Video error:', e);
                                                    errorDiv.style.display = 'block';
                                                    errorDiv.innerHTML = `
                                                        <strong>Error loading video:</strong><br>
                                                        Path: ${question.media_url}<br>
                                                        Error: ${video.error ? video.error.message : 'Unknown error'}<br>
                                                        <small>Please check if the URL is correct and accessible.</small>
                                                    `;
                                                });
                                            }
                                        });
                                    </script>
                                </c:when>
                                <c:otherwise>
                                    <!-- Image with error handling -->
                                    <c:choose>
                                        <c:when test="${fn:startsWith(question.media_url, 'http://') || fn:startsWith(question.media_url, 'https://')}">
                                            <img src="${question.media_url}" 
                                                 alt="Question Media" 
                                                 class="img-fluid" 
                                                 style="max-width:100%; border-radius:8px;"
                                                 onerror="this.onerror=null; this.style.display='none'; document.getElementById('imageError').style.display='block';">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/media/${question.media_url}" 
                                                 alt="Question Media" 
                                                 class="img-fluid" 
                                                 style="max-width:100%; border-radius:8px;"
                                                 onerror="this.onerror=null; this.style.display='none'; document.getElementById('imageError').style.display='block';">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div id="imageError" style="display:none; color: red; margin-top: 10px; padding: 10px; background: #fff5f5; border-radius: 4px;">
                                        <strong>Error loading image:</strong><br>
                                        Path: ${question.media_url}<br>
                                        <small>Please check if the URL is correct and accessible.</small>
                                    </div>
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
                    <input type="hidden" name="questionNumber" value="${currentNumber}">
                    
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
                        <a href="${pageContext.request.contextPath}/expert/essay-grading" class="btn-secondary" style="margin-left: 10px;">
                            <i class="fas fa-list"></i> Back to List
                        </a>
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
            
            // Khắc phục lỗi select2
            $(document).ready(function() {
                // Kiểm tra xem select2 có tồn tại không trước khi gọi
                if ($.fn.select2 !== undefined) {
                    $('.select2').select2();
                }
                
                // Fix relative paths in HTML media content
                const htmlMediaContent = document.querySelector('.html-media-content');
                if (htmlMediaContent) {
                    // Fix video sources
                    const videos = htmlMediaContent.querySelectorAll('video source');
                    videos.forEach(source => {
                        const src = source.getAttribute('src');
                        if (src && src.startsWith('/SWP391_QUIZ_PRACTICE_SU25/uploads/')) {
                            source.setAttribute('src', '${pageContext.request.contextPath}' + src);
                        } else if (src && src.startsWith('../uploads/')) {
                            source.setAttribute('src', '${pageContext.request.contextPath}/' + src.substring(3));
                        }
                    });
                    
                    // Fix image sources
                    const images = htmlMediaContent.querySelectorAll('img');
                    images.forEach(img => {
                        const src = img.getAttribute('src');
                        if (src && src.startsWith('/SWP391_QUIZ_PRACTICE_SU25/uploads/')) {
                            img.setAttribute('src', '${pageContext.request.contextPath}' + src);
                        } else if (src && src.startsWith('../uploads/')) {
                            img.setAttribute('src', '${pageContext.request.contextPath}/' + src.substring(3));
                        }
                    });
                }
            });
        </script>
    </body>
</html>
