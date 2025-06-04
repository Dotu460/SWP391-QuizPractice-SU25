<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login - SkillGro</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/view/common/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/user/link_css_common.jsp"></jsp:include>
        <style>
            .dashboard__content-wrap {
                background: rgba(255, 255, 255, 0.9);
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                margin: 0 auto;
                padding: 30px;
            }
            .login-form {
                max-width: 400px;
                margin: 0 auto;
            }
            .form-group {
                margin-bottom: 1.5rem;
            }
            .form-control {
                border-radius: 5px;
                padding: 12px;
                border: 1px solid #ddd;
            }
            .btn-login {
                width: 100%;
                padding: 12px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                margin-top: 10px;
                cursor: pointer;
            }
            .btn-login:hover {
                background: #0056b3;
            }
            .login-options {
                text-align: center;
                margin-top: 20px;
            }
            .login-options a {
                color: #007bff;
                text-decoration: none;
                margin: 0 10px;
            }
            .login-options a:hover {
                text-decoration: underline;
            }
            .dashboard__bg {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: -1;
            }
            .dashboard__bg img {
                display: none;
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
                <div class="dashboard__bg"></div>
                <div class="container">
                    <div class="dashboard__inner-wrap">
                        <div class="row justify-content-center">
                            <div class="col-lg-12">
                                <div class="dashboard__content-wrap">
                                    <div class="text-center mb-4">
                                        <h4 class="title">LOGIN</h4>
                                    </div>
                                    <div class="login-form">
                                        <form action="login" method="post">
                                            <div class="form-group">
                                                <label for="email">Email</label>
                                                <div class="input-group">
                                                    <span class="input-group-text">
                                                        <i class="far fa-envelope"></i>
                                                    </span>
                                                    <input type="email" class="form-control" id="email" name="email" 
                                                           placeholder="Enter your email" required>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label for="password">Password</label>
                                                <div class="input-group">
                                                    <span class="input-group-text">
                                                        <i class="fas fa-lock"></i>
                                                    </span>
                                                    <input type="password" class="form-control" id="password" name="password" 
                                                           placeholder="Enter your password" required>
                                                </div>
                                            </div>

                                            <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>

                                            <div class="text-center">
                                                <a href="forgot-password" class="text-primary d-block mb-2">Forgot password?</a>
                                                <a href="register" class="text-primary">Don't have an account? Register</a>
                                            </div>
                                        </form>
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
