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
                                    <h4 class="title">Registration Details</h4>
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

                                <form id="registrationForm">
                                    <!-- Registration Details Section -->
                                    <div class="section">
                                        <div class="section-header">📋 Registration Details</div>
                                        <div class="section-content">
                                            <div class="form-row">
                                                <label for="subject" class="required">Subject:</label>
                                                <input type="text" id="subject" name="subject" value="Advanced Mathematics" required />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="priority">Priority:</label>
                                                <select id="priority" name="priority">
                                                    <option value="high" selected>High</option>
                                                    <option value="medium">Medium</option>
                                                    <option value="low">Low</option>
                                                </select>
                                            </div>
                                            
                                            <div class="form-row">
                                                <textarea id="customerMessage" name="customerMessage">📦 Premium Package Details
Advanced Mathematics course with 1-on-1 tutoring, practice tests, and completion certificate. Includes digital materials and 24/7 support.

List Price: $399.00 Sale Price: $299.00</textarea>
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="listPrice">List Price:</label>
                                                <input type="text" id="listPrice" name="listPrice" value="$299.00 One Time: $349.00" />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="validFrom" class="required">Valid From:</label>
                                                <input type="date" id="validFrom" name="validFrom" value="2024-06-01" required />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="validTo" class="required">Valid To:</label>
                                                <input type="date" id="validTo" name="validTo" value="2025-06-01" required />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Personal Information Section -->
                                    <div class="section">
                                        <div class="section-header">👤 Personal Information</div>
                                        <div class="section-content">
                                            <div class="form-row">
                                                <label for="fullName" class="required">Full Name:</label>
                                                <input type="text" id="fullName" name="fullName" value="John Doe" required />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="gender">Gender:</label>
                                                <select id="gender" name="gender">
                                                    <option value="male" selected>Male</option>
                                                    <option value="female">Female</option>
                                                    <option value="other">Other</option>
                                                </select>
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="email" class="required">Email:</label>
                                                <input type="email" id="email" name="email" value="john.doe@example.com" required />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="mobile" class="required">Mobile:</label>
                                                <input type="tel" id="mobile" name="mobile" value="+84-90-234-5678" required />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Customer Message Section -->
                                    <div class="section">
                                        <div class="section-header">💬 Customer Message</div>
                                        <div class="section-content">
                                            <div class="form-row">
                                                <textarea id="customerMessage" name="customerMessage">Thank you for registering! Your NetAmateur package is now active. You will receive login information shortly either in message.</textarea>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Status & Payment Section -->
                                    <div class="section">
                                        <div class="section-header">💳 Status & Payment</div>
                                        <div class="section-content">
                                            <div class="form-row">
                                                <label for="currentStatus">Current Status:</label>
                                                <input type="text" id="currentStatus" name="currentStatus" class="readonly" readonly value="Open" />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="sizeText">Sale Representative:</label>
                                                <input type="text" id="sizeText" name="sizeText" class="readonly" readonly value="System Admin" />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- System Information Section -->
                                    <div class="section">
                                        <div class="section-header">🔧 System Information</div>
                                        <div class="section-content">
                                            <div class="form-row">
                                                <label for="registrationTime">Registration Time:</label>
                                                <input type="text" id="registrationTime" name="registrationTime" class="readonly" readonly value="2024-06-05 21:02:00" />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="createdBy">Created By:</label>
                                                <input type="text" id="createdBy" name="createdBy" class="readonly" readonly value="System Admin" />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="lastUpdated">Last Updated:</label>
                                                <input type="text" id="lastUpdated" name="lastUpdated" class="readonly" readonly value="2024-06-05 21:02:00" />
                                            </div>
                                            
                                            <div class="form-row">
                                                <label for="updatedBy">Updated By:</label>
                                                <input type="text" id="updatedBy" name="updatedBy" class="readonly" readonly value="System Admin" />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="button-row">
                                        <button type="button" class="btn btn-secondary" onclick="history.back()">Cancel</button>
                                        <button type="button" class="btn btn-success" onclick="saveForm()">Save Changes</button>
                                        <button type="submit" class="btn btn-primary">Save & Submit Information</button>
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
        function saveForm() {
            alert('Form saved successfully!');
        }
        
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('Form submitted successfully!');
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
    </script>
</body>
</html>
