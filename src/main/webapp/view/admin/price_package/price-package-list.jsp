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
            
            .action-details {
                background-color: #5751e1;
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
            
            .column-hidden {
                display: none;
            }
            
            .column-checkbox {
                margin-bottom: 10px;
                display: flex;
                align-items: center;
            }
            
            .column-checkbox input[type="checkbox"] {
                margin-right: 8px;
            }
            
            .column-checkbox label {
                margin-bottom: 0;
                user-select: none;
                cursor: pointer;
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

                            <c:url value="/admin/price-package-list" var="paginationUrl">
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
                                            <a href="${pageContext.request.contextPath}/admin/price-package-list?action=add" class="add-btn">
                                                <i class="fas fa-plus"></i> Add New Package
                                            </a>
                                            <button type="button" class="settings-btn ml-2" id="columnSettingsBtn">
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
                                        <form action="${pageContext.request.contextPath}/admin/price-package-list" method="get" id="filterForm">
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
                                            
                                            <!-- Hidden field to preserve showAll parameter -->
                                            <input type="hidden" id="showAllField" name="showAll" value="${param.showAll}" />
                                            
                                            <div class="row mt-2">
                                                <div class="col-md-12 d-flex justify-content-end">
                                                    <button type="submit" class="btn btn-primary" style="padding: 6px 15px; font-size: 15px;">Filter</button>
                                                    <a href="${pageContext.request.contextPath}/admin/price-package-list" class="btn btn-secondary ml-2" style="padding: 6px 15px; font-size: 15px; margin-left: 8px;">Reset</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Package List Info -->
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            Showing <span class="fw-bold">${fn:length(pricePackages)}</span> of <span class="fw-bold">${totalPackages}</span> price packages
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <div class="input-group" style="width: auto;">
                                                <input type="number" id="customPageSize" class="form-control form-control-sm" min="1" max="100" value="${showAll ? '' : pageSize}" style="width: 80px; height: 38px;" ${showAll ? 'disabled placeholder="-"' : ''} />
                                                <button class="btn btn-primary" onclick="applyCustomPageSize()" id="applySizeBtn" style="padding: 6px 12px; font-size: 15px;">Apply</button>
                                            </div>
                                            <span class="ms-2">items per page</span>
                                            <div class="form-check ms-3">
                                                <input class="form-check-input" type="checkbox" id="showAllCheckbox" ${param.showAll eq 'true' ? 'checked' : ''}>
                                                <label class="form-check-label" for="showAllCheckbox">
                                                    Show all
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Package Table -->
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover" id="pricePackageTable">
                                            <thead>
                                                <tr>
                                                    <th class="column-id">ID</th>
                                                    <th class="column-name">Name</th>
                                                    <th class="column-duration">Duration (Months)</th>
                                                    <th class="column-list-price">List Price</th>
                                                    <th class="column-sale-price">Sale Price</th>
                                                    <th class="column-status">Status</th>
                                                    <th class="column-description">Description</th>
                                                    <th class="column-actions">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${pricePackages}" var="pkg" varStatus="loop">
                                                    <tr>
                                                        <td class="column-id">${pkg.id}</td>
                                                        <td class="column-name"><strong>${pkg.name}</strong></td>
                                                        <td class="column-duration">${pkg.access_duration_months}</td>
                                                        <td class="column-list-price"><fmt:formatNumber value="${pkg.list_price}" type="currency" currencySymbol="$" /></td>
                                                        <td class="column-sale-price"><fmt:formatNumber value="${pkg.sale_price}" type="currency" currencySymbol="$" /></td>
                                                        <td class="column-status">
                                                            <span class="package-status ${pkg.status == 'active' ? 'status-active' : 'status-inactive'}">
                                                                ${pkg.status}
                                                            </span>
                                                        </td>
                                                        <td class="column-description">
                                                            <span title="${pkg.description}">
                                                                ${pkg.description != null ? (fn:length(pkg.description) > 50 ? fn:substring(pkg.description, 0, 50).concat('...') : pkg.description) : 'No description'}
                                                            </span>
                                                        </td>
                                                        <td class="column-actions">
                                                            <div class="table-actions">
                                                                <a href="${pageContext.request.contextPath}/admin/price-package-list?action=details&id=${pkg.id}" class="action-details">
                                                                    <i class="fas fa-eye"></i> Details
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/price-package-list?action=edit&id=${pkg.id}" class="action-edit">
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

        <!-- Settings Modal -->
        <div class="modal fade" id="columnSettingsModal" tabindex="-1" role="dialog" aria-labelledby="columnSettingsModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="columnSettingsModalLabel">Customize Column Display</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="columnSettingsForm">
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-id" value="id" checked>
                                <label for="col-id">ID</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-name" value="name" checked>
                                <label for="col-name">Name</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-duration" value="duration" checked>
                                <label for="col-duration">Duration</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-list-price" value="list-price" checked>
                                <label for="col-list-price">List Price</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-sale-price" value="sale-price" checked>
                                <label for="col-sale-price">Sale Price</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-status" value="status" checked>
                                <label for="col-status">Status</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-description" value="description" checked>
                                <label for="col-description">Description</label>
                            </div>
                        </form>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="selectAllBtn">Select All</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="deselectAllBtn">Deselect All</button>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="applySettingsBtn">Apply</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
        
        <!-- iziToast CSS and JS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/css/iziToast.min.css">
        <script src="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/js/iziToast.min.js"></script>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
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
                
                // Function to change page size
                window.changePageSize = function(newSize, showAll) {
                    // Set a flag to indicate navigation is due to pagination
                    sessionStorage.setItem('isPricePackagePaginating', 'true');
                    const url = new URL(window.location);
                    
                    if (showAll) {
                        url.searchParams.set('showAll', 'true');
                        url.searchParams.delete('pageSize');
                    } else {
                        url.searchParams.delete('showAll');
                        url.searchParams.set('pageSize', newSize);
                    }
                    
                    url.searchParams.set('page', '1'); // Reset to first page
                    window.location.href = url.toString();
                };
                
                // Function to apply custom page size from input
                window.applyCustomPageSize = function() {
                    const showAllCheckbox = document.getElementById('showAllCheckbox');
                    
                    if (showAllCheckbox.checked) {
                        // Show all items
                        changePageSize(null, true);
                    } else {
                        // Apply custom page size
                        const customSizeInput = document.getElementById('customPageSize');
                        let newSize = parseInt(customSizeInput.value);
                        
                        // Validate input
                        if (isNaN(newSize) || newSize < 1) {
                            newSize = 10; // Default value if invalid
                            customSizeInput.value = newSize;
                        } else if (newSize > 100) {
                            newSize = 100; // Max limit
                            customSizeInput.value = newSize;
                        }
                        
                        // Apply the new page size
                        changePageSize(newSize, false);
                    }
                };
                
                // Add event listener for Enter key on the input
                document.getElementById('customPageSize').addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        applyCustomPageSize();
                    }
                });
                
                // Add event listener for checkbox
                document.getElementById('showAllCheckbox').addEventListener('change', function() {
                    const customSizeInput = document.getElementById('customPageSize');
                    const showAllField = document.getElementById('showAllField');
                    
                    if (this.checked) {
                        customSizeInput.disabled = true;
                        customSizeInput.value = '';
                        customSizeInput.placeholder = '-';
                        showAllField.value = 'true';
                    } else {
                        customSizeInput.disabled = false;
                        customSizeInput.value = '${pageSize == 2147483647 ? 10 : pageSize}';
                        customSizeInput.placeholder = '';
                        showAllField.value = '';
                    }
                });
            });
            
            $(document).ready(function() {
                const storageKey = 'pricePackageColumnPrefs';
                const navigationFlag = 'isPricePackagePaginating';

                // --- Main Event Handlers ---
                $('#columnSettingsBtn').click(function() {
                    syncModal();
                    $('#columnSettingsModal').modal('show');
                });

                $('#applySettingsBtn').click(function() {
                    saveAndApplySettings();
                });

                $('#selectAllBtn').click(function() {
                    $('#columnSettingsForm input[type="checkbox"]').prop('checked', true);
                });

                $('#deselectAllBtn').click(function() {
                    $('#columnSettingsForm input[type="checkbox"]').prop('checked', false);
                });

                // Add listener for pagination link clicks
                $('.pagination a').on('click', function(e) {
                    if (!$(this).parent().hasClass('disabled')) {
                        sessionStorage.setItem(navigationFlag, 'true');
                    }
                });

                // --- Helper Functions ---
                function getPrefsFromSession() {
                    const savedPrefs = sessionStorage.getItem(storageKey);
                    if (savedPrefs) {
                        return JSON.parse(savedPrefs);
                    }
                    // Default: show all columns
                    return { 
                        id: true, 
                        name: true, 
                        duration: true, 
                        'list-price': true, 
                        'sale-price': true, 
                        status: true, 
                        description: true 
                    };
                }

                function savePrefsToSession() {
                    const prefs = {};
                    $('#columnSettingsForm input[type="checkbox"]').each(function() {
                        prefs[this.value] = this.checked;
                    });
                    sessionStorage.setItem(storageKey, JSON.stringify(prefs));
                    return prefs;
                }

                function applyColumnVisibility(prefs) {
                    prefs = prefs || { 
                        id: true, 
                        name: true, 
                        duration: true, 
                        'list-price': true, 
                        'sale-price': true, 
                        status: true, 
                        description: true 
                    };
                    
                    $('#pricePackageTable .column-id').toggle(!!prefs.id);
                    $('#pricePackageTable .column-name').toggle(!!prefs.name);
                    $('#pricePackageTable .column-duration').toggle(!!prefs.duration);
                    $('#pricePackageTable .column-list-price').toggle(!!prefs['list-price']);
                    $('#pricePackageTable .column-sale-price').toggle(!!prefs['sale-price']);
                    $('#pricePackageTable .column-status').toggle(!!prefs.status);
                    $('#pricePackageTable .column-description').toggle(!!prefs.description);
                }
                
                function syncModal() {
                    const prefs = getPrefsFromSession();
                    $('#columnSettingsForm input[type="checkbox"]').each(function() {
                        this.checked = prefs[this.value] !== false;
                    });
                }

                function saveAndApplySettings() {
                    const prefs = savePrefsToSession();
                    applyColumnVisibility(prefs);
                    $('#columnSettingsModal').modal('hide');
                    iziToast.success({
                        title: 'Success',
                        message: 'Display settings updated successfully!',
                        position: 'topRight'
                    });
                }

                function resetToDefault() {
                    const defaultPrefs = { 
                        id: true, 
                        name: true, 
                        duration: true, 
                        'list-price': true, 
                        'sale-price': true, 
                        status: true, 
                        description: true 
                    };
                    applyColumnVisibility(defaultPrefs);
                    $('#columnSettingsForm input[type="checkbox"]').prop('checked', true);
                    sessionStorage.setItem(storageKey, JSON.stringify(defaultPrefs));
                }
                
                // --- Initial Load Logic ---
                function initializeView() {
                    if (sessionStorage.getItem(navigationFlag) === 'true') {
                        const prefs = getPrefsFromSession();
                        applyColumnVisibility(prefs);
                        sessionStorage.removeItem(navigationFlag); // Consume the flag
                    } else {
                        resetToDefault();
                    }
                }
                
                // Run on page load
                initializeView();
            });
        </script>
    </body>

</html>
