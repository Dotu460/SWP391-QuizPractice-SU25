<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Settings - Admin</title>

        <!-- Include common CSS -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">

        <style>
            .main-content {
                min-height: calc(100vh - 100px);
                padding: 20px 0;
                background-color: #f8f9fa;
            }

            .content-header {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .settings-table-container {
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .page-title {
                color: #333;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .page-description {
                color: #666;
                margin-bottom: 0;
            }

            .filters-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 8px;
                padding: 8px 20px;
                font-weight: 500;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
            }

            .table th {
                background-color: #f8f9fa;
                color: #333;
                font-weight: 600;
                border: none;
                padding: 15px 12px;
            }

            .table td {
                padding: 12px;
                vertical-align: middle;
                border-color: #dee2e6;
            }

            .table tbody tr:hover {
                background-color: #f1f3f4;
            }

            .action-buttons {
                display: flex;
                gap: 5px;
            }

            .btn-sm {
                padding: 5px 10px;
                font-size: 12px;
                border-radius: 5px;
            }

            .setting-key {
                font-family: 'Courier New', monospace;
                background-color: #f1f3f4;
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: 500;
            }

            .setting-value {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .pagination {
                margin-top: 20px;
            }

            .page-info {
                color: #666;
                font-size: 14px;
            }

            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1050;
            }

            @media (max-width: 768px) {
                .action-buttons {
                    flex-direction: column;
                }

                .filters-section .row > div {
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="../../common/user/header.jsp"></jsp:include>



            <main class="main-content">
                <div class="container-fluid">
                    <!-- Content Header -->
                    <div class="content-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                                                <h2 class="page-title">Settings Management</h2>
                                <p class="page-description">Manage system configuration settings</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/setting?action=add" class="btn btn-secondary">
                            <i class="fas fa-plus"></i> Add New Setting
                        </a>
                    </div>
                </div>

               

                 

                    <!-- Settings Table -->
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th width="35%">Key</th>
                                    <th width="45%">Value</th>
                                    <th width="20%">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty settings}">
                                        <tr>
                                            <td colspan="4" class="text-center py-4">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">No settings found</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${settings}" var="setting">
                                            <tr>
                                                <td>
                                                    <span class="setting-key">${setting.key}</span>
                                                </td>
                                                <td>
                                                    <div class="setting-value" title="${setting.value}">
                                                        ${setting.value}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/setting?action=details&id=${setting.id}" 
                                                           class="btn btn-info btn-sm" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/setting?action=edit&id=${setting.id}" 
                                                           class="btn btn-warning btn-sm" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Settings pagination">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${searchFilter}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>

                                <!-- Page Numbers -->
                                <c:set var="startPage" value="${currentPage - 2}" />
                                <c:set var="endPage" value="${currentPage + 2}" />

                                <c:if test="${startPage < 1}">
                                    <c:set var="startPage" value="1" />
                                    <c:set var="endPage" value="${totalPages < 5 ? totalPages : 5}" />
                                </c:if>

                                <c:if test="${endPage > totalPages}">
                                    <c:set var="endPage" value="${totalPages}" />
                                    <c:set var="startPage" value="${totalPages - 4 > 0 ? totalPages - 4 : 1}" />
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}&search=${searchFilter}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>

                                <!-- Next Button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${searchFilter}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </main>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this setting?</p>
                        <p><strong>Key:</strong> <span id="deleteSettingKey"></span></p>
                        <p class="text-danger"><small>This action cannot be undone.</small></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form id="deleteForm" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="deleteSettingId">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container"></div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Delete confirmation
            function confirmDelete(id, key) {
                document.getElementById('deleteSettingId').value = id;
                document.getElementById('deleteSettingKey').textContent = key;
                document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/setting';
                new bootstrap.Modal(document.getElementById('deleteModal')).show();
            }

            // Show toast messages
            document.addEventListener('DOMContentLoaded', function () {
                // Handle delete button clicks
                document.querySelectorAll('.delete-btn').forEach(function (button) {
                    button.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const key = this.getAttribute('data-key');
                        confirmDelete(id, key);
                    });
                });

            <c:if test="${not empty sessionScope.toastMessage}">
                showToast('${sessionScope.toastMessage}', '${sessionScope.toastType}');
                <c:remove var="toastMessage" scope="session"/>
                <c:remove var="toastType" scope="session"/>
            </c:if>
            });

            function showToast(message, type) {
                const bgClass = type === 'success' ? 'success' : 'danger';
                const iconClass = type === 'success' ? 'check-circle' : 'exclamation-circle';

                const toastHtml =
                        '<div class="toast align-items-center text-white bg-' + bgClass + ' border-0" role="alert">' +
                        '<div class="d-flex">' +
                        '<div class="toast-body">' +
                        '<i class="fas fa-' + iconClass + ' me-2"></i>' +
                        message +
                        '</div>' +
                        '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                        '</div>' +
                        '</div>';

                const toastContainer = document.querySelector('.toast-container');
                toastContainer.insertAdjacentHTML('beforeend', toastHtml);

                const toastElement = toastContainer.lastElementChild;
                const toast = new bootstrap.Toast(toastElement, {delay: 4000});
                toast.show();

                // Remove toast element after it's hidden
                toastElement.addEventListener('hidden.bs.toast', function () {
                    toastElement.remove();
                });
            }
        </script>

        <!-- Footer -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html> 