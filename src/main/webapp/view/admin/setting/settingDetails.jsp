<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Kiểm tra quyền admin --%>
<c:choose>
    <c:when test="${empty sessionScope.account or sessionScope.account.role_id != 1}">
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Access Denied - SkillGro</title>
            <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        </head>
        <body>
            <jsp:include page="../../common/user/header.jsp"></jsp:include>
            
            <div class="container" style="padding: 100px 0; text-align: center;">
                <div class="alert alert-danger" style="max-width: 600px; margin: 0 auto;">
                    <h3><i class="fas fa-exclamation-triangle"></i> Access Denied</h3>
                    <p>You don't have permission to access this page. Only administrators can view system settings.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </div>
            </div>
            
            <jsp:include page="../../common/user/footer.jsp"></jsp:include>
        </body>
        </html>
    </c:when>
<c:otherwise>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Setting Details - Admin</title>

        <!-- Include common CSS -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Prism.js for syntax highlighting -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css" rel="stylesheet">

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

            .details-container {
                background: white;
                padding: 30px;
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

            .setting-id-badge {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.875em;
                font-weight: 500;
            }

            .detail-section {
                margin-bottom: 30px;
                padding: 25px;
                background-color: #f8f9fa;
                border-radius: 10px;
                border-left: 4px solid #667eea;
            }

            .detail-section:last-child {
                margin-bottom: 0;
            }

            .detail-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
                display: block;
            }

            .detail-value {
                color: #555;
                font-size: 16px;
            }

            .setting-key {
                font-family: 'Courier New', monospace;
                background-color: #e9ecef;
                padding: 8px 12px;
                border-radius: 6px;
                font-weight: 500;
                color: #495057;
                border: 1px solid #ced4da;
            }

            .setting-value {
                background-color: #ffffff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 15px;
                min-height: 120px;
                font-family: 'Courier New', monospace;
                font-size: 14px;
                color: #333;
                white-space: pre-wrap;
                word-wrap: break-word;
                overflow-x: auto;
            }

            .value-type-badge {
                font-size: 0.75em;
                padding: 2px 8px;
                border-radius: 12px;
                font-weight: 500;
                margin-left: 10px;
            }

            .type-text {
                background-color: #d1ecf1;
                color: #0c5460;
            }

            .type-number {
                background-color: #d4edda;
                color: #155724;
            }

            .type-boolean {
                background-color: #fff3cd;
                color: #856404;
            }

            .type-json {
                background-color: #f8d7da;
                color: #721c24;
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 8px;
                padding: 12px 24px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
            }

            .btn-outline-warning {
                border-color: #ffc107;
                color: #ffc107;
                border-radius: 8px;
                padding: 12px 24px;
                font-weight: 500;
            }

            .btn-outline-danger {
                border-color: #dc3545;
                color: #dc3545;
                border-radius: 8px;
                padding: 12px 24px;
                font-weight: 500;
            }

            .btn-secondary {
                border-radius: 8px;
                padding: 12px 24px;
                font-weight: 500;
            }

            .action-section {
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .copy-button {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #6c757d;
                border: none;
                color: white;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                cursor: pointer;
                transition: background 0.3s;
            }

            .copy-button:hover {
                background: #5a6268;
            }

            .value-container {
                position: relative;
            }

            

            @media (max-width: 768px) {
                .details-container {
                    padding: 20px;
                }

                .action-buttons {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .action-buttons .btn {
                    width: 100%;
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
                                <h2 class="page-title">Setting Details</h2>
                                <p class="page-description">
                                    Detailed view of setting 
                                    <span class="setting-id-badge">#${setting.id}</span>
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}setting" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>

                <!-- Details Container -->
                <div class="details-container">
                    <!-- Basic Information Section -->
                    <div class="detail-section">
                        <h4 class="mb-4">
                            <i class="fas fa-info-circle text-primary"></i>
                            Basic Information
                        </h4>

                        <div class="row">
                            <div class="col-md-3">
                                <span class="detail-label">Setting ID</span>
                                <div class="detail-value">
                                    <strong>#${setting.id}</strong>
                                </div>
                            </div>
                            <div class="col-md-9">
                                <span class="detail-label">Setting Key</span>
                                <div class="detail-value">
                                    <span class="setting-key">${setting.key}</span>
                                    <button class="copy-button" onclick="copyToClipboard('${setting.key}')" title="Copy Key">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Value Section -->
                    <div class="detail-section">
                        <h4 class="mb-4">
                            <i class="fas fa-edit text-success"></i>
                            Setting Value
                            <span class="value-type-badge" id="valueType">TEXT</span>
                        </h4>

                        <div class="value-container">
                            <div class="setting-value" id="settingValue">${setting.value}</div>
                            <button class="copy-button" onclick="copyToClipboard('${setting.value}')" title="Copy Value">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>

                        
                    </div>

                    

                <!-- Action Section -->
                <div class="action-section">
                    <h5 class="mb-3">
                        <i class="fas fa-tools"></i>
                        Actions
                    </h5>

                    <div class="action-buttons d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/setting?action=edit&id=${setting.id}" 
                           class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Setting
                        </a>

                        

                        <a href="${pageContext.request.contextPath}/setting" class="btn btn-secondary">
                            <i class="fas fa-list"></i> Back to List
                        </a>
                    </div>
                </div>
            </div>
        </main>

        

        

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-core.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/autoloader/prism-autoloader.min.js"></script>

        <script>
                            

                            

                            

                            

                            function copyToClipboard(text) {
                                navigator.clipboard.writeText(text).then(function () {
                                    // Show success feedback
                                    const toast = createToast('Copied to clipboard!', 'success');
                                    document.body.appendChild(toast);

                                    setTimeout(() => {
                                        document.body.removeChild(toast);
                                    }, 3000);
                                }).catch(function (err) {
                                    console.error('Could not copy text: ', err);
                                    alert('Failed to copy to clipboard');
                                });
                            }

                            function createToast(message, type) {
                                const toast = document.createElement('div');
                                toast.className = `alert alert-${type} position-fixed`;
                                toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; opacity: 0.9;';
                                toast.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
                                return toast;
                            }

                            

                            
        </script>

        <!-- Footer -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html> 
</c:otherwise>
</c:choose>