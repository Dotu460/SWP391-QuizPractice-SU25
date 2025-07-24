<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <!-- CSS here -->
    <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
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
            margin-bottom: 36px;
            background: #f8f9fd;
            border-radius: 18px;
            box-shadow: 0 2px 12px rgba(87,81,225,0.06);
            padding: 28px 28px 18px 28px;
            border: 1px solid #eceefd;
        }
        .details-section h5 {
            margin-bottom: 22px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e0e3fa;
            color: #5751e1;
            font-size: 1.25rem;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .info-row {
            margin-bottom: 18px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eceefd;
        }
        .info-label {
            font-weight: 700;
            color: #3d38a1;
            font-size: 1.05rem;
        }
        .info-value {
            color: #222;
            font-size: 1.08rem;
            margin-top: 2px;
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
        .purchase-btn-theme {
            background: #5751e1;
            color: #fff;
            border: none;
            padding: 12px 36px;
            border-radius: 999px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 6px 20px 0 rgba(87,81,225,0.18);
            outline: none;
        }
        .purchase-btn-theme:hover, .purchase-btn-theme:focus {
            background: #3d38a1;
            color: #fff;
            box-shadow: 0 10px 32px 0 rgba(87,81,225,0.22);
        }
        .main-title-package {
            font-size: 2.1rem;
            font-weight: 800;
            color: #5751e1;
            letter-spacing: 1px;
            margin-bottom: 18px;
            text-shadow: 0 2px 8px rgba(87,81,225,0.08);
            background: linear-gradient(90deg, #8B7FD2 0%, #5751e1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
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
                                <!-- Title and Back Button Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                            <h4 class="main-title-package">Price Package Details</h4>
                                            <a href="${pageContext.request.contextPath}/price-package-menu" class="btn btn-secondary rounded-pill">
                                                <i class="fa fa-arrow-left me-2"></i> Back to Packages
                                            </a>
                                        </div>
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
                                                                            <c:out value="${fn:replace(pricePackage.description, '
', '<br/>')}" escapeXml="false"/>
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
                                                                        <fmt:formatNumber value="${pricePackage.list_price}" type="currency" currencySymbol="₫" />
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Sale Price</div>
                                                                <div class="info-value">
                                                                    <span class="price-highlight">
                                                                        <fmt:formatNumber value="${pricePackage.sale_price}" type="currency" currencySymbol="₫" />
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
                                                                                <fmt:formatNumber value="${pricePackage.list_price - pricePackage.sale_price}" type="currency" currencySymbol="₫" />
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
                                                                    <fmt:formatNumber value="${pricePackage.sale_price / pricePackage.access_duration_months}" type="currency" currencySymbol="₫" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- End of Details -->
                                                <c:if test="${pricePackage.status eq 'active'}">
                                                    <div class="text-end mt-4">
                                                        <c:choose>
                                                            <c:when test="${isPurchased}">
                                                                <!-- User has purchased this package -->
                                                                <a href="${pageContext.request.contextPath}/quiz-handle-menu?packageId=${pricePackage.id}" class="purchase-btn-theme" style="background:#28a745; text-decoration:none; display:inline-block;">
                                                                    Access
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- User hasn't purchased this package -->
                                                                <c:choose>
                                                                    <c:when test="${empty currentUser}">
                                                                        <!-- User not logged in -->
                                                                        <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/price-package-menu?id=${pricePackage.id}" class="purchase-btn-theme" style="text-decoration:none; display:inline-block;">
                                                                           Purchase 
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <!-- User logged in but haven't purchased -->
                                                                        <form action="${pageContext.request.contextPath}/ajaxServlet" method="post" style="display:inline-block;">
                                                                            <input type="hidden" name="packageId" value="${pricePackage.id}"/>
                                                                            <input type="hidden" name="amount" value="${pricePackage.sale_price}"/>
                                                                            <button type="submit" class="purchase-btn-theme">Purchase</button>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
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
        </section>
    </main>
    <!-- main-area-end -->
    <!-- footer-area -->
    <jsp:include page="../../common/user/footer.jsp"></jsp:include>
    <!-- footer-area-end -->
    <!-- JS here -->
    <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
</body>
</html>
