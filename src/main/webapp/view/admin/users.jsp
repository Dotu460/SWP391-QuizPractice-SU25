<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>User Management - SkillGro Dashboard</title>
    <meta name="description" content="SkillGro - Online Courses & Education Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for this page -->
    <style>
        .dashboard__users-filter {
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        .dashboard__users-filter form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .dashboard__users-filter .form-group {
            flex: 1;
            min-width: 180px;
        }

        .dashboard__users-filter label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .dashboard__users-filter select,
        .dashboard__users-filter input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
        }

        .dashboard__users-filter button {
            padding: 12px 25px;
            background-color: #3f78e0;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .dashboard__users-filter button:hover {
            background-color: #2c5ec1;
        }

        .dashboard__actions {
            display: flex;
            justify-content: space-between;
            margin-bottom: 25px;
            align-items: center;
        }

        .add-user-btn {
            padding: 12px 25px;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .add-user-btn:hover {
            background-color: #3d9640;
            color: white;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 10px;
        }

        .pagination a {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            color: #3f78e0;
            transition: all 0.3s ease;
        }

        .pagination a:hover {
            background-color: #3f78e0;
            color: white;
        }

        .pagination span {
            padding: 8px 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }

        .user-action-link {
            padding: 5px 10px;
            border-radius: 4px;
            margin-right: 5px;
            display: inline-block;
            color: white;
            text-align: center;
            font-size: 14px;
        }

        .edit-link {
            background-color: #3f78e0;
        }

        .view-link {
            background-color: #6c757d;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }

        .status-active {
            background-color: #d1f7c4;
            color: #389b10;
        }

        .status-inactive {
            background-color: #ffe0e0;
            color: #d03030;
        }



        .table-header-sortable {
            cursor: pointer;
            user-select: none;
        }

        .table-header-sortable:hover {
            background-color: #f8f9fa;
        }

        .table-header-sortable i {
            margin-left: 5px;
        }

        .alert-custom {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            border-left: 4px solid;
        }

        .alert-success-custom {
            background-color: #d1f7c4;
            border-left-color: #389b10;
            color: #389b10;
        }

        .alert-danger-custom {
            background-color: #ffe0e0;
            border-left-color: #d03030;
            color: #d03030;
        }

        .page-size-selector {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }

        .page-size-selector select {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        /* Alert styling */
        .alert-custom {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            border-left: 4px solid;
        }

        .alert-success-custom {
            background-color: #d4edda;
            border-left-color: #28a745;
            color: #155724;
        }

        .alert-danger-custom {
            background-color: #f8d7da;
            border-left-color: #dc3545;
            color: #721c24;
        }

        .alert-info-custom {
            background-color: #e3f2fd;
            border-left-color: #2196f3;
            color: #0d47a1;
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
        <div class="dashboard__bg"><img src="../common/assets/img/bg/dashboard_bg.jpg" alt=""></div>
        <div class="container-fluid" style="padding: 0 20px;">
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
                                <h4 class="title">User Management</h4>
                            </div>

                            <!-- Alert messages for actions -->
                            <c:if test="${param.success != null}">
                                <div class="alert-custom alert-success-custom">
                                    <c:choose>
                                        <c:when test="${param.success eq 'userAdded'}">User added successfully!</c:when>
                                        <c:when test="${param.success eq 'userAddedWithEmail'}">
                                            User added successfully! Welcome email with login credentials has been sent.
                                        </c:when>
                                        <c:when test="${param.success eq 'userAddedNoEmail'}">
                                            User added successfully! However, email sending failed. Please contact the user directly.
                                        </c:when>
                                        <c:when test="${param.success eq 'userUpdated'}">User updated successfully!</c:when>
                                        <c:otherwise>Operation completed successfully!</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>



                            <c:if test="${param.error != null}">
                                <div class="alert-custom alert-danger-custom">
                                    <c:choose>
                                        <c:when test="${param.error eq 'userNotFound'}">User not found!</c:when>
                                        <c:when test="${param.error eq 'invalidId'}">Invalid user ID!</c:when>
                                        <c:when test="${param.error eq 'invalidData'}">Invalid user data!</c:when>
                                        <c:otherwise>An error occurred!</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <!-- Filters Section -->
                            <div class="dashboard__users-filter">
                                <form action="${pageContext.request.contextPath}/admin/users" method="get">
                                    <div class="form-group">
                                        <label for="gender">Gender:</label>
                                        <select name="gender" id="gender" class="form-select">
                                            <option value="">All Genders</option>
                                            <option value="male" ${genderFilter eq 'male' ? 'selected' : ''}>Male</option>
                                            <option value="female" ${genderFilter eq 'female' ? 'selected' : ''}>Female</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="role">Role:</label>
                                        <select name="role" id="role" class="form-select">
                                            <option value="">All Roles</option>
                                            <c:forEach items="${roles}" var="role">
                                                <option value="${role.id}" ${roleFilter eq role.id.toString() ? 'selected' : ''}>${role.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status:</label>
                                        <select name="status" id="status" class="form-select">
                                            <option value="">All Status</option>
                                            <option value="active" ${statusFilter eq 'active' ? 'selected' : ''}>Active</option>
                                            <option value="inactive" ${statusFilter eq 'inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="search">Search:</label>
                                        <input type="text" id="search" name="search" placeholder="Name, Email, Mobile..." value="${searchTerm}" class="form-control">
                                    </div>

                                    <!-- Hidden fields to preserve sorting and pagination -->
                                    <input type="hidden" name="sortBy" value="${sortBy}">
                                    <input type="hidden" name="sortOrder" value="${sortOrder}">
                                    <input type="hidden" name="page" value="1">

                                    <button type="submit" class="btn">Apply Filters</button>
                                </form>
                            </div>

                            <!-- Add User Button -->
                            <div class="dashboard__actions">
                                <h5>Total Users: <span class="text-primary">${users.size()}</span></h5>
                                <a href="${pageContext.request.contextPath}/admin/user?action=add" class="add-user-btn">
                                    <i class="fas fa-plus"></i> Add New User
                                </a>
                            </div>

                            <!-- Users Table -->
                            <div class="dashboard__review-table table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th class="table-header-sortable" onclick="sortTable('id')">
                                            ID
                                            <c:if test="${sortBy eq 'id'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('full_name')">
                                            Full Name
                                            <c:if test="${sortBy eq 'full_name'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('gender')">
                                            Gender
                                            <c:if test="${sortBy eq 'gender'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('email')">
                                            Email
                                            <c:if test="${sortBy eq 'email'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('mobile')">
                                            Mobile
                                            <c:if test="${sortBy eq 'mobile'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('role')">
                                            Role
                                            <c:if test="${sortBy eq 'role'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th class="table-header-sortable" onclick="sortTable('status')">
                                            Status
                                            <c:if test="${sortBy eq 'status'}">
                                                <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                            </c:if>
                                        </th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>
                                                <div class="dashboard__quiz-info">
                                                    <h6 class="title">${user.full_name}</h6>
                                                </div>
                                            </td>
                                            <td>${user.gender == 1 ? 'Male' : 'Female'}</td>
                                            <td>${user.email}</td>
                                            <td>${user.mobile}</td>
                                            <td>
                                                <c:forEach items="${roles}" var="role">
                                                    <c:if test="${role.id == user.role_id}">${role.name}</c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status eq 'active'}">
                                                        <span class="status-badge status-active">Active</span>
                                                    </c:when>
                                                    <c:when test="${user.status eq 'inactive'}">
                                                        <span class="status-badge status-inactive">Inactive</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">Unknown</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="dashboard__review-action">
                                                    <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.id}" class="user-action-link edit-link" title="Edit"><i class="skillgro-edit"></i> Edit</a>
                                                    <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="user-action-link view-link" title="View"><i class="skillgro-book-2"></i> View</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="8" class="text-center">No users found</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 0}">
                                <div class="pagination">
                                    <c:if test="${page > 1}">
                                        <a href="#" onclick="gotoPage(${page - 1})">
                                            <i class="fas fa-chevron-left"></i> Previous
                                        </a>
                                    </c:if>

                                    <span>Page ${page} of ${totalPages}</span>

                                    <c:if test="${page < totalPages}">
                                        <a href="#" onclick="gotoPage(${page + 1})">
                                            Next <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- Page Size Selector -->
                            <div class="page-size-selector">
                                <span>Show</span>
                                <select id="pageSize" onchange="changePageSize()">
                                    <option value="5" ${pageSize eq 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize eq 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize eq 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize eq 50 ? 'selected' : ''}>50</option>
                                </select>
                                <span>per page</span>
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
<script src="assets/js/vendor/jquery-3.6.0.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/imagesloaded.pkgd.min.js"></script>
<script src="assets/js/jquery.magnific-popup.min.js"></script>
<script src="assets/js/jquery.odometer.min.js"></script>
<script src="assets/js/jquery.appear.js"></script>
<script src="assets/js/tween-max.min.js"></script>
<script src="assets/js/select2.min.js"></script>
<script src="assets/js/swiper-bundle.min.js"></script>
<script src="assets/js/jquery.marquee.min.js"></script>
<script src="assets/js/tg-cursor.min.js"></script>
<script src="assets/js/vivus.min.js"></script>
<script src="assets/js/ajax-form.js"></script>
<script src="assets/js/svg-inject.min.js"></script>
<script src="assets/js/jquery.circleType.js"></script>
<script src="assets/js/jquery.lettering.min.js"></script>
<script src="assets/js/plyr.min.js"></script>
<script src="assets/js/wow.min.js"></script>
<script src="assets/js/aos.js"></script>
<script src="assets/js/main.js"></script>
<jsp:include page="../common/js/"></jsp:include>

<!-- JavaScript for sorting and pagination -->
<script>
    SVGInject(document.querySelectorAll("img.injectable"));

    function sortTable(column) {
        const urlParams = new URLSearchParams(window.location.search);

        // Toggle sort order if clicking the same column
        let newOrder = 'asc';
        if (urlParams.get('sortBy') === column && urlParams.get('sortOrder') === 'asc') {
            newOrder = 'desc';
        }

        urlParams.set('sortBy', column);
        urlParams.set('sortOrder', newOrder);
        urlParams.set('page', 1); // Reset to first page when sorting changes

        window.location.href = window.location.pathname + '?' + urlParams.toString();
    }

    function gotoPage(page) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('page', page);
        window.location.href = window.location.pathname + '?' + urlParams.toString();
    }

    function changePageSize() {
        const pageSize = document.getElementById('pageSize').value;
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('pageSize', pageSize);
        urlParams.set('page', 1); // Reset to first page when changing page size
        window.location.href = window.location.pathname + '?' + urlParams.toString();
    }

    // Initialize Select2 for better dropdown experience (if available)
    $(document).ready(function() {
        if(typeof $.fn.select2 !== 'undefined') {
            $('#gender, #role, #status').select2();
        }
    });
</script>

<style>
  /* Action buttons styling */
  .dashboard__review-action {
    display: flex;
    gap: 6px;
    align-items: center;
    flex-wrap: wrap;
    justify-content: flex-start;
  }

  .user-action-link {
    padding: 6px 10px;
    border-radius: 4px;
    text-decoration: none;
    font-size: 11px;
    font-weight: 500;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    border: none;
    cursor: pointer;
    white-space: nowrap;
    min-width: 60px;
    height: 28px;
  }

  .user-action-link.view-link {
    background-color: #007bff;
    color: white;
  }

  .user-action-link.view-link:hover {
    background-color: #0056b3;
    transform: translateY(-1px);
  }

  .user-action-link.edit-link {
    background-color: #28a745;
    color: white;
  }

  .user-action-link.edit-link:hover {
    background-color: #1e7e34;
    transform: translateY(-1px);
  }

  /* Table styling */
  .dashboard__review-table {
    overflow-x: auto;
  }

  .dashboard__review-table table {
    width: 100%;
    min-width: 800px;
  }

  .dashboard__review-table th {
    white-space: nowrap;
    padding: 12px 8px;
    vertical-align: middle;
  }

  .dashboard__review-table td {
    padding: 12px 8px;
    vertical-align: middle;
  }

  /* Status badges */
  .status-badge {
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
  }

  .status-badge.status-active {
    background-color: #d4edda;
    color: #155724;
  }

  .status-badge.status-inactive {
    background-color: #f8d7da;
    color: #721c24;
  }



  /* Mobile responsive for action buttons */
  @media (max-width: 768px) {
    .dashboard__review-action {
      flex-direction: column;
      gap: 4px;
    }

    .user-action-link {
      width: 100%;
      justify-content: center;
      min-width: auto;
    }

    .dashboard__review-table {
      font-size: 12px;
    }

    .dashboard__review-table th,
    .dashboard__review-table td {
      padding: 8px 4px;
    }
  }
</style>
</body>
</html>