<%-- 
    Document   : my-registrationn
    Created on : 24 thg 5, 2025, 14:22:40
    Author     : FPT
--%>

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
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>Order ID</th>
                                                                <th>Course Name</th>
                                                                <th>Date</th>
                                                                <th>Price</th>
                                                                <th>Status</th>
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>#2348</p>
                                                                </td>
                                                                <td>
                                                                    <p>Application</p>
                                                                </td>
                                                                <td>
                                                                    <p>June 20, 2024</p>
                                                                </td>
                                                                <td>
                                                                    <p>$99.99</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">Success</span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
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



            <!-- footer-area -->
        <jsp:include page="../../common/user/footer.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../../common/js/"></jsp:include>
    </body>

</html>
