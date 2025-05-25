<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>QuizPractice - Learn English with Quizzes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="C:/templateSWP391/html.themegenix.com/skillgro/assets/img/favicon.png">
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>

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
    </body>
</html> 