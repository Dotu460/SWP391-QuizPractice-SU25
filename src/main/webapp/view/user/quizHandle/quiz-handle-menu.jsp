<%-- 
    Document   : quiz-handle-menu
    Created on : 14 thg 6, 2025, 00:44:45
    Author     : kenngoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quiz Menu</title>
    <meta name="description" content="SkillGro - Quiz Menu">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    <style>
        .quiz-card {
            transition: transform 0.2s;
            cursor: pointer;
            width: 100%;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
        }
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
    </style>
</head>

<body>
    <!-- Scroll-top -->
    <button class="scroll__top scroll-to-target" data-target="html">
        <i class="tg-flaticon-arrowhead-up"></i>
    </button>
    <!-- Scroll-top-end-->

    <!-- header-area -->
    <jsp:include page="../../common/user/header.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->  
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>

                        <div class="col-xl-9">
                            <div class="dashboard__content-area">
                                <div class="dashboard__content-title mb-4">
                                    <h4 class="title">Available Quizzes</h4>
                                </div>
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
                                                    <button class="btn btn-primary w-100 mt-3" onclick="startQuiz('${quiz.id}')">Start Quiz</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <!-- main-area-end -->  
            
    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    <script>
        function startQuiz(quizId) {
            console.log("Starting quiz with ID:", quizId);
            window.location.href = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId;
        }
        
        // Initialize Select2 if needed (might not be required anymore)
        $(document).ready(function() {
            if($.fn.select2) {
                $('.select2').select2();
            }
        });
    </script>
    
    <script>
        //hiển thị điểm vừa đạt
        document.addEventListener('DOMContentLoaded', function() {
            const score = sessionStorage.getItem('quizScore');
            if (score) {
                // Using iziToast for consistency
                iziToast.success({
                    title: 'Quiz Completed!',
                    message: 'Your score: ' + score,
                    position: 'topRight',
                    timeout: 7000
                });
                sessionStorage.removeItem('quizScore');
            }
        });
    </script>
</body>

</html>
