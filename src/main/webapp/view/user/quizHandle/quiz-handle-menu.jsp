<%-- 
    Document   : quiz-handle-menu
    Created on : 14 thg 6, 2025, 00:44:45
    Author     : kenngoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quiz List</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <!-- Swiper CSS -->
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
        <style>
            .container {
                max-width: 100% !important;
                padding: 0;
            }
            .quiz-card {
                transition: transform 0.2s;
                cursor: pointer;
                width: 100%;
            }
            .quiz-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .row {
                margin: 0;
                width: 100%;
            }
            .col {
                padding: 10px;
                width: 100%;
            }
            .card {
                width: 100%;
                margin: 0;
            }
            .card-body {
                padding: 20px;
            }
            .quiz-level {
                position: absolute;
                top: 10px;
                right: 10px;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: bold;
            }
            .level-easy {
                background-color: #28a745;
                color: white;
            }
            .level-medium {
                background-color: #ffc107;
                color: black;
            }
            .level-hard {
                background-color: #dc3545;
                color: white;
            }
            .quiz-info {
                font-size: 0.9rem;
                color: #6c757d;
            }
            .quiz-title {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .quiz-score {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 10px;
                margin-top: 15px;
                text-align: center;
            }
            .score-value {
                font-size: 1.5rem;
                font-weight: bold;
                color: #007bff;
            }
            .score-label {
                font-size: 0.9rem;
                color: #6c757d;
                margin-bottom: 5px;
            }
            .no-score {
                color: #6c757d;
                font-style: italic;
            }
            .card h-100 quiz-card{
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <!-- Quiz List -->
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <c:forEach items="${quizzesList}" var="quiz">
                    <div class="col">
                        <div class="card h-100 quiz-card">
                            <div class="card-body">
                                <span class="quiz-level level-${quiz.level.toLowerCase()}">${quiz.level}</span>
                                <h5 class="quiz-title">${quiz.name}</h5>
                                <div class="quiz-info">
                                    <!--<p><i class="fas fa-clock"></i> Duration: ${quiz.duration_minutes} minutes</p>-->
                                    <p><i class="fas fa-question-circle"></i> Questions: ${quiz.number_of_questions_target}</p>
                                    <p><i class="fas fa-book"></i> Lesson: ${quiz.lesson_id}</p>
                                </div>
                                <div class="quiz-score">
                                    <div class="score-label">Your Score</div>
                                    <c:choose>
                                        <c:when test="${not empty quizScores[quiz.id]}">
                                            <div class="score-value">${quizScores[quiz.id]}%</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-score">Not attempted yet</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <button class="btn btn-primary w-100 mt-3" onclick="startQuiz(${quiz.id})">Start Quiz</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <!-- Swiper JS -->
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <script>
            function startQuiz(quizId) {
                console.log("Starting quiz with ID:", quizId);
                window.location.href = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId;
            }
            
            // Initialize Select2 if needed
            $(document).ready(function() {
                if($.fn.select2) {
                    $('.select2').select2();
                }
            });
        </script>
    </body>
</html>
