<%-- 
    Document   : homepage
    Created on : May 25, 2025, 6:15:10 PM
    Author     : LENOVO
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quiz Practice - Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
        <style>
            <%@ include file="/view/common/css/main.css" %>
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"/>

        <!-- Hero Section with Sliders -->
        <section class="hero-section">
            <div class="swiper hero-slider">
                <div class="swiper-wrapper">
                    <c:forEach items="${sliders}" var="slider">
                        <div class="swiper-slide">
                            <a href="${pageContext.request.contextPath}${slider.buttonLink}" class="slide-link">
                                <div class="container">
                                    <div class="row align-items-center">
                                        <div class="col-lg-6 hero-content">
                                            <h1 class="hero-title">${slider.title}</h1>
                                            <h2 class="hero-subtitle">${slider.subtitle}</h2>
                                            <p class="hero-text">${slider.description}</p>
                                            <span class="hero-button">${slider.buttonText}</span>
                                        </div>
                                        <div class="col-lg-6 hero-image">
                                            <img src="${pageContext.request.contextPath}${slider.imageUrl}" 
                                                 alt="${slider.title}" class="img-fluid">
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
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
                    <c:forEach items="${hotPosts}" var="post">
                        <div class="col-xl-6 col-lg-6">
                            <div class="blog__post-item mb-30">
                                <div class="blog__post-thumb">
                                    <a href="${pageContext.request.contextPath}/post?id=${post.id}">
                                        <img src="${pageContext.request.contextPath}${post.thumbnailUrl}" 
                                             alt="${post.title}" style="border-radius: 15px; height: 300px; object-fit: cover;">
                                    </a>
                                </div>
                                <div class="blog__post-content">
                                    <h3 class="title">
                                        <a href="${pageContext.request.contextPath}/post?id=${post.id}">${post.title}</a>
                                    </h3>
                                    <p>${post.createdAt} | Views: ${post.viewCount}</p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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
                    <c:forEach items="${featuredSubjects}" var="subject">
                        <div class="col-lg-3 col-md-6">
                            <div class="features__item text-center mb-30">
                                <div class="features__icon">
                                    <img src="${pageContext.request.contextPath}${subject.thumbnailUrl}" 
                                         alt="${subject.name}" style="width: 80px; height: 80px;">
                                </div>
                                <div class="features__content">
                                    <h4>${subject.name}</h4>
                                    <p>"${subject.tagline}"</p>
                                    <div class="subject-stats">
                                        <small>${subject.totalQuizzes} Quizzes | ${subject.totalEnrollments} Students</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Latest Posts Sidebar -->
        <section class="latest-posts section-padding-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="sidebar">
                            <h3 class="sidebar-title">Latest Posts</h3>
                            <div class="row">
                                <c:forEach items="${latestPosts}" var="post">
                                    <div class="col-lg-3 col-md-6">
                                        <a href="${pageContext.request.contextPath}/post?id=${post.id}" class="latest-post">
                                            <img src="${pageContext.request.contextPath}${post.thumbnailUrl}" alt="${post.title}">
                                            <div class="latest-post-content">
                                                <h4>${post.title}</h4>
                                                <span>${post.createdAt}</span>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <jsp:include page="../common/user/footer.jsp"/>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <script>
            <%@ include file="/view/common/js/main.js" %>
        </script>
    </body>
</html>
