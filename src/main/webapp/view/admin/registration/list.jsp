<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

                                <!-- Page Size Warning -->
                                <c:if test="${not empty pageSizeWarning}">
                                    <div class="alert alert-warning" style="color: #856404; background-color: #fff3cd; border-color: #ffeaa7;">
                                        <strong>Warning:</strong> ${pageSizeWarning}
                                    </div>
                                </c:if>

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

                                <!-- Combined Filter & Configuration Section -->
                                <div class="dashboard__filter">
                                    <form action="${pageContext.request.contextPath}/admin/registrations" method="get" id="mainForm">
                                        <!-- Filter Fields -->
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
                                                <c:forEach var="s" items="${allStatuses}">
                                                    <option value="${s}" ${status eq s ? 'selected' : ''}>${s}</option>
                                                </c:forEach>
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

                                        <!-- Dynamic Configuration -->
                                        <div class="form-group">
                                            <label for="pageSize">Rows per page:</label>
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <input type="number" name="pageSize" id="pageSize" 
                                                       value="${pageSize != null ? pageSize : 10}" 
                                                       min="1" max="1000" 
                                                       style="width: 120px; padding: 8px 12px;"
                                                       placeholder="Enter number">
                                                <small class="text-muted">(1-1000)</small>
                                            </div>
                                        </div>

                                        <div class="form-group" style="min-width: 300px;">
                                            <label>Select Columns to Display:</label>
                                            <small class="text-muted" style="display: block; margin-bottom: 8px;">
                                                💡 Select columns to display. Click "Apply Filters" to apply changes.
                                            </small>

                                            
                                            <!-- Create a set for faster lookup -->
                                            <c:set var="selectedColumnSet" value=""/>
                                            <c:if test="${not empty selectedColumns}">
                                                <c:forEach items="${selectedColumns}" var="col">
                                                    <c:set var="selectedColumnSet" value="${selectedColumnSet},${col},"/>
                                                </c:forEach>
                                            </c:if>
                                            
                                            <div class="column-selector">
                                                <div class="column-group">
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="id" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',id,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">ID</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="email" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',email,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Email</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="registration_time" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',registration_time,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Registration Time</span>
                                                    </label>
                                                </div>
                                                <div class="column-group">
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="subject" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',subject,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Subject</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="package" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',package,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Package</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="total_cost" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',total_cost,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Total Cost</span>
                                                    </label>
                                                </div>
                                                <div class="column-group">
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="status" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',status,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Status</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="valid_from" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',valid_from,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Valid From</span>
                                                    </label>
                                                    <label class="column-checkbox">
                                                        <input type="checkbox" name="selectedColumns" value="valid_to" 
                                                               <c:choose>
                                                                   <c:when test="${empty selectedColumns}">checked</c:when>
                                                                   <c:when test="${fn:contains(selectedColumnSet, ',valid_to,')}">checked</c:when>
                                                               </c:choose>>
                                                        <span class="checkmark"></span>
                                                        <span class="column-label">Valid To</span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                        <input type="hidden" name="sortBy" value="${sortBy}">
                                        <input type="hidden" name="sortOrder" value="${sortOrder}">
                                        <input type="hidden" name="page" value="1">

                                        <button type="submit" style="background-color: #3f78e0; color: white; padding: 12px 25px;">
                                            📊 Apply Filters
                                        </button>
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
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',id,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('id')">
                                                        ID
                                                        <c:if test="${sortBy eq 'id'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',email,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('email')">
                                                        Email
                                                        <c:if test="${sortBy eq 'email'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',registration_time,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('registration_time')">
                                                        Registration Time
                                                        <c:if test="${sortBy eq 'registration_time'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',subject,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('subject')">
                                                        Subject
                                                        <c:if test="${sortBy eq 'subject'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',package,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('package')">
                                                        Package
                                                        <c:if test="${sortBy eq 'package'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',total_cost,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('total_cost')">
                                                        Total Cost
                                                        <c:if test="${sortBy eq 'total_cost'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',status,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('status')">
                                                        Status
                                                        <c:if test="${sortBy eq 'status'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_from,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('valid_from')">
                                                        Valid From
                                                        <c:if test="${sortBy eq 'valid_from'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_to,')}">
                                                    <th class="table-header-sortable" onclick="sortTable('valid_to')">
                                                        Valid To
                                                        <c:if test="${sortBy eq 'valid_to'}">
                                                            <i class="fas fa-sort-${sortOrder eq 'asc' ? 'up' : 'down'}"></i>
                                                        </c:if>
                                                    </th>
                                                </c:if>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${registrations}" var="registration">
                                                <tr>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',id,')}">
                                                        <td>${registration.id}</td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',email,')}">
                                                        <td>${userEmails[registration.user_id]}</td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',registration_time,')}">
                                                        <td><fmt:formatDate value="${registration.registration_time}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',subject,')}">
                                                        <td>${subjectTitles[registration.subject_id]}</td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',package,')}">
                                                        <td>${packageNames[registration.package_id]}</td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',total_cost,')}">
                                                        <td><fmt:formatNumber value="${registration.total_cost}" type="currency"/></td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',status,')}">
                                                        <td>
                                                            <span class="status-badge status-${registration.status.toLowerCase()}">${registration.status}</span>
                                                        </td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_from,')}">
                                                        <td><fmt:formatDate value="${registration.valid_from}" pattern="yyyy-MM-dd"/></td>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_to,')}">
                                                        <td><fmt:formatDate value="${registration.valid_to}" pattern="yyyy-MM-dd"/></td>
                                                    </c:if>
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
                                                    <c:set var="visibleColumnCount" value="1"/> <!-- Actions always visible -->
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',id,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',email,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',registration_time,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',subject,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',package,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',total_cost,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',status,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_from,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <c:if test="${empty selectedColumns or fn:contains(selectedColumnSet, ',valid_to,')}">
                                                        <c:set var="visibleColumnCount" value="${visibleColumnCount + 1}"/>
                                                    </c:if>
                                                    <td colspan="${visibleColumnCount}" class="text-center">No registrations found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 0}">
                                    <div class="pagination justify-content-center mt-4">
                                        <c:if test="${page > 1}">
                                            <a href="javascript:void(0)" onclick="gotoPage('${page - 1}')" class="btn btn-outline-primary me-2">
                                                <i class="fas fa-chevron-left"></i> Previous
                                            </a>
                                        </c:if>

                                        <span class="mx-3">
                                            Page ${page} of ${totalPages} 
                                            <br><small class="text-muted">
                                                Showing ${pageSize} rows per page
                                                <c:if test="${not empty registrations}">
                                                    | ${(page-1) * pageSize + 1} - ${(page-1) * pageSize + registrations.size()} records
                                                </c:if>
                                            </small>
                                        </span>

                                        <c:if test="${page < totalPages}">
                                            <a href="javascript:void(0)" onclick="gotoPage('${page + 1}')" class="btn btn-outline-primary ms-2">
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
            // Chuẩn hóa tên cột cho sort
            const columnMap = {
                'id': 'id',
                'email': 'email',
                'registration_time': 'registration_time',
                'subject': 'subject',
                'package': 'package',
                'total_cost': 'total_cost',
                'status': 'status',
                'valid_from': 'valid_from',
                'valid_to': 'valid_to'
            };
            const sortColumn = columnMap[column] || column;
            const urlParams = new URLSearchParams(window.location.search);
            let newOrder = 'asc';
            if (urlParams.get('sortBy') === sortColumn && urlParams.get('sortOrder') === 'asc') {
                newOrder = 'desc';
            }
            urlParams.set('sortBy', sortColumn);
            urlParams.set('sortOrder', newOrder);
            urlParams.set('page', '1');
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }

        function gotoPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page.toString());
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        }

        function updateTable() {
            const mainForm = document.getElementById('mainForm');
            setTimeout(() => {
                mainForm.submit();
            }, 100);
        }

        // Page size functions removed - no quick selection buttons needed

        function validateAndSubmitForm() {
            const pageSizeInput = document.getElementById('pageSize');
            const value = parseInt(pageSizeInput.value);
            
            if (isNaN(value) || value < 1) {
                alert('Page size must be a number greater than 0');
                pageSizeInput.value = 10;
                return;
            }
            
            if (value > 1000) {
                alert('Page size cannot exceed 1000. Setting to maximum value.');
                pageSizeInput.value = 1000;
            }
            
            updateTable();
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

        // Update pagination links to preserve current configuration
        // Function gotoPage is already defined above, no need to redefine

        // Preserve checkbox state when submitting form
        document.getElementById('mainForm').addEventListener('submit', function(e) {
            // Remove any existing hidden selectedColumns inputs to avoid duplicates
            const existingHiddenInputs = this.querySelectorAll('input[type="hidden"][name="selectedColumns"]');
            existingHiddenInputs.forEach(input => input.remove());
            
            // Get all checkboxes that are currently checked
            const checkedCheckboxes = this.querySelectorAll('input[name="selectedColumns"]:checked');
            console.log('Submitting form with checked columns:', Array.from(checkedCheckboxes).map(cb => cb.value));
            
            // Disable all visible checkboxes temporarily to prevent duplicate submission
            const allCheckboxes = this.querySelectorAll('input[name="selectedColumns"]');
            allCheckboxes.forEach(checkbox => {
                if (!checkbox.disabled) {
                    checkbox.disabled = true;
                    // Mark for re-enabling after form submission (though page will reload)
                    checkbox.setAttribute('data-was-enabled', 'true');
                }
            });
            
            // Create hidden inputs for each checked checkbox to ensure they are submitted
            checkedCheckboxes.forEach(checkbox => {
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'selectedColumns';
                hiddenInput.value = checkbox.value;
                this.appendChild(hiddenInput);
                console.log('Added hidden input for:', checkbox.value);
            });
        });

        // Column visibility will be applied server-side after form submission

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Add Enter key support for page size input
            document.getElementById('pageSize').addEventListener('keypress', function(event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    validateAndSubmitForm();
                }
            });
        });
    </script>
</body>
</html> 