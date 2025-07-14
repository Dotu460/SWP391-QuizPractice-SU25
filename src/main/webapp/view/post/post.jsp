<%-- 
    Document   : post
    Created on : Jun 12, 2025, 4:45:12 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SkillGro - Blog Details</title>

        <!-- Include common CSS -->
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">

        <style>
            .post-detail {
                padding: 40px 0;
            }

            .post-header {
                margin-bottom: 30px;
            }

            .post-title {
                font-size: 36px;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
            }

            .post-meta {
                color: #666;
                font-size: 14px;
                margin-bottom: 20px;
            }

            .post-meta span {
                margin-right: 20px;
            }

            .post-meta i {
                margin-right: 5px;
            }

            .post-content {
                font-size: 16px;
                line-height: 1.8;
                color: #444;
            }

            .post-content p {
                margin-bottom: 20px;
            }

            .post-content img {
                max-width: 100%;
                height: auto;
                margin: 20px 0;
            }

            .post-category {
                display: inline-block;
                padding: 5px 15px;
                background: #6C5CE7;
                color: #fff;
                border-radius: 20px;
                font-size: 14px;
                margin-bottom: 15px;
            }

            /* Sidebar styles - giống blog_list.jsp */
            .blog-sidebar {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.05);
            }

            .sidebar-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
                border-bottom: 2px solid #6C5CE7;
                padding-bottom: 10px;
            }

            .search-box {
                margin-bottom: 25px;
            }

            .category-list {
                list-style: none;
                padding: 0;
                margin: 0 0 25px 0;
            }

            .category-list li {
                margin-bottom: 10px;
                display: flex;
                justify-content: space-between;
            }

            .category-list li a {
                color: #555;
                transition: all 0.3s;
                text-decoration: none;
            }

            .category-list li a:hover {
                color: #6C5CE7;
                padding-left: 5px;
            }

            .latest-posts {
                margin-bottom: 25px;
            }

            .latest-post-item {
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }

            .latest-post-item:last-child {
                border-bottom: none;
            }

            .latest-post-item h6 {
                margin-bottom: 5px;
                font-size: 15px;
            }

            .latest-post-item .date {
                font-size: 12px;
                color: #777;
            }

            .contact-info {
                margin-bottom: 25px;
            }

            .contact-info p {
                margin-bottom: 5px;
                font-size: 14px;
            }

            .social-links {
                list-style: none;
                padding: 0;
                margin: 0;
                display: flex;
            }

            .social-links li {
                margin-right: 10px;
            }

            .social-links li a {
                color: #555;
                font-size: 18px;
                transition: all 0.3s;
            }

            .social-links li a:hover {
                color: #6C5CE7;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../common/user/header.jsp"></jsp:include>

        <!-- Main Content -->
        <div class="container">
            <div class="post-detail">
                <div class="row">
                    <!-- Main Content Column -->
                    <div class="col-lg-8">
                        <!-- Post Header -->
                        <div class="post-header">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="post-category">
                                        ${post.category}
                                    </span>

                                    <h1 class="post-title">
                                        ${post.title}
                                    </h1>

                                    <div class="post-meta">
                                        <span>
                                            <i class="fas fa-calendar-alt"></i>
                                            <fmt:formatDate value="${post.updated_at}" pattern="MMMM d, yyyy"/>
                                        </span>
                                        <span>
                                            <i class="fas fa-user"></i>
                                            ${post.author != null ? post.author : 'Author Name'}
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- Edit Button (for authorized users) -->
                                <div class="post-actions">
                                    <a href="${pageContext.request.contextPath}/post-details?id=${post.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-edit"></i> Edit Post
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Post Content -->
                        <div class="post-content">
                            ${post.content}
                        </div>
                    </div>

                    <!-- Sidebar Column -->
                    <div class="col-lg-4">
                        <div class="blog-sidebar">
                            <!-- Search Box -->
                            <div class="search-box">
                                <h4 class="sidebar-title">Search Posts</h4>
                                <form action="${pageContext.request.contextPath}/blog" method="get" id="searchForm" class="mt-3">
                                    <div class="input-group">
                                        <input type="text" 
                                               class="form-control" 
                                               placeholder="Search posts..." 
                                               name="search" 
                                               aria-label="Search posts"
                                               aria-describedby="button-search">
                                        <button class="btn btn-primary" type="submit" id="button-search">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Post Categories -->
                            <div class="post-categories">
                                <h4 class="sidebar-title">Post Categories</h4>
                                <ul class="category-list">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/blog?categoryName=Grammar">
                                            <i class="fas fa-book"></i> Grammar
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${pageContext.request.contextPath}/blog?categoryName=Vocabulary">
                                            <i class="fas fa-language"></i> Vocabulary
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${pageContext.request.contextPath}/blog?categoryName=Listening">
                                            <i class="fas fa-headphones"></i> Listening
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <!-- Latest Posts -->
                            <div class="latest-posts">
                                <h4 class="sidebar-title">Latest Posts</h4>
                                <c:forEach items="${latestPosts}" var="latestPost">
                                    <div class="latest-post-item">
                                        <h6>
                                            <a href="${pageContext.request.contextPath}/post?id=${latestPost.id}">${latestPost.title}</a>
                                        </h6>
                                        <span class="date">
                                            <i class="fas fa-calendar-alt"></i>
                                            <fmt:formatDate value="${latestPost.updated_at}" pattern="MMM dd, yyyy" />
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Contact Info -->
                            <div class="contact-info">
                                <h4 class="sidebar-title">Contact Us</h4>
                                <p><i class="fas fa-map-marker-alt"></i> 123 Main Street, City, Country</p>
                                <p><i class="fas fa-phone"></i> +1 234 567 890</p>
                                <p><i class="fas fa-envelope"></i> info@skillgro.com</p>

                                <ul class="social-links">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>