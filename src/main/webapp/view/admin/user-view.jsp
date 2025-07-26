<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>User Details - Admin Panel</title>
    <meta name="description" content="SkillGro - Online Courses & Education Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <style>
        .user-avatar {
            width: 150px;
            height: 150px;
            object-fit: cover;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 120px;
        }
        .info-value {
            color: #212529;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 6px 12px;
            border-radius: 20px;
        }
        .user-detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border: none;
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
    <!-- dashboard-area -->
    <section class="dashboard__area section-pb-120">
        <div class="dashboard__bg"><img src="assets/img/bg/dashboard_bg.jpg" alt=""></div>
        <div class="container-fluid">
            <div class="dashboard__inner-wrap">
                <div class="row">
                    <div class="col-lg-2">
                        <jsp:include page="adminSidebar.jsp">
                            <jsp:param name="active" value="users"/>
                        </jsp:include>
                    </div>
                    <div class="col-lg-10">
                        <div class="dashboard__content-wrap">
                            <div class="dashboard__content-title">
                                <h4 class="title">User Details</h4>
                            </div>

                            <!-- User Detail Card -->
                            <div class="user-detail-card">
                                <div class="card-header-custom">
                                    <h4 class="mb-0"><i class="fas fa-user-circle"></i> User Information</h4>
                                </div>
                                
                                <div class="card-body p-4">
                                    <!-- User Profile Section -->
                                    <div class="row mb-4">
                                        <div class="col-md-3 text-center">
                                            <c:choose>
                                                <c:when test="${not empty user.avatar_url}">
                                                    <img src="${pageContext.request.contextPath}${user.avatar_url}" 
                                                         alt="${user.full_name}" 
                                                         class="img-fluid rounded-circle user-avatar border border-3 border-primary">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center user-avatar mx-auto border border-3 border-secondary">
                                                        <i class="fas fa-user text-white" style="font-size: 4rem;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div class="mt-3">
                                                <span class="badge status-badge ${user.status == 'active' ? 'bg-success' : user.status == 'inactive' ? 'bg-danger' : 'bg-warning'}">
                                                    <i class="fas ${user.status == 'active' ? 'fa-check-circle' : user.status == 'inactive' ? 'fa-times-circle' : 'fa-clock'}"></i>
                                                    ${user.status}
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-9">
                                            <h2 class="text-primary mb-1">${user.full_name}</h2>
                                            <h5 class="text-muted mb-3">
                                                <i class="fas fa-user-tag"></i> 
                                                ${not empty userRole ? userRole.name : 'No Role Assigned'}
                                            </h5>
                                            
                                            <div class="info-card">
                                                <h6 class="text-primary mb-3"><i class="fas fa-info-circle"></i> Basic Information</h6>
                                                
                                                <div class="info-row">
                                                    <span class="info-label"><i class="fas fa-hashtag"></i> User ID:</span>
                                                    <span class="info-value"><strong>#${user.id}</strong></span>
                                                </div>
                                                
                                                <div class="info-row">
                                                    <span class="info-label"><i class="fas fa-envelope"></i> Email:</span>
                                                    <span class="info-value">${user.email}</span>
                                                </div>
                                                
                                                <div class="info-row">
                                                    <span class="info-label"><i class="fas fa-venus-mars"></i> Gender:</span>
                                                    <span class="info-value">
                                                        <c:choose>
                                                            <c:when test="${user.gender == 1}">
                                                                <i class="fas fa-mars text-primary"></i> Male
                                                            </c:when>
                                                            <c:when test="${user.gender == 0}">
                                                                <i class="fas fa-venus text-danger"></i> Female
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-question-circle text-muted"></i> Not specified
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                
                                                <div class="info-row">
                                                    <span class="info-label"><i class="fas fa-phone"></i> Mobile:</span>
                                                    <span class="info-value">
                                                        ${not empty user.mobile ? user.mobile : '<span class="text-muted">Not specified</span>'}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Admin Note -->
                                    <div class="alert alert-info mt-3">
                                        <i class="fas fa-info-circle"></i>
                                        <strong>Admin Note:</strong> As an administrator, you can only modify the user's role and status. 
                                        Other user information must be updated by the user themselves or through other administrative processes.
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="text-center mt-4">
                                        <a href="${pageContext.request.contextPath}/admin/users" 
                                           class="btn btn-secondary me-3">
                                            <i class="fas fa-list"></i> Back to User List
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.id}" 
                                           class="btn btn-warning">
                                            <i class="fas fa-edit"></i> Edit Role & Status
                                        </a>
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
<jsp:include page="../common/user/footer.jsp"></jsp:include>
<!-- footer-area-end -->

<!-- JS here -->
<jsp:include page="../common/user/link_js_common.jsp"></jsp:include>

<script>
    SVGInject(document.querySelectorAll("img.injectable"));
</script>
</body>
</html>