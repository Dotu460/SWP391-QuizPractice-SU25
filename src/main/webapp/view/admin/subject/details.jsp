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
      margin-left: 0;
      margin-right: 0;
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

    .subject-description-full {
      background: #f8f9fa;
      padding: 30px;
      border-radius: 10px;
      border-left: 4px solid #3f78e0;
      margin-bottom: 30px;
      width: 100%;
    }

    .subject-description-full h3 {
      color: #3f78e0;
      margin-bottom: 20px;
      font-weight: 600;
    }

    .subject-description-full p {
      line-height: 1.6;
      color: #333;
      margin: 0;
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
      padding: 15px;
      margin-bottom: 12px;
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
      font-size: 1rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 8px;
    }

    .package-price {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
      flex-wrap: wrap;
    }

    .original-price {
      text-decoration: line-through;
      color: #6c757d;
      font-size: 1rem;
    }

    .sale-price {
      font-size: 1.3rem;
      font-weight: 700;
      color: #28a745;
    }

    .savings-badge {
      background: #dc3545;
      color: white;
      padding: 3px 6px;
      border-radius: 10px;
      font-size: 0.75rem;
      font-weight: 600;
      margin-left: 8px;
    }

    .package-duration {
      color: #6c757d;
      font-size: 0.85rem;
      margin-bottom: 0;
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

    /* Media Gallery Styles */
    .media-gallery {
      margin-top: 30px;
    }

    .media-section {
      margin-bottom: 40px;
      background: #f8f9fa;
      border-radius: 15px;
      padding: 25px;
      border: 2px solid #e9ecef;
    }

    .media-section h4 {
      color: #333;
      margin-bottom: 20px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .media-section h4 i {
      color: #3f78e0;
    }

    .media-viewer {
      position: relative;
      background: #fff;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .media-display {
      position: relative;
      text-align: center;
      margin-bottom: 20px;
    }

    .media-image {
      max-width: 100%;
      height: auto;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      transition: all 0.3s ease;
    }

    .media-image:hover {
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
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .video-container iframe,
    .video-container video {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: none;
      border-radius: 10px;
    }

    .media-notes {
      background: #e7f3ff;
      border: 1px solid #b3d9ff;
      border-radius: 8px;
      padding: 15px;
      margin-top: 15px;
      border-left: 4px solid #3f78e0;
    }

    .media-notes h6 {
      color: #0066cc;
      margin-bottom: 8px;
      font-weight: 600;
    }

    .media-notes p {
      margin: 0;
      color: #004080;
      font-size: 0.9rem;
      line-height: 1.5;
    }

    .media-navigation {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 15px;
      margin-top: 20px;
    }

    .nav-btn {
      background: #3f78e0;
      color: white;
      border: none;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 1.2rem;
    }

    .nav-btn:hover {
      background: #2c5ec1;
      transform: scale(1.1);
    }

    .nav-btn:disabled {
      background: #6c757d;
      cursor: not-allowed;
      transform: none;
    }

    .media-counter {
      background: #fff;
      border: 2px solid #3f78e0;
      border-radius: 20px;
      padding: 8px 15px;
      font-weight: 600;
      color: #3f78e0;
      min-width: 80px;
      text-align: center;
    }

    .media-thumbnails {
      display: flex;
      gap: 10px;
      margin-top: 15px;
      overflow-x: auto;
      padding: 10px 0;
    }

    .media-thumbnail {
      width: 80px;
      height: 60px;
      border-radius: 5px;
      object-fit: cover;
      cursor: pointer;
      border: 2px solid transparent;
      transition: all 0.3s ease;
    }

    .media-thumbnail:hover {
      border-color: #3f78e0;
      transform: scale(1.05);
    }

    .media-thumbnail.active {
      border-color: #28a745;
      box-shadow: 0 0 10px rgba(40, 167, 69, 0.3);
    }

    .no-media-message {
      text-align: center;
      padding: 40px 20px;
      background: #f8f9fa;
      border-radius: 10px;
      border: 2px dashed #dee2e6;
      color: #6c757d;
    }

    .no-media-message i {
      font-size: 3rem;
      margin-bottom: 15px;
    }

    .no-media-message p {
      margin: 0;
      font-size: 1.1rem;
    }

    /* Sidebar Styles */
    .subject-sidebar {
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0,0,0,0.1);
      padding: 25px;
      margin-bottom: 30px;
      margin-left: 0;
      margin-right: 0;
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

      .media-navigation {
        flex-wrap: wrap;
        gap: 10px;
      }

      .media-thumbnails {
        justify-content: center;
      }
    }

    /* Full width layout adjustments */
    @media (min-width: 1200px) {
      .container-fluid {
        padding-left: 30px !important;
        padding-right: 30px !important;
      }
    }

    @media (min-width: 1400px) {
      .container-fluid {
        padding-left: 40px !important;
        padding-right: 40px !important;
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
    <div class="container-fluid" style="padding: 0 20px;">
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
          <div class="col-lg-6">
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

              <!-- Content Section -->
              <div class="subject-content">
                <!-- Media Gallery -->
                <div class="media-gallery">
                  <!-- Images Section -->
                  <div class="media-section">
                    <h4><i class="fas fa-images"></i> Course Images</h4>
                    <c:choose>
                      <c:when test="${not empty subjectImages}">
                        <div class="media-viewer" id="imageViewer">
                          <div class="media-display">
                            <img id="currentImage" src="${subjectImages[0].link}" alt="Course Image" class="media-image">
                          </div>
                          
                          <div class="media-notes" id="currentImageNotes">
                            <h6>Image Notes:</h6>
                            <p id="imageNotesText">${subjectImages[0].notes != null ? subjectImages[0].notes : 'No notes available'}</p>
                          </div>
                          
                          <div class="media-navigation">
                            <button class="nav-btn" id="prevImageBtn" onclick="changeImage(-1)">
                              <i class="fas fa-chevron-left"></i>
                            </button>
                            <div class="media-counter">
                              <span id="currentImageIndex">1</span> / <span id="totalImages">${fn:length(subjectImages)}</span>
                            </div>
                            <button class="nav-btn" id="nextImageBtn" onclick="changeImage(1)">
                              <i class="fas fa-chevron-right"></i>
                            </button>
                          </div>
                          
                          <div class="media-thumbnails">
                            <c:forEach var="image" items="${subjectImages}" varStatus="status">
                              <img src="${image.link}" alt="Thumbnail ${status.index + 1}" 
                                   class="media-thumbnail ${status.index == 0 ? 'active' : ''}" 
                                   onclick="showImage(${status.index})">
                            </c:forEach>
                          </div>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-media-message">
                          <i class="fas fa-image"></i>
                          <p>No images available for this course</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <!-- Videos Section -->
                  <div class="media-section">
                    <h4><i class="fas fa-video"></i> Course Videos</h4>
                    <c:choose>
                      <c:when test="${not empty subjectVideos}">
                        <div class="media-viewer" id="videoViewer">
                          <div class="media-display">
                            <div id="currentVideoContainer" class="video-container">
                              <!-- Video will be loaded here -->
                            </div>
                          </div>
                          
                          <div class="media-notes" id="currentVideoNotes">
                            <h6>Video Notes:</h6>
                            <p id="videoNotesText">${subjectVideos[0].notes != null ? subjectVideos[0].notes : 'No notes available'}</p>
                          </div>
                          
                          <div class="media-navigation">
                            <button class="nav-btn" id="prevVideoBtn" onclick="changeVideo(-1)">
                              <i class="fas fa-chevron-left"></i>
                            </button>
                            <div class="media-counter">
                              <span id="currentVideoIndex">1</span> / <span id="totalVideos">${fn:length(subjectVideos)}</span>
                            </div>
                            <button class="nav-btn" id="nextVideoBtn" onclick="changeVideo(1)">
                              <i class="fas fa-chevron-right"></i>
                            </button>
                          </div>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-media-message">
                          <i class="fas fa-video-slash"></i>
                          <p>No videos available for this course</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>

                <!-- Description Section - Full Width -->
                <div class="subject-description-full">
                  <h3><i class="fas fa-info-circle"></i> Description</h3>
                  <p>${subject.description != null ? subject.description : 'No description available for this subject.'}</p>
                </div>
              </div>
            </div>
          </div>

                        <!-- Right Sidebar - Price Packages -->
              <div class="col-lg-3">
                <div class="subject-sidebar">
                  <!-- Price Packages Section -->
                  <div class="sidebar-section">
                    <h4><i class="fas fa-tags"></i> Price Packages</h4>
                    <c:choose>
                      <c:when test="${not empty subjectPricePackages}">
                        <c:forEach var="pkg" items="${subjectPricePackages}" varStatus="status">
                          <div class="package-card ${status.index == 0 ? 'featured-package' : ''}">
                            <c:if test="${status.index == 0}">
                              <div class="package-badge">
                                <i class="fas fa-star"></i> Best Deal
                              </div>
                            </c:if>
                            <div class="package-name">${pkg.name}</div>
                            <div class="package-price">
                              <span class="original-price">
                                <fmt:formatNumber value="${pkg.list_price}" type="currency" currencySymbol="$" />
                              </span>
                              <span class="sale-price">
                                <fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="$" />
                              </span>
                              <c:set var="savings" value="${pkg.list_price - pkg.sale_price}" />
                              <c:if test="${savings > 0}">
                                <span class="savings-badge">
                                  Save <fmt:formatNumber value="${savings}" type="currency" currencySymbol="$" />
                                </span>
                              </c:if>
                            </div>
                            <div class="package-duration">
                              <i class="fas fa-clock"></i> ${pkg.access_duration_months} months access
                            </div>
                          </div>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <div class="package-card">
                          <div class="package-name">No packages available</div>
                          <p style="color: #6c757d; text-align: center;">No price packages are currently available for this course.</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
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

<!-- Hidden data containers for JavaScript -->
<div id="imageData" style="display: none;">
  <c:forEach var="image" items="${subjectImages}" varStatus="status">
    <div class="image-data" data-link="${image.link}" data-notes="${image.notes != null ? image.notes : 'No notes available'}"></div>
  </c:forEach>
</div>
<div id="videoData" style="display: none;">
  <c:forEach var="video" items="${subjectVideos}" varStatus="status">
    <div class="video-data" data-link="${video.link}" data-notes="${video.notes != null ? video.notes : 'No notes available'}"></div>
  </c:forEach>
</div>

<!-- JavaScript for Media Navigation -->
<script>
  // Image data from server
  const images = [];
  document.querySelectorAll('.image-data').forEach(function(element) {
    images.push({
      link: element.getAttribute('data-link'),
      notes: element.getAttribute('data-notes')
    });
  });
  
  // Video data from server
  const videos = [];
  document.querySelectorAll('.video-data').forEach(function(element) {
    videos.push({
      link: element.getAttribute('data-link'),
      notes: element.getAttribute('data-notes')
    });
  });
  
  let currentImageIndex = 0;
  let currentVideoIndex = 0;
  
  // Image navigation functions
  function changeImage(direction) {
    currentImageIndex += direction;
    
    if (currentImageIndex < 0) {
      currentImageIndex = images.length - 1;
    } else if (currentImageIndex >= images.length) {
      currentImageIndex = 0;
    }
    
    showImage(currentImageIndex);
  }
  
  function showImage(index) {
    if (index >= 0 && index < images.length) {
      currentImageIndex = index;
      
      // Update image
      document.getElementById('currentImage').src = images[index].link;
      document.getElementById('imageNotesText').textContent = images[index].notes;
      
      // Update counter
      document.getElementById('currentImageIndex').textContent = index + 1;
      
      // Update thumbnails
      const thumbnails = document.querySelectorAll('.media-thumbnail');
      thumbnails.forEach((thumb, i) => {
        thumb.classList.toggle('active', i === index);
      });
      
      // Update navigation buttons
      document.getElementById('prevImageBtn').disabled = images.length <= 1;
      document.getElementById('nextImageBtn').disabled = images.length <= 1;
    }
  }
  
  // Video navigation functions
  function changeVideo(direction) {
    currentVideoIndex += direction;
    
    if (currentVideoIndex < 0) {
      currentVideoIndex = videos.length - 1;
    } else if (currentVideoIndex >= videos.length) {
      currentVideoIndex = 0;
    }
    
    showVideo(currentVideoIndex);
  }
  
  function showVideo(index) {
    if (index >= 0 && index < videos.length) {
      currentVideoIndex = index;
      const video = videos[index];
      
      // Update video container
      const container = document.getElementById('currentVideoContainer');
      let videoHtml = '';
      
      if (video.link.includes('youtube.com') || video.link.includes('youtu.be')) {
        // YouTube video
        let videoId = '';
        if (video.link.includes('youtube.com/watch?v=')) {
          videoId = video.link.split('v=')[1].split('&')[0];
        } else if (video.link.includes('youtu.be/')) {
          videoId = video.link.split('youtu.be/')[1];
        }
        videoHtml = '<iframe src="https://www.youtube.com/embed/' + videoId + '" title="Course Video" allowfullscreen></iframe>';
      } else if (video.link.includes('vimeo.com')) {
        // Vimeo video
        const videoId = video.link.split('vimeo.com/')[1];
        videoHtml = '<iframe src="https://player.vimeo.com/video/' + videoId + '" title="Course Video" allowfullscreen></iframe>';
      } else {
        // Direct video file
        videoHtml = '<video controls><source src="' + video.link + '" type="video/mp4"><source src="' + video.link + '" type="video/webm">Your browser does not support the video tag.</video>';
      }
      
      container.innerHTML = videoHtml;
      
      // Update notes
      document.getElementById('videoNotesText').textContent = video.notes;
      
      // Update counter
      document.getElementById('currentVideoIndex').textContent = index + 1;
      
      // Update navigation buttons
      document.getElementById('prevVideoBtn').disabled = videos.length <= 1;
      document.getElementById('nextVideoBtn').disabled = videos.length <= 1;
    }
  }
  
  // Initialize when page loads
  document.addEventListener('DOMContentLoaded', function() {
    // Initialize image viewer
    if (images.length > 0) {
      showImage(0);
    }
    
    // Initialize video viewer
    if (videos.length > 0) {
      showVideo(0);
    }
    
    // Initialize tooltips
    if (typeof $ !== 'undefined') {
      $('[data-toggle="tooltip"]').tooltip();
    }
  });
  
  // Keyboard navigation
  document.addEventListener('keydown', function(e) {
    if (e.key === 'ArrowLeft') {
      changeImage(-1);
    } else if (e.key === 'ArrowRight') {
      changeImage(1);
    }
  });
</script>

<!-- JS here -->
<jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
<script>
  if (typeof SVGInject !== 'undefined') {
    SVGInject(document.querySelectorAll("img.injectable"));
  }
</script>
</body>
</html>
