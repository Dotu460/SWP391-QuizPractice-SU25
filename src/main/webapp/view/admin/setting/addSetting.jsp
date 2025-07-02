<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Setting - Admin</title>

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

            .required {
                color: #dc3545;
            }

            .form-section {
                margin-bottom: 25px;
            }

            .form-section:last-child {
                margin-bottom: 0;
            }

            .setting-key-preview {
                font-family: 'Courier New', monospace;
                background-color: #f8f9fa;
                padding: 8px 12px;
                border-radius: 4px;
                border: 1px solid #dee2e6;
                color: #495057;
            }

            .help-text {
                font-size: 0.875em;
                color: #6c757d;
                margin-top: 5px;
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
                                <h2 class="page-title">Add New Setting</h2>
                                <p class="page-description">Create a new system configuration setting</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/setting" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
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

                    <form method="POST" action="${pageContext.request.contextPath}/admin/setting" id="addSettingForm">
                        <input type="hidden" name="action" value="create">

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
                                           placeholder="e.g., max_login_attempts" 
                                           value="${key}"
                                           required>
                                    <div class="help-text">
                                        Use lowercase letters, numbers, and underscores only. Must be unique.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Key Preview</label>
                                    <div class="setting-key-preview" id="keyPreview">
                                        <em>Enter key to see preview</em>
                                    </div>
                                    <div class="help-text">
                                        This is how the key will appear in the system.
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
                                              rows="4" 
                                              placeholder="Enter the setting value..."
                                              required>${value}</textarea>
                                    <div class="help-text">
                                        Enter the value for this setting. Can be text, numbers, JSON, etc.
                                    </div>
                                </div>
                            </div>
                        </div>

                        

                        <!-- Form Actions -->
                        <div class="form-section">
                            <div class="d-flex gap-3 btn-group-mobile">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="fas fa-save"></i> Create Setting
                                </button>
                                <button type="reset" class="btn btn-outline-secondary">
                                    <i class="fas fa-undo"></i> Reset Form
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/setting" class="btn btn-outline-dark">
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
                const keyPreview = document.getElementById('keyPreview');

                // Update key preview as user types
                keyInput.addEventListener('input', function () {
                    const value = this.value.trim();
                    if (value) {
                        keyPreview.textContent = value;
                    } else {
                        keyPreview.innerHTML = '<em>Enter key to see preview</em>';
                    }
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
                document.getElementById('addSettingForm').addEventListener('submit', function (e) {
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
                });

                // Initialize key preview if there's a value
                if (keyInput.value.trim()) {
                    keyPreview.textContent = keyInput.value.trim();
                }
            });
        </script>

        <!-- Footer -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html> 