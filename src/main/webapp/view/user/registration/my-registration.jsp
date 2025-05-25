<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
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
                                    <h4 class="title">Emily Hannah</h4>
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
                                            <h4 class="title">My registration</h4>
                                        </div>
                                        <!-- Filter and Search Form -->
                                        <div class="row mb-4">
                                            <div class="col-12">
                                                <form action="my-registration" method="get" class="dashboard__filter-form">
                                                    <div class="row g-3 align-items-end">
                                                        <div class="col-md-4">
                                                            <label for="subjectIdFilter" class="form-label">Filter by Subject:</label>
                                                            <select name="subjectId" id="subjectIdFilter" class="form-select">
                                                                <option value="0">All Subjects</option>
                                                                <c:forEach var="subject" items="${allSubjects}">
                                                                    <option value="${subject.id}" ${subject.id eq selectedSubjectId ? 'selected' : ''}>
                                                                        ${subject.title}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label for="searchNameInput" class="form-label">Search by Subject Name:</label>
                                                            <input type="text" name="searchName" id="searchNameInput" class="form-control" value="${currentSearchName}" placeholder="Enter subject name...">
                                                        </div>
                                                        <div class="col-md-2">
                                                            <button type="submit" class="btn btn-primary w-100">Filter/Search</button>
                                                        </div>
                                                         <div class="col-md-2">
                                                            <a href="my-registration" class="btn btn-secondary w-100">Clear</a>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <!-- End Filter and Search Form -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Course Name</th>
                                                                <th>Package</th>
                                                                <th>Registration time</th>
                                                                <th>Price</th>
                                                                <th>Status</th>
                                                                <th>Valid from</th>
                                                                <th>Valid to</th>
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <c:forEach var="r" items="${listRegistration}">
                                                            <tr>
                                                                <td>
                                                                    <p>${r.id}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${subjectDAO.findById(r.subject_id).title}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${packageDAO.findById(r.package_id).sale_price}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${r.registration_time}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${r.total_cost}</p>
                                                                </td>
                                                                                                                                <td>
                                                                    <span class="dashboard__quiz-result">${r.status}</span>
                                                                </td>
                                                                 <td>
                                                                    <p>${r.valid_from}</p>
                                                                </td>
                                                                 <td>
                                                                    <p>${r.valid_to}</p>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- Pagination -->
                                            <div class="col-12 mt-4">
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination justify-content-center">
                                                        <c:if test="${currentPage > 1}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="my-registration?page=${currentPage - 1}&subjectId=${selectedSubjectId}&searchName=${currentSearchName}">Previous</a>
                                                            </li>
                                                        </c:if>

                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                            <c:choose>
                                                                <c:when test="${currentPage eq i}">
                                                                    <li class="page-item active" aria-current="page">
                                                                        <span class="page-link">${i}</span>
                                                                    </li>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <li class="page-item">
                                                                        <a class="page-link" href="my-registration?page=${i}&subjectId=${selectedSubjectId}&searchName=${currentSearchName}">${i}</a>
                                                                    </li>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>

                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="my-registration?page=${currentPage + 1}&subjectId=${selectedSubjectId}&searchName=${currentSearchName}">Next</a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </nav>
                                            </div>
                                            <!-- End Pagination -->
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



        <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
    </body>

</html>
