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
        <title>EngQuiz - Online English Learning Platform</title>
        <meta name="description" content="EngQuiz - Online English Learning Platform">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .slider-section {
                padding: 60px 0;
                background: #f8f9fa;
            }
            .hero-section {
                padding: 60px 0;
                background: #f8f9fa;
                position: relative;
                overflow: hidden;
            }
            .hero-content {
                padding: 50px 0;
                position: relative;
                z-index: 2;
            }
            .hero-title {
                font-size: 48px;
                font-weight: 700;
                color: #2D3748;
                margin-bottom: 20px;
                line-height: 1.2;
            }
            .hero-subtitle {
                font-size: 32px;
                color: #4A5568;
                margin-bottom: 30px;
            }
            .hero-image-wrapper {
                position: relative;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .hero-image {
                max-width: 100%;
                height: auto;
                position: relative;
                z-index: 2;
            }
            .hero-shape {
                position: absolute;
                z-index: 1;
            }
            .hero-shape-1 {
                top: 0;
                right: 0;
            }
            .hero-shape-2 {
                bottom: 0;
                left: 0;
            }
            .hot-posts {
                padding: 60px 0;
            }
            .section-title {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 40px;
                color: #2D3748;
            }
            .post-card {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                text-decoration: none;
                display: block;
                height: 100%;
            }
            .post-card:hover {
                transform: translateY(-5px);
            }
            .post-thumbnail {
                width: 100%;
                height: 300px;
                object-fit: cover;
                object-position: center;
            }
            .post-content {
                padding: 20px;
                background: white;
                height: 120px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .post-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
                color: #2D3748;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                line-height: 1.5;
            }
            .post-date {
                color: #718096;
                font-size: 14px;
                margin-top: auto;
            }
            .featured-subjects {
                padding: 60px 0;
                background: #f8f9fa;
            }
            .subject-card {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                text-decoration: none;
                display: block;
                margin-bottom: 30px;
            }
            .subject-card:hover {
                transform: translateY(-5px);
            }
            .subject-thumbnail {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }
            .subject-content {
                padding: 20px;
            }
            .subject-title {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 10px;
                color: #2D3748;
            }
            .subject-tagline {
                color: #4A90E2;
                font-size: 14px;
                font-style: italic;
            }
            .sidebar {
                padding: 30px;
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            .sidebar-title {
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 20px;
                color: #2D3748;
            }
            .latest-post {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #E2E8F0;
                text-decoration: none;
            }
            .latest-post:last-child {
                margin-bottom: 0;
                padding-bottom: 0;
                border-bottom: none;
            }
            .latest-post img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 10px;
                margin-right: 15px;
            }
            .latest-post-content h4 {
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 5px;
                color: #2D3748;
            }
            .latest-post-content span {
                color: #718096;
                font-size: 12px;
            }
            .useful-links ul li {
                margin-bottom: 10px;
            }
            .useful-links ul li a {
                color: #4A5568;
                text-decoration: none;
                transition: color 0.3s ease;
            }
            .useful-links ul li a:hover {
                color: #4A90E2;
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
        <jsp:include page="../common/user/header.jsp"></jsp:include>
        <!-- header-area-end -->

        <!-- main-area -->
        <main>
            <!-- Hero Section -->
            <section class="hero-section">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-6">
                            <div class="hero-content">
                                <h1 class="hero-title">Level Up<br>Your English</h1>
                                <h2 class="hero-subtitle">with Quizzes</h2>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="hero-image-wrapper">
                                <img src="${pageContext.request.contextPath}/assets/banner/banner_img.png" alt="Education" class="hero-image">
                                <img src="${pageContext.request.contextPath}/assets/banner/banner_shape01.png" alt="" class="hero-shape hero-shape-1">
                                <img src="${pageContext.request.contextPath}/assets/banner/banner_shape02.png" alt="" class="hero-shape hero-shape-2">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Hot Posts Section -->
            <section class="hot-posts">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <h2 class="section-title">HOT POSTS</h2>
                            <div class="row">
                                <div class="col-12 mb-4">
                                    <a href="#" class="post-card">
                                        <img src="${pageContext.request.contextPath}/assets/blog/blog_post01.jpg" alt="Grammar Skills" class="post-thumbnail">
                                        <div class="post-content">
                                            <h3 class="post-title">How to Improve Your Grammar Skills</h3>
                                            <p class="post-date">April 15, 2025</p>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-12 mb-4">
                                    <a href="#" class="post-card">
                                        <img src="${pageContext.request.contextPath}/assets/blog/blog_post02.jpg" alt="Daily Quizzes" class="post-thumbnail">
                                        <div class="post-content">
                                            <h3 class="post-title">The Benefits of Daily Quizzes</h3>
                                            <p class="post-date">April 5, 2025</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Latest Posts Sidebar -->
                        <div class="col-lg-4">
                            <div class="sidebar">
                                <h3 class="sidebar-title">Latest Posts</h3>
                                <a href="#" class="latest-post">
                                    <img src="${pageContext.request.contextPath}/assets/blog/latest_post01.jpg" alt="Grammar Skills">
                                    <div class="latest-post-content">
                                        <h4>How to Improve Your Grammar Skills</h4>
                                        <span>April 16, 2025</span>
                                    </div>
                                </a>
                                <a href="#" class="latest-post">
                                    <img src="${pageContext.request.contextPath}/assets/blog/latest_post02.jpg" alt="Daily Quizzes">
                                    <div class="latest-post-content">
                                        <h4>The Benefits of Daily Quizzes</h4>
                                        <span>April 10, 2025</span>
                                    </div>
                                </a>
                                <a href="#" class="latest-post">
                                    <img src="${pageContext.request.contextPath}/assets/blog/latest_post03.jpg" alt="Vocabulary Exam">
                                    <div class="latest-post-content">
                                        <h4>Common Vocabulary Exam</h4>
                                        <span>April 5, 2025</span>
                                    </div>
                                </a>
                                <a href="#" class="latest-post">
                                    <img src="${pageContext.request.contextPath}/assets/blog/latest_post04.jpg" alt="English Tests">
                                    <div class="latest-post-content">
                                        <h4>Preparing for English Tests</h4>
                                        <span>March 27, 2025</span>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Featured Subjects Section -->
            <section class="featured-subjects">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <h2 class="section-title">FEATURED SUBJECTS</h2>
                            <div class="row">
                                <div class="col-md-6">
                                    <a href="#" class="subject-card">
                                        <img src="${pageContext.request.contextPath}/assets/others/h6_faq_img01.jpg" alt="Grammar" class="subject-thumbnail">
                                        <div class="subject-content">
                                            <h3 class="subject-title">Grammar</h3>
                                            <p class="subject-tagline">"Enhance your grammar knowledge"</p>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="#" class="subject-card">
                                        <img src="${pageContext.request.contextPath}/assets/others/h6_faq_img02.jpg" alt="Vocabulary" class="subject-thumbnail">
                                        <div class="subject-content">
                                            <h3 class="subject-title">Vocabulary</h3>
                                            <p class="subject-tagline">"Expand your word power"</p>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="#" class="subject-card">
                                        <img src="${pageContext.request.contextPath}/assets/others/h5_about_img01.jpg" alt="Listening" class="subject-thumbnail">
                                        <div class="subject-content">
                                            <h3 class="subject-title">Listening</h3>
                                            <p class="subject-tagline">"Enhance your listening skills"</p>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="#" class="subject-card">
                                        <img src="${pageContext.request.contextPath}/assets/others/h5_about_img02.jpg" alt="Speaking" class="subject-thumbnail">
                                        <div class="subject-content">
                                            <h3 class="subject-title">Speaking</h3>
                                            <p class="subject-tagline">"Practice your speaking skills"</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Contact and Links Sidebar -->
                        <div class="col-lg-4">
                            <div class="sidebar">
                                <div class="contact-info">
                                    <h3 class="sidebar-title">Contact Us</h3>
                                    <ul class="list-unstyled">
                                        <li class="mb-3">
                                            <i class="fas fa-map-marker-alt me-2"></i>
                                            589 5th Ave, NY 10024, USA
                                        </li>
                                        <li class="mb-3">
                                            <i class="fas fa-phone me-2"></i>
                                            +123 599 8989
                                        </li>
                                        <li class="mb-3">
                                            <i class="fas fa-envelope me-2"></i>
                                            info@quizpractice.com
                                        </li>
                                    </ul>
                                </div>

                                <div class="useful-links mt-5">
                                    <h3 class="sidebar-title">Useful Links</h3>
                                    <ul class="list-unstyled">
                                        <li><a href="about">About Us</a></li>
                                        <li><a href="contact">Contact</a></li>
                                        <li><a href="privacy-policy">Privacy Policy</a></li>
                                        <li><a href="terms">Terms & Conditions</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- main-area-end -->

        <!-- footer-area -->
        <jsp:include page="../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../common/js/"></jsp:include>
    </body>
</html>
