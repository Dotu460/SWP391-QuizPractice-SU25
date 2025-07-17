<%-- 
    Document   : slider-edit
    Created on : Jun 23, 2025, 1:15:24 PM
    Author     : kenngoc
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Edit Slider</title>
    <meta name="description" content="SkillGro - Edit Slider">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for form styling -->
    <style>
        .edit-form-card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .edit-form-card .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .edit-form-card .card-body {
            padding: 25px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h5 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            color: #343a40;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-control {
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 10px 12px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .btn-group {
            gap: 10px;
        }
        
        .required {
            color: #dc3545;
        }
        
        .alert {
            border-radius: 4px;
            margin-bottom: 20px;
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
                                            <h4 class="title">Edit Slider</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/slider-list?${returnQueryString}" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to Slider List
                                        </a>
                                    </div>
                                </div>

                                <!-- Error Messages -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Edit Form Card -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card edit-form-card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Edit Slider #${slider.id} - ${slider.title}</h5>
                                            </div>
                                            <div class="card-body">
                                                <form method="post" action="${pageContext.request.contextPath}/slider-list">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="id" value="${slider.id}">
                                                    <input type="hidden" name="returnQueryString" value="${returnQueryString}">
                                                    
                                                    <!-- Slider Information Section -->
                                                    <div class="form-section">
                                                        <h5>Slider Details</h5>
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <div class="form-group">
                                                                    <label for="title" class="form-label">Title <span class="required">*</span></label>
                                                                    <input type="text" class="form-control" id="title" name="title" 
                                                                           value="${slider.title}" required>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <div class="form-group">
                                                                    <label for="image_url" class="form-label">Image URL <span class="required">*</span></label>
                                                                    <input type="text" class="form-control" id="image_url" name="image_url" 
                                                                           value="${slider.image_url}" required>
                                                                    <small class="text-muted">Example: /assets/banner/your-image.png</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <div class="form-group">
                                                                    <label for="backlink_url" class="form-label">Backlink URL <span class="required">*</span></label>
                                                                    <input type="text" class="form-control" id="backlink_url" name="backlink_url" 
                                                                           value="${slider.backlink_url}" required>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="status" class="form-label">Status <span class="required">*</span></label>
                                                                    <select class="form-control" id="status" name="status" required>
                                                                        <option value="">Select Status</option>
                                                                        <option value="active" ${slider.status ? 'selected' : ''}>Active</option>
                                                                        <option value="inactive" ${!slider.status ? 'selected' : ''}>Inactive</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-12">
                                                                <div class="form-group">
                                                                    <label for="notes" class="form-label">Notes</label>
                                                                    <textarea class="form-control" id="notes" name="notes" rows="3">${slider.notes}</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Action Buttons -->
                                                    <div class="text-end btn-group">
                                                        <a href="${pageContext.request.contextPath}/slider-list?${returnQueryString}" class="btn btn-secondary">
                                                            <i class="fa fa-times"></i> Cancel
                                                        </a>
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="fa fa-save"></i> Update Slider
                                                        </button>
                                                    </div>
                                                </form>
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
