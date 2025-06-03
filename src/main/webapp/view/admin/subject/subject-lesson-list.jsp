<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Subject Lesson Management</title>
        <meta name="description" content="SkillGro - Subject Lesson Management">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .lesson-status {
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
            
            .table-actions a, .table-actions button {
                padding: 4px 8px;
                border-radius: 4px;
                border: none;
                color: white;
                font-size: 12px;
                cursor: pointer;
                text-decoration: none;
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
                text-decoration: none;
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
            
            .subject-selector {
                margin-bottom: 20px;
                padding: 15px;
                background-color: #e9ecef;
                border-radius: 8px;
            }
            
            .subject-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            
            .subject-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
            }
            
            .subject-info {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }
            
            .subject-description {
                margin-bottom: 15px;
                color: #6c757d;
            }
            
            .lesson-count-badge {
                background-color: #007bff;
                color: white;
                padding: 3px 8px;
                border-radius: 10px;
                font-size: 12px;
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
                        <%--<jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include> --%>

                            <c:url value="/admin/subject-lesson" var="paginationUrl">
                                <c:if test="${not empty param.subjectId}">
                                    <c:param name="subjectId" value="${param.subjectId}" />
                                </c:if>
                                <c:if test="${not empty param.packageId}">
                                    <c:param name="packageId" value="${param.packageId}" />
                                </c:if>
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

                            <div class="col-xl-12">
                                <div class="dashboard__content-area">
                                    <div class="dashboard__content-title d-flex justify-content-between align-items-center mb-4">
                                        <h4 class="title">Subject Lesson Management</h4>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/admin/subject-lesson/add" class="add-btn">
                                                <i class="fas fa-plus"></i> Add New Lesson
                                            </a>
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

                                    <!-- Subject Selector -->
                                    <div class="subject-selector">
                                        <h5 class="mb-3">Select Subject</h5>
                                        <div class="row">
                                            <div class="col-md-8">
                                                <select class="form-control" id="subjectSelector" onchange="changeSubject(this.value)">
                                                    <option value="">-- Select a Subject --</option>
                                                    <c:forEach items="${subjects}" var="subject">
                                                        <option value="${subject.id}" ${selectedSubjectId == subject.id ? 'selected' : ''}>
                                                            ${subject.title}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4">
                                                <a href="${pageContext.request.contextPath}/admin/subject-lesson?action=manage-subjects" class="btn btn-primary w-100">
                                                    Manage Subjects
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${not empty currentSubject}">
                                        <!-- Current Subject Info -->
                                        <div class="subject-card">
                                            <div class="subject-title">${currentSubject.title}</div>
                                            <div class="subject-info">
                                                <span class="lesson-count-badge">
                                                    ${totalLessons} Lessons
                                                </span>
                                                <span class="lesson-status ${currentSubject.status == 'active' ? 'status-active' : 'status-inactive'}">
                                                    ${currentSubject.status}
                                                </span>
                                            </div>
                                            <div class="subject-description">
                                                ${currentSubject.description != null ? currentSubject.description : 'No description available'}
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Filter Form -->
                                    <div class="filter-form">
                                        <form action="${pageContext.request.contextPath}/admin/subject-lesson" method="get">
                                            <c:if test="${not empty selectedSubjectId}">
                                                <input type="hidden" name="subjectId" value="${selectedSubjectId}">
                                            </c:if>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label for="status">Status</label>
                                                        <select class="form-control" id="status" name="status">
                                                            <option value="">All Status</option>
                                                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                                                            <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label for="search">Search</label>
                                                        <input type="text" class="form-control" id="search" name="search" 
                                                               placeholder="Search by title..." value="${searchFilter}">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label for="pageSize">Items per page</label>
                                                        <select class="form-control" id="pageSize" name="pageSize">
                                                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                                                            <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 per page</option>
                                                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                                                            <option value="100" ${pageSize == 100 ? 'selected' : ''}>100 per page</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-2">
                                                <div class="col-md-12 d-flex justify-content-end">
                                                    <button type="submit" class="btn btn-primary">Filter</button>
                                                    <a href="${pageContext.request.contextPath}/admin/subject-lesson" class="btn btn-secondary ml-2">Reset</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Lesson List Info -->
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            Showing <span class="fw-bold">${startRecord}</span> to <span class="fw-bold">${endRecord}</span> of <span class="fw-bold">${totalLessons}</span> lessons
                                        </div>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="d-flex justify-content-center mt-4">
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/subject-lesson?subjectId=${selectedSubjectId}&page=${currentPage - 1}&pageSize=${pageSize}&status=${statusFilter}&search=${searchFilter}" aria-label="Previous">
                                                                <span aria-hidden="true">&laquo;</span>
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/subject-lesson?subjectId=${selectedSubjectId}&page=${i}&pageSize=${pageSize}&status=${statusFilter}&search=${searchFilter}">${i}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="page-item">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/subject-lesson?subjectId=${selectedSubjectId}&page=${currentPage + 1}&pageSize=${pageSize}&status=${statusFilter}&search=${searchFilter}" aria-label="Next">
                                                                <span aria-hidden="true">&raquo;</span>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>

                                    <!-- Lesson Table -->
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Order</th>
                                                    <th>Title</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${lessons}" var="lesson" varStatus="loop">
                                                    <tr>
                                                        <td>${lesson.id}</td>
                                                        <td>${lesson.order_in_subject}</td>
                                                        <td><strong>${lesson.title}</strong></td>
                                                        <td>
                                                            <span class="lesson-status ${lesson.status == 'active' ? 'status-active' : 'status-inactive'}">
                                                                ${lesson.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="table-actions">
                                                                <a class="action-edit" href="${pageContext.request.contextPath}/admin/subject-lesson/edit?id=${lesson.id}">
                                                                    <i class="fas fa-edit"></i> Edit
                                                                </a>
                                                                <form method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this lesson?');">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="id" value="${lesson.id}">
                                                                    <button type="submit" class="action-delete">
                                                                        <i class="fas fa-trash"></i> Delete
                                                                    </button>
                                                                </form>
                                                                <c:if test="${lesson.status == 'active'}">
                                                                    <form method="post" style="display: inline;">
                                                                        <input type="hidden" name="action" value="deactivate">
                                                                        <input type="hidden" name="id" value="${lesson.id}">
                                                                        <button type="submit" class="action-delete">
                                                                            <i class="fas fa-ban"></i> Deactivate
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <c:if test="${lesson.status == 'inactive'}">
                                                                    <form method="post" style="display: inline;">
                                                                        <input type="hidden" name="action" value="activate">
                                                                        <input type="hidden" name="id" value="${lesson.id}">
                                                                        <button type="submit" class="action-edit">
                                                                            <i class="fas fa-check"></i> Activate
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty lessons}">
                                                    <tr>
                                                        <td colspan="5" class="text-center">
                                                            <c:choose>
                                                                <c:when test="${empty selectedSubjectId}">
                                                                    Please select a subject to view lessons
                                                                </c:when>
                                                                <c:otherwise>
                                                                    No lessons found for this subject
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
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
                                    <input class="form-check-input" type="checkbox" value="order" id="orderColumn" checked>
                                    <label class="form-check-label" for="orderColumn">Order</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="title" id="titleColumn" checked>
                                    <label class="form-check-label" for="titleColumn">Title</label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="status" id="statusColumn" checked>
                                    <label class="form-check-label" for="statusColumn">Status</label>
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
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
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
            });
            
            // Change subject function
            function changeSubject(subjectId) {
                if (subjectId) {
                    window.location.href = '${pageContext.request.contextPath}/admin/subject-lesson?subjectId=' + subjectId;
                } else {
                    window.location.href = '${pageContext.request.contextPath}/admin/subject-lesson';
                }
            }
            
            // Change page size function
            function changePageSize(newSize) {
                var currentUrl = new URL(window.location);
                currentUrl.searchParams.set('pageSize', newSize);
                currentUrl.searchParams.set('page', '1'); // Reset to first page
                window.location.href = currentUrl.toString();
            }
        </script>
    </body>

</html> 