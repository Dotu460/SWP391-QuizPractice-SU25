<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <style>
        .table-header-sortable {
            cursor: pointer;
        }
        .table-header-sortable i {
            margin-left: 5px;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2>User Management</h2>

    <!-- Alert messages for actions -->
    <c:if test="${param.success != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:choose>
                <c:when test="${param.success eq 'userAdded'}">User added successfully!</c:when>
                <c:when test="${param.success eq 'userUpdated'}">User updated successfully!</c:when>
                <c:otherwise>Operation completed successfully!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <c:choose>
                <c:when test="${param.error eq 'userNotFound'}">User not found!</c:when>
                <c:when test="${param.error eq 'invalidId'}">Invalid user ID!</c:when>
                <c:when test="${param.error eq 'invalidData'}">Invalid user data!</c:when>
                <c:otherwise>An error occurred!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Filter and Search Form -->
    <div class="card mb-4">
        <div class="card-header">
            <h5>Filters and Search</h5>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                <!-- Gender Filter -->
                <div class="col-md-2">
                    <label for="gender" class="form-label">Gender</label>
                    <select name="gender" id="gender" class="form-select">
                        <option value="">All</option>
                        <option value="male" ${genderFilter eq 'male' ? 'selected' : ''}>Male</option>
                        <option value="female" ${genderFilter eq 'female' ? 'selected' : ''}>Female</option>
                    </select>
                </div>

                <!-- Role Filter -->
                <div class="col-md-3">
                    <label for="role" class="form-label">Role</label>
                    <select name="role" id="role" class="form-select">
                        <option value="">All</option>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.id}" ${roleFilter eq role.id.toString() ? 'selected' : ''}>${role.role_name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Status Filter -->
                <div class="col-md-2">
                    <label for="status" class="form-label">Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">All</option>
                        <option value="active" ${statusFilter eq 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${statusFilter eq 'inactive' ? 'selected' : ''}>Inactive</option>
                        <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Pending</option>
                    </select>
                </div>

                <!-- Search -->
                <div class="col-md-3">
                    <label for="search" class="form-label">Search</label>
                    <input type="text" class="form-control" id="search" name="search" placeholder="Name, Email, Mobile" value="${searchTerm}">
                </div>

                <!-- Submit Button -->
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary mb-3">Apply Filters</button>
                </div>

                <!-- Hidden fields to preserve sorting and pagination -->
                <input type="hidden" name="sortBy" value="${sortBy}">
                <input type="hidden" name="sortOrder" value="${sortOrder}">
                <input type="hidden" name="page" value="1">
            </form>
        </div>
    </div>

    <!-- User List -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5>User List</h5>
            <a href="${pageContext.request.contextPath}/admin/user?action=add" class="btn btn-success">
                <i class="fas fa-plus"></i> Add New User
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
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
                            <td>${user.full_name}</td>
                            <td>${user.gender == 1 ? 'Male' : 'Female'}</td>
                            <td>${user.email}</td>
                            <td>${user.mobile}</td>
                            <td>
                                <c:forEach items="${roles}" var="role">
                                    <c:if test="${role.id == user.role_id}">${role.role_name}</c:if>
                                </c:forEach>
                            </td>
                            <td>
                                 <span class="badge ${user.status eq 'active' ? 'bg-success' : (user.status eq 'inactive' ? 'bg-danger' : 'bg-warning')}">
                                         ${user.status}
                                 </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/user?action=view&id=${user.id}" class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i>
                                </a>
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
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <!-- Previous page -->
                        <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="gotoPage(${page - 1})" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <!-- Page numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${page eq i ? 'active' : ''}">
                                <a class="page-link" href="#" onclick="gotoPage(${i})">${i}</a>
                            </li>
                        </c:forEach>

                        <!-- Next page -->
                        <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="gotoPage(${page + 1})" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <!-- Page Size Selector -->
            <div class="d-flex justify-content-center mt-2">
                <div class="input-group" style="width: 200px;">
                    <label class="input-group-text" for="pageSize">Show</label>
                    <select class="form-select" id="pageSize" onchange="changePageSize()">
                        <option value="5" ${pageSize eq 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize eq 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize eq 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize eq 50 ? 'selected' : ''}>50</option>
                    </select>
                    <span class="input-group-text">per page</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<!-- JavaScript for sorting and pagination -->
<script>
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
</script>
</body>
</html>