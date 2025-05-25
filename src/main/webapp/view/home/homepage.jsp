<%-- 
    Document   : homepage
    Created on : May 25, 2025, 6:15:10 PM
    Author     : LENOVO
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
    </head>

    <body>
        <!-- Scroll-top -->
        <button class="scroll__top scroll-to-target" data-target="html">
            <i class="tg-flaticon-arrowhead-up"></i>
        </button>
        <!-- Scroll-top-end-->

        <!-- header-area -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>
        <!-- header-area-end -->

        <!-- main-area -->
        <main class="main-area">
            <div class="dashboard__content-wrap">
                <!-- Slider Section -->
                <div class="text-center mb-5">
                    <h2 class="slider__title">
                        <span style="color: #666;">Level Up</span><br>
                        <span style="color: #1a237e;">Your English</span><br>
                        <span style="color: #3f51b5;">with Quizzes</span>
                    </h2>
                    <img src="${pageContext.request.contextPath}/view/common/img/slider/teacher.png" alt="English Teacher" class="img-fluid">
                </div>

                <div class="row">
                    <!-- Left Content -->
                    <div class="col-lg-8">
                        <!-- Hot Posts Section -->
                        <div class="section__title mb-4">
                            <h3>HOT POSTS</h3>
                        </div>
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <div class="post__item">
                                    <div class="post__thumb">
                                        <a href="post-details?id=1">
                                            <img src="${pageContext.request.contextPath}/view/common/img/posts/grammar-skills.png" alt="Grammar Skills">
                                        </a>
                                    </div>
                                    <div class="post__content">
                                        <h4 class="post__title">
                                            <a href="post-details?id=1">How to Improve Your Grammar Skills</a>
                                        </h4>
                                        <div class="post__meta">
                                            <span class="date">April 15, 2025</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="post__item">
                                    <div class="post__thumb">
                                        <a href="post-details?id=2">
                                            <img src="${pageContext.request.contextPath}/view/common/img/posts/daily-quizzes.png" alt="Daily Quizzes">
                                        </a>
                                    </div>
                                    <div class="post__content">
                                        <h4 class="post__title">
                                            <a href="post-details?id=2">The Benefits of Daily Quizzes</a>
                                        </h4>
                                        <div class="post__meta">
                                            <span class="date">April 5, 2025</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Featured Subjects Section -->
                        <div class="section__title mb-4">
                            <h3>FEATURED SUBJECTS</h3>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="subject__item">
                                    <div class="subject__thumb">
                                        <a href="subject-details?id=1">
                                            <img src="${pageContext.request.contextPath}/view/common/img/subjects/grammar.png" alt="Grammar">
                                        </a>
                                    </div>
                                    <div class="subject__content">
                                        <h4 class="subject__title">
                                            <a href="subject-details?id=1">Grammar</a>
                                        </h4>
                                        <p class="subject__tagline" style="color: #3f51b5;">"Enhance your grammar knowledge"</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-4">
                                <div class="subject__item">
                                    <div class="subject__thumb">
                                        <a href="subject-details?id=2">
                                            <img src="${pageContext.request.contextPath}/view/common/img/subjects/vocabulary.png" alt="Vocabulary">
                                        </a>
                                    </div>
                                    <div class="subject__content">
                                        <h4 class="subject__title">
                                            <a href="subject-details?id=2">Vocabulary</a>
                                        </h4>
                                        <p class="subject__tagline" style="color: #3f51b5;">"Expand your word power"</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-4">
                                <div class="subject__item">
                                    <div class="subject__thumb">
                                        <a href="subject-details?id=3">
                                            <img src="${pageContext.request.contextPath}/view/common/img/subjects/listening.png" alt="Listening">
                                        </a>
                                    </div>
                                    <div class="subject__content">
                                        <h4 class="subject__title">
                                            <a href="subject-details?id=3">Listening</a>
                                        </h4>
                                        <p class="subject__tagline" style="color: #3f51b5;">"Enhance your listening skills"</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-4">
                                <div class="subject__item">
                                    <div class="subject__thumb">
                                        <a href="subject-details?id=4">
                                            <img src="${pageContext.request.contextPath}/view/common/img/subjects/speaking.png" alt="Speaking">
                                        </a>
                                    </div>
                                    <div class="subject__content">
                                        <h4 class="subject__title">
                                            <a href="subject-details?id=4">Speaking</a>
                                        </h4>
                                        <p class="subject__tagline" style="color: #3f51b5;">"Practice your speaking skills"</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Sidebar -->
                    <div class="col-lg-4">
                        <div class="sidebar__widget">
                            <div class="widget__title">
                                <h4>LATEST POSTS</h4>
                            </div>
                            <div class="latest__posts">
                                <div class="latest__post">
                                    <h5><a href="#">How to Improve Your Grammar Skills</a></h5>
                                    <span class="date">April 16, 2025</span>
                                </div>
                                <div class="latest__post">
                                    <h5><a href="#">The Benefits of Daily Quizzes</a></h5>
                                    <span class="date">April 10, 2025</span>
                                </div>
                                <div class="latest__post">
                                    <h5><a href="#">Common Vocabulary Exam</a></h5>
                                    <span class="date">April 5, 2025</span>
                                </div>
                                <div class="latest__post">
                                    <h5><a href="#">Preparing for English Tests</a></h5>
                                    <span class="date">March 27, 2025</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer Links -->
                <div class="footer__links mt-5">
                    <a href="about" class="btn btn-outline-secondary me-2">About</a>
                    <a href="contact" class="btn btn-outline-secondary">Contact</a>
                    <div class="social__links float-end">
                        <a href="#" class="me-2"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="me-2"><i class="far fa-envelope"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>
        </main>
        <!-- main-area-end -->

        <!-- footer-area -->
        <jsp:include page="../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
    </body>
</html>
