<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>${action == 'add' ? 'Add New User' : 'Edit User'} - Quiz Practice Admin</title>
    <meta name="description" content="Quiz Practice - Online Learning Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for this page -->
    <style>
        .user-form-container {
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        .form-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .form-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 25px;
            border: none;
        }

        .form-card .card-header h4 {
            margin: 0;
            font-weight: 600;
        }

        .form-card .card-body {
            padding: 30px;
        }

        .form-label {
            font-weight: 500;
            color: #555;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .alert-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border: none;
            border-left: 4px solid #2196f3;
            color: #0d47a1;
        }

        .form-check-input:checked {
            background-color: #667eea;
            border-color: #667eea;
        }

        .invalid-feedback {
            color: #dc3545;
            font-size: 0.875em;
        }

        .form-text {
            color: #6c757d;
            font-size: 0.875em;
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

                            <div class="user-form-container">
                                <div class="form-card">
                                    <div class="card-header">
                                        <h4><i class="fas fa-user-plus"></i> ${action == 'add' ? 'Add New User' : 'Edit User'}</h4>
                                    </div>
                                    <div class="card-body">
          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <h6 style="margin-bottom: 15px; font-weight: bold;">
                    <i class="fas fa-exclamation-triangle"></i> User Creation Failed
                </h6>
                <pre style="white-space: pre-wrap; font-size: 13px; margin: 0; background: #f8f9fa; padding: 15px; border-radius: 4px; border-left: 4px solid #dc3545;">${error}</pre>
                <small style="display: block; margin-top: 10px; color: #666;">
                    <strong>Note:</strong> Please review the errors above and correct the form data before submitting again.
                </small>
            </div>
          </c:if>



          <form action="${pageContext.request.contextPath}/admin/user" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="${action}">
            <c:if test="${action == 'update'}">
              <input type="hidden" name="userId" value="${user.id}">
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

            <c:if test="${action != 'add'}">
              <div class="mb-3">
                <label for="password" class="form-label">Password (leave blank to keep current)</label>
                <input type="password" class="form-control" id="password" name="password">
                <div class="form-text">Leave empty to keep the current password</div>
              </div>
            </c:if>
            
            <c:if test="${action == 'add'}">
              <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <strong>Password will be auto-generated:</strong> A secure password will be automatically created and sent to the user via email.
              </div>
            </c:if>

            <div class="mb-3">
              <label class="form-label d-block">Gender*</label>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="male"
                       value="male" ${user.gender == 1 ? 'checked' : ''} required>
                <label class="form-check-label" for="male">Male</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="female"
                       value="female" ${user.gender == 0 ? 'checked' : ''} required>
                <label class="form-check-label" for="female">Female</label>
              </div>
            </div>

            <div class="mb-3">
              <label for="mobile" class="form-label">Mobile Number*</label>
              <input type="tel" class="form-control" id="mobile" name="mobile"
                     value="${user.mobile}" placeholder="Enter mobile number (e.g., 0123456789)" required>
              <div class="invalid-feedback" id="mobile-error">
                Please provide a valid mobile number.
              </div>
              <div class="form-text">Mobile number must start with 03, 05, 07, 08, 09 and have 10 digits</div>
            </div>

            <div class="mb-3">
              <label for="roleId" class="form-label">Role*</label>
              <select class="form-select" id="roleId" name="roleId" required>
                <option value="">Select Role</option>
                <c:forEach var="role" items="${roles}">
                  <option value="${role.id}" ${user.role_id == role.id ? 'selected' : ''}>
                      ${role.name}
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
                                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-md-2">
                                                <i class="fas fa-arrow-left"></i> Cancel
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-check-circle"></i> Save
                                            </button>
                                        </div>
                                    </form>
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

    // Mobile number validation
    document.addEventListener('DOMContentLoaded', function() {
        const mobileInput = document.getElementById('mobile');
        const mobileError = document.getElementById('mobile-error');
        
        function validateMobile(mobile) {
            // Remove all spaces and special characters
            const cleanMobile = mobile.replaceAll(/[\s\-\(\)]/g, '');
            
            // Check if it's a valid Vietnamese mobile number
            // Pattern requires: starts with 03, 05, 07, 08, or 09 and has exactly 10 digits
            const mobileRegex = /^(0[3|5|7|8|9])+([0-9]{8})$/;
            
            if (mobile.trim() === '') {
                return 'Mobile number is required';
            }
            
            if (!mobileRegex.test(cleanMobile)) {
                return 'Mobile number must start with 03, 05, 07, 08, 09 and have 10 digits';
            }
            
            return null; // No error
        }
        
        mobileInput.addEventListener('input', function() {
            const mobileValue = this.value;
            const error = validateMobile(mobileValue);
            
            if (error) {
                mobileInput.classList.add('is-invalid');
                mobileError.textContent = error;
            } else {
                mobileInput.classList.remove('is-invalid');
                mobileInput.classList.add('is-valid');
                mobileError.textContent = '';
            }
        });
        
        mobileInput.addEventListener('blur', function() {
            const mobileValue = this.value;
            const error = validateMobile(mobileValue);
            
            if (error) {
                mobileInput.classList.add('is-invalid');
                mobileError.textContent = error;
            } else {
                mobileInput.classList.remove('is-invalid');
                mobileInput.classList.add('is-valid');
                mobileError.textContent = '';
            }
        });
    });
</script>
</body>
</html>