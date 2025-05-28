<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

                <!-- dashboard-area -->
                <section class="dashboard__area section-pb-120">
                    <div class="dashboard__bg"><img src="${pageContext.request.contextPath}/view/common/img/bg/dashboard_bg.jpg" alt=""></div>
                <div class="container">
                    <div class="dashboard__top-wrap">
                        <div class="dashboard__top-bg" data-background="${pageContext.request.contextPath}/view/common/img/bg/student_bg.jpg"></div>
                        <div class="dashboard__instructor-info">
                            <div class="dashboard__instructor-info-left">
                                <div class="thumb">
                                    <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors02.jpg" alt="img">
                                </div>
                                <div class="content">
                                    <h4 class="title">Admin Panel</h4>
                                    <ul class="list-wrap">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                            <jsp:include page="../../common/user/sidebarCustomer.jsp"></jsp:include>

                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Price Package Management</h4>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                                                Add New Package
                                            </button>
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
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Name</th>
                                                                <th>Subject ID</th>
                                                                <th>Duration (Months)</th>
                                                                <th>List Price</th>
                                                                <th>Sale Price</th>
                                                                <th>Status</th>
                                                                <th>Description</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="pkg" items="${pricePackages}">
                                                            <tr>
                                                                <td>
                                                                    <p>${pkg.id}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${pkg.name}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${pkg.subject_id != null ? pkg.subject_id : 'N/A'}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${pkg.access_duration_months}</p>
                                                                </td>
                                                                <td>
                                                                    <p>$${pkg.list_price}</p>
                                                                </td>
                                                                <td>
                                                                    <p>$${pkg.sale_price}</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result ${pkg.status == 'active' ? 'text-success' : 'text-danger'}">${pkg.status}</span>
                                                                </td>
                                                                <td>
                                                                    <p>${pkg.description != null ? (pkg.description.length() > 50 ? pkg.description.substring(0, 50) + '...' : pkg.description) : 'No description'}</p>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <button type="button" class="btn btn-sm btn-warning edit-btn" 
                                                                                data-id="${pkg.id}"
                                                                                data-name="${pkg.name}"
                                                                                data-subject-id="${pkg.subject_id}"
                                                                                data-duration="${pkg.access_duration_months}"
                                                                                data-list-price="${pkg.list_price}"
                                                                                data-sale-price="${pkg.sale_price}"
                                                                                data-status="${pkg.status}"
                                                                                data-description="${pkg.description}"
                                                                                data-bs-toggle="modal" data-bs-target="#editPackageModal">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        <form method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this package?');">
                                                                            <input type="hidden" name="action" value="delete">
                                                                            <input type="hidden" name="id" value="${pkg.id}">
                                                                            <button type="submit" class="btn btn-sm btn-danger">
                                                                                <i class="fas fa-trash"></i>
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty pricePackages}">
                                                            <tr>
                                                                <td colspan="9" class="text-center">No price packages found</td>
                                                            </tr>
                                                        </c:if>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- dashboard-area-end -->

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
                                        <label for="subject_id" class="form-label">Subject ID</label>
                                        <input type="number" class="form-control" id="subject_id" name="subject_id">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="access_duration_months" class="form-label">Duration (Months) *</label>
                                        <input type="number" class="form-control" id="access_duration_months" name="access_duration_months" min="1" required>
                                    </div>
                                </div>
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

        <!-- Edit Package Modal -->
        <div class="modal fade" id="editPackageModal" tabindex="-1" aria-labelledby="editPackageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editPackageModalLabel">Edit Price Package</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="edit_id">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit_name" class="form-label">Package Name *</label>
                                        <input type="text" class="form-control" id="edit_name" name="name" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit_subject_id" class="form-label">Subject ID</label>
                                        <input type="number" class="form-control" id="edit_subject_id" name="subject_id">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit_access_duration_months" class="form-label">Duration (Months) *</label>
                                        <input type="number" class="form-control" id="edit_access_duration_months" name="access_duration_months" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit_status" class="form-label">Status *</label>
                                        <select class="form-control" id="edit_status" name="status" required>
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
                                        <label for="edit_list_price" class="form-label">List Price *</label>
                                        <input type="number" class="form-control" id="edit_list_price" name="list_price" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit_sale_price" class="form-label">Sale Price *</label>
                                        <input type="number" class="form-control" id="edit_sale_price" name="sale_price" min="1" required>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="edit_description" class="form-label">Description</label>
                                <textarea class="form-control" id="edit_description" name="description" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Package</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
        
        <script>
            // Validate that sale price doesn't exceed list price
            document.addEventListener('DOMContentLoaded', function() {
                // Handle edit button clicks
                document.querySelectorAll('.edit-btn').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const subjectId = this.getAttribute('data-subject-id');
                        const duration = this.getAttribute('data-duration');
                        const listPrice = this.getAttribute('data-list-price');
                        const salePrice = this.getAttribute('data-sale-price');
                        const status = this.getAttribute('data-status');
                        const description = this.getAttribute('data-description');
                        
                        document.getElementById('edit_id').value = id;
                        document.getElementById('edit_name').value = name || '';
                        document.getElementById('edit_subject_id').value = subjectId === 'null' || !subjectId ? '' : subjectId;
                        document.getElementById('edit_access_duration_months').value = duration;
                        document.getElementById('edit_list_price').value = listPrice;
                        document.getElementById('edit_sale_price').value = salePrice;
                        document.getElementById('edit_status').value = status;
                        document.getElementById('edit_description').value = description === 'null' || !description ? '' : description;
                    });
                });
                
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
                validatePrices('edit_list_price', 'edit_sale_price');
            });
        </script>
    </body>

</html>
