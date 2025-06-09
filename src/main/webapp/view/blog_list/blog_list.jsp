<%-- 
    Document   : blog_list
    Created on : Jun 4, 2025, 3:54:29 PM
    Author     : LENOVO
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog - SkillGro</title>
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
    <style>
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
        
        .pagination {
            margin-top: 30px;
            justify-content: center;
        }
        
        .page-link {
            color: #6C5CE7;
            border-color: #6C5CE7;
        }
        
        .page-item.active .page-link {
            background-color: #6C5CE7;
            border-color: #6C5CE7;
        }
        
        .display-options {
            margin-bottom: 20px;
        }
        
        .display-options label {
            margin-right: 15px;
        }
        
        .advanced-search {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .advanced-search h6 {
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: 600;
            color: #555;
        }
        
        .advanced-search .form-check {
            margin-bottom: 8px;
        }
        
        .advanced-search .form-check-label {
            font-size: 13px;
            color: #666;
        }
        
        .advanced-search .form-group label {
            font-size: 12px;
            margin-bottom: 3px;
        }
    </style>
    </head>
    <body>
    <!-- Header -->
    <jsp:include page="../common/user/header.jsp"></jsp:include>

    <!-- Breadcrumb -->
    <section class="breadcrumb-area breadcrumb__hide-img" data-background="${pageContext.request.contextPath}/view/common/img/breadcrumb-bg.jpg">
        <div class="container">
            <div class="breadcrumb__wrapper">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb__content">
                            <h2 class="breadcrumb__title">Blog</h2>
                            <div class="breadcrumb__menu">
                                <nav aria-label="Breadcrumbs">
                                    <ul class="breadcrumb__list">
                                        <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                        <li><span>Blog</span></li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Blog Content -->
    <section class="blog-area section-padding-120">
        <div class="container">
            <div class="row">
                <!-- Blog Posts -->
                <div class="col-lg-8">
                    <!-- Display Options Form -->
                    <div class="display-options mb-4">
                        <form action="${pageContext.request.contextPath}/blog" method="get" id="displayOptionsForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="pageSize">Posts per page:</label>
                                        <form id="displayOptionsForm" method="get" action="yourServletOrControllerURL">
                                            <input type="number"
                                                   class="form-control"
                                                   id="pageSize"
                                                   name="pageSize"
                                                   value="${pageSize}"
                                                   min="1"
                                                   max="100"
                                                   onchange="document.getElementById('displayOptionsForm').submit()" />
                                        </form>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Display options:</label>
                                        <div>
                                            <c:forEach items="${availableDisplayOptions}" var="option">
                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" name="display" 
                                                           id="display_${option}" value="${option}" 
                                                           ${fn:contains(displayOptions, option) ? 'checked' : ''}>
                                                    <label class="form-check-label" for="display_${option}">
                                                        ${fn:toUpperCase(fn:substring(option, 0, 1))}${fn:substring(option, 1, fn:length(option))}
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Preserve other parameters -->
                            <c:if test="${not empty categoryId}">
                                <input type="hidden" name="category" value="${categoryId}">
                            </c:if>
                            <c:if test="${not empty searchQuery}">
                                <input type="hidden" name="search" value="${searchQuery}">
                            </c:if>
                            <c:if test="${not empty param.page}">
                                <input type="hidden" name="page" value="${param.page}">
                            </c:if>
                            
                            <button type="submit" class="btn btn-primary btn-sm">Apply</button>
                        </form>
                    </div>
                    
                    <!-- Search Results Summary -->
                    <div class="search-results-summary mb-3">
                        <c:choose>
                            <c:when test="${not empty searchQuery}">
                                <p class="text-muted">
                                    <i class="fas fa-search"></i>
                                    Found ${totalCount} results for "<strong>${searchQuery}</strong>"
                                    <c:if test="${not empty categoryId}">
                                        in category "<strong>${param.categoryName}</strong>"
                                    </c:if>
                                    (Showing ${(currentPage-1)*pageSize + 1} - ${currentPage*pageSize > totalCount ? totalCount : currentPage*pageSize} of ${totalCount})
                                </p>
                            </c:when>
                            <c:when test="${not empty categoryId}">
                                <p class="text-muted">
                                    <i class="fas fa-folder-open"></i>
                                    Showing ${totalCount} posts in category
                                    (Showing ${(currentPage-1)*pageSize + 1} - ${currentPage*pageSize > totalCount ? totalCount : currentPage*pageSize} of ${totalCount})
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">
                                    <i class="fas fa-list"></i>
                                    Showing all posts (${(currentPage-1)*pageSize + 1} - ${currentPage*pageSize > totalCount ? totalCount : currentPage*pageSize} of ${totalCount})
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Blog Posts List -->
                    <c:if test="${empty posts}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            No posts found. Try adjusting your search criteria.
                        </div>
                    </c:if>
                    
                    <c:forEach items="${posts}" var="postItem">
                        <c:set var="post" value="${postItem.post}" />
                        <div class="blog__post-item" style="display: flex; gap: 20px; margin-bottom: 30px; background: #fff; padding: 15px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                            <!-- Post Thumbnail -->
                            <div class="blog__post-thumb" style="flex: 0 0 200px;">
                                <a href="${pageContext.request.contextPath}/post?id=${post.id}">
                                    <img src="${pageContext.request.contextPath}${post.thumbnail_url}" 
                                         alt="${post.title}" 
                                         style="width: 200px; height: 150px; object-fit: cover; border-radius: 8px;">
                                </a>
                            </div>
                            
                            <!-- Post Content -->
                            <div class="blog__post-content" style="flex: 1;">
                                <!-- Category -->
                                <div class="category" style="margin-bottom: 8px;">
                                    <span style="color: #666; font-size: 14px;">${postItem.categoryName}</span>
                                </div>
                                
                                <!-- Title -->
                                <h3 class="title" style="margin: 0 0 10px 0; font-size: 20px; font-weight: 600;">
                                    <a href="${pageContext.request.contextPath}/post?id=${post.id}" 
                                       style="color: #333; text-decoration: none;">
                                        ${post.title}
                                    </a>
                                </h3>
                                
                                <!-- Brief Info -->
                                <p style="color: #666; margin-bottom: 10px; font-size: 15px;">
                                    ${post.brief_info}
                                </p>
                                
                                <!-- Date -->
                                <div class="date" style="color: #888; font-size: 13px;">
                                    <fmt:formatDate value="${post.published_at}" pattern="MMMM d, yyyy" />
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <!-- Build query parameters -->
                                <c:set var="queryParams" value="pageSize=${pageSize}" />
                                <c:if test="${not empty categoryId}">
                                    <c:set var="queryParams" value="${queryParams}&category=${categoryId}" />
                                </c:if>
                                <c:if test="${not empty searchQuery}">
                                    <c:set var="queryParams" value="${queryParams}&search=${searchQuery}" />
                                </c:if>
                                <c:if test="${not empty startDate}">
                                    <c:set var="queryParams" value="${queryParams}&startDate=${startDate}" />
                                </c:if>
                                <c:if test="${not empty endDate}">
                                    <c:set var="queryParams" value="${queryParams}&endDate=${endDate}" />
                                </c:if>
                                <c:forEach items="${displayOptions}" var="option">
                                    <c:set var="queryParams" value="${queryParams}&display=${option}" />
                                </c:forEach>
                                
                                <!-- Previous Page -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/blog?page=${currentPage - 1}&${queryParams}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                
                                <!-- Page Numbers (show limited range for better UX) -->
                                <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                                <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />
                                
                                <c:if test="${startPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/blog?page=1&${queryParams}">1</a>
                                    </li>
                                    <c:if test="${startPage > 2}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                </c:if>
                                
                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/blog?page=${i}&${queryParams}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/blog?page=${totalPages}&${queryParams}">${totalPages}</a>
                                    </li>
                                </c:if>
                                
                                <!-- Next Page -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/blog?page=${currentPage + 1}&${queryParams}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
                
                <!-- Sidebar -->
                <div class="col-lg-4">
                    <div class="blog-sidebar">
                        <!-- Search Box -->
                        <div class="search-box">
                            <h4 class="sidebar-title">Search Posts</h4>
                            <form action="${pageContext.request.contextPath}/blog" method="get" id="searchForm">
                                <div class="input-group mb-3">
                                    <input type="text" class="form-control" placeholder="Search..." name="search" value="${searchQuery}">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                
                                    
                                    <!-- Preserve other parameters -->
                                    <c:if test="${not empty categoryId}">
                                        <input type="hidden" name="category" value="${categoryId}">
                                    </c:if>
                                    <c:if test="${not empty pageSize}">
                                        <input type="hidden" name="pageSize" value="${pageSize}">
                                    </c:if>
                                </div>
                            </form>
                        </div>
        
                        
                        <!-- Latest Posts -->
                        <div class="latest-posts">
                            <h4 class="sidebar-title">Latest Posts</h4>
                            <c:forEach items="${latestPosts}" var="post">
                                <div class="latest-post-item">
                                    <h6>
                                        <a href="${pageContext.request.contextPath}/post?id=${post.id}">${post.title}</a>
                                    </h6>
                                    <span class="date">
                                        <i class="fas fa-calendar-alt"></i>
                                        <fmt:formatDate value="${post.updated_at}" pattern="MMM dd, yyyy" />
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
    </section>

    <!-- Footer -->
    <jsp:include page="../common/user/footer.jsp"></jsp:include>
    
    <!-- JS here -->
    <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html>
