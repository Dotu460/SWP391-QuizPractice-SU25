<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sort-icon {
            margin-left: 5px;
        }
        th a {
            color: inherit;
            text-decoration: none;
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>User Management</h1>
        <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary">
            <i class="fas fa-plus"></i> Add New User
        </a>
    </div>

    <!-- Filter and Search Section -->
    <div class="filter-section">
        <form action="${pageContext.request.contextPath}/admin/users" method="get" id="filterForm">
            <div class="row g-3">
                <!-- Search Box -->
                <div class="col-md-4">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search by name, email, mobile"
                               name="search" value="${searchTerm}">
                        <button class="btn btn-outline-secondary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <div class="form-text">Search by name, email or mobile</div>
                </div>

                <!-- Gender Filter -->
                <div class="col-md-2">
                    <select name="gender" class="form-select" onchange="document.getElementById('filterForm').submit()">
                        <option value="" ${empty genderFilter ? 'selected' : ''}>All Genders</option>
                        <option value="male" ${genderFilter == 'male' ? 'selected' : ''}>Male</option>
                        <option value="female" ${genderFilter == 'female' ? 'selected' : ''}>Female</option>
                    </select>
                    <div class="form-text">Filter by gender</div>
                </div>

                <!-- Role Filter -->
                <div class="col-md-3">
                    <select name="role" class="form-select" onchange="document.getElementById('filterForm').submit()">
                        <option value="" ${empty roleFilter ? 'selected' : ''}>All Roles</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.id}" ${roleFilter == role.id ? 'selected' : ''}>${role.role_name}</option>
                        </c:forEach>
                    </select>
                    <div class="form-text">Filter by role</div>
                </div>

                <!-- Status Filter -->
                <div class="col-md-3">
                    <select name="status" class="form-select" onchange="document.getElementById('filterForm').submit()">
                        <option value="" ${empty statusFilter ? 'selected' : ''}>All Status</option>
                        <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                        <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                    </select>
                    <div class="form-text">Filter by status</div>
                </div>
            </div>

            <!-- Hidden fields to preserve sorting when filtering -->
            <input type="hidden" name="sortBy" value="${sortBy}">
            <input type="hidden" name="sortOrder" value="${sortOrder}">
            <input type="hidden" name="page" value="1">
        </form>
    </div>

    <!-- User Table -->
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-dark">
            <tr>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=user_id&sortOrder=${sortBy == 'user_id' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        ID
                        <c:if test="${sortBy == 'user_id'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=full_name&sortOrder=${sortBy == 'full_name' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Full Name
                        <c:if test="${sortBy == 'full_name'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=gender&sortOrder=${sortBy == 'gender' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Gender
                        <c:if test="${sortBy == 'gender'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=email&sortOrder=${sortBy == 'email' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Email
                        <c:if test="${sortBy == 'email'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=mobile&sortOrder=${sortBy == 'mobile' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Mobile
                        <c:if test="${sortBy == 'mobile'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=role&sortOrder=${sortBy == 'role' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Role
                        <c:if test="${sortBy == 'role'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>
                    <a href="${pageContext.request.contextPath}/admin/users?sortBy=status&sortOrder=${sortBy == 'status' && sortOrder != 'desc' ? 'desc' : 'asc'}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}&page=${currentPage}">
                        Status
                        <c:if test="${sortBy == 'status'}">
                            <i class="fas fa-sort-${sortOrder == 'desc' ? 'down' : 'up'} sort-icon"></i>
                        </c:if>
                    </a>
                </th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty users}">
                    <tr>
                        <td colspan="8" class="text-center">No users found</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.user_id}</td>
                            <td>${user.full_name}</td>
                            <td>${user.gender ? 'Male' : 'Female'}</td>
                            <td>${user.email}</td>
                            <td>${user.mobile}</td>
                            <td><span class="badge bg-info">${user.role.role_name}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:when test="${user.status == 'inactive'}">
                                        <span class="badge bg-danger">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">${user.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.user_id}" class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.user_id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}">
                        Previous
                    </a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${currentPage == i}">
                            <li class="page-item active">
                                <span class="page-link">${i}</span>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&sortBy=${sortBy}&sortOrder=${sortOrder}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}">
                                        ${i}
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&gender=${genderFilter}&role=${roleFilter}&status=${statusFilter}&search=${searchTerm}">
                        Next
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>