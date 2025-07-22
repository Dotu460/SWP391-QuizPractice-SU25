<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h4>User Details</h4>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.user_id}" class="btn btn-warning">
                                <i class="bi bi-pencil"></i> Edit User
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-3 text-center">
                                <c:choose>
                                    <c:when test="${not empty user.avatar_url}">
                                        <img src="${user.avatar_url}" alt="${user.full_name}" class="img-fluid rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center" style="width: 150px; height: 150px; margin: 0 auto;">
                                            <i class="bi bi-person-fill text-white" style="font-size: 4rem;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge ${user.status == 'active' ? 'bg-success' : 'bg-danger'} mt-2">
                                    ${user.status}
                                </span>
                            </div>
                            <div class="col-md-9">
                                <h3>${user.full_name}</h3>
                                <p class="text-muted">
                                    <c:forEach items="${roles}" var="role">
                                        <c:if test="${role.id == user.role_id}">${role.name}</c:if>
                                    </c:forEach>
                                </p>

                                <div class="mb-2">
                                    <i class="bi bi-envelope"></i> <strong>Email:</strong> ${user.email}
                                </div>

                                <div class="mb-2">
                                    <i class="bi bi-gender-ambiguous"></i> <strong>Gender:</strong>
                                    ${user.gender ? 'Male' : 'Female'}
                                </div>

                                <div class="mb-2">
                                    <i class="bi bi-telephone"></i> <strong>Mobile:</strong>
                                    ${not empty user.mobile ? user.mobile : 'Not specified'}
                                </div>

                                <div class="mb-2">
                                    <i class="bi bi-person-badge"></i> <strong>User ID:</strong> ${user.user_id}
                                </div>
                            </div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-md-12">
                                <h5>Role Information</h5>
                                <table class="table table-bordered">
                                    <tr>
                                        <th style="width: 30%">Role Name</th>
                                        <td>
                                            <c:forEach items="${roles}" var="role">
                                                <c:if test="${role.id == user.role_id}">${role.name}</c:if>
                                            </c:forEach>
                                        </td>
                                    </tr>
                                </table>
                                    <tr>
                                        <th>Role Created At</th>
                                        <td>${user.role.created_at}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                            <i class="bi bi-arrow-left"></i> Back to User List
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.user_id}" class="btn btn-warning">
                            <i class="bi bi-pencil"></i> Edit User
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>