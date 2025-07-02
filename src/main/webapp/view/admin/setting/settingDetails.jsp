<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

            .stats-row {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid #dee2e6;
            }

            .stat-item {
                text-align: center;
                flex: 1;
                min-width: 120px;
            }

            .stat-number {
                font-size: 1.5em;
                font-weight: 600;
                color: #667eea;
            }

            .stat-label {
                font-size: 0.875em;
                color: #6c757d;
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

                        <!-- Value Statistics -->
                        <div class="stats-row">
                            <div class="stat-item">
                                <div class="stat-number" id="charCount">-</div>
                                <div class="stat-label">Characters</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number" id="lineCount">-</div>
                                <div class="stat-label">Lines</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number" id="wordCount">-</div>
                                <div class="stat-label">Words</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number" id="dataType">-</div>
                                <div class="stat-label">Data Type</div>
                            </div>
                        </div>
                    </div>

                    <!-- Usage Information Section -->
                    <div class="detail-section">
                        <h4 class="mb-4">
                            <i class="fas fa-chart-line text-info"></i>
                            Usage Information
                        </h4>

                        <div class="row">
                            <div class="col-md-6">
                                <span class="detail-label">Recommended Usage</span>
                                <div class="detail-value" id="usageRecommendation">
                                    System configuration parameter
                                </div>
                            </div>
                            <div class="col-md-6">
                                <span class="detail-label">Access Method</span>
                                <div class="detail-value">
                                    <code>settingDAO.getValueByKey("${setting.key}")</code>
                                </div>
                            </div>
                        </div>
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

                        <button type="button" class="btn btn-outline-warning" onclick="testSetting()">
                            <i class="fas fa-flask"></i> Test Value
                        </button>

                        <button type="button" class="btn btn-outline-danger" onclick="confirmDelete()">
                            <i class="fas fa-trash"></i> Delete Setting
                        </button>

                        <a href="${pageContext.request.contextPath}/setting" class="btn btn-secondary">
                            <i class="fas fa-list"></i> Back to List
                        </a>
                    </div>
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
                        <p><strong>Key:</strong> <code>${setting.key}</code></p>
                        <p><strong>Value:</strong> <code class="text-break">${setting.value}</code></p>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Warning:</strong> This action cannot be undone and may affect system functionality.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="POST" action="${pageContext.request.contextPath}setting" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${setting.id}">
                            <button type="submit" class="btn btn-danger">Delete Setting</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Test Result Modal -->
        <div class="modal fade" id="testModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Value Test Results</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="testResults"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-core.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/autoloader/prism-autoloader.min.js"></script>

        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const settingValue = '${setting.value}';
                                analyzeValue(settingValue);
                            });

                            function analyzeValue(value) {
                                // Character count
                                document.getElementById('charCount').textContent = value.length;

                                // Line count
                                const lines = value.split('\n').length;
                                document.getElementById('lineCount').textContent = lines;

                                // Word count
                                const words = value.trim() ? value.trim().split(/\s+/).length : 0;
                                document.getElementById('wordCount').textContent = words;

                                // Determine data type and set badge
                                let dataType = 'TEXT';
                                let typeClass = 'type-text';

                                if (value.toLowerCase() === 'true' || value.toLowerCase() === 'false') {
                                    dataType = 'BOOLEAN';
                                    typeClass = 'type-boolean';
                                } else if (!isNaN(value) && !isNaN(parseFloat(value))) {
                                    dataType = 'NUMBER';
                                    typeClass = 'type-number';
                                } else if (isValidJSON(value)) {
                                    dataType = 'JSON';
                                    typeClass = 'type-json';
                                }

                                document.getElementById('dataType').textContent = dataType;

                                const typeBadge = document.getElementById('valueType');
                                typeClass.textContent = dataType;
                                typeClass.className = 'value-type-badge ' + typeClass;

                                // Set usage recommendation
                                setUsageRecommendation(dataType, value);
                            }

                            function isValidJSON(str) {
                                try {
                                    JSON.parse(str);
                                    return true;
                                } catch (e) {
                                    return false;
                                }
                            }

                            function setUsageRecommendation(type, value) {
                                const element = document.getElementById('usageRecommendation');
                                let recommendation = '';

                                switch (type) {
                                    case 'BOOLEAN':
                                        recommendation = 'Use for feature flags, toggles, or yes/no configurations';
                                        break;
                                    case 'NUMBER':
                                        recommendation = 'Use for limits, thresholds, timeouts, or numeric configurations';
                                        break;
                                    case 'JSON':
                                        recommendation = 'Use for complex configurations, arrays, or structured data';
                                        break;
                                    default:
                                        recommendation = 'Use for text values, URLs, paths, or simple string configurations';
                                }

                                element.textContent = recommendation;
                            }

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

                            function confirmDelete() {
                                new bootstrap.Modal(document.getElementById('deleteModal')).show();
                            }

                            function testSetting() {
                                const value = '${setting.value}';
                                const key = '${setting.key}';

                                let results = '';

                                // Test if it's a boolean
                                if (value.toLowerCase() === 'true' || value.toLowerCase() === 'false') {
                                    results += '<h6>Boolean Test</h6>';
                                    results += '<p class="text-success"><i class="fas fa-check"></i> Valid boolean value: ' + value + '</p>';
                                }

                                // Test if it's a number
                                if (!isNaN(value) && !isNaN(parseFloat(value))) {
                                    results += '<h6>Number Test</h6>';
                                    results += '<p class="text-success"><i class="fas fa-check"></i> Valid number: ' + parseFloat(value) + '</p>';
                                }

                                // Test if it's JSON
                                if (isValidJSON(value)) {
                                    results += '<h6>JSON Test</h6>';
                                    results += '<p class="text-success"><i class="fas fa-check"></i> Valid JSON structure</p>';
                                    try {
                                        const parsed = JSON.parse(value);
                                        results += '<pre class="bg-light p-3 border rounded">' + JSON.stringify(parsed, null, 2) + '</pre>';
                                    } catch (e) {
                                        results += '<p class="text-danger">Error parsing JSON: ' + e.message + '</p>';
                                    }
                                }

                                // General validation
                                results += '<h6>General Validation</h6>';
                                results += '<p><strong>Length:</strong> ' + value.length + ' characters</p>';
                                results += '<p><strong>Empty:</strong> ' + (value.trim() === '' ? 'Yes' : 'No') + '</p>';
                                results += '<p><strong>Contains HTML:</strong> ' + (/<[^>]*>/.test(value) ? 'Yes' : 'No') + '</p>';

                                document.getElementById('testResults').innerHTML = results;
                                new bootstrap.Modal(document.getElementById('testModal')).show();
                            }
        </script>

        <!-- Footer -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>

        <!-- Include common JS -->
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
    </body>
</html> 