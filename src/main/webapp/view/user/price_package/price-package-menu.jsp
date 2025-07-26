<%-- 
    Document   : price-package-menu
    Created on : Jul 17, 2025, 3:39:19 PM
    Author     : kenngoc
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Price Package</title>
        <meta name="description" content="SkillGro - Price Package">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->
            <style>
                .package-card {
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                    padding: 24px;
                    margin-bottom: 24px;
                    background: #fff;
                    transition: box-shadow 0.2s;
                    height: 100%;
                    display: flex;
                    flex-direction: column;
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
                    flex-grow: 1;
                }
                .buy-btn {
                    background: #5751e1;
                    color: #fff;
                    border: none;
                    padding: 8px 20px;
                    border-radius: 4px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    text-decoration: none;
                    display: inline-block;
                }
                .buy-btn:hover,
                .buy-btn:hover:enabled {
                    background: #ffd700;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 8px rgba(255, 215, 0, 0.3);
                    color: #000;
                    text-decoration: none;
                }
                
                /* Override Bootstrap btn-primary to remove box-shadow */
                .btn-primary {
                    box-shadow: none !important;
                }
                .btn-primary:hover {
                    box-shadow: none !important;
                }
                .access-btn {
                    background: linear-gradient(90deg, #28a745 0%, #218838 100%) !important;
                    color: #fff !important;
                    border: none;
                    padding: 8px 20px;
                    border-radius: 4px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: background 0.2s;
                    font-size: 1rem;
                    display: inline-block;
                    text-align: center;
                    box-shadow: 0 2px 8px rgba(40,167,69,0.07);
                }
                .access-btn:hover {
                    background: linear-gradient(90deg, #218838 0%, #28a745 100%) !important;
                    text-decoration: none;
                    color: #fff !important;
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
                .status-unavailable {
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
                .dashboard__area.section-pb-120 {
                    padding-top: 18px !important;
                    padding-bottom: 24px !important;
                }
            </style>
        </head>

        <body>
            <!-- header-area -->
            <jsp:include page="../../common/user/header.jsp"></jsp:include>
            <!-- header-area-end -->
            <!-- Scroll-top -->
            <button class="scroll__top scroll-to-target" data-target="html">
                <i class="tg-flaticon-arrowhead-up"></i>
            </button>
            <!-- Scroll-top-end-->

            

            <!-- main-area -->
            <main class="main-area">
                <section class="dashboard__area section-pb-120">
                    <div class="container-fluid">
                        <div class="dashboard__inner-wrap">
                            <div class="row">
                            <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>
                            
                                <div class="col-xl-9">
                                    <div class="dashboard__content-area">
                                        
                                        <!-- Search and Sort Controls -->
                                        <div class="mb-4 d-flex align-items-center gap-3">
                                            <input id="packageSearchInput" type="text" class="form-control" style="max-width: 350px; border: 2px solid #8B7FD2; border-radius: 8px; font-size: 1.08rem; padding: 10px 18px; color: #3d38a1; background: #f6f7fb; transition: border-color 0.2s; box-shadow: 0 2px 8px rgba(87,81,225,0.04);" placeholder="Search package by name...">
                                            <select id="packageSortMode" class="form-select" style="min-width: 180px; max-width: 260px; font-size: 0.98rem;">
                                                <option value="name-asc">Sort by Name A-Z</option>
                                                <option value="name-desc">Sort by Name Z-A</option>
                                                <option value="price-asc">Sort by Price Low-High</option>
                                                <option value="price-desc">Sort by Price High-Low</option>
                                            </select>
                                            <button type="button" class="btn btn-primary btn-sm" onclick="applySearchAndSort()" style="height: 38px; display: flex; align-items: center; justify-content: center;">
                                                Apply
                                            </button>
                                        </div>
                                        <script>
                                            function applySearchAndSort() {
                                                const search = document.getElementById('packageSearchInput').value.trim().toLowerCase();
                                                const sortMode = document.getElementById('packageSortMode').value;
                                                const packageList = document.querySelector('.row.row-cols-1.row-cols-md-2.row-cols-lg-3.g-4');
                                                const packageCards = Array.from(document.querySelectorAll('.package-card-wrapper'));
                                                
                                                // Filter by name
                                                let filtered = packageCards.filter(card => {
                                                    const name = card.getAttribute('data-package-name') || '';
                                                    return name.includes(search);
                                                });
                                                
                                                // Sort
                                                filtered.sort((a, b) => {
                                                    if (sortMode === 'name-asc') {
                                                        return a.getAttribute('data-package-name').localeCompare(b.getAttribute('data-package-name'));
                                                    } else if (sortMode === 'name-desc') {
                                                        return b.getAttribute('data-package-name').localeCompare(a.getAttribute('data-package-name'));
                                                    } else if (sortMode === 'price-asc') {
                                                        return parseFloat(a.getAttribute('data-package-price')) - parseFloat(b.getAttribute('data-package-price'));
                                                    } else if (sortMode === 'price-desc') {
                                                        return parseFloat(b.getAttribute('data-package-price')) - parseFloat(a.getAttribute('data-package-price'));
                                                    }
                                                    return 0;
                                                });
                                                
                                                // Remove all
                                                packageCards.forEach(card => card.style.display = 'none');
                                                
                                                // Append filtered & sorted
                                                filtered.forEach(card => {
                                                    card.style.display = '';
                                                    packageList.appendChild(card);
                                                });
                                            }
                                            
                                            // Handle Enter key on search input
                                            document.getElementById('packageSearchInput').addEventListener('keypress', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    applySearchAndSort();
                                                }
                                            });
                                        </script>
                                        <!-- Pagination and page size controls -->
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div>
                                                Showing <span class="fw-bold">${fn:length(pricePackages)}</span> of <span class="fw-bold">${totalPackages}</span> price packages
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <form id="paginationForm" method="get" action="${pageContext.request.contextPath}/price-package-menu" class="d-flex align-items-center gap-2 mb-0">
                                                    <input type="number" id="customPageSize" name="pageSize" class="form-control form-control-sm" min="1" max="100" value="${showAll ? '' : pageSize}" style="width: 80px; height: 38px;" ${showAll ? 'disabled placeholder="-"' : ''} />
                                                    <button type="button" class="btn btn-primary btn-sm" onclick="applyCustomPageSize()">Apply</button>
                                                    <span class="ms-2">items per page</span>
                                                    <div class="form-check ms-3">
                                                        <input class="form-check-input" type="checkbox" id="showAllCheckbox" name="showAll" value="true" ${showAll ? 'checked' : ''}>
                                                        <label class="form-check-label" for="showAllCheckbox">Show all</label>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <script>
                                            function applyCustomPageSize() {
                                                const showAllCheckbox = document.getElementById('showAllCheckbox');
                                                if (showAllCheckbox.checked) {
                                                    document.getElementById('customPageSize').disabled = true;
                                                    document.getElementById('customPageSize').value = '';
                                                } else {
                                                    document.getElementById('customPageSize').disabled = false;
                                                }
                                                document.getElementById('paginationForm').submit();
                                            }
                                            
                                            // Handle Enter key on pageSize input
                                            document.getElementById('customPageSize').addEventListener('keypress', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    applyCustomPageSize();
                                                }
                                            });
                                            
                                            // Handle Show All checkbox change - only disable/enable, don't auto submit
                                            document.getElementById('showAllCheckbox').addEventListener('change', function () {
                                                const customPageSize = document.getElementById('customPageSize');
                                                if (this.checked) {
                                                    customPageSize.disabled = true;
                                                    customPageSize.value = '';
                                                } else {
                                                    customPageSize.disabled = false;
                                                }
                                            });
                                        </script>
                                        <!-- End Pagination/PageSize Controls -->
                                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                                        <c:forEach items="${pricePackages}" var="pkg">
                                            <div class="col package-card-wrapper" data-package-name="${fn:toLowerCase(pkg.name)}" data-package-price="${pkg.sale_price}">
                                                <div class="package-card h-100">
                                                    <div class="package-title">${pkg.name}</div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${pkg.sale_price < pkg.list_price}">
                                                                <!-- Có giảm giá: hiển thị cả list price (gạch ngang) và sale price -->
                                                                <span class="package-list-price">
                                                                    <fmt:formatNumber value="${pkg.list_price}" type="currency" currencySymbol="₫"/>
                                                                </span>
                                                                <span class="package-price">
                                                                    <fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="₫"/>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- Không giảm giá: chỉ hiển thị sale price (không gạch ngang) -->
                                                                <span class="package-price">
                                                                    <fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="₫"/>
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
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
                                                                            <c:out value="${fn:replace(fn:substring(pkg.description, 0, 50), '', '<br/>')}" escapeXml="false"/>...
                                                                        </span>
                                                                        <a href="javascript:void(0);" class="see-more-link" data-id="${pkg.id}">See more</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${fn:replace(pkg.description, '', '<br/>')}" escapeXml="false"/>
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
                                                        <span class="status-${pkg.status == 'active' ? 'available' : 'unavailable'}">
                                                            ${pkg.status == 'active' ? 'Available' : 'Unavailable'}
                                                        </span>
                                                    </div>
                                                    
                                                    
                                                    
                                                    
                                                    <div class="mt-auto pt-3">
                                                        <c:choose>
                                                            <c:when test="${not empty userPurchases[pkg.id]}">
                                                                <!-- User has purchased this package -->
                                                                <a href="${pageContext.request.contextPath}/quiz-handle-menu?packageId=${pkg.id}" class="buy-btn access-btn" style="margin-right:8px;">
                                                                    Access
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- User hasn't purchased this package -->
                                                                <c:choose>
                                                                    <c:when test="${empty currentUser}">
                                                                        <!-- User not logged in -->
                                                                        <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/price-package-menu${not empty param.id ? ('?id=' + param.id) : ''}" class="buy-btn" style="text-decoration:none; display:inline-block;">
                                                                           Purchase 
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <!-- User logged in but haven't purchased -->
                                                                        <!-- THAY BẰNG form này: -->
                                                                        <form action="${pageContext.request.contextPath}/ajaxServlet" method="post" style="display:inline-block;">
                                                                            <input type="hidden" name="packageId" value="${pkg.id}"/>
                                                                            <input type="hidden" name="amount" value="${pkg.sale_price}"/>
                                                                            <button type="submit" class="buy-btn" ${pkg.status != 'active' ? 'disabled' : ''}>
                                                                                Purchase
                                                                            </button>
                                                                        </form>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <a href="${pageContext.request.contextPath}/price-package-menu?id=${pkg.id}" class="buy-btn" style="background:#6c757d; margin-left:8px; text-decoration:none; display:inline-block;">
                                                            Learn More
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <!-- Pagination controls -->
                                    <div class="d-flex justify-content-center mt-4">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/price-package-menu?page=${currentPage - 1}&pageSize=${pageSize}&showAll=${showAll}">&laquo;</a>
                                                    </li>
                                                </c:if>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/price-package-menu?page=${i}&pageSize=${pageSize}&showAll=${showAll}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/price-package-menu?page=${currentPage + 1}&pageSize=${pageSize}&showAll=${showAll}">&raquo;</a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                    <!-- End Pagination controls -->
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
