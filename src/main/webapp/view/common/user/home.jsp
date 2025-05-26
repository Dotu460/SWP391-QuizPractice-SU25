<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>QuizPractice - Learn English with Quizzes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
        <!-- Add Swiper CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>

        <!-- Hero Section with Slider -->
        <section class="hero-section">
            <div class="swiper hero-slider">
                <div class="swiper-wrapper">
                    <!-- Slide 1 -->
                    <div class="swiper-slide">
                        <a href="${pageContext.request.contextPath}/quizzes" class="slide-link">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6 hero-content">
                                        <h1 class="hero-title">Level Up<br>Your English</h1>
                                        <h2 class="hero-subtitle">with Quizzes</h2>
                                        <p class="hero-text">Master English through interactive quizzes, track your progress, and achieve your language learning goals.</p>
                                        <span class="hero-button">Start Learning</span>
                                    </div>
                                    <div class="col-lg-6 hero-image">
                                        <img src="${pageContext.request.contextPath}/view/common/img/banner_img.png" alt="English Learning" class="img-fluid">
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>

                    <!-- Slide 2 -->
                    <div class="swiper-slide">
                        <a href="${pageContext.request.contextPath}/practice" class="slide-link">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6 hero-content">
                                        <h1 class="hero-title">Practice<br>Daily</h1>
                                        <h2 class="hero-subtitle">with Friends</h2>
                                        <p class="hero-text">Join our community of learners, compete with friends, and improve your English skills together.</p>
                                        <span class="hero-button">Join Practice</span>
                                    </div>
                                    <div class="col-lg-6 hero-image">
                                        <img src="${pageContext.request.contextPath}/view/common/img/banner_img2.png" alt="Practice English" class="img-fluid">
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>

                    <!-- Slide 3 -->
                    <div class="swiper-slide">
                        <a href="${pageContext.request.contextPath}/dashboard" class="slide-link">
                            <div class="container">
                                <div class="row align-items-center">
                                    <div class="col-lg-6 hero-content">
                                        <h1 class="hero-title">Track Your<br>Progress</h1>
                                        <h2 class="hero-subtitle">with Analytics</h2>
                                        <p class="hero-text">Monitor your learning journey with detailed analytics and personalized recommendations.</p>
                                        <span class="hero-button">View Dashboard</span>
                                    </div>
                                    <div class="col-lg-6 hero-image">
                                        <img src="${pageContext.request.contextPath}/view/common/img/banner_img3.png" alt="Track Progress" class="img-fluid">
                                    </div>
                                </div>
                            </div>
                        </a>
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
        <section class="blog-area section-padding-120">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-6">
                        <div class="section-title text-center mb-70">
                            <h2 class="title" style="color: #6C5CE7">HOT POSTS</h2>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Grammar Skills Post -->
                    <div class="col-xl-6 col-lg-6">
                        <div class="blog__post-item mb-30">
                            <div class="blog__post-thumb">
                                <a href="#"><img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/blog/blog_post01.jpg" alt="Grammar Skills" style="border-radius: 15px; height: 300px; object-fit: cover;"></a>
                            </div>
                            <div class="blog__post-content">
                                <h3 class="title"><a href="#">How to Improve Your Grammar Skills</a></h3>
                                <p>April 15, 2025</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Daily Quizzes Post -->
                    <div class="col-xl-6 col-lg-6">
                        <div class="blog__post-item mb-30">
                            <div class="blog__post-thumb">
                                <a href="#"><img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/blog/blog_post02.jpg" alt="Daily Quizzes" style="border-radius: 15px; height: 300px; object-fit: cover;"></a>
                            </div>
                            <div class="blog__post-content">
                                <h3 class="title"><a href="#">The Benefits of Daily Quizzes</a></h3>
                                <p>April 5, 2025</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Subjects Section -->
        <section class="features-area section-padding-120">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-6">
                        <div class="section-title text-center mb-70">
                            <h2 class="title" style="color: #6C5CE7">FEATURED SUBJECTS</h2>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Grammar -->
                    <div class="col-lg-3 col-md-6">
                        <div class="features__item text-center mb-30">
                            <div class="features__icon">
                                <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/h2_features_icon01.svg" alt="Grammar" style="width: 80px; height: 80px;">
                            </div>
                            <div class="features__content">
                                <h4>Grammar</h4>
                                <p>"Enhance your grammar knowledge"</p>
                            </div>
                        </div>
                    </div>

                    <!-- Vocabulary -->
                    <div class="col-lg-3 col-md-6">
                        <div class="features__item text-center mb-30">
                            <div class="features__icon">
                                <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/h2_features_icon02.svg" alt="Vocabulary" style="width: 80px; height: 80px;">
                            </div>
                            <div class="features__content">
                                <h4>Vocabulary</h4>
                                <p>"Expand your word power"</p>
                            </div>
                        </div>
                    </div>

                    <!-- Listening -->
                    <div class="col-lg-3 col-md-6">
                        <div class="features__item text-center mb-30">
                            <div class="features__icon">
                                <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/h2_features_icon03.svg" alt="Listening" style="width: 80px; height: 80px;">
                            </div>
                            <div class="features__content">
                                <h4>Listening</h4>
                                <p>"Improve your listening skills"</p>
                            </div>
                        </div>
                    </div>

                    <!-- Speaking -->
                    <div class="col-lg-3 col-md-6">
                        <div class="features__item text-center mb-30">
                            <div class="features__icon">
                                <img src="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/icons/h3_features_icon01.svg" alt="Speaking" style="width: 80px; height: 80px;">
                            </div>
                            <div class="features__content">
                                <h4>Speaking</h4>
                                <p>"Master your speaking ability"</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- JS -->
        <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>

        <!-- Add Swiper JS before closing body -->
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

        <style>
        .hero-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            position: relative;
            overflow: hidden;
        }

        .slide-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .hero-slider {
            width: 100%;
            height: 100%;
        }

        .swiper-slide {
            background: transparent;
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

        .hero-content {
            padding-right: 40px;
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
            color: white;
            border-radius: 8px;
            font-weight: 600;
            font-size: 18px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(108, 92, 231, 0.2);
        }

        .hero-image {
            text-align: center;
        }

        .hero-image img {
            max-width: 100%;
            height: auto;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }
        }

        @media (max-width: 991px) {
            .hero-section {
                padding: 60px 0;
            }
            
            .hero-content {
                text-align: center;
                padding-right: 0;
                margin-bottom: 40px;
            }
            
            .hero-title {
                font-size: 48px;
            }
            
            .hero-subtitle {
                font-size: 36px;
            }
        }
        </style>
    </body>
</html> 