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
                    <p>You don't have permission to access this page. Only administrators can edit system settings.</p>
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
        <title>Edit Setting - Admin</title>

        <!-- Include common CSS -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

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

            .form-container {
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

            .form-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 8px;
            }

            .form-control, .form-select {
                border-radius: 8px;
                border: 1px solid #dee2e6;
                padding: 12px 15px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            .btn-primary {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 8px;
                padding: 12px 30px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
            }

            .btn-secondary {
                border-radius: 8px;
                padding: 12px 30px;
                font-weight: 500;
            }

            .alert {
                border-radius: 8px;
                padding: 15px 20px;
                margin-bottom: 25px;
                border: none;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
            }

            .alert-info {
                background-color: #d1ecf1;
                color: #0c5460;
            }

            .required {
                color: #dc3545;
            }

            .form-section {
                margin-bottom: 25px;
            }

            .form-section:last-child {
                margin-bottom: 0;
            }

            .setting-key-display {
                font-family: 'Courier New', monospace;
                background-color: #e9ecef;
                padding: 12px 15px;
                border-radius: 8px;
                border: 1px solid #ced4da;
                color: #495057;
                font-weight: 500;
            }

            .setting-id-badge {
                background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.875em;
                font-weight: 500;
            }

            .help-text {
                font-size: 0.875em;
                color: #6c757d;
                margin-top: 5px;
            }

            .info-section {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 25px;
                border-left: 4px solid #667eea;
            }

            .warning-text {
                color: #856404;
                background-color: #fff3cd;
                padding: 10px 15px;
                border-radius: 6px;
                border: 1px solid #ffeaa7;
                margin-top: 10px;
            }

            @media (max-width: 768px) {
                .form-container {
                    padding: 20px;
                }

                .btn-group-mobile {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .btn-group-mobile .btn {
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
                                <h2 class="page-title">Edit Setting</h2>
                                <p class="page-description">
                                    Modify system configuration setting 
                                    <span class="setting-id-badge">#${setting.id}</span>
                            </p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/setting?action=details&id=${setting.id}" class="btn btn-outline-info">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/setting" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <!-- Info Section -->
                    <div class="info-section">
                        <h5 class="mb-3">
                            <i class="fas fa-info-circle text-primary"></i>
                            Setting Information
                        </h5>
                        <div class="row">
                            <div class="col-md-3">
                                <strong>Setting ID:</strong><br>
                                <span class="text-muted">#${setting.id}</span>
                            </div>
                            <div class="col-md-9">
                                <strong>Current Key:</strong><br>
                                <code>${setting.key}</code>
                            </div>
                        </div>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/setting" id="editSettingForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${setting.id}">

                        <!-- Setting Key Section -->
                        <div class="form-section">
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="key" class="form-label">
                                        Setting Key <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="key" 
                                           name="key" 
                                           value="${setting.key}"
                                           readonly>
                                    <div class="help-text">
                                        Use lowercase letters, numbers, and underscores only. Must be unique.
                                    </div>
                                    <div class="warning-text">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <strong>Warning:</strong> Changing the key may affect other parts of the system that reference this setting.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Current Key Display</label>
                                    <div class="setting-key-display">
                                        ${setting.key}
                                    </div>
                                    <div class="help-text">
                                        This is the current key in the system.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Setting Value Section -->
                        <div class="form-section">
                            <div class="row">
                                <div class="col-12">
                                    <label for="value" class="form-label">
                                        Setting Value <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" 
                                              id="value" 
                                              name="value" 
                                              rows="6" 
                                              placeholder="Enter timeout in seconds (numbers only)..."
                                              pattern="^[0-9]+$"
                                              title="Only numbers are allowed"
                                              required>${setting.value}</textarea>
                                    
                                </div>
                            </div>
                        </div>

                       

                        <!-- Form Actions -->
                        <div class="form-section">
                            <div class="d-flex gap-3 btn-group-mobile">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Update Setting
                                </button>
                                <button type="reset" class="btn btn-outline-secondary">
                                    <i class="fas fa-undo"></i> Reset Changes
                                </button>
                                <a href="${pageContext.request.contextPath}/setting?action=details&id=${setting.id}" class="btn btn-outline-info">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                                <a href="${pageContext.request.contextPath}/setting" class="btn btn-outline-dark">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const keyInput = document.getElementById('key');
                const originalKey = '${setting.key}';

                // Only allow numbers in value field
                const valueInput = document.getElementById('value');
                valueInput.addEventListener('input', function(e) {
                    // Remove any non-digit characters
                    e.target.value = e.target.value.replace(/\D/g, '');
                });

                // Validate key format
                keyInput.addEventListener('blur', function () {
                    const value = this.value.trim();
                    if (value) {
                        // Check if key contains only allowed characters
                        const validPattern = /^[a-z0-9_]+$/;
                        if (!validPattern.test(value)) {
                            this.setCustomValidity('Key must contain only lowercase letters, numbers, and underscores');
                            this.classList.add('is-invalid');
                        } else {
                            this.setCustomValidity('');
                            this.classList.remove('is-invalid');
                        }
                    }
                });

                // Form validation
                document.getElementById('editSettingForm').addEventListener('submit', function (e) {
                    const key = keyInput.value.trim();
                    const value = document.getElementById('value').value.trim();

                    if (!key || !value) {
                        e.preventDefault();
                        alert('Please fill in all required fields');
                        return;
                    }

                    // Final key validation
                    const validPattern = /^[a-z0-9_]+$/;
                    if (!validPattern.test(key)) {
                        e.preventDefault();
                        alert('Setting key must contain only lowercase letters, numbers, and underscores');
                        keyInput.focus();
                        return;
                    }

                    // Warn if key is being changed
                    if (key !== originalKey) {
                        const confirmed = confirm(
                                'Warning: You are changing the setting key from "' + originalKey + '" to "' + key + '".\n\n' +
                                'This may affect other parts of the system that reference this setting.\n\n' +
                                'Are you sure you want to continue?'
                                );

                        if (!confirmed) {
                            e.preventDefault();
                            return;
                        }
                    }
                });

                // Reset button functionality
                document.querySelector('button[type="reset"]').addEventListener('click', function () {
                    setTimeout(function () {
                        keyInput.classList.remove('is-invalid');
                        keyInput.setCustomValidity('');
                    }, 100);
                });
            });
        </script>

        <!-- Footer -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html> 
</c:otherwise>
</c:choose>