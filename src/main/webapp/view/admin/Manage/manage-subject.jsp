<%-- 
    Document   : manage-subject
    Created on : 24 thg 6, 2025, 09:46:26
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>Subject Management - SkillGro</title>
  <meta name="description" content="SkillGro - Online Courses & Education Platform">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">

  <!-- CSS here -->
  <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>

  <!-- Custom CSS for this page -->
  <style>
    .dashboard__subjects-filter {
      padding: 25px;
      background-color: #f8f9fa;
      border-radius: 10px;
      margin-bottom: 30px;
      box-shadow: 0 0 15px rgba(0,0,0,0.05);
    }

    .dashboard__subjects-filter form {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      align-items: flex-end;
    }

    .dashboard__subjects-filter .form-group {
      flex: 1;
      min-width: 200px;
    }

    .dashboard__subjects-filter label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: #555;
    }

    .dashboard__subjects-filter select,
    .dashboard__subjects-filter input {
      width: 100%;
      padding: 10px 15px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #fff;
    }

    .dashboard__subjects-filter button {
      padding: 12px 25px;
      background-color: #3f78e0;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .dashboard__subjects-filter button:hover {
      background-color: #2c5ec1;
    }

    .dashboard__actions {
      display: flex;
      justify-content: space-between;
      margin-bottom: 25px;
      align-items: center;
    }

    .subject-action-link {
      padding: 5px 10px;
      border-radius: 4px;
      margin-right: 5px;
      display: inline-block;
      color: white;
      text-align: center;
      font-size: 14px;
    }

    .view-link {
      background-color: #3f78e0;
    }

    .delete-link {
      background-color: #dc3545;
    }

    .status-badge {
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
      text-align: center;
      display: inline-block;
    }

    .status-active {
      background-color: #d1f7c4;
      color: #389b10;
    }

    .status-inactive {
      background-color: #ffe0e0;
      color: #d03030;
    }

    .status-draft {
      background-color: #f0f0f0;
      color: #6c757d;
    }

    .delete-link:hover {
      background-color: #c82333;
      color: white;
    }

    .view-link:hover {
      background-color: #2c5ec1;
      color: white;
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
  <!-- dashboard-area -->
  <section class="dashboard__area section-pb-120">
    <div class="dashboard__bg"><img src="assets/img/bg/dashboard_bg.jpg" alt=""></div>
    <div class="container">
      <div class="dashboard__inner-wrap">
        <div class="row">
          <div class="col-lg-3">
            <jsp:include page="../adminSidebar.jsp">
              <jsp:param name="active" value="subjects"/>
            </jsp:include>
          </div>
          <div class="col-lg-9">
            <div class="dashboard__content-wrap">
              <div class="dashboard__content-title">
                <h4 class="title">Subject Management</h4>
              </div>

              <!-- Filters Section -->
              <div class="dashboard__subjects-filter">
                <form method="get" action="${pageContext.request.contextPath}/manage-subjects">
                  <div class="form-group">
                    <label for="category">Category:</label>
                    <select name="category" id="category" class="form-select">
                      <option value="">All Categories</option>
                      <c:forEach var="category" items="${categories}">
                        <option value="${category.id}" ${categoryFilter == category.id ? 'selected' : ''}>${category.name}</option>
                      </c:forEach>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="status">Status:</label>
                    <select name="status" id="status" class="form-select">
                      <option value="">All Status</option>
                      <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                      <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                      <option value="draft" ${statusFilter == 'draft' ? 'selected' : ''}>Draft</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="search">Search:</label>
                    <input type="text" id="search" name="search" placeholder="Search by name..." value="${searchTerm}" class="form-control">
                  </div>

                  <button type="submit" class="btn">Apply Filters</button>
                </form>
              </div>

              <!-- Subjects Table -->
              <div class="dashboard__review-table">
                <table class="table table-borderless">
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Subject Name</th>
                    <th>Category</th>
                    <th>Number of Lessons</th>
                    <th>Owner</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="subject" items="${subjects}">
                    <tr>
                      <td>${subject.id}</td>
                      <td>
                        <div class="dashboard__quiz-info">
                          <h6 class="title">${subject.title}</h6>
                        </div>
                      </td>
                      <td>
                        <c:forEach var="category" items="${categories}">
                          <c:if test="${category.id == subject.category_id}">
                            ${category.name}
                          </c:if>
                        </c:forEach>
                      </td>
                      <td>
                        <span class="badge bg-light text-dark">
                          ${lessonCounts[subject.id]}
                        </span>
                      </td>
                      <td>${ownerNames[subject.owner_id]}</td>
                      <td>
                        <c:choose>
                          <c:when test="${subject.status == 'active'}">
                            <span class="status-badge status-active">Active</span>
                          </c:when>
                          <c:when test="${subject.status == 'inactive'}">
                            <span class="status-badge status-inactive">Inactive</span>
                          </c:when>
                          <c:otherwise>
                            <span class="status-badge status-draft">Draft</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="dashboard__review-action">
                          <a href="${pageContext.request.contextPath}/manage-subjects/view?id=${subject.id}" 
                             class="subject-action-link view-link" title="View Lessons">
                             <i class="skillgro-book-2"></i>
                          </a>
                          <a href="${pageContext.request.contextPath}/manage-subjects/delete?id=${subject.id}" 
                             class="subject-action-link delete-link" 
                             onclick="return confirm('Are you sure you want to delete this subject?')" 
                             title="Delete">
                             <i class="fas fa-trash"></i>
                          </a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- Pagination -->
              <nav aria-label="Page navigation">
                  <ul class="pagination mb-0">
                      <li class="page-item ${page == 1 ? 'disabled' : ''}">
                          <a class="page-link" 
                             href="${pageContext.request.contextPath}/manage-subjects?page=${page - 1}&pageSize=${pageSize}&category=${categoryFilter}&status=${statusFilter}&search=${searchTerm}"
                             ${page == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                               &laquo;
                          </a>
                      </li>

                      <c:forEach begin="1" end="${totalPages}" var="i">
                          <li class="page-item ${i == page ? 'active' : ''}">
                              <a class="page-link" 
                                 href="${pageContext.request.contextPath}/manage-subjects?page=${i}&pageSize=${pageSize}&category=${categoryFilter}&status=${statusFilter}&search=${searchTerm}">
                                   ${i}
                              </a>
                          </li>
                      </c:forEach>

                      <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                          <a class="page-link" 
                             href="${pageContext.request.contextPath}/manage-subjects?page=${page + 1}&pageSize=${pageSize}&category=${categoryFilter}&status=${statusFilter}&search=${searchTerm}"
                             ${page == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>
                               &raquo;
                          </a>
                      </li>
                  </ul>
              </nav>
              <!-- End Pagination -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- dashboard-area-end -->
</main>
<!-- main-area-end -->

<!-- footer-area -->
<jsp:include page="../../common/user/footer.jsp"></jsp:include>
<!-- footer-area-end -->

<!-- JS here -->
<jsp:include page="../../common/js/"></jsp:include>
<script>
  SVGInject(document.querySelectorAll("img.injectable"));

  // Initialize Select2 for better dropdown experience
  $(document).ready(function() {
    $('#category, #status').select2();
  });
</script>
</body>
</html>
