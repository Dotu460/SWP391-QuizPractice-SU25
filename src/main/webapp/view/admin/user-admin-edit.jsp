<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
"From the Subjects List screen, the user can click to edit or delete an existing course subject
When editing, the user can update fields such as name, images with notes, videos with notes, category, featured flag, owner, status, and description


When deleting, a confirmation dialog is shown. If the subject is linked to active registrations, the system may block the deletion and show a warning


After saving or deleting, the Subjects List is updated accordingly"
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Edit User Role & Status - Admin Panel</title>
    <meta name="description" content="SkillGro - Online Courses & Education Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <style>
        .user-info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }
        .form-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
        .form-control:focus, .form-select:focus {
            border-color: #f39c12;
            box-shadow: 0 0 0 0.2rem rgba(243, 156, 18, 0.25);
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
                                <h4 class="title">Edit User Role & Status</h4>
                            </div>

                            <!-- User Information Display (Read-only) -->
                            <div class="user-info-card mb-4">
                                <h6 class="text-primary mb-3"><i class="fas fa-info-circle"></i> User Information (Read-only)</h6>
                                <div class="row align-items-center">
                                    <div class="col-md-2 text-center">
                                        <c:choose>
                                            <c:when test="${not empty user.avatar_url}">
                                                <img src="${pageContext.request.contextPath}${user.avatar_url}" 
                                                     alt="${user.full_name}" 
                                                     class="img-fluid rounded-circle user-avatar border border-2 border-primary">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center user-avatar mx-auto">
                                                    <i class="fas fa-user text-white" style="font-size: 2rem;"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-10">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong>Full Name:</strong> ${user.full_name}<br>
                                                <strong>Email:</strong> ${user.email}<br>
                                                <strong>User ID:</strong> #${user.id}
                                            </div>
                                            <div class="col-md-6">
                                                <strong>Gender:</strong> 
                                                <c:choose>
                                                    <c:when test="${user.gender == 1}">Male</c:when>
                                                    <c:when test="${user.gender == 0}">Female</c:when>
                                                    <c:otherwise>Not specified</c:otherwise>
                                                </c:choose><br>
                                                <strong>Mobile:</strong> ${not empty user.mobile ? user.mobile : 'Not specified'}<br>
                                                <strong>Current Role:</strong> 
                                                <span class="badge bg-primary">
                                                    ${not empty userRole ? userRole.role_name : 'Unknown Role'}
                                                </span><br>
                                                <strong>Current Status:</strong> 
                                                <span class="badge ${user.status == 'active' ? 'bg-success' : user.status == 'inactive' ? 'bg-danger' : 'bg-warning'}">
                                                    ${user.status}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Edit Form -->
                            <div class="form-section">
                                <h6 class="text-danger mb-3">
                                    <i class="fas fa-exclamation-triangle"></i> Admin Edit Permissions
                                </h6>
                                <div class="alert alert-warning">
                                    <strong>Notice:</strong> As an administrator, you can only modify the user's <strong>Role</strong> and <strong>Status</strong>. 
                                    All other user information is read-only and must be updated by the user themselves.
                                </div>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-circle"></i> ${error}
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/admin/user" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="userId" value="${user.id}">

                                    <div class="row">
                                        <!-- Role Selection -->
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="roleId" class="form-label">
                                                    <i class="fas fa-user-tag"></i> User Role <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="roleId" name="roleId" required>
                                                    <option value="">Select Role</option>
                                                    <c:forEach var="role" items="${roles}">
                                                        <option value="${role.id}" ${user.role_id == role.id ? 'selected' : ''}>
                                                            ${role.role_name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- Status Selection -->
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="status" class="form-label">
                                                    <i class="fas fa-toggle-on"></i> Account Status <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="status" name="status" required>
                                                    <option value="">Select Status</option>
                                                    <option value="active" ${user.status == 'active' ? 'selected' : ''}>
                                                        Active
                                                    </option>
                                                    <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>
                                                        Inactive
                                                    </option>
                                                    <option value="suspended" ${user.status == 'suspended' ? 'selected' : ''}>
                                                        Suspended
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form Actions -->
                                    <div class="d-flex justify-content-between mt-4">
                                        <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" 
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left"></i> Back to View
                                        </a>
                                        
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-save"></i> Update Role & Status
                                        </button>
                                    </div>
                                </form>
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
<jsp:include page="../common/js/"></jsp:include>

<script>
    SVGInject(document.querySelectorAll("img.injectable"));

    // Form validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const roleSelect = document.getElementById('roleId');
        const statusSelect = document.getElementById('status');
        
        if (!roleSelect.value || !statusSelect.value) {
            e.preventDefault();
            alert('Please select both Role and Status before submitting.');
            return false;
        }
    });

    // Highlight changes
    document.getElementById('roleId').addEventListener('change', function() {
        this.style.borderColor = '#f39c12';
        this.style.boxShadow = '0 0 0 0.2rem rgba(243, 156, 18, 0.25)';
    });

    document.getElementById('status').addEventListener('change', function() {
        this.style.borderColor = '#f39c12';
        this.style.boxShadow = '0 0 0 0.2rem rgba(243, 156, 18, 0.25)';
    });
</script>
</body>
</html> 