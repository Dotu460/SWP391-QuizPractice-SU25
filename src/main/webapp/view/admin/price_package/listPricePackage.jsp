<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Price Package Management</title>
        <meta name="description" content="SkillGro - Price Package Management">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .package-status {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
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
            
            .table-actions {
                display: flex;
                gap: 8px;
            }
            
            .table-actions a,button {
                padding: 4px 8px;
                border-radius: 4px;
                border: none;
                color: white;
                font-size: 12px;
                cursor: pointer;
            }
            
            .action-edit {
                background-color: #17a2b8;
            }
            
            .action-delete {
                background-color: #dc3545;
            }
            
            .filter-form {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .settings-btn {
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .add-btn {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .modal-header {
                background-color: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }
            
            .column-option {
                margin-bottom: 10px;
            }
            
            .dashboard__content-area {
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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

                            <c:url value="/admin/pricepackage" var="paginationUrl">
                                <c:if test="${not empty param.status}">
                                    <c:param name="status" value="${param.status}" />
                                </c:if>
                                <c:if test="${not empty param.search}">
                                    <c:param name="search" value="${param.search}" />
                                </c:if>
                                <c:if test="${not empty param.minPrice}">
                                    <c:param name="minPrice" value="${param.minPrice}" />
                                </c:if>
                                <c:if test="${not empty param.maxPrice}">
                                    <c:param name="maxPrice" value="${param.maxPrice}" />
                                </c:if>
                                <c:if test="${not empty param.pageSize}">
                                    <c:param name="pageSize" value="${param.pageSize}" />
                                </c:if>
                            </c:url>

                            <div class="col-xl-9">
                                <div class="dashboard__content-area">
                                    <div class="dashboard__content-title d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="title">Price Package Management</h4>
                                        <div>
                                            <button type="button" class="add-btn" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                                                <i class="fas fa-plus"></i> Add New Package
                                            </button>
                                            <button type="button" class="settings-btn ml-2" data-bs-toggle="modal" data-bs-target="#settingModal">
                                                <i class="fa fa-cog"></i> Display Settings
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Success/Error Messages -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            ${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <!-- Filter Form -->
                                    <div class="filter-form">
                                        <form action="${pageContext.request.contextPath}/admin/pricepackage" method="get">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="status">Status</label>
                                                        <select class="form-control" id="status" name="status">
                                                            <option value="">All Status</option>
                                                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="search">Search</label>
                                                        <input type="text" class="form-control" id="search" name="search" 
                                                               placeholder="Search by name, description..." value="${param.search}">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="minPrice">Min Price</label>
                                                        <input type="number" class="form-control" id="minPrice" name="minPrice" 
                                                               placeholder="Min price" value="${param.minPrice}">
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group">
                                                        <label for="maxPrice">Max Price</label>
                                                        <input type="number" class="form-control" id="maxPrice" name="maxPrice" 
                                                               placeholder="Max price" value="${param.maxPrice}">
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-2">
                                                <div class="col-md-12 d-flex justify-content-end">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                    <a href="${pageContext.request.contextPath}/admin/pricepackage" class="btn btn-secondary ml-2">Reset</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Package List Info -->
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            Showing <span class="fw-bold">${fn:length(pricePackages)}</span> of <span class="fw-bold">${totalPackages}</span> price packages
                                        </div>
                                        <div>
                                            <select class="form-control" style="width: auto;" onchange="changePageSize(this.value)">
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                                                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 per page</option>
                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100 per page</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Package Table -->
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th>Duration (Months)</th>
                                                    <th>List Price</th>
                                                    <th>Sale Price</th>
                                                    <th>Status</th>
                                                    <th>Description</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${pricePackages}" var="pkg" varStatus="loop">
                                                    <tr>
                                                        <td>${pkg.id}</td>
                                                        <td><strong>${pkg.name}</strong></td>
                                                        <td>${pkg.access_duration_months}</td>
                                                        <td><fmt:formatNumber value="${pkg.list_price}" type="currency" currencySymbol="$" /></td>
                                                        <td><fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="$" /></td>
                                                        <td>
                                                            <span class="package-status ${pkg.status == 'active' ? 'status-active' : 'status-inactive'}">
                                                                ${pkg.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span title="${pkg.description}">
                                                                ${pkg.description != null ? (fn:length(pkg.description) > 50 ? fn:substring(pkg.description, 0, 50).concat('...') : pkg.description) : 'No description'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="table-actions">
                                                                <a type="button" class="action-edit edit-btn"
                                                                     href="${pageContext.request.contextPath}/admin/pricepackage?action=details&id=${pkg.id}">
                                                                    <i class="fas fa-eye"></i> Details
                                                                </a>
                                                                <a type="button" class="action-edit edit-btn"
                                                                     href="${pageContext.request.contextPath}/admin/pricepackage?action=edit&id=${pkg.id}">
                                                                    <i class="fas fa-edit"></i> Edit
                                                                </a>
                                                                <form method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this package?');">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="id" value="${pkg.id}">
                                                                    <button type="submit" class="action-delete">
                                                                        <i class="fas fa-trash"></i> Delete
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty pricePackages}">
                                                    <tr>
                                                        <td colspan="8" class="text-center">No price packages found</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination (if needed) -->
                                    <div class="d-flex justify-content-center mt-4">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${currentPage - 1}"
                                                            aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${currentPage + 1}"
                                                            aria-label="Next">
                                                            <span aria-hidden="true">&raquo;</span>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- main-area-end -->

        <!-- Add Package Modal -->
        <div class="modal fade" id="addPackageModal" tabindex="-1" aria-labelledby="addPackageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addPackageModalLabel">Add New Price Package</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="create">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Package Name *</label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="access_duration_months" class="form-label">Duration (Months) *</label>
                                        <input type="number" class="form-control" id="access_duration_months" name="access_duration_months" min="1" required>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Status *</label>
                                        <select class="form-control" id="status" name="status" required>
                                            <option value="">Select Status</option>
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="list_price" class="form-label">List Price *</label>
                                        <input type="number" class="form-control" id="list_price" name="list_price" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="sale_price" class="form-label">Sale Price *</label>
                                        <input type="number" class="form-control" id="sale_price" name="sale_price" min="1" required>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Create Package</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Settings Modal -->
        <div class="modal fade" id="settingModal" tabindex="-1" role="dialog" aria-labelledby="settingModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="settingModalLabel">Display Settings</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="font-weight-bold mb-3">Select columns to display:</label>
                            <div class="d-flex justify-content-end mb-3">
                                <button type="button" class="btn btn-sm btn-outline-primary mr-2" id="selectAllColumns">Select All</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="deselectAllColumns">Deselect All</button>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="id" id="idColumn" checked>
                                    <label class="form-check-label" for="idColumn">ID</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="name" id="nameColumn" checked>
                                    <label class="form-check-label" for="nameColumn">Name</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="duration" id="durationColumn" checked>
                                    <label class="form-check-label" for="durationColumn">Duration</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="prices" id="pricesColumn" checked>
                                    <label class="form-check-label" for="pricesColumn">Prices</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="status" id="statusColumn" checked>
                                    <label class="form-check-label" for="statusColumn">Status</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="description" id="descriptionColumn" checked>
                                    <label class="form-check-label" for="descriptionColumn">Description</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Apply</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Validate that sale price doesn't exceed list price for add modal
                function validatePrices(listPriceId, salePriceId) {
                    const listPrice = document.getElementById(listPriceId);
                    const salePrice = document.getElementById(salePriceId);
                    
                    function validate() {
                        if (listPrice.value && salePrice.value) {
                            if (parseFloat(salePrice.value) > parseFloat(listPrice.value)) {
                                salePrice.setCustomValidity('Sale price cannot be greater than list price');
                            } else {
                                salePrice.setCustomValidity('');
                            }
                        }
                    }
                    
                    listPrice.addEventListener('input', validate);
                    salePrice.addEventListener('input', validate);
                }
                
                validatePrices('list_price', 'sale_price');
                
                // Select all columns button
                document.getElementById('selectAllColumns').addEventListener('click', function() {
                    document.querySelectorAll('input[type="checkbox"]').forEach(function(checkbox) {
                        checkbox.checked = true;
                    });
                });
                
                // Deselect all columns button
                document.getElementById('deselectAllColumns').addEventListener('click', function() {
                    document.querySelectorAll('input[type="checkbox"]').forEach(function(checkbox) {
                        checkbox.checked = false;
                    });
                });
                
                // Change page size function
                window.changePageSize = function(newSize) {
                    var currentUrl = new URL(window.location);
                    currentUrl.searchParams.set('pageSize', newSize);
                    currentUrl.searchParams.set('page', '1'); // Reset to first page
                    window.location.href = currentUrl.toString();
                };
            });
        </script>
    </body>

</html>
