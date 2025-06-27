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
        <title>SkillGro - Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <jsp:include page="../common/user/link_css_common.jsp"/>
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/view/common/css/main.css"/>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">

        <style>
            /* Đảm bảo chỉ hiện slide đang active */
            .swiper-slide {
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.5s ease;
                /* position: absolute; */
                top: 0;
                left: 0;
                width: 100%;
            }

            .swiper-slide.swiper-slide-active {
                opacity: 1;
                visibility: visible;
                position: relative;
                z-index: 1;
            }

            /* Quan trọng: đặt chiều cao cố định cho slider container */
            .hero-slider {
                position: relative;
                overflow: hidden;
                height: 500px; /* tuỳ chỉnh theo hình ảnh */
            }

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
                            <a href="${pageContext.request.contextPath}${slider.backlink_url}" class="slide-link">
                                <div class="container">
                                    <div class="row align-items-center">
                                        <div class="col-lg-6 hero-content">
                                            <h1 class="hero-title">${slider.title}</h1>
                                        </div>
                                        <div class="col-lg-6 hero-image">
                                            <img src="${pageContext.request.contextPath}${slider.image_url}" 
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
            <div style="max-width: 960px;padding-left: 24px; padding-right: 0;">
                <div class="row">
                    <div class="col-12">
                        <div class="section-title mb-70">
                            <h2 class="title" style="color: #6C5CE7; text-align: left;">HOT POSTS</h2>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <c:forEach items="${hotPosts}" var="post">
                        <div class="col-xl-6 col-lg-6">
                            <div class="blog__post-item mb-30">
                                <div class="blog__post-thumb">
                                    <a href="${pageContext.request.contextPath}/post?id=${post.id}">
                                        <img src="${pageContext.request.contextPath}${post.thumbnail_url}" 
                                             alt="${post.title}" style="border-radius: 15px; height: 300px; object-fit: cover;">
                                    </a>
                                </div>
                                <div class="blog__post-content">
                                    <h3 class="title">
                                        <a href="${pageContext.request.contextPath}/post?id=${post.id}">${post.title}</a>
                                    </h3>
                                    <p>${post.brief_info}</p>
                                    <span class="date">${post.created_at}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Featured Subjects Section -->
        <section class="features-area section-padding-120">
            <div style="max-width: 960px;padding-left: 24px; padding-right: 0;">
                <div class="row">
                    <div class="col-12">
                        <div class="section-title mb-40">
                            <h2 class="title" style="color: #6C5CE7; text-align: left;">FEATURED SUBJECTS</h2>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <c:forEach items="${featuredSubjects}" var="subject">
                        <div class="col-xl-6 col-lg-6">
                            <div class="blog__post-item mb-30">
                                <!-- Hình ảnh đại diện -->
                                <div class="blog__post-thumb">
                                    <a href="${pageContext.request.contextPath}/subject?id=${subject.id}">
                                        <img src="${pageContext.request.contextPath}${subject.thumbnail_url}" 
                                             alt="${subject.title}" style="border-radius: 15px; height: 300px; object-fit: cover;">
                                    </a>
                                </div>

                                <!-- Nội dung -->
                                <div class="blog__post-content">
                                    <h3 class="title">
                                        <a href="${pageContext.request.contextPath}/subject?id=${subject.id}">
                                            ${subject.title}
                                        </a>
                                    </h3>
                                    <p>${subject.tag_line}</p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Latest Posts Sidebar -->
        <section class="latest-posts section-padding-120">
            <div style="max-width: 960px;padding-left: 24px; padding-right: 0;">
                <div class="row">
                    <div class="col-12">
                        <div class="section-title mb-70">
                            <h2 class="title" style="color: #6C5CE7; text-align: left;">LATEST POSTS</h2>
                        </div>
                    </div>
                </div>    
                <div class="row gx-4">
                    <c:forEach items="${latestPosts}" var="post">
                        <div class="col-xl-6 col-lg-6">
                            <div class="blog__post-item mb-30">
                                <div class="blog__post-thumb">
                                    <a href="${pageContext.request.contextPath}/post?id=${post.id}" class="latest-post">
                                        <img src="${pageContext.request.contextPath}${post.thumbnail_url}" alt="${post.title}"style="border-radius: 15px; height: 300px; object-fit: cover;width: 100%">
                                    </a>
                                </div>
                                <div class="blog__post-content">
                                    <h3 class="title">
                                        <a href="${pageContext.request.contextPath}/post?id=${post.id}">${post.title}</a>
                                    </h3>
                                    <p>${post.brief_info}</p>
                                    <span class="date">${post.created_at}</span>
                                </div>
                            </div>
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
<script src="${pageContext.request.contextPath}/view/common/js/main.js"></script>
<jsp:include page="../common/user/link_js_common.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var heroSwiper = new Swiper(".hero-slider", {
            spaceBetween: 0,
            effect: "slide", /* Or "slide", "cube", "coverflow", "flip" depending on desired effect */
            loop: true,
            autoplay: {
                delay: 7000, /* Adjust delay as needed */
                disableOnInteraction: false,
            },
            pagination: {
                el: ".swiper-pagination",
                clickable: true,
            },
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
        });
    });
</script>
</body>
</html>
