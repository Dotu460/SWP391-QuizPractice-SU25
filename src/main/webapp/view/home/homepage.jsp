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
        <title>SkillGro - Online English Learning Platform</title>
        <meta name="description" content="EngQuiz - Online English Learning Platform">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .slider-section {
                padding: 60px 0;
                background: #f8f9fa;
            }
            .hero-section {
                padding: 60px 0;
                background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
                position: relative;
                overflow: hidden;
            }
            .hero-content {
                padding: 50px 0;
                position: relative;
                z-index: 2;
            }
            .hero-title {
                font-size: 64px;
                font-weight: 800;
                background: linear-gradient(135deg, #2D3748 0%, #1a202c 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                line-height: 1.1;
                margin-bottom: 15px;
            }
            .hero-subtitle {
                font-size: 48px;
                font-weight: 700;
                background: linear-gradient(135deg, #6C5CE7 0%, #4c3ee3 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                margin-bottom: 24px;
            }
            .hero-text {
                font-size: 18px;
                color: #4A5568;
                margin-bottom: 32px;
                line-height: 1.6;
            }
            .hero-button {
                display: inline-block;
                padding: 16px 32px;
                background: linear-gradient(135deg, #6C5CE7 0%, #4c3ee3 100%);
                color: white !important;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 18px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(108, 92, 231, 0.2);
            }
            .hero-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(108, 92, 231, 0.3);
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
                animation: float 6s ease-in-out infinite;
            }
            @keyframes float {
                0% { transform: translateY(0px); }
                50% { transform: translateY(-20px); }
                100% { transform: translateY(0px); }
            }
            .swiper-button-next,
            .swiper-button-prev {
                color: #6C5CE7;
                width: 50px;
                height: 50px;
                background: white;
                border-radius: 50%;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .swiper-button-next:after,
            .swiper-button-prev:after {
                font-size: 20px;
            }
            .swiper-pagination-bullet {
                width: 12px;
                height: 12px;
                background: #6C5CE7;
                opacity: 0.5;
            }
            .swiper-pagination-bullet-active {
                opacity: 1;
                background: #6C5CE7;
            }
            @media (max-width: 991px) {
                .hero-section {
                    padding: 40px 0;
                }
                
                .hero-content {
                    text-align: center;
                    padding: 30px 0;
                }
                
                .hero-title {
                    font-size: 48px;
                }
                
                .hero-subtitle {
                    font-size: 36px;
                }
                .hero-text {
                    font-size: 16px;
                }
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
                <div class="swiper hero-slider">
                    <div class="swiper-wrapper">
                        <!-- Slide 1 -->
                        <div class="swiper-slide">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6">
                                        <div class="hero-content">
                                            <h1 class="hero-title">Level Up<br>Your English</h1>
                                            <h2 class="hero-subtitle">with Quizzes</h2>
                                            <p class="hero-text">Master English through interactive quizzes, track your progress, and achieve your language learning goals.</p>
                                            <a href="${pageContext.request.contextPath}/quizzes" class="hero-button">Start Learning</a>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="hero-image-wrapper">
                                            <img src="${pageContext.request.contextPath}/assets/banner/banner_img.png" alt="Education" class="hero-image">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Slide 2 -->
                        <div class="swiper-slide">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6">
                                        <div class="hero-content">
                                            <h1 class="hero-title">Practice<br>Daily</h1>
                                            <h2 class="hero-subtitle">with Friends</h2>
                                            <p class="hero-text">Join our community of learners, compete with friends, and improve your English skills together.</p>
                                            <a href="${pageContext.request.contextPath}/practice" class="hero-button">Join Practice</a>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="hero-image-wrapper">
                                            <img src="${pageContext.request.contextPath}/assets/banner/h3_hero_img.png" alt="Practice" class="hero-image">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Slide 3 -->
                        <div class="swiper-slide">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6">
                                        <div class="hero-content">
                                            <h1 class="hero-title">Track Your<br>Progress</h1>
                                            <h2 class="hero-subtitle">with Analytics</h2>
                                            <p class="hero-text">Monitor your learning journey with detailed analytics and personalized recommendations.</p>
                                            <a href="${pageContext.request.contextPath}/dashboard" class="hero-button">View Dashboard</a>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="hero-image-wrapper">
                                            <img src="${pageContext.request.contextPath}/assets/banner/h5_hero_img.png" alt="Analytics" class="hero-image">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Navigation -->
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>

                    <!-- Add Pagination -->
                    <div class="swiper-pagination"></div>
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
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script>
            var swiper = new Swiper('.hero-slider', {
                loop: true,
                effect: 'fade',
                fadeEffect: {
                    crossFade: true
                },
                autoplay: {
                    delay: 5000,
                    disableOnInteraction: false,
                },
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
            });
        </script>
    </body>
</html>
