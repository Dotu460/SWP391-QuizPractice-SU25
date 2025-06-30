<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>${subject.title} - Subject Details</title>
  <meta name="description" content="${subject.brief_info}">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">

  <!-- CSS here -->
  <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

  <!-- Custom CSS for this page -->
  <style>
    .subject-details-container {
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0,0,0,0.1);
      overflow: hidden;
      margin-bottom: 30px;
    }

    .subject-hero {
      position: relative;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 40px;
      text-align: center;
    }

    .subject-hero h1 {
      font-size: 2.5rem;
      margin-bottom: 15px;
      font-weight: 700;
    }

    .subject-tagline {
      font-size: 1.2rem;
      opacity: 0.9;
      margin-bottom: 20px;
    }

    .subject-brief {
      font-size: 1rem;
      opacity: 0.8;
      max-width: 600px;
      margin: 0 auto;
    }

    .subject-content {
      padding: 40px;
    }

    .subject-info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 40px;
      margin-bottom: 40px;
    }

    .subject-description {
      background: #f8f9fa;
      padding: 30px;
      border-radius: 10px;
      border-left: 4px solid #3f78e0;
    }

    .subject-description h3 {
      color: #3f78e0;
      margin-bottom: 20px;
      font-weight: 600;
    }

    .price-packages {
      background: #fff;
      border: 2px solid #e9ecef;
      border-radius: 10px;
      padding: 25px;
    }

    .price-packages h3 {
      color: #333;
      margin-bottom: 20px;
      font-weight: 600;
      text-align: center;
    }

    .package-card {
      background: #f8f9fa;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 15px;
      border: 1px solid #e9ecef;
      transition: all 0.3s ease;
    }

    .package-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .featured-package {
      background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
      border: 2px solid #28a745;
      position: relative;
      box-shadow: 0 5px 20px rgba(40, 167, 69, 0.1);
    }

    .featured-package:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(40, 167, 69, 0.2);
    }

    .package-badge {
      position: absolute;
      top: -10px;
      right: 15px;
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      padding: 5px 12px;
      border-radius: 15px;
      font-size: 0.8rem;
      font-weight: 600;
      box-shadow: 0 2px 10px rgba(40, 167, 69, 0.3);
    }

    .package-description {
      background: #e9ecef;
      padding: 15px;
      border-radius: 8px;
      margin: 15px 0;
      border-left: 3px solid #28a745;
    }

    .package-description p {
      margin: 0;
      font-size: 0.9rem;
      color: #495057;
      line-height: 1.5;
    }

    .package-name {
      font-size: 1.1rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 10px;
    }

    .package-price {
      display: flex;
      align-items: center;
      gap: 15px;
      margin-bottom: 15px;
    }

    .original-price {
      text-decoration: line-through;
      color: #6c757d;
      font-size: 1rem;
    }

    .sale-price {
      font-size: 1.5rem;
      font-weight: 700;
      color: #28a745;
    }

    .savings-badge {
      background: #dc3545;
      color: white;
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: 600;
      margin-left: 10px;
    }

    .package-duration {
      color: #6c757d;
      font-size: 0.9rem;
      margin-bottom: 15px;
    }

    .register-btn {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      border: none;
      padding: 12px 25px;
      border-radius: 25px;
      font-weight: 600;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s ease;
      text-align: center;
      width: 100%;
    }

    .register-btn:hover {
      background: linear-gradient(135deg, #218838 0%, #1ea085 100%);
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
    }

    .subject-media {
      margin-top: 30px;
    }

    .media-section {
      margin-bottom: 30px;
    }

    .media-section h4 {
      color: #333;
      margin-bottom: 15px;
      font-weight: 600;
    }

    .thumbnail-container {
      text-align: center;
      margin-bottom: 20px;
    }

    .subject-thumbnail {
      max-width: 100%;
      height: auto;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      transition: all 0.3s ease;
    }

    .subject-thumbnail:hover {
      transform: scale(1.02);
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }

    .video-container {
      position: relative;
      width: 100%;
      height: 0;
      padding-bottom: 56.25%; /* 16:9 aspect ratio */
      border-radius: 10px;
      overflow: hidden;
    }

    .video-container iframe {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: none;
    }

    .no-video-message {
      text-align: center;
      padding: 40px 20px;
      background: #f8f9fa;
      border-radius: 10px;
      border: 2px dashed #dee2e6;
    }

    .no-video-message i {
      font-size: 3rem;
      color: #6c757d;
      margin-bottom: 15px;
    }

    .no-video-message p {
      margin: 0;
      color: #6c757d;
      font-size: 1.1rem;
    }

    .no-image-message {
      text-align: center;
      padding: 40px 20px;
      background: #f8f9fa;
      border-radius: 10px;
      border: 2px dashed #dee2e6;
    }

    .no-image-message i {
      font-size: 3rem;
      color: #6c757d;
      margin-bottom: 15px;
    }

    .no-image-message p {
      margin: 0;
      color: #6c757d;
      font-size: 1.1rem;
    }

    .image-debug-info,
    .video-debug-info {
      background: #f8f9fa;
      padding: 10px;
      border-radius: 5px;
      margin-top: 10px;
      border-left: 3px solid #007bff;
    }

    .image-debug-info small,
    .video-debug-info small {
      color: #6c757d;
      font-family: monospace;
      word-break: break-all;
    }

    /* Sidebar Styles */
    .subject-sidebar {
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0,0,0,0.1);
      padding: 25px;
      margin-bottom: 30px;
    }

    .sidebar-section {
      margin-bottom: 30px;
    }

    .sidebar-section:last-child {
      margin-bottom: 0;
    }

    .sidebar-section h4 {
      color: #333;
      margin-bottom: 15px;
      font-weight: 600;
      border-bottom: 2px solid #3f78e0;
      padding-bottom: 8px;
    }

    .search-box {
      position: relative;
    }

    .search-box input {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e9ecef;
      border-radius: 25px;
      font-size: 0.9rem;
      transition: all 0.3s ease;
    }

    .search-box input:focus {
      outline: none;
      border-color: #3f78e0;
      box-shadow: 0 0 0 3px rgba(63, 120, 224, 0.1);
    }

    .search-box button {
      position: absolute;
      right: 5px;
      top: 50%;
      transform: translateY(-50%);
      background: #3f78e0;
      color: white;
      border: none;
      border-radius: 50%;
      width: 35px;
      height: 35px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .search-box button:hover {
      background: #2c5ec1;
    }

    .view-all-link {
      display: inline-block;
      padding: 8px 15px;
      background: #3f78e0;
      color: white;
      text-decoration: none;
      border-radius: 20px;
      font-size: 0.9rem;
      transition: all 0.3s ease;
    }

    .view-all-link:hover {
      background: #2c5ec1;
      color: white;
      text-decoration: none;
      transform: translateY(-1px);
    }

    .category-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .category-list li {
      margin-bottom: 8px;
    }

    .category-list a {
      display: block;
      padding: 10px 15px;
      background: #f8f9fa;
      border-radius: 8px;
      color: #333;
      text-decoration: none;
      transition: all 0.3s ease;
      border-left: 3px solid transparent;
    }

    .category-list a:hover {
      background: #e9ecef;
      border-left-color: #3f78e0;
      color: #3f78e0;
    }

    .featured-subjects {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .featured-subject-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px;
      background: #f8f9fa;
      border-radius: 8px;
      margin-bottom: 10px;
      transition: all 0.3s ease;
    }

    .featured-subject-item:hover {
      background: #e9ecef;
      transform: translateX(5px);
    }

    .featured-subject-link {
      display: flex;
      align-items: center;
      gap: 12px;
      text-decoration: none;
      color: inherit;
      width: 100%;
    }

    .featured-subject-link:hover {
      text-decoration: none;
      color: inherit;
    }

    .featured-subject-thumbnail {
      width: 50px;
      height: 50px;
      border-radius: 8px;
      object-fit: cover;
    }

    .featured-subject-info h6 {
      margin: 0;
      font-size: 0.9rem;
      font-weight: 600;
      color: #333;
    }

    .featured-subject-info p {
      margin: 0;
      font-size: 0.8rem;
      color: #6c757d;
    }

    .contact-info {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .contact-info li {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 8px 0;
      border-bottom: 1px solid #e9ecef;
    }

    .contact-info li:last-child {
      border-bottom: none;
    }

    .contact-info i {
      color: #3f78e0;
      width: 20px;
    }

    .contact-info a {
      color: #333;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .contact-info a:hover {
      color: #3f78e0;
    }

    .social-links {
      display: flex;
      gap: 10px;
      margin-top: 15px;
    }

    .social-links a {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 35px;
      height: 35px;
      background: #3f78e0;
      color: white;
      border-radius: 50%;
      text-decoration: none;
      transition: all 0.3s ease;
    }

    .social-links a:hover {
      background: #2c5ec1;
      transform: translateY(-2px);
    }

    .back-btn {
      background: #6c757d;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s ease;
      margin-bottom: 20px;
    }

    .back-btn:hover {
      background: #5a6268;
      color: white;
    }

    @media (max-width: 768px) {
      .subject-info-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }
      
      .subject-hero h1 {
        font-size: 2rem;
      }
      
      .subject-content {
        padding: 20px;
      }
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
<jsp:include page="../../common/user/header.jsp"></jsp:include>
<!-- header-area-end -->

<!-- main-area -->
<main class="main-area">
  <!-- dashboard-area -->
  <section class="dashboard__area section-pb-120">
    <div class="dashboard__bg"><img src="${pageContext.request.contextPath}/view/common/img/bg/dashboard_bg.jpg" alt=""></div>
    <div class="container">
      <div class="dashboard__inner-wrap">
        <div class="row">
          <!-- Sidebar -->
          <div class="col-lg-3">
            <div class="subject-sidebar">
              <!-- Search Box -->
              <div class="sidebar-section">
                <h4><i class="fas fa-search"></i> Search Subjects</h4>
                <form class="search-box" method="get" action="${pageContext.request.contextPath}/admin/subjects">
                  <input type="text" name="search" placeholder="Search subjects..." value="${searchTerm}">
                  <button type="submit"><i class="fas fa-search"></i></button>
                </form>
                <div style="text-align: center; margin-top: 10px;">
                  <a href="${pageContext.request.contextPath}/admin/subjects" class="view-all-link">
                    <i class="fas fa-list"></i> View All Subjects
                  </a>
                </div>
              </div>

              <!-- Categories -->
              <div class="sidebar-section">
                <h4><i class="fas fa-tags"></i> Categories</h4>
                <ul class="category-list">
                  <c:forEach var="cat" items="${categories}">
                    <li>
                      <a href="${pageContext.request.contextPath}/admin/subjects?category=${cat.id}">
                        ${cat.name}
                      </a>
                    </li>
                  </c:forEach>
                </ul>
              </div>

              <!-- Featured Subjects -->
              <div class="sidebar-section">
                <h4><i class="fas fa-star"></i> Featured Subjects</h4>
                <ul class="featured-subjects">
                  <c:forEach var="featuredSubject" items="${featuredSubjects}" varStatus="status">
                    <c:if test="${status.index < 5}">
                      <li class="featured-subject-item">
                        <a href="${pageContext.request.contextPath}/admin/subject/details?id=${featuredSubject.id}" class="featured-subject-link">
                          <img src="${featuredSubject.thumbnail_url != null ? featuredSubject.thumbnail_url : pageContext.request.contextPath.concat('/view/common/img/courses/course_thumb01.jpg')}" 
                               alt="${featuredSubject.title}" class="featured-subject-thumbnail">
                          <div class="featured-subject-info">
                            <h6>${featuredSubject.title}</h6>
                            <p>${featuredSubject.tag_line != null ? featuredSubject.tag_line : 'No tagline'}</p>
                          </div>
                        </a>
                      </li>
                    </c:if>
                  </c:forEach>
                </ul>
              </div>

              <!-- Contact Information -->
              <div class="sidebar-section">
                <h4><i class="fas fa-address-book"></i> Contact Info</h4>
                <ul class="contact-info">
                  <li>
                    <i class="fas fa-map-marker-alt"></i>
                    <span>Hoa Lac Hi-tech Park, Km29, Thang Long Boulevard, Thach Hoa, Thach That, Ha Noi, Vietnam</span>
                  </li>
                  <li>
                    <i class="fas fa-envelope"></i>
                    <a href="mailto:se1931Group@gmail.com">se1931Group@gmail.com</a>
                  </li>
                  <li>
                    <i class="fas fa-phone"></i>
                    <a href="tel:+84123456789">+84 123 456 789</a>
                  </li>
                </ul>
                
                <!-- Social Links -->
                <div class="social-links">
                  <a href="#"><i class="fab fa-facebook-f"></i></a>
                  <a href="#"><i class="fab fa-twitter"></i></a>
                  <a href="#"><i class="fab fa-linkedin-in"></i></a>
                  <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
              </div>
            </div>
          </div>

          <!-- Main Content -->
          <div class="col-lg-9">
            <!-- Back Button -->
            <a href="${pageContext.request.contextPath}/admin/subjects" class="back-btn">
              <i class="fas fa-arrow-left"></i> Back to Subjects
            </a>

            <!-- Subject Details Container -->
            <div class="subject-details-container">
              <!-- Hero Section -->
              <div class="subject-hero">
                <h1>${subject.title}</h1>
                <div class="subject-tagline">${subject.tag_line != null ? subject.tag_line : 'No tagline available'}</div>
                <div class="subject-brief">${subject.brief_info != null ? subject.brief_info : 'No brief information available'}</div>
              </div>

              <!-- Debug Section (remove in production) -->
              <div class="debug-section" style="background: #f8f9fa; padding: 20px; margin: 20px; border-radius: 10px; border: 2px dashed #007bff;">
                <h5><i class="fas fa-bug"></i> Debug Information</h5>
                <div style="font-family: monospace; font-size: 0.9rem;">
                  <p><strong>Subject ID:</strong> ${subject.id}</p>
                  <p><strong>Title:</strong> ${subject.title}</p>
                  <p><strong>Thumbnail URL:</strong> ${subject.thumbnail_url != null ? subject.thumbnail_url : 'NULL'}</p>
                  <p><strong>Video URL:</strong> ${subject.video_url != null ? subject.video_url : 'NULL'}</p>
                  <p><strong>Tag Line:</strong> ${subject.tag_line != null ? subject.tag_line : 'NULL'}</p>
                  <p><strong>Brief Info:</strong> ${subject.brief_info != null ? subject.brief_info : 'NULL'}</p>
                  <p><strong>Description:</strong> ${subject.description != null ? subject.description : 'NULL'}</p>
                  <p><strong>Status:</strong> ${subject.status}</p>
                  <p><strong>Category ID:</strong> ${subject.category_id}</p>
                </div>
              </div>

              <!-- Content Section -->
              <div class="subject-content">
                <div class="subject-info-grid">
                  <!-- Description -->
                  <div class="subject-description">
                    <h3><i class="fas fa-info-circle"></i> Description</h3>
                    <p>${subject.description != null ? subject.description : 'No description available for this subject.'}</p>
                  </div>

                  <!-- Price Packages -->
                  <div class="price-packages">
                    <h3><i class="fas fa-tags"></i> Best Value Package</h3>
                    <c:choose>
                      <c:when test="${lowestPricePackage != null}">
                        <div class="package-card featured-package">
                          <div class="package-badge">
                            <i class="fas fa-star"></i> Best Deal
                          </div>
                          <div class="package-name">${lowestPricePackage.name}</div>
                          <div class="package-price">
                            <span class="original-price">
                              <fmt:formatNumber value="${lowestPricePackage.list_price}" type="currency" currencySymbol="$" />
                            </span>
                            <span class="sale-price">
                              <fmt:formatNumber value="${lowestPricePackage.sale_price}" type="currency" currencySymbol="$" />
                            </span>
                            <c:set var="savings" value="${lowestPricePackage.list_price - lowestPricePackage.sale_price}" />
                            <c:if test="${savings > 0}">
                              <span class="savings-badge">
                                Save <fmt:formatNumber value="${savings}" type="currency" currencySymbol="$" />
                              </span>
                            </c:if>
                          </div>
                          <div class="package-duration">
                            <i class="fas fa-clock"></i> ${lowestPricePackage.access_duration_months} months access
                          </div>
                          <c:if test="${lowestPricePackage.description != null}">
                            <div class="package-description">
                              <p>${lowestPricePackage.description}</p>
                            </div>
                          </c:if>
                          <a href="${pageContext.request.contextPath}/admin/subject/register?id=${subject.id}&packageId=${lowestPricePackage.id}" 
                             class="register-btn">
                            <i class="fas fa-user-plus"></i> Register Now
                          </a>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="package-card">
                          <div class="package-name">No packages available</div>
                          <p style="color: #6c757d; text-align: center;">No price packages are currently available.</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>

                <!-- Media Section -->
                <div class="subject-media">
                  <!-- Thumbnail -->
                  <div class="media-section">
                    <h4><i class="fas fa-image"></i> Subject Thumbnail</h4>
                    <c:choose>
                      <c:when test="${subject.thumbnail_url != null && not empty subject.thumbnail_url}">
                        <div class="thumbnail-container">
                          <c:choose>
                            <c:when test="${fn:startsWith(subject.thumbnail_url, '/')}">
                              <img src="${pageContext.request.contextPath}${subject.thumbnail_url}" alt="${subject.title}" class="subject-thumbnail" 
                                   onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/common/img/courses/course_thumb01.jpg'; this.style.border='2px dashed #dc3545';">
                            </c:when>
                            <c:when test="${fn:startsWith(subject.thumbnail_url, 'http')}">
                              <img src="${subject.thumbnail_url}" alt="${subject.title}" class="subject-thumbnail" 
                                   onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/common/img/courses/course_thumb01.jpg'; this.style.border='2px dashed #dc3545';">
                            </c:when>
                            <c:otherwise>
                              <img src="${pageContext.request.contextPath}/${subject.thumbnail_url}" alt="${subject.title}" class="subject-thumbnail" 
                                   onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/view/common/img/courses/course_thumb01.jpg'; this.style.border='2px dashed #dc3545';">
                            </c:otherwise>
                          </c:choose>
                          <div class="image-debug-info">
                            <small>Image URL: ${subject.thumbnail_url}</small>
                            <br><small>Common patterns to try:</small>
                            <br><small>- /media/demoImages.png</small>
                            <br><small>- ${pageContext.request.contextPath}/media/demoImages.png</small>
                            <br><small>- /view/common/img/courses/course_thumb01.jpg</small>
                            <br><small>- ${pageContext.request.contextPath}/view/common/img/courses/course_thumb01.jpg</small>
                          </div>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-image-message">
                          <i class="fas fa-image"></i>
                          <p>No thumbnail available for this subject</p>
                          <small>Thumbnail URL: ${subject.thumbnail_url}</small>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <!-- Video -->
                  <div class="media-section">
                    <h4><i class="fas fa-video"></i> Subject Video</h4>
                    <c:choose>
                      <c:when test="${subject.video_url != null && not empty subject.video_url}">
                        <div class="video-container">
                          <c:choose>
                            <c:when test="${fn:contains(subject.video_url, 'youtube.com') || fn:contains(subject.video_url, 'youtu.be')}">
                              <!-- YouTube Video -->
                              <c:set var="videoId" value="" />
                              <c:choose>
                                <c:when test="${fn:contains(subject.video_url, 'youtube.com/watch?v=')}">
                                  <c:set var="videoId" value="${fn:substringAfter(subject.video_url, 'v=')}" />
                                  <c:if test="${fn:contains(videoId, '&')}">
                                    <c:set var="videoId" value="${fn:substringBefore(videoId, '&')}" />
                                  </c:if>
                                </c:when>
                                <c:when test="${fn:contains(subject.video_url, 'youtu.be/')}">
                                  <c:set var="videoId" value="${fn:substringAfter(subject.video_url, 'youtu.be/')}" />
                                </c:when>
                              </c:choose>
                              <iframe src="https://www.youtube.com/embed/${videoId}" 
                                      title="${subject.title}" 
                                      allowfullscreen>
                              </iframe>
                              <div class="video-debug-info">
                                <small>YouTube Video ID: ${videoId}</small><br>
                                <small>Original URL: ${subject.video_url}</small>
                              </div>
                            </c:when>
                            <c:when test="${fn:contains(subject.video_url, 'vimeo.com')}">
                              <!-- Vimeo Video -->
                              <c:set var="videoId" value="${fn:substringAfter(subject.video_url, 'vimeo.com/')}" />
                              <iframe src="https://player.vimeo.com/video/${videoId}" 
                                      title="${subject.title}" 
                                      allowfullscreen>
                              </iframe>
                              <div class="video-debug-info">
                                <small>Vimeo Video ID: ${videoId}</small><br>
                                <small>Original URL: ${subject.video_url}</small>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <!-- Direct Video File -->
                              <c:choose>
                                <c:when test="${fn:startsWith(subject.video_url, '/')}">
                                  <video controls width="100%" height="100%" 
                                         onerror="console.log('Video failed to load:', this.src); this.style.border='2px dashed #dc3545';"
                                         onloadstart="console.log('Video loading started:', this.src);"
                                         onloadeddata="console.log('Video loaded successfully:', this.src);">
                                    <source src="${pageContext.request.contextPath}${subject.video_url}" type="video/mp4">
                                    <source src="${pageContext.request.contextPath}${subject.video_url}" type="video/webm">
                                    <source src="${pageContext.request.contextPath}${subject.video_url}" type="video/ogg">
                                    Your browser does not support the video tag.
                                  </video>
                                </c:when>
                                <c:when test="${fn:startsWith(subject.video_url, 'http')}">
                                  <video controls width="100%" height="100%" 
                                         onerror="console.log('Video failed to load:', this.src); this.style.border='2px dashed #dc3545';"
                                         onloadstart="console.log('Video loading started:', this.src);"
                                         onloadeddata="console.log('Video loaded successfully:', this.src);">
                                    <source src="${subject.video_url}" type="video/mp4">
                                    <source src="${subject.video_url}" type="video/webm">
                                    <source src="${subject.video_url}" type="video/ogg">
                                    Your browser does not support the video tag.
                                  </video>
                                </c:when>
                                <c:otherwise>
                                  <video controls width="100%" height="100%" 
                                         onerror="console.log('Video failed to load:', this.src); this.style.border='2px dashed #dc3545';"
                                         onloadstart="console.log('Video loading started:', this.src);"
                                         onloadeddata="console.log('Video loaded successfully:', this.src);">
                                    <source src="${pageContext.request.contextPath}/${subject.video_url}" type="video/mp4">
                                    <source src="${pageContext.request.contextPath}/${subject.video_url}" type="video/webm">
                                    <source src="${pageContext.request.contextPath}/${subject.video_url}" type="video/ogg">
                                    Your browser does not support the video tag.
                                  </video>
                                </c:otherwise>
                              </c:choose>
                              <div class="video-debug-info">
                                <small>Direct Video URL: ${subject.video_url}</small>
                                <br><small>Constructed URL: ${pageContext.request.contextPath}${subject.video_url}</small>
                                <br><small>Context Path: ${pageContext.request.contextPath}</small>
                                <br><small>Common patterns to try:</small>
                                <br><small>- /media/demoVideo.mp4</small>
                                <br><small>- ${pageContext.request.contextPath}/media/demoVideo.mp4</small>
                                <br><small>- /media/skdaljw.mp4</small>
                                <br><small>- ${pageContext.request.contextPath}/media/skdaljw.mp4</small>
                                <br><small>Test direct link: <a href="${pageContext.request.contextPath}${subject.video_url}" target="_blank">Click here to test video URL</a></small>
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-video-message">
                          <i class="fas fa-video-slash"></i>
                          <p>No video available for this subject</p>
                          <small>Video URL: ${subject.video_url}</small>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- dashboard-area-end -->
</main>
<!-- main-area-end -->

<!-- footer-area -->
<jsp:include page="../../common/user/footer.jsp"></jsp:include>
<!-- footer-area-end -->

<!-- JS here -->
<jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
<script>
  SVGInject(document.querySelectorAll("img.injectable"));

  // Initialize tooltips
  $(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();
  });
</script>
</body>
</html>
