<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Registrations - SkillGro Dashboard</title>
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

        /* Custom button styles */
        .btn {
            padding: 8px 16px;
            font-weight: 500;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #4A90E2;
            border-color: #4A90E2;
            color: white;
        }

        .btn-primary:hover {
            background-color: #357ABD;
            border-color: #357ABD;
            transform: translateY(-1px);
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #218838;
            transform: translateY(-1px);
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
            color: white;
        }

        .btn-info:hover {
            background-color: #138496;
            border-color: #138496;
            transform: translateY(-1px);
        }

        /* Filter section styles */
        .dashboard__filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .text-muted {
            color: #6c757d;
            font-size: 0.875rem;
        }

        /* Table styles */
        .table {
            margin-bottom: 0;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        .table td {
            vertical-align: middle;
        }

        /* Pagination styles */
        .pagination {
            margin-bottom: 0;
        }

        .page-link {
            color: #4A90E2;
            border: 1px solid #dee2e6;
            padding: 0.5rem 0.75rem;
        }

        .page-item.active .page-link {
            background-color: #4A90E2;
            border-color: #4A90E2;
        }

        .page-link:hover {
            color: #357ABD;
            background-color: #e9ecef;
            border-color: #dee2e6;
        }

        /* Input group styles */
        .input-group-text {
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            color: #495057;
        }

        .form-control:focus {
            border-color: #4A90E2;
            box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
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
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">Registrations Management</h4>
                                    <a href="${pageContext.request.contextPath}/admin/registrations?action=add" class="btn btn-success">
                                        <i class="fas fa-plus"></i> Add New Registration
                                    </a>
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

                                <!-- Search and Filter Section -->
                                <div class="dashboard__filter-section">
                                    <form action="${pageContext.request.contextPath}/admin/registrations" method="get" class="row g-3" id="filterForm">
                                        <!-- Filter descriptions -->
                                        <div class="col-12 mb-2">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <small class="text-muted">Search by user's email address</small>
                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted">Search by subject name</small>
                                                </div>
                                                <div class="col-md-2">
                                                    <small class="text-muted">Filter by registration status</small>
                                                </div>
                                                <div class="col-md-2">
                                                    <small class="text-muted">Filter by start date</small>
                                                </div>
                                                <div class="col-md-2">
                                                    <small class="text-muted">Filter by end date</small>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Existing search fields -->
                                        <div class="col-md-3">
                                            <input type="text" class="form-control" name="emailSearch" placeholder="Search by email" value="${emailSearch}">
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" class="form-control" name="subjectSearch" placeholder="Search by subject" value="${subjectSearch}">
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" name="status">
                                                <option value="">All Status</option>
                                                <c:forEach items="${allStatuses}" var="statusOption">
                                                    <option value="${statusOption}" ${status == statusOption ? 'selected' : ''}>${statusOption}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" class="form-control" name="toDate" value="${toDate}">
                                        </div>

                                        <!-- Column Selection -->
                                        <div class="col-12 mt-3">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="mb-0">Select Columns to Display</h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_id" name="selectedColumns" value="id" 
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('id') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_id">ID</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_email" name="selectedColumns" value="email"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('email') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_email">Email</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_subject" name="selectedColumns" value="subject"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('subject') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_subject">Subject</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_package" name="selectedColumns" value="package"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('package') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_package">Package</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_total_cost" name="selectedColumns" value="total_cost"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('total_cost') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_total_cost">Total Cost</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_status" name="selectedColumns" value="status"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('status') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_status">Status</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_valid_from" name="selectedColumns" value="valid_from"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('valid_from') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_valid_from">Valid From</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_valid_to" name="selectedColumns" value="valid_to"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('valid_to') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_valid_to">Valid To</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-check">
                                                                <input type="checkbox" class="form-check-input column-selector" id="col_registration_time" name="selectedColumns" value="registration_time"
                                                                       ${empty paramValues['selectedColumns'] ? 'checked' : fn:join(paramValues['selectedColumns'], ',').contains('registration_time') ? 'checked' : ''}>
                                                                <label class="form-check-label" for="col_registration_time">Registration Time</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Action buttons -->
                                        <div class="col-12 text-end">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-filter"></i> Apply Filters
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Table Section -->
                                <div class="table-responsive mt-3">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <c:forEach items="${selectedColumns}" var="column">
                                                    <th>
                                                        <c:choose>
                                                            <c:when test="${column == 'id'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=id&sortOrder=${sortBy == 'id' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    ID
                                                                    <c:if test="${sortBy == 'id'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'email'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=email&sortOrder=${sortBy == 'email' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Email
                                                                    <c:if test="${sortBy == 'email'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'subject'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=subject&sortOrder=${sortBy == 'subject' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Subject
                                                                    <c:if test="${sortBy == 'subject'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'package'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=package&sortOrder=${sortBy == 'package' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Package
                                                                    <c:if test="${sortBy == 'package'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'total_cost'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=total_cost&sortOrder=${sortBy == 'total_cost' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Total Cost
                                                                    <c:if test="${sortBy == 'total_cost'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'status'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=status&sortOrder=${sortBy == 'status' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Status
                                                                    <c:if test="${sortBy == 'status'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'valid_from'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=valid_from&sortOrder=${sortBy == 'valid_from' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Valid From
                                                                    <c:if test="${sortBy == 'valid_from'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'valid_to'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=valid_to&sortOrder=${sortBy == 'valid_to' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Valid To
                                                                    <c:if test="${sortBy == 'valid_to'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${column == 'registration_time'}">
                                                                <a href="?${pageContext.request.queryString}&sortBy=registration_time&sortOrder=${sortBy == 'registration_time' && sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                                   class="text-dark text-decoration-none">
                                                                    Registration Time
                                                                    <c:if test="${sortBy == 'registration_time'}">
                                                                        <i class="fas fa-sort-${sortOrder == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </c:when>
                                                        </c:choose>
                                                    </th>
                                                </c:forEach>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${registrations}" var="reg">
                                                <tr>
                                                    <c:forEach items="${selectedColumns}" var="column">
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${column == 'id'}">${reg.id}</c:when>
                                                                <c:when test="${column == 'email'}">${userEmails[reg.user_id]}</c:when>
                                                                <c:when test="${column == 'subject'}">${subjectTitles[reg.subject_id]}</c:when>
                                                                <c:when test="${column == 'package'}">${packageNames[reg.package_id]}</c:when>
                                                                <c:when test="${column == 'total_cost'}">$${reg.total_cost}</c:when>
<%--                                                                <c:when test="${column == 'status'}">--%>
<%--                                                                    <span class="badge ${reg.status == 'pending' ? 'bg-warning' : reg.status == 'paid' ? 'bg-success' : 'bg-danger'}">--%>
<%--                                                                        ${reg.status}--%>
<%--                                                                    </span>--%>
<%--                                                                </c:when> --%>
                                                                <c:when test="${column == 'status'}">${reg.status}</c:when>
                                                                <c:when test="${column == 'valid_from'}">
                                                                    <fmt:formatDate value="${reg.valid_from}" pattern="yyyy-MM-dd"/>
                                                                </c:when>
                                                                <c:when test="${column == 'valid_to'}">
                                                                    <fmt:formatDate value="${reg.valid_to}" pattern="yyyy-MM-dd"/>
                                                                </c:when>
                                                                <c:when test="${column == 'registration_time'}">
                                                                    <fmt:formatDate value="${reg.registration_time}" pattern="yyyy-MM-dd"/>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                    </c:forEach>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/registrations?action=view&id=${reg.id}" 
                                                           class="btn btn-info btn-sm">View</a>
                                                        <a href="${pageContext.request.contextPath}/admin/registrations?action=edit&id=${reg.id}" 
                                                           class="btn btn-primary btn-sm">Edit</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Results count, rows per page and pagination info -->
                                <div class="dashboard__info-section mt-3">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <label class="input-group-text" for="pageSize">Rows per page</label>
                                                <input type="number" class="form-control" id="pageSize" name="pageSize" 
                                                       min="1" max="1000" value="${pageSize}" 
                                                       placeholder="Enter number of rows">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <p class="mb-0">
                                                <c:set var="startRow" value="${(page-1)*pageSize + 1}"/>
                                                <c:set var="endRow" value="${page*pageSize}"/>
                                                <c:set var="displayEndRow" value="${endRow > totalRecords ? totalRecords : endRow}"/>
                                                Showing ${startRow} to ${displayEndRow} of ${totalRecords} entries
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <nav aria-label="Page navigation" class="float-end">
                                                <ul class="pagination justify-content-end mb-0">
                                                    <!-- Previous page -->
                                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/registrations?page=${page-1}&pageSize=${pageSize}&emailSearch=${emailSearch}&subjectSearch=${subjectSearch}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}<c:forEach items="${selectedColumns}" var="col">&selectedColumns=${col}</c:forEach>" aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>

                                                    <!-- Page numbers -->
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${page == i ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/registrations?page=${i}&pageSize=${pageSize}&emailSearch=${emailSearch}&subjectSearch=${subjectSearch}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}<c:forEach items="${selectedColumns}" var="col">&selectedColumns=${col}</c:forEach>">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    
                                                    <!-- Next page -->
                                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/registrations?page=${page+1}&pageSize=${pageSize}&emailSearch=${emailSearch}&subjectSearch=${subjectSearch}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&sortBy=${sortBy}&sortOrder=${sortOrder}<c:forEach items="${selectedColumns}" var="col">&selectedColumns=${col}</c:forEach>" aria-label="Next">
                                                            <span aria-hidden="true">&raquo;</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
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
        // Handle form submission for filtering and pagination
        document.getElementById('filterForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get date values for validation
            const fromDate = document.querySelector('input[name="fromDate"]').value;
            const toDate = document.querySelector('input[name="toDate"]').value;
            
            // Validate date range if both dates are provided
            if (fromDate && toDate) {
                if (new Date(fromDate) > new Date(toDate)) {
                    alert('End date must be greater than or equal to start date');
                    return;
                }
            }
            
            // Validate column selection - at least one column must be selected
            var checkedColumns = document.querySelectorAll('.column-selector:checked');
            if (checkedColumns.length === 0) {
                alert('Please select at least one column to display');
                return;
            }
            
            // Validate and adjust page size
            const pageSizeInput = document.getElementById('pageSize');
            let pageSize = parseInt(pageSizeInput.value);
            
            if (isNaN(pageSize) || pageSize < 1) {
                alert('Page size must be at least 1');
                pageSizeInput.value = 1;
                pageSize = 1;
            }
            if (pageSize > 1000) {
                alert('Page size cannot exceed 1000');
                pageSizeInput.value = 1000;
                pageSize = 1000;
            }
            
            // Add validated page size to form data
            const hiddenPageSizeInput = document.createElement('input');
            hiddenPageSizeInput.type = 'hidden';
            hiddenPageSizeInput.name = 'pageSize';
            hiddenPageSizeInput.value = pageSize;
            this.appendChild(hiddenPageSizeInput);
            
            // Submit form if all validations pass
            this.submit();
        });

        // Handle date input changes for real-time validation
        document.querySelector('input[name="fromDate"]').addEventListener('change', function() {
            const toDate = document.querySelector('input[name="toDate"]');
            if (this.value && toDate.value && new Date(this.value) > new Date(toDate.value)) {
                alert('Start date must be less than or equal to end date');
                this.value = toDate.value;
            }
        });

        document.querySelector('input[name="toDate"]').addEventListener('change', function() {
            const fromDate = document.querySelector('input[name="fromDate"]');
            if (this.value && fromDate.value && new Date(fromDate.value) > new Date(this.value)) {
                alert('End date must be greater than or equal to start date');
                this.value = fromDate.value;
            }
        });

        // Initialize column selection on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Check all columns by default if no selection exists
            var checkedColumns = document.querySelectorAll('.column-selector:checked');
            var hasSelectedColumns = window.location.search.includes('selectedColumns=');
            
            if (checkedColumns.length === 0 && !hasSelectedColumns) {
                document.querySelectorAll('.column-selector').forEach(function(checkbox) {
                    checkbox.checked = true;
                });
            }
        });
    </script>
</body>
</html> 