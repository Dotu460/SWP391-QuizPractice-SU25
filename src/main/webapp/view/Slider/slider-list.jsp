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
                                                    <th>ID</th>
                                                    <th>Title</th>
                                                    <th>Image</th>
                                                    <th>Backlink</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${sliders}" var="slider">
                                                    <tr>
                                                        <td>${slider.id}</td>
                                                        <td><strong>${slider.title}</strong></td>
                                                        <td><img src="${slider.image_url}" alt="${slider.title}" class="slider-image"/></td>
                                                        <td><a href="${slider.backlink_url}" target="_blank">${slider.backlink_url}</a></td>
                                                        <td>
                                                            <span class="slider-status ${slider.status ? 'status-active' : 'status-inactive'}">
                                                                ${slider.status ? 'Active' : 'Inactive'}
                                                            </span>
                                                        </td>
                                                        <td>
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
                
        <!-- Settings Modal -->
        <div class="modal fade" id="settingModal" tabindex="-1" role="dialog" aria-labelledby="settingModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="settingModalLabel">Display Settings</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                                    <input class="form-check-input column-toggle" type="checkbox" value="id" id="idColumn" data-column-index="0">
                                    <label class="form-check-label" for="idColumn">ID</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input column-toggle" type="checkbox" value="title" id="titleColumn" data-column-index="1">
                                    <label class="form-check-label" for="titleColumn">Title</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input column-toggle" type="checkbox" value="image" id="imageColumn" data-column-index="2">
                                    <label class="form-check-label" for="imageColumn">Image</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input column-toggle" type="checkbox" value="backlink" id="backlinkColumn" data-column-index="3">
                                    <label class="form-check-label" for="backlinkColumn">Backlink</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input column-toggle" type="checkbox" value="status" id="statusColumn" data-column-index="4">
                                    <label class="form-check-label" for="statusColumn">Status</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="applySettings">Apply</button>
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
            function changePageSize(newSize) {
                const url = new URL(window.location);
                url.searchParams.set('pageSize', newSize);
                url.searchParams.set('page', '1'); // Reset to first page
                window.location.href = url.toString();
            }
            
            document.addEventListener('DOMContentLoaded', function() {
                const table = document.getElementById('sliderTable');
                const checkboxes = document.querySelectorAll('.column-toggle');
                const SLIDER_COLUMN_PREFS_KEY = 'sliderColumnPrefs';

                function applyColumnVisibility(prefs) {
                    checkboxes.forEach(checkbox => {
                        const columnIndex = parseInt(checkbox.dataset.columnIndex, 10) + 1;
                        const isVisible = !prefs || prefs[checkbox.value] !== false;

                        // Toggle visibility for header
                        table.querySelector(`thead th:nth-child(${columnIndex})`).classList.toggle('column-hidden', !isVisible);

                        // Toggle visibility for all cells in this column
                        table.querySelectorAll(`tbody tr td:nth-child(${columnIndex})`).forEach(cell => {
                            cell.classList.toggle('column-hidden', !isVisible);
                        });
                    });
                }

                function loadPrefsIntoModal() {
                    const prefs = JSON.parse(localStorage.getItem(SLIDER_COLUMN_PREFS_KEY));
                    if (prefs) {
                        checkboxes.forEach(checkbox => {
                            checkbox.checked = prefs[checkbox.value] !== false;
                        });
                    } else {
                        checkboxes.forEach(checkbox => checkbox.checked = true);
                    }
                }

                const settingModalEl = document.getElementById('settingModal');
                settingModalEl.addEventListener('show.bs.modal', loadPrefsIntoModal);

                document.getElementById('applySettings').addEventListener('click', () => {
                    const currentPrefs = {};
                    checkboxes.forEach(checkbox => {
                        currentPrefs[checkbox.value] = checkbox.checked;
                    });

                    localStorage.setItem(SLIDER_COLUMN_PREFS_KEY, JSON.stringify(currentPrefs));
                    applyColumnVisibility(currentPrefs);
                    
                    const modalInstance = bootstrap.Modal.getInstance(settingModalEl);
                    modalInstance.hide();
                });

                document.getElementById('selectAllColumns').addEventListener('click', () => {
                    checkboxes.forEach(cb => cb.checked = true);
                });

                document.getElementById('deselectAllColumns').addEventListener('click', () => {
                    checkboxes.forEach(cb => cb.checked = false);
                });

                // Initial load
                const initialPrefs = JSON.parse(localStorage.getItem(SLIDER_COLUMN_PREFS_KEY));
                applyColumnVisibility(initialPrefs);
            });
        </script>
    </body>
    
</html>
