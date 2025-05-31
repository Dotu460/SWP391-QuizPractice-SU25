<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Price Package Details</title>
    <meta name="description" content="SkillGro - Price Package Details">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/view/common/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

    <!-- Custom CSS for status indicators -->
    <style>
        .package-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #e6f7e6;
            color: #28a745;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #dc3545;
        }
        
        .status-draft {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        
        .details-card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .details-card .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .details-card .card-body {
            padding: 25px;
        }
        
        .details-section {
            margin-bottom: 30px;
        }
        
        .details-section h5 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            color: #343a40;
        }
        
        .info-row {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #212529;
        }
        
        .action-button {
            margin-right: 10px;
            padding: 8px 16px;
            border-radius: 4px;
        }
        
        .price-highlight {
            font-size: 1.2em;
            font-weight: bold;
            color: #28a745;
        }
        
        .price-original {
            text-decoration: line-through;
            color: #6c757d;
            margin-right: 10px;
        }
        
        .discount-badge {
            background-color: #dc3545;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            margin-left: 10px;
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
    <jsp:include page="../../common/user/header.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Price Package Details</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/admin/pricepackage?${param.returnQueryString}" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to Price Packages
                                        </a>
                                    </div>
                                </div>

                                <!-- Price Package Detail Card -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card details-card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Package #${pricePackage.id} - ${pricePackage.name}</h5>
                                            </div>
                                            <div class="card-body">
                                                <!-- Status Badge -->
                                                <div class="text-end mb-4">
                                                    <span class="package-status 
                                                        <c:choose>
                                                            <c:when test="${pricePackage.status eq 'active'}">status-active</c:when>
                                                            <c:when test="${pricePackage.status eq 'inactive'}">status-inactive</c:when>
                                                            <c:otherwise>status-draft</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        ${pricePackage.status}
                                                    </span>
                                                </div>
                                                
                                                <!-- Package Basic Information Section -->
                                                <div class="details-section">
                                                    <h5>Package Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Package Name</div>
                                                                <div class="info-value">${pricePackage.name}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Package ID</div>
                                                                <div class="info-value">${pricePackage.id}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Access Duration</div>
                                                                <div class="info-value">${pricePackage.access_duration_months} months</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Status</div>
                                                                <div class="info-value">
                                                                    <span class="package-status 
                                                                        <c:choose>
                                                                            <c:when test="${pricePackage.status eq 'active'}">status-active</c:when>
                                                                            <c:when test="${pricePackage.status eq 'inactive'}">status-inactive</c:when>
                                                                            <c:otherwise>status-draft</c:otherwise>
                                                                        </c:choose>
                                                                    ">
                                                                        ${pricePackage.status}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <div class="info-row">
                                                                <div class="info-label">Description</div>
                                                                <div class="info-value">
                                                                    <c:choose>
                                                                        <c:when test="${not empty pricePackage.description}">
                                                                            ${pricePackage.description}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">No description provided</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Pricing Information Section -->
                                                <div class="details-section">
                                                    <h5>Pricing Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">List Price</div>
                                                                <div class="info-value">
                                                                    <span class="price-original">
                                                                        <fmt:formatNumber value="${pricePackage.list_price}" type="currency" currencySymbol="$" />
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Sale Price</div>
                                                                <div class="info-value">
                                                                    <span class="price-highlight">
                                                                        <fmt:formatNumber value="${pricePackage.sale_price}" type="currency" currencySymbol="$" />
                                                                    </span>
                                                                    <c:if test="${pricePackage.sale_price < pricePackage.list_price}">
                                                                        <span class="discount-badge">
                                                                            <fmt:formatNumber value="${((pricePackage.list_price - pricePackage.sale_price) / pricePackage.list_price) * 100}" maxFractionDigits="0" />% OFF
                                                                        </span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Savings</div>
                                                                <div class="info-value">
                                                                    <c:choose>
                                                                        <c:when test="${pricePackage.sale_price < pricePackage.list_price}">
                                                                            <span class="text-success">
                                                                                <fmt:formatNumber value="${pricePackage.list_price - pricePackage.sale_price}" type="currency" currencySymbol="$" />
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">No discount</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Price per Month</div>
                                                                <div class="info-value">
                                                                    <fmt:formatNumber value="${pricePackage.sale_price / pricePackage.access_duration_months}" type="currency" currencySymbol="$" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Package Status Information Section -->
                                                <div class="details-section">
                                                    <h5>Status Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Current Status</div>
                                                                <div class="info-value">
                                                                    <span class="package-status 
                                                                        <c:choose>
                                                                            <c:when test="${pricePackage.status eq 'active'}">status-active</c:when>
                                                                            <c:when test="${pricePackage.status eq 'inactive'}">status-inactive</c:when>
                                                                            <c:otherwise>status-draft</c:otherwise>
                                                                        </c:choose>
                                                                    ">
                                                                        ${pricePackage.status}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Availability</div>
                                                                <div class="info-value">
                                                                    <c:choose>
                                                                        <c:when test="${pricePackage.status eq 'active'}">
                                                                            <span class="text-success">Available for purchase</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-danger">Not available for purchase</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Action Buttons Section -->
                                                <div class="mt-4 text-end">
                                                    <a href="${pageContext.request.contextPath}/admin/pricepackage?action=edit&id=${pricePackage.id}" class="btn btn-warning action-button">
                                                        <i class="fa fa-edit"></i> Edit Package
                                                    </a>
                                                    <c:if test="${pricePackage.status eq 'active'}">
                                                        <button type="button" class="btn btn-danger action-button" onclick="confirmDeactivate('${pricePackage.id}')">
                                                            <i class="fa fa-ban"></i> Deactivate Package
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${pricePackage.status eq 'inactive'}">
                                                        <button type="button" class="btn btn-success action-button" onclick="confirmActivate('${pricePackage.id}')">
                                                            <i class="fa fa-check"></i> Activate Package
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    
    <!-- iziToast CSS and JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/css/iziToast.min.css">
    <script src="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/js/iziToast.min.js"></script>

    <script>
        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 5000,
                onClosing: function () {
                    // Remove toast attributes from the session after displaying
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                    }).then(response => {
                        if (!response.ok) {
                            console.error('Failed to remove toast attributes');
                        }
                    }).catch(error => {
                        console.error('Error:', error);
                    });
                }
            });
        }
        
        // Confirm deactivate function
        function confirmDeactivate(packageId) {
            if (confirm('Are you sure you want to deactivate this price package? This will make it unavailable for purchase.')) {
                // Create form and submit
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/pricepackage';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deactivate';
                form.appendChild(actionInput);
                
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = packageId;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Confirm activate function
        function confirmActivate(packageId) {
            if (confirm('Are you sure you want to activate this price package? This will make it available for purchase.')) {
                // Create form and submit
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/pricepackage';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'activate';
                form.appendChild(actionInput);
                
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = packageId;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>

</html> 