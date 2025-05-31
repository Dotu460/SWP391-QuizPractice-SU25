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
                <div class="container-fluid px-0">
                    <div class="dashboard__top-wrap">
                        <div class="dashboard__top-bg" data-background="${pageContext.request.contextPath}/view/common/img/bg/student_bg.jpg"></div>
                        <div class="dashboard__instructor-info">
                            <div class="dashboard__instructor-info-left">
                                <div class="thumb">
                                    <c:choose>
                                        <c:when test="${not empty currentUser.avatar_url}">
                                            <img src="${pageContext.request.contextPath}${currentUser.avatar_url}" alt="User Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/view/common/img/courses/details_instructors02.jpg" alt="Default Avatar">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="content">
                                    <h4 class="title">${not empty currentUser.full_name ? currentUser.full_name : 'User'}</h4>
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
                                            <h4 class="title">My Course Registrations</h4>
                                        </div>

                                        <!-- Filter Section -->
                                        <div class="mb-4 p-3 border rounded bg-white">
                                            <form action="${pageContext.request.contextPath}/my-registration" method="get" class="dashboard_sidebar_search-form">
                                                <div class="row gy-2 gx-3 align-items-end">
                                                    <div class="col-md-2">
                                                        <label for="subjectId" class="form-label">Course</label>
                                                        <select name="subjectId" id="subjectId" class="form-select">
                                                            <option value="0">All Courses</option>
                                                            <c:forEach var="subject" items="${allSubjects}">
                                                                <option value="${subject.id}" ${subject.id eq currentSubjectId ? 'selected' : ''}>${subject.title}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="col-md-2">
                                                        <label for="status" class="form-label">Status</label>
                                                        <select name="status" id="status" class="form-select">
                                                            <option value="">All Status</option>
                                                            <option value="approved" ${currentStatus eq 'approved' ? 'selected' : ''}>Approved</option>
                                                            <option value="submit" ${currentStatus eq 'submit' ? 'selected' : ''}>Rejected</option>
                                                        </select>
                                                    </div>
                                                    
                                                    <div class="col-md-2">
                                                        <label for="searchName" class="form-label">Search</label>
                                                        <input type="text" name="searchName" id="searchName" placeholder="Search by course name" value="${currentSearchName}" class="form-control" />
                                                    </div>

                                                    <div class="col-md-2">
                                                        <label for="fromDate" class="form-label">From Date</label>
                                                        <input type="date" name="fromDate" id="fromDate" value="${currentFromDate}" class="form-control" placeholder="yyyy/mm/dd"/>
                                                    </div>

                                                    <div class="col-md-2">
                                                        <label for="toDate" class="form-label">To Date</label>
                                                        <input type="date" name="toDate" id="toDate" value="${currentToDate}" class="form-control" placeholder="yyyy/mm/dd"/>
                                                    </div>
                                                    
                                                    <!-- New Button Structure -->
                                                    <div class="col-md-2 d-flex justify-content-end align-items-end gap-1">
                                                        <button type="submit" >Filter</button>
                                                         <a href="${pageContext.request.contextPath}/my-registration" >Reset</a> 
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                        <!-- End Filter Section -->
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Subject Name</th>
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
                                                                    <p>${packageDAO.findById(r.package_id).name}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${r.registration_time}</p>
                                                                </td>
                                                                <td>
                                                                    <p>${packageDAO.findById(r.package_id).sale_price}</p>
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
                                                                    <c:if test="${r.status eq 'submit'}">
                                                                        <div class="dashboard__review-action">
                                                                            <form action="my-registration" method="post" style="display: inline;">
                                                                                <input type="hidden" name="action" value="delete">
                                                                                <input type="hidden" name="id" value="${r.id}">
                                                                                <button type="submit" title="Delete" class="btn btn-link p-0 m-0 align-baseline"><i class="skillgro-bin"></i></button>
                                                                            </form>
                                                                        </div>
                                                                    </c:if>
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
                                                                <a class="page-link" href="my-registration?page=${currentPage - 1}&searchName=${currentSearchName}&subjectId=${currentSubjectId != null ? currentSubjectId : 0}&status=${currentStatus != null ? currentStatus : ''}&fromDate=${currentFromDate != null ? currentFromDate : ''}&toDate=${currentToDate != null ? currentToDate : ''}">Previous</a>
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
                                                                        <a class="page-link" href="my-registration?page=${i}&searchName=${currentSearchName}&subjectId=${currentSubjectId != null ? currentSubjectId : 0}&status=${currentStatus != null ? currentStatus : ''}&fromDate=${currentFromDate != null ? currentFromDate : ''}&toDate=${currentToDate != null ? currentToDate : ''}">${i}</a>
                                                                    </li>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>

                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="my-registration?page=${currentPage + 1}&searchName=${currentSearchName}&subjectId=${currentSubjectId != null ? currentSubjectId : 0}&status=${currentStatus != null ? currentStatus : ''}&fromDate=${currentFromDate != null ? currentFromDate : ''}&toDate=${currentToDate != null ? currentToDate : ''}">Next</a>
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
        <jsp:include page="../../common/user/link_js_common.jsp"></jsp:include>
        
        <!-- Date validation script -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const fromDate = document.getElementById('fromDate');
                const toDate = document.getElementById('toDate');
                
                function validateDates() {
                    if (fromDate.value && toDate.value) {
                        if (new Date(fromDate.value) > new Date(toDate.value)) {
                            alert('From Date cannot be greater than To Date');
                            toDate.value = '';
                            return false;
                        }
                    }
                    return true;
                }
                
                fromDate.addEventListener('change', validateDates);
                toDate.addEventListener('change', validateDates);
                
                // Validate on form submit
                document.querySelector('form').addEventListener('submit', function(e) {
                    if (!validateDates()) {
                        e.preventDefault();
                    }
                });
            });
        </script>
    </body>

</html>
