<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        </head>

        <body>

            <!--Preloader-end -->

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
                    <jsp:include page="../../common/user/dashboard_top.jsp"></jsp:include>       
                        <div class="dashboard__inner-wrap">
                            <div class="row">
                                <!--Sidebar-->
                            <jsp:include page="../../common/user/sidebar.jsp"></jsp:include>            
                                
                                <!--Main-->
                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Quiz Attempts</h4>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>Quiz</th>
                                                                <th>Qus</th>
                                                                <th>TM</th>
                                                                <th>CA</th>
                                                                <th>Result</th>
                                                                <th>&nbsp;</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div class="dashboard__quiz-info">
                                                                        <p>January 20, 2024</p>
                                                                        <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                        <span>Student: <a href="#">John Due</a></span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">5</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">9</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">3</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">Pass</span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div class="dashboard__quiz-info">
                                                                        <p>February 29, 2024</p>
                                                                        <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                        <span>Student: <a href="#">John Due</a></span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">2</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">6</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">3</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result fail">Fail</span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div class="dashboard__quiz-info">
                                                                        <p>January 20, 2024</p>
                                                                        <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                        <span>Student: <a href="#">John Due</a></span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">4</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">8</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">4</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">Pass</span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div class="dashboard__quiz-info">
                                                                        <p>February 29, 2024</p>
                                                                        <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                        <span>Student: <a href="#">John Due</a></span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">2</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">6</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">3</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result fail">Fail</span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="#" title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div class="dashboard__quiz-info">
                                                                        <p>January 20, 2024</p>
                                                                        <h6 class="title">Learning JavaScript With Imagination</h6>
                                                                        <span>Student: <a href="#">John Due</a></span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">4</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">8</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">4</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">Pass</span>
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