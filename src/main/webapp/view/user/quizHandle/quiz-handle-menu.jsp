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
        .header-top-wrap{background:#1A1B3D;padding:8px 0;color:#fff;position:relative}.header-logo{position:relative;z-index:2;display:flex;align-items:center}.header-logo a{display:block;width:auto;height:100%}.header-logo img{max-height:50px;width:auto;height:auto;display:block;object-fit:contain;filter:brightness(0) invert(1)}.header-top{display:flex;align-items:center;justify-content:space-between;min-height:60px}.header-right{display:flex;align-items:center;gap:15px}.user-menu,.settings-menu{position:relative}.user-icon,.settings-icon{width:40px;height:40px;border-radius:50%;background:#5751E1;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all .3s ease}.user-icon i,.settings-icon i{color:#fff;font-size:18px}.user-icon:hover,.settings-icon:hover{background:#7A6DC0;transform:translateY(-1px)}.dropdown-menu,.settings-dropdown{position:absolute;top:120%;right:0;width:280px;background:#fff;border-radius:8px;box-shadow:0 5px 15px rgba(0,0,0,.15);opacity:0;visibility:hidden;transform:translateY(10px);transition:all .3s ease;z-index:1000}.settings-dropdown{width:200px}.dropdown-menu.show,.settings-dropdown.show{opacity:1;visibility:visible;transform:translateY(0)}.dropdown-header{padding:16px;border-bottom:1px solid #eee}.user-info{display:flex;align-items:center;gap:12px}.user-avatar{width:40px;height:40px;border-radius:50%;overflow:hidden}.user-avatar img{width:100%;height:100%;object-fit:cover}.user-details{display:flex;flex-direction:column}.user-name{font-weight:600;color:#1A1B3D;font-size:14px}.user-email{color:#666;font-size:12px}.dropdown-body{padding:8px 0}.dropdown-item{display:flex;align-items:center;padding:10px 16px;color:#1A1B3D;text-decoration:none;transition:background-color .3s ease}.dropdown-item:hover{background-color:#f8f9fa}.dropdown-item i{width:20px;margin-right:12px;font-size:16px}.dropdown-item span{font-size:14px}.text-danger{color:#dc3545!important}.dropdown-divider{height:1px;background-color:#eee;margin:8px 0}
    </style>
</head>

<body>
    <!-- Scroll-top -->
    <button class="scroll__top scroll-to-target" data-target="html">
        <i class="tg-flaticon-arrowhead-up"></i>
    </button>
    <!-- Scroll-top-end-->

    <!-- header-area -->
    <header>
        <div class="header-top-wrap">
            <div class="container">
                <div class="header-top">
                    <div class="logo header-logo">
                        <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                    </div>
                    <div class="header-right">
                        <div class="settings-menu">
                            <div class="settings-icon" onclick="toggleSettingsDropdown()">
                                <i class="fas fa-cog"></i>
                            </div>
                            <div class="settings-dropdown">
                                <!-- No specific settings for menu page -->
                            </div>
                        </div>
                        <div class="user-menu">
                            <div class="user-icon" onclick="toggleDropdown()">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="dropdown-menu">
                                <div class="dropdown-header">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account}">
                                            <div class="user-info">
                                                <div class="user-avatar">
                                                    <img src="${pageContext.request.contextPath}/media/user-avatar.png" alt="User Avatar">
                                                </div>
                                                <div class="user-details">
                                                    <span class="user-name">${sessionScope.account.full_name}</span>
                                                    <span class="user-email">${sessionScope.account.email}</span>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="guest-info">
                                                <span>Welcome, Guest!</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="dropdown-body">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account}">
                                            <a href="${pageContext.request.contextPath}/my-profile" class="dropdown-item">
                                                <i class="fas fa-user-circle"></i>
                                                <span>My Profile</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/my-courses" class="dropdown-item">
                                                <i class="fas fa-graduation-cap"></i>
                                                <span>My Courses</span>
                                            </a>
                                            <div class="dropdown-divider"></div>
                                            <a href="${pageContext.request.contextPath}/login?action=logout" class="dropdown-item text-danger">
                                                <i class="fas fa-sign-out-alt"></i>
                                                <span>Log out</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login" class="dropdown-item">
                                                <i class="fas fa-sign-in-alt"></i>
                                                <span>Log in</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/register" class="dropdown-item">
                                                <i class="fas fa-user-plus"></i>
                                                <span>Register</span>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="header-fixed-height"></div>
    </header>
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
                                                                                                                    <div class="mt-3">
                                                        <c:choose>
                                                            <c:when test="${not empty quizScores[quiz.id]}">
                                                                <div class="d-flex gap-2">
                                                                    <button class="btn btn-primary flex-grow-1" onclick="startQuiz('${quiz.id}', true)">Retake Quiz</button>
                                                                    <button class="btn btn-secondary flex-grow-1" onclick="reviewQuiz('${quiz.id}')">Review Quiz</button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn btn-primary w-100" onclick="startQuiz('${quiz.id}', false)">Start Quiz</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
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
        function startQuiz(quizId, isRetake) {
            console.log("Starting quiz with ID:", quizId, isRetake ? "(retake)" : "");
            if (isRetake) {
                // Clear all browser session storage for the quiz
                sessionStorage.removeItem('answeredQuestions');
                sessionStorage.removeItem('markedQuestions');
                sessionStorage.removeItem('selectedAnswers');
                
                window.location.href = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId + '&retake=true';
            } else {
                window.location.href = '${pageContext.request.contextPath}/quiz-handle?id=' + quizId;
            }
        }

        function reviewQuiz(quizId) {
            console.log("Reviewing quiz with ID:", quizId);
            window.location.href = '${pageContext.request.contextPath}/quiz-review?quizId=' + quizId;
        }
        
        $(document).ready(function() {
            if($.fn.select2) {
                $('.select2').select2();
            }
        });
        
        function toggleDropdown() {
            const dropdown = document.querySelector('.user-menu .dropdown-menu');
            dropdown.classList.toggle('show');
        }

        function toggleSettingsDropdown() {
            const dropdown = document.querySelector('.settings-menu .settings-dropdown');
            dropdown.classList.toggle('show');
        }

        document.addEventListener('click', function(event) {
            if (!event.target.closest('.user-menu')) {
                document.querySelector('.user-menu .dropdown-menu').classList.remove('show');
            }
            if (!event.target.closest('.settings-menu')) {
                document.querySelector('.settings-menu .settings-dropdown').classList.remove('show');
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
