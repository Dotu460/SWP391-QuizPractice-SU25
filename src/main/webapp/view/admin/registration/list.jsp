<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Registration Management - SkillGro Dashboard</title>
    <meta name="description" content="SkillGro - Online Courses & Education Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
    
    <!-- Custom CSS for this page -->
    <style>
        .dashboard__filter {
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        .dashboard__filter form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .dashboard__filter .form-group {
            flex: 1;
            min-width: 180px;
        }

        .dashboard__filter label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .dashboard__filter select,
        .dashboard__filter input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
        }

        .dashboard__filter button {
            padding: 12px 25px;
            background-color: #3f78e0;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .dashboard__filter button:hover {
            background-color: #2c5ec1;
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

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-button {
            padding: 6px 12px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .edit-button {
            background-color: #3f78e0;
        }

        .view-button {
            background-color: #6c757d;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
    </style>
</head>

<body>
    <!-- header-area -->
    <jsp:include page="../../common/user/header.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area">
        <!-- dashboard-area -->
        <section class="dashboard__area">
            <div class="container-fluid">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <div class="col-lg-2">
                            <jsp:include page="../adminSidebar.jsp">
                                <jsp:param name="active" value="registrations"/>
                            </jsp:include>
                        </div>
                        <div class="col-lg-10">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title">
                                    <h4 class="title">Registration Management</h4>
                                </div>

                                <!-- Success/Error Messages -->
                                <c:if test="${param.success != null}">
                                    <div class="alert alert-success">
                                        <c:choose>
                                            <c:when test="${param.success == 'added'}">Registration successfully added.</c:when>
                                            <c:when test="${param.success == 'updated'}">Registration successfully updated.</c:when>
                                        </c:choose>
                                    </div>
                                </c:if>
                                <c:if test="${param.error != null}">
                                    <div class="alert alert-danger">
                                        <c:choose>
                                            <c:when test="${param.error == 'notFound'}">Registration not found.</c:when>
                                            <c:when test="${param.error == 'addFailed'}">Failed to add registration.</c:when>
                                            <c:when test="${param.error == 'updateFailed'}">Failed to update registration.</c:when>
                                            <c:when test="${param.error == 'invalidData'}">Invalid data provided.</c:when>
                                        </c:choose>
                                    </div>
                                </c:if>

                                <!-- Filter Section -->
                                <div class="dashboard__filter">
                                    <form action="${pageContext.request.contextPath}/admin/registrations" method="get">
                                        <div class="form-group">
                                            <label for="emailSearch">Email:</label>
                                            <input type="text" id="emailSearch" name="emailSearch" 
                                                   value="${emailSearch}" placeholder="Search by email...">
                                        </div>

                                        <div class="form-group">
                                            <label for="subjectSearch">Subject:</label>
                                            <input type="text" id="subjectSearch" name="subjectSearch" 
                                                   value="${subjectSearch}" placeholder="Search by subject...">
                                        </div>

                                        <div class="form-group">
                                            <label for="status">Status:</label>
                                            <select name="status" id="status">
                                                <option value="">All Status</option>
                                                <option value="active" ${status eq 'active' ? 'selected' : ''}>Active</option>
                                                <option value="inactive" ${status eq 'inactive' ? 'selected' : ''}>Inactive</option>
                                                <option value="pending" ${status eq 'pending' ? 'selected' : ''}>Pending</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="fromDate">From Date:</label>
                                            <input type="date" id="fromDate" name="fromDate" value="${fromDate}">
                                        </div>

                                        <div class="form-group">
                                            <label for="toDate">To Date:</label>
                                            <input type="date" id="toDate" name="toDate" value="${toDate}">
                                        </div>

                                        <input type="hidden" name="sortBy" value="${sortBy}">
                                        <input type="hidden" name="sortOrder" value="${sortOrder}">
                                        <input type="hidden" name="page" value="1">

                                        <button type="submit">Apply Filters</button>
                                    </form>
                                </div>

                                <!-- Add Registration Button -->
                                <div class="dashboard__actions mb-4">
                                    <a href="${pageContext.request.contextPath}/admin/registrations?action=add" 
                                       class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Add New Registration
                                    </a>
                                </div>

                                <!-- Registrations Table -->
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
                                                <th class="table-header-sortable" onclick="sortTable('email')">
                                                    Email
                                                    <c:if test="${sortBy eq 'email'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('registration_time')">
                                                    Registration Time
                                                    <c:if test="${sortBy eq 'registration_time'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('subject')">
                                                    Subject
                                                    <c:if test="${sortBy eq 'subject'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('package')">
                                                    Package
                                                    <c:if test="${sortBy eq 'package'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('total_cost')">
                                                    Total Cost
                                                    <c:if test="${sortBy eq 'total_cost'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('status')">
                                                    Status
                                                    <c:if test="${sortBy eq 'status'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('valid_from')">
                                                    Valid From
                                                    <c:if test="${sortBy eq 'valid_from'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th class="table-header-sortable" onclick="sortTable('valid_to')">
                                                    Valid To
                                                    <c:if test="${sortBy eq 'valid_to'}">
                                                        <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                    </c:if>
                                                </th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${registrations}" var="registration">
                                                <tr>
                                                    <td>${registration.id}</td>
                                                    <td>${userEmails[registration.user_id]}</td>
                                                    <td><fmt:formatDate value="${registration.registration_time}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                                    <td>${subjectTitles[registration.subject_id]}</td>
                                                    <td>${packageNames[registration.package_id]}</td>
                                                    <td><fmt:formatNumber value="${registration.total_cost}" type="currency"/></td>
                                                    <td>
                                                        <span class="status-badge status-${registration.status.toLowerCase()}">${registration.status}</span>
                                                    </td>
                                                    <td><fmt:formatDate value="${registration.valid_from}" pattern="yyyy-MM-dd"/></td>
                                                    <td><fmt:formatDate value="${registration.valid_to}" pattern="yyyy-MM-dd"/></td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/admin/registrations?action=edit&id=${registration.id}" 
                                                               class="action-button edit-button">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/admin/registrations?action=view&id=${registration.id}" 
                                                               class="action-button view-button">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty registrations}">
                                                <tr>
                                                    <td colspan="10" class="text-center">No registrations found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 0}">
                                    <div class="pagination justify-content-center mt-4">
                                        <c:if test="${page > 1}">
                                            <a href="javascript:void(0)" onclick="gotoPage(${page - 1})" class="btn btn-outline-primary me-2">
                                                <i class="fas fa-chevron-left"></i> Previous
                                            </a>
                                        </c:if>

                                        <span class="mx-3">Page ${page} of ${totalPages}</span>

                                        <c:if test="${page < totalPages}">
                                            <a href="javascript:void(0)" onclick="gotoPage(${page + 1})" class="btn btn-outline-primary ms-2">
                                                Next <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </c:if>
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
        function sortTable(column) {
            const urlParams = new URLSearchParams(window.location.search);
            let newOrder = 'asc';
            
            if (urlParams.get('sortBy') === column && urlParams.get('sortOrder') === 'asc') {
                newOrder = 'desc';
            }
            
            urlParams.set('sortBy', column);
            urlParams.set('sortOrder', newOrder);
            urlParams.set('page', '1');
            
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }

        function gotoPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page.toString());
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }

        // Initialize date range validation
        document.getElementById('toDate').addEventListener('change', function() {
            var fromDate = document.getElementById('fromDate').value;
            var toDate = this.value;
            
            if (fromDate && toDate && fromDate > toDate) {
                alert('To Date must be greater than or equal to From Date');
                this.value = fromDate;
            }
        });

        document.getElementById('fromDate').addEventListener('change', function() {
            var fromDate = this.value;
            var toDate = document.getElementById('toDate').value;
            
            if (fromDate && toDate && fromDate > toDate) {
                alert('From Date must be less than or equal to To Date');
                this.value = toDate;
            }
        });
    </script>
</body>
</html> 