<%-- 
    Document   : price-package-menu
    Created on : Jul 17, 2025, 3:39:19 PM
    Author     : kenngoc
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Price Package</title>
        <meta name="description" content="SkillGro - Price Package">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
            <style>
                .package-card {
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                    padding: 24px;
                    margin-bottom: 24px;
                    background: #fff;
                    transition: box-shadow 0.2s;
                    height: 100%;
                }
                .package-card:hover {
                    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                }
                .package-title {
                    font-size: 1.3rem;
                    font-weight: bold;
                    margin-bottom: 10px;
                }
                .package-price {
                    font-size: 1.1rem;
                    color: #28a745;
                    font-weight: bold;
                }
                .package-list-price {
                    text-decoration: line-through;
                    color: #888;
                    margin-right: 8px;
                }
                .package-duration {
                    font-size: 0.95rem;
                    color: #555;
                }
                .package-description {
                    margin: 12px 0;
                    color: #666;
                }
                .buy-btn {
                    background: #5751e1;
                    color: #fff;
                    border: none;
                    padding: 8px 20px;
                    border-radius: 4px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: background 0.2s;
                }
                .buy-btn:hover:enabled {
                    background: #3d38a1;
                }
                .status-available {
                    display: inline-block;
                    background: #f3f1fd;
                    color: #5751e1;
                    font-weight: 600;
                    border-radius: 999px;
                    padding: 4px 16px;
                    font-size: 0.98rem;
                    letter-spacing: 0.2px;
                    box-shadow: 0 2px 8px rgba(87,81,225,0.07);
                }
                .status-pending {
                    display: inline-block;
                    background: #f3f4f6;
                    color: #888;
                    font-weight: 600;
                    border-radius: 999px;
                    padding: 4px 16px;
                    font-size: 0.98rem;
                    letter-spacing: 0.2px;
                    box-shadow: 0 2px 8px rgba(180,180,180,0.07);
                }
                .d-none {
                    display: none !important;
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
                            
                                <div class="col-xl-9">
                                    <div class="dashboard__content-area">
                                        <div class="dashboard__content-title mb-4">
                                            <h4 class="title">Available Packages</h4>
                                        </div>
                                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                                        <c:forEach items="${pricePackages}" var="pkg">
                                            <div class="col">
                                                <div class="package-card h-100">
                                                    <div class="package-title">${pkg.name}</div>
                                                    <div>
                                                        <span class="package-list-price">
                                                            <fmt:formatNumber value="${pkg.list_price}" type="currency" currencySymbol="₫"/>
                                                        </span>
                                                        <span class="package-price">
                                                            <fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="₫"/>
                                                        </span>
                                                    </div>
                                                    <div class="package-duration">
                                                        Access Duration: ${pkg.access_duration_months} months
                                                    </div>
                                                    <div class="package-description" id="desc-short-${pkg.id}">
                                                        <c:choose>
                                                            <c:when test="${not empty pkg.description}">
                                                                <c:choose>
                                                                    <c:when test="${fn:length(pkg.description) > 50}">
                                                                        <span>
                                                                            <c:out value="${fn:replace(fn:substring(pkg.description, 0, 50), '
', '<br/>')}" escapeXml="false"/>...
                                                                        </span>
                                                                        <a href="javascript:void(0);" class="see-more-link" data-id="${pkg.id}">See more</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${fn:replace(pkg.description, '
', '<br/>')}" escapeXml="false"/>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                No Description
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="package-description d-none" id="desc-full-${pkg.id}">
                                                        <c:out value="${fn:replace(pkg.description, '
', '<br/>')}" escapeXml="false"/>
                                                        <a href="javascript:void(0);" class="see-less-link" data-id="${pkg.id}">See less</a>
                                                    </div>
                                                    <div>
                                                        <span class="status-${pkg.status == 'active' ? 'available' : 'pending'}">
                                                            ${pkg.status == 'active' ? 'Available' : 'Pending'}
                                                        </span>
                                                    </div>
                                                    <div class="mt-3">
                                                        <form action="${pageContext.request.contextPath}/user/buy-price-package" method="post" style="display:inline-block;">
                                                            <input type="hidden" name="packageId" value="${pkg.id}"/>
                                                            <button type="submit" class="buy-btn" ${pkg.status != 'active' ? 'disabled' : ''}>
                                                                Purchase
                                                            </button>
                                                        </form>
                                                        <a href="${pageContext.request.contextPath}/price-package-menu?id=${pkg.id}" class="buy-btn" style="background:#6c757d; margin-left:8px; text-decoration:none; display:inline-block;">
                                                            Learn More
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
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

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Xử lý nút See more
                document.querySelectorAll('.see-more-link').forEach(function (link) {
                    link.addEventListener('click', function () {
                        var id = this.getAttribute('data-id');
                        document.getElementById('desc-short-' + id).classList.add('d-none');
                        document.getElementById('desc-full-' + id).classList.remove('d-none');
                    });
                });
                // Xử lý nút See less
                document.querySelectorAll('.see-less-link').forEach(function (link) {
                    link.addEventListener('click', function () {
                        var id = this.getAttribute('data-id');
                        document.getElementById('desc-full-' + id).classList.add('d-none');
                        document.getElementById('desc-short-' + id).classList.remove('d-none');
                    });
                });
            });
        </script>
    </body>
</html>
