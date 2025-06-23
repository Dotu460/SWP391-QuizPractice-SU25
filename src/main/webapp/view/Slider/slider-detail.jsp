<%-- 
    Document   : slider-detail
    Created on : Jun 20, 2025, 2:59:16 PM
    Author     : kenngoc
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Slider Details</title>
    <meta name="description" content="SkillGro - Slider Details">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for status indicators -->
    <style>
        .slider-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #e6f7e6;
            color: #28a745;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #dc3545;
        }
        
        .details-card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .details-card .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .details-card .card-body {
            padding: 25px;
        }
        
        .details-section {
            margin-bottom: 30px;
        }
        
        .details-section h5 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            color: #343a40;
        }
        
        .info-row {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #212529;
        }
        
        .action-button {
            margin-right: 10px;
            padding: 8px 16px;
            border-radius: 4px;
        }
        
        .slider-image-preview {
            max-width: 100%;
            max-height: 250px;
            border-radius: 8px;
            margin-top: 10px;
            border: 1px solid #dee2e6;
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
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../common/user/sidebarCustomer.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Slider Details</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/slider-list?${returnQueryString}" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to Slider List
                                        </a>
                                    </div>
                                </div>

                                <!-- Slider Detail Card -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card details-card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Slider #${slider.id} - ${slider.title}</h5>
                                            </div>
                                            <div class="card-body">
                                                <!-- Status Badge -->
                                                <div class="text-end mb-4">
                                                    <span class="slider-status ${slider.status ? 'status-active' : 'status-inactive'}">
                                                        ${slider.status ? 'Active' : 'Inactive'}
                                                    </span>
                                                </div>
                                                
                                                <!-- Slider Information Section -->
                                                <div class="details-section">
                                                    <h5>Slider Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Slider ID</div>
                                                                <div class="info-value">${slider.id}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Title</div>
                                                                <div class="info-value">${slider.title}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-12">
                                                            <div class="info-row">
                                                                <div class="info-label">Backlink URL</div>
                                                                <div class="info-value">
                                                                    <a href="${slider.backlink_url}" target="_blank">${slider.backlink_url}</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <div class="info-row">
                                                                <div class="info-label">Notes</div>
                                                                <div class="info-value">
                                                                    <c:choose>
                                                                        <c:when test="${not empty slider.notes}">
                                                                            <p style="white-space: pre-wrap;">${slider.notes}</p>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">No notes provided</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Image Preview Section -->
                                                <div class="details-section">
                                                    <h5>Image Preview</h5>
                                                    <div class="row">
                                                        <div class="col-12 text-center">
                                                            <img src="${pageContext.request.contextPath}${slider.image_url}" 
                                                                 alt="Slider Image for ${slider.title}" 
                                                                 class="slider-image-preview">
                                                            <div class="info-row mt-2">
                                                                <div class="info-label">Image URL</div>
                                                                <div class="info-value">${slider.image_url}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Action Buttons Section -->
                                                <div class="mt-4 text-end">
                                                    <a href="${pageContext.request.contextPath}/slider-list?action=edit&id=${slider.id}&${returnQueryString}" class="btn btn-warning action-button">
                                                        <i class="fa fa-edit"></i> Edit Slider
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
    <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
</body>

</html>
