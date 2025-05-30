<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${action == 'add' ? 'Add New User' : 'Edit User'}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
<div class="container mt-4">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <h4>${action == 'add' ? 'Add New User' : 'Edit User'}</h4>
        </div>
        <div class="card-body">
          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/user" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="${action}">
            <c:if test="${action == 'update'}">
              <input type="hidden" name="userId" value="${user.user_id}">
            </c:if>

            <div class="mb-3">
              <label for="fullName" class="form-label">Full Name*</label>
              <input type="text" class="form-control" id="fullName" name="fullName"
                     value="${user.full_name}" required>
              <div class="invalid-feedback">
                Please provide a name.
              </div>
            </div>

            <div class="mb-3">
              <label for="email" class="form-label">Email*</label>
              <input type="email" class="form-control" id="email" name="email"
                     value="${user.email}" required>
              <div class="invalid-feedback">
                Please provide a valid email.
              </div>
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">
                ${action == 'add' ? 'Password*' : 'Password (leave blank to keep current)'}
              </label>
              <input type="password" class="form-control" id="password" name="password"
              ${action == 'add' ? 'required' : ''}>
              <div class="invalid-feedback">
                Please provide a password.
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label d-block">Gender*</label>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="male"
                       value="male" ${user.gender ? 'checked' : ''} required>
                <label class="form-check-label" for="male">Male</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="female"
                       value="female" ${!user.gender ? 'checked' : ''} required>
                <label class="form-check-label" for="female">Female</label>
              </div>
            </div>

            <div class="mb-3">
              <label for="mobile" class="form-label">Mobile Number</label>
              <input type="tel" class="form-control" id="mobile" name="mobile"
                     value="${user.mobile}">
            </div>

            <div class="mb-3">
              <label for="avatarUrl" class="form-label">Avatar URL</label>
              <input type="url" class="form-control" id="avatarUrl" name="avatarUrl"
                     value="${user.avatar_url}">
            </div>

            <div class="mb-3">
              <label for="roleId" class="form-label">Role*</label>
              <select class="form-select" id="roleId" name="roleId" required>
                <option value="">Select Role</option>
                <c:forEach var="role" items="${roles}">
                  <option value="${role.id}" ${user.role.id == role.id ? 'selected' : ''}>
                      ${role.role_name}
                  </option>
                </c:forEach>
              </select>
              <div class="invalid-feedback">
                Please select a role.
              </div>
            </div>

            <div class="mb-3">
              <label for="status" class="form-label">Status*</label>
              <select class="form-select" id="status" name="status" required>
                <option value="active" ${user.status == 'active' ? 'selected' : ''}>Active</option>
                <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Inactive</option>
              </select>
              <div class="invalid-feedback">
                Please select a status.
              </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
              <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-md-2">Cancel</a>
              <button type="submit" class="btn btn-primary">Save</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Form validation
  (function() {
    'use strict'
    const forms = document.querySelectorAll('.needs-validation')
    Array.from(forms).forEach(form => {
      form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add('was-validated')
      }, false)
    })
  })()
</script>
</body>
</html>