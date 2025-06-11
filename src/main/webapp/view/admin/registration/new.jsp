<%--
  Created by IntelliJ IDEA.
  User: Tien Hoang
  Date: 6/5/2025
  Time: 9:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Registration Details - SkillGro Dashboard</title>
    <meta name="description" content="SkillGro - Online Courses & Education Platform">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for this page -->
    <style>
        .dashboard__content-wrap {
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        .section {
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #fff;
        }

        .section-header {
            background-color: #f0f8ff;
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            font-weight: 600;
            color: #0066cc;
            font-size: 16px;
        }

        .section-content {
            padding: 20px;
        }

        .form-row {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }

        .form-row label {
            min-width: 150px;
            margin-right: 15px;
            font-weight: 500;
            color: #333;
        }

        .form-row input,
        .form-row select,
        .form-row textarea {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-row input:focus,
        .form-row select:focus,
        .form-row textarea:focus {
            border-color: #4A90E2;
            outline: none;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.1);
        }

        .form-row input[type="date"] {
            max-width: 200px;
        }

        .form-row select {
            max-width: 250px;
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .button-row {
            text-align: center;
            padding: 20px;
            border-top: 1px solid #ddd;
            background-color: #f9f9f9;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 25px;
            margin: 0 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #4A90E2;
            color: white;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .readonly {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }

        .required::after {
            content: " *";
            color: #dc3545;
        }

        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
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

        .price-info {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .price-info .original-price {
            text-decoration: line-through;
            color: #6c757d;
        }

        .price-info .sale-price {
            color: #28a745;
            font-weight: bold;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-paid {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
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
                                <h4 class="title">
                                    <c:choose>
                                        <c:when test="${registration == null}">Add New Registration</c:when>
                                        <c:when test="${isViewMode}">View Registration Details</c:when>
                                        <c:otherwise>Edit Registration</c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>

                            <!-- Success/Error Messages -->
                            <c:if test="${param.success != null}">
                                <div class="alert alert-success">
                                    <c:choose>
                                        <c:when test="${param.success == 'added'}">Registration successfully added.</c:when>
                                        <c:when test="${param.success == 'updated'}">Registration successfully updated.</c:when>
                                        <c:when test="${param.success == 'userCreated'}">
                                            Registration successfully added and user account created.
                                            <c:if test="${sessionScope.passwordNote != null}">
                                                <div class="mt-3 p-3 bg-light border rounded">
                                                    <pre class="mb-0">${sessionScope.passwordNote}</pre>
                                                </div>
                                                <c:remove var="passwordNote" scope="session"/>
                                            </c:if>
                                        </c:when>
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
                                        <c:when test="${param.error == 'userCreateFailed'}">Failed to create user account.</c:when>
                                    </c:choose>
                                </div>
                            </c:if>

                            <form id="registrationForm" action="${pageContext.request.contextPath}/admin/registrations" method="post">
                                <input type="hidden" name="action" value="${registration == null ? 'add' : 'edit'}">
                                <c:if test="${registration != null}">
                                    <input type="hidden" name="id" value="${registration.id}">
                                </c:if>

                                <!-- Registration Details Section -->
                                <div class="section">
                                    <div class="section-header">📋 Registration Details</div>
                                    <div class="section-content">
                                        <div class="form-row">
                                            <label for="subject" class="required">Subject:</label>
                                            <select id="subject" name="subjectId" required ${isViewMode ? 'disabled' : ''}>
                                                <c:forEach items="${subjects}" var="subject">
                                                    <option value="${subject.id}" ${registration != null && registration.subject_id == subject.id ? 'selected' : ''}>
                                                            ${subject.title}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-row">
                                            <label for="package" class="required">Package:</label>
                                            <select id="package" name="packageId" required ${isViewMode ? 'disabled' : ''}>
                                                <c:forEach items="${pricePackages}" var="pkg">
                                                    <option value="${pkg.id}" ${registration != null && registration.package_id == pkg.id ? 'selected' : ''}>
                                                            ${pkg.name} -
                                                        <span class="price-info">
                                                                <span class="original-price">$${pkg.list_price}</span>
                                                                <span class="sale-price">$${pkg.sale_price}</span>
                                                            </span>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-row">
                                            <label for="validFrom" class="required">Valid From:</label>
                                            <input type="date" id="validFrom" name="validFrom"
                                                   value="${registration != null ? registration.valid_from : ''}" required
                                            ${isViewMode ? 'readonly' : ''} />
                                        </div>

                                        <div class="form-row">
                                            <label for="validTo" class="required">Valid To:</label>
                                            <input type="date" id="validTo" name="validTo"
                                                   value="${registration != null ? registration.valid_to : ''}" required
                                            ${isViewMode ? 'readonly' : ''} />
                                        </div>
                                    </div>
                                </div>

                                <!-- Personal Information Section -->
                                <div class="section">
                                    <div class="section-header">👤 Personal Information</div>
                                    <div class="section-content">
                                        <div class="form-row">
                                            <label for="fullName" class="required">Full Name:</label>
                                            <input type="text" id="fullName" name="fullName"
                                                   value="${user != null ? user.full_name : ''}" required
                                            ${isViewMode ? 'readonly' : ''} />
                                        </div>

                                        <div class="form-row">
                                            <label for="gender">Gender:</label>
                                            <select id="gender" name="gender" ${isViewMode ? 'disabled' : ''}>
                                                <option value="1" ${user != null && user.gender == 1 ? 'selected' : ''}>Male</option>
                                                <option value="0" ${user != null && user.gender == 0 ? 'selected' : ''}>Female</option>
                                            </select>
                                        </div>

                                        <div class="form-row">
                                            <label for="email" class="required">Email:</label>
                                            <input type="email" id="email" name="email"
                                                   value="${user != null ? user.email : ''}" required
                                            ${isViewMode ? 'readonly' : ''} />
                                        </div>

                                        <div class="form-row">
                                            <label for="mobile" class="required">Mobile:</label>
                                            <input type="tel" id="mobile" name="mobile"
                                                   value="${user != null ? user.mobile : ''}" required
                                            ${isViewMode ? 'readonly' : ''} />
                                        </div>
                                    </div>
                                </div>

                                <!-- Status & Notes Section -->
                                <div class="section">
                                    <div class="section-header">💳 Status & Notes</div>
                                    <div class="section-content">
                                        <div class="form-row">
                                            <label for="status">Status:</label>
                                            <select id="status" name="status" required ${isViewMode ? 'disabled' : ''}>
                                                <option value="pending" ${registration != null && registration.status == 'pending' ? 'selected' : ''}>Pending</option>
                                                <option value="paid" ${registration != null && registration.status == 'paid' ? 'selected' : ''}>Paid</option>
                                                <option value="cancelled" ${registration != null && registration.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </div>

                                        <div class="form-row">
                                            <label for="notes">Email Content:</label>
                                            <textarea id="notes" name="notes" placeholder="Add any additional notes to be included in the email notification..."
                                            ${isViewMode ? 'readonly' : ''}>${registration != null && registration.status == 'paid' ? 'Your registration has been confirmed. You can now access the course materials.' : ''}</textarea>
                                        </div>
                                    </div>
                                </div>

                                <!-- System Information Section -->
                                <div class="section">
                                    <div class="section-header">🔧 System Information</div>
                                    <div class="section-content">
                                        <div class="form-row">
                                            <label for="registrationTime">Registration Time:</label>
                                            <input type="text" id="registrationTime" class="readonly" readonly
                                                   value="${registration != null ? registration.registration_time : ''}" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="button-row">
                                    <button type="button" class="btn btn-secondary" onclick="history.back()">Back</button>
                                    <c:if test="${!isViewMode}">
                                        <button type="submit" class="btn btn-primary">
                                            <c:choose>
                                                <c:when test="${registration == null}">Add Registration</c:when>
                                                <c:otherwise>Save Changes</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </c:if>
                                    <c:if test="${isViewMode}">
                                        <a href="${pageContext.request.contextPath}/admin/registrations?action=edit&id=${registration.id}"
                                           class="btn btn-primary">Edit</a>
                                    </c:if>
                                </div>
                            </form>
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
    // Handle status change to "Paid"
    document.getElementById('status').addEventListener('change', function() {
        if (this.value === 'paid') {
            // Check if user exists
            const email = document.getElementById('email').value;
            if (email) {
                fetch('${pageContext.request.contextPath}/admin/check-user?email=' + encodeURIComponent(email))
                    .then(response => response.json())
                    .then(data => {
                        if (!data.exists) {
                            if (confirm('User does not exist. Would you like to create a new user account?')) {
                                // Enable user creation fields
                                document.getElementById('fullName').readOnly = false;
                                document.getElementById('gender').disabled = false;
                                document.getElementById('mobile').readOnly = false;
                            } else {
                                this.value = 'pending';
                            }
                        }
                    });
            }
        }
    });

    // Initialize date range validation
    document.getElementById('validTo').addEventListener('change', function() {
        var fromDate = document.getElementById('validFrom').value;
        var toDate = this.value;

        if (fromDate && toDate && fromDate > toDate) {
            alert('To Date must be greater than or equal to From Date');
            this.value = fromDate;
        }
    });

    document.getElementById('validFrom').addEventListener('change', function() {
        var fromDate = this.value;
        var toDate = document.getElementById('validTo').value;

        if (fromDate && toDate && fromDate > toDate) {
            alert('From Date must be less than or equal to To Date');
            this.value = toDate;
        }
    });

    // Form submission
    document.getElementById('registrationForm').addEventListener('submit', function(e) {
        e.preventDefault();

        // Validate form
        if (!this.checkValidity()) {
            e.stopPropagation();
            this.classList.add('was-validated');
            return;
        }

        // Submit form
        this.submit();
    });
</script>
</body>
</html>
