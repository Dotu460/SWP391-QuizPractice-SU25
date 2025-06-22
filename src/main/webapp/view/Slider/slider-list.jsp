<%-- 
    Document   : slider-list.jsp
    Created on : Jun 20, 2025, 2:40:37 PM
    Author     : kenngoc
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="en">

<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Slider Management</title>
        <meta name="description" content="SkillGro - Slider Management">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .slider-status {
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
            
            .slider-image {
                max-width: 150px;
                max-height: 75px;
                object-fit: cover;
                border-radius: 4px;
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
        <jsp:include page="../common/user/header.jsp"></jsp:include>
        <!-- header-area-end -->

        <!-- main-area -->  
        <main class="main-area">
            <section class="dashboard__area section-pb-120">
                <div class="container-fluid">
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                            <jsp:include page="../common/user/sidebarCustomer.jsp"></jsp:include>

                            <c:url value="/slider-list" var="paginationUrl">
                                <c:if test="${not empty param.status}">
                                    <c:param name="status" value="${param.status}" />
                                </c:if>
                                <c:if test="${not empty param.search}">
                                    <c:param name="search" value="${param.search}" />
                                </c:if>
                                <c:if test="${not empty param.pageSize}">
                                    <c:param name="pageSize" value="${param.pageSize}" />
                                </c:if>
                            </c:url>

                            <div class="col-xl-9">
                                <div class="dashboard__content-area">
                                    <div class="dashboard__content-title d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="title">Slider Management</h4>
                                        <div>
                                            <button type="button" class="add-btn" onclick="location.href='${pageContext.request.contextPath}/slider-list?action=add'">
                                                <i class="fas fa-plus"></i> Add New Slider
                                            </button>
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
                                        <form action="${pageContext.request.contextPath}/slider-list" method="get">
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <div class="form-group">
                                                        <label for="search">Search</label>
                                                        <input type="text" class="form-control" id="search" name="search" 
                                                               placeholder="Search by title or backlink..." value="${param.search}">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label for="status">Status</label>
                                                        <select class="form-control" id="status" name="status">
                                                            <option value="">All Status</option>
                                                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3 d-flex align-items-end">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                    <a href="${pageContext.request.contextPath}/slider-list" class="btn btn-secondary ml-2">Reset</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Slider List Info -->
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            Showing <span class="fw-bold">${fn:length(sliders)}</span> of <span class="fw-bold">${totalSliders}</span> sliders
                                        </div>
                                        <div>
                                            <select class="form-control" style="width: auto;" onchange="changePageSize(this.value)">
                                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 per page</option>
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 per page</option>
                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Slider Table -->
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover" id="sliderTable">
                                            <thead>
                                                <tr>
                                                    <th class="column-id">ID</th>
                                                    <th class="column-title">Title</th>
                                                    <th class="column-image">Image</th>
                                                    <th class="column-backlink">Backlink</th>
                                                    <th class="column-status">Status</th>
                                                    <th class="column-actions">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${sliders}" var="slider">
                                                    <tr>
                                                        <td class="column-id">${slider.id}</td>
                                                        <td class="column-title"><strong>${slider.title}</strong></td>
                                                        <td class="column-image"><img src="${pageContext.request.contextPath}${slider.image_url}" alt="${slider.title}" class="slider-image"/></td>
                                                        <td class="column-backlink"><a href="${slider.backlink_url}" target="_blank">${slider.backlink_url}</a></td>
                                                        <td class="column-status">
                                                            <span class="slider-status ${slider.status ? 'status-active' : 'status-inactive'}">
                                                                ${slider.status ? 'Active' : 'Inactive'}
                                                            </span>
                                                        </td>
                                                        <td class="column-actions">
                                                            <div class="table-actions">
                                                                <a href="${pageContext.request.contextPath}/slider-list?action=edit&id=${slider.id}" class="action-edit">
                                                                    <i class="fas fa-edit"></i> Edit
                                                                </a>
                                                                <form action="${pageContext.request.contextPath}/slider-list" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this slider?');">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="id" value="${slider.id}">
                                                                    <button type="submit" class="action-delete">
                                                                        <i class="fas fa-trash"></i> Delete
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty sliders}">
                                                    <tr>
                                                        <td colspan="6" class="text-center">No sliders found</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <div class="d-flex justify-content-center mt-4">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${paginationUrl}${fn:contains(paginationUrl, '?') ? '&' : '?'}page=${currentPage - 1}" aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="${paginationUrl}${fn:contains(paginationUrl, '?') ? '&' : '?'}page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="${paginationUrl}${fn:contains(paginationUrl, '?') ? '&' : '?'}page=${currentPage + 1}" aria-label="Next">
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
                
        <!-- Column Settings Modal -->
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
                                <input type="checkbox" id="col-title" value="title" checked>
                                <label for="col-title">Title</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-image" value="image" checked>
                                <label for="col-image">Image</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-backlink" value="backlink" checked>
                                <label for="col-backlink">Backlink</label>
                            </div>
                            <div class="column-checkbox">
                                <input type="checkbox" id="col-status" value="status" checked>
                                <label for="col-status">Status</label>
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
        <jsp:include page="../common/user/footer.jsp"></jsp:include>
        <!-- footer-area-end -->

        <!-- JS here -->
        <jsp:include page="../common/user/link_js_common.jsp"></jsp:include>
        
        <!-- iziToast CSS and JS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/css/iziToast.min.css">
        <script src="https://cdn.jsdelivr.net/npm/izitoast@1.4.0/dist/js/iziToast.min.js"></script>       
        <script>
            // Function to change page size
            function changePageSize(newSize) {
                // Set a flag to indicate navigation is due to pagination
                sessionStorage.setItem('isSliderPaginating', 'true');
                const url = new URL(window.location);
                url.searchParams.set('pageSize', newSize);
                url.searchParams.set('page', '1'); // Reset to first page
                window.location.href = url.toString();
            }

            $(document).ready(function() {
                const storageKey = 'sliderColumnPrefs';
                const navigationFlag = 'isSliderPaginating';

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
                    return { id: true, title: true, image: true, backlink: true, status: true };
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
                    prefs = prefs || { id: true, title: true, image: true, backlink: true, status: true };
                    $('#sliderTable .column-id').toggle(!!prefs.id);
                    $('#sliderTable .column-title').toggle(!!prefs.title);
                    $('#sliderTable .column-image').toggle(!!prefs.image);
                    $('#sliderTable .column-backlink').toggle(!!prefs.backlink);
                    $('#sliderTable .column-status').toggle(!!prefs.status);
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
                    const defaultPrefs = { id: true, title: true, image: true, backlink: true, status: true };
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
