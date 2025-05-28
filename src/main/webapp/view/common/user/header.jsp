<%-- 
    Document   : header
    Created on : 23 thg 5, 2025, 23:36:22
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
    <div class="tg-header__top">
        <div class="container custom-container">
            <div class="row">
                <div class="col-lg-6">
                    <ul class="tg-header__top-info list-wrap">
                        <li><img src="${pageContext.request.contextPath}/view/common/img/icons/map_marker.svg" alt="Icon"> <span>589 5th Ave, NY 10024, USA</span></li>
                        <li><img src="${pageContext.request.contextPath}/view/common/img/icons/envelope.svg" alt="Icon"> <a href="mailto:info@skillgrodemo.com">info@skillgrodemo.com</a></li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <div class="tg-header__top-right">
                        <div class="tg-header__phone">
                            <img src="${pageContext.request.contextPath}/view/common/img/icons/phone.svg" alt="Icon">Call us: <a href="tel:0123456789">+123 599 8989</a>
                        </div>
                        <ul class="tg-header__top-social list-wrap">
                            <li>Follow Us On :</li>
                            <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                            <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                            <li><a href="#"><i class="fab fa-whatsapp"></i></a></li>
                            <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                            <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header-fixed-height"></div>
    <div id="sticky-header" class="tg-header__area">
        <div class="container custom-container">
            <div class="row">
                <div class="col-12">
                    <div class="tgmenu__wrap">
                        <nav class="tgmenu__nav">
                            <div class="logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                            </div>
                            <div class="tgmenu__navbar-wrap tgmenu__main-menu d-none d-xl-flex">
                                <ul class="navigation">
                                    <li class="menu-item-has-children"><a href="#">Home</a>
                                        <ul class="sub-menu mega-menu">
                                            <li>
                                                <ul class="list-wrap mega-sub-menu">
                                                    <li>
                                                        <a href="index.html">Main Home</a>
                                                    </li>
                                                    <li>
                                                        <a href="index-2.html">Online Course <span class="tg-badge">Hot</span></a>
                                                    </li>
                                                    <li>
                                                        <a href="index-3.html">University <span class="tg-badge-two">New</span></a>
                                                    </li>
                                                    <li>
                                                        <a href="index-4.html">Yoga Instructor<span class="tg-badge-two">New</span></a>
                                                    </li>
                                                    <li>
                                                        <a href="index-5.html">Kindergarten<span class="tg-badge">Hot</span></a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li>
                                                <ul class="list-wrap mega-sub-menu">
                                                    <li>
                                                        <a href="index-6.html">Language Academy<span class="tg-badge-two">New</span></a>
                                                    </li>
                                                    <li>
                                                        <a href="index-7.html">Business Coach <span class="tg-badge-two">New</span></a>
                                                    </li>
                                                    <li>
                                                        <a href="index-8.html">Kitchen Coach <span class="tg-badge">Hot</span></a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li>
                                                <div class="mega-menu-img">
                                                    <a href="courses.html"><img src="${pageContext.request.contextPath}/view/common/img/others/mega_menu_img.jpg" alt="img"></a>
                                                </div>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="menu-item-has-children"><a href="#">Courses</a>
                                        <ul class="sub-menu">
                                            <li><a href="courses.html">All Courses</a></li>
                                            <li><a href="course-details.html">Course Details</a></li>
                                            <li><a href="lesson.html">Course Lesson</a></li>
                                        </ul>
                                    </li>
                                    <li class="menu-item-has-children"><a href="#">Pages</a>
                                        <ul class="sub-menu">
                                            <li><a href="about-us.html">About Us</a></li>
                                            <li class="menu-item-has-children">
                                                <a href="instructors.html">Our Instructors</a>
                                                <ul class="sub-menu">
                                                    <li><a href="instructors.html">Our Instructors</a></li>
                                                    <li><a href="instructor-details.html">Instructor Details</a></li>
                                                </ul>
                                            </li>
                                            <li class="menu-item-has-children">
                                                <a href="events.html">Our Events</a>
                                                <ul class="sub-menu">
                                                    <li><a href="events.html">Our Events</a></li>
                                                    <li><a href="events-details.html">Event Details</a></li>
                                                </ul>
                                            </li>
                                            <li class="menu-item-has-children">
                                                <a href="shop.html">Shop</a>
                                                <ul class="sub-menu">
                                                    <li><a href="shop.html">Shop Page</a></li>
                                                    <li><a href="shop-details.html">Shop Details</a></li>
                                                    <li><a href="cart.html">Cart Page</a></li>
                                                    <li><a href="check-out.html">Checkout</a></li>
                                                </ul>
                                            </li>
                                            <li class="menu-item-has-children">
                                                <a href="blog.html">Blog</a>
                                                <ul class="sub-menu">
                                                    <li><a href="blog.html">Blog Right Sidebar</a></li>
                                                    <li><a href="blog-2.html">Blog Left Sidebar</a></li>
                                                    <li><a href="blog-3.html">Blog Full Width</a></li>
                                                    <li><a href="blog-details.html">Blog Details</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="login.html">Student Login</a></li>
                                            <li><a href="registration.html">Student Registration</a></li>
                                            <li><a href="404.html">404 Page</a></li>
                                            <li><a href="contact.html">contact</a></li>
                                        </ul>
                                    </li>
                                    <li class="menu-item-has-children"><a href="#">Dashboard</a>
                                        <ul class="sub-menu">
                                            <li class="active menu-item-has-children">
                                                <a href="instructor-dashboard.html">Instructor Dashboard</a>
                                                <ul class="sub-menu">
                                                    <li><a href="instructor-dashboard.html">Dashboard</a></li>
                                                    <li><a href="instructor-profile.html">Profile</a></li>
                                                    <li><a href="instructor-enrolled-courses.html">Enrolled Courses</a></li>
                                                    <li><a href="instructor-wishlist.html">Wishlist</a></li>
                                                    <li><a href="instructor-review.html">Reviews</a></li>
                                                    <li><a href="instructor-attempts.html">My Quiz Attempts</a></li>
                                                    <li><a href="instructor-history.html">Order History</a></li>
                                                    <li><a href="instructor-courses.html">My Course</a></li>
                                                    <li><a href="instructor-announcement.html">Announcements</a></li>
                                                    <li class="active"><a href="instructor-quiz.html">Quiz Attempts</a></li>
                                                    <li><a href="instructor-assignment.html">Assignments</a></li>
                                                    <li><a href="instructor-setting.html">Settings</a></li>
                                                </ul>
                                            </li>
                                            <li class="menu-item-has-children"><a href="student-dashboard.html">Student Dashboard</a>
                                                <ul class="sub-menu">
                                                    <li><a href="student-dashboard.html">Dashboard</a></li>
                                                    <li><a href="student-profile.html">Profile</a></li>
                                                    <li><a href="student-enrolled-courses.html">Enrolled Courses</a></li>
                                                    <li><a href="student-wishlist.html">Wishlist</a></li>
                                                    <li><a href="student-review.html">Reviews</a></li>
                                                    <li><a href="student-attempts.html">My Quiz Attempts</a></li>
                                                    <li><a href="student-history.html">Order History</a></li>
                                                    <li><a href="student-setting.html">Settings</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <div class="tgmenu__action">
                                <ul class="list-wrap">                                   
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                        <!-- Nút Log out -->
                                            <a href="login?action=logout" class="button-style">Log out</a>
                                        </c:when>
                                        <c:otherwise>
                                        <!-- Nút Log in -->
                                            <a href="login" class="button-style">Log in</a>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                            <div class="mobile-login-btn">
                                <a href="login"><img src="${pageContext.request.contextPath}/view/common/img/icons/user.svg" alt="" class="injectable"></a>
                            </div>
                            <div class="mobile-nav-toggler"><i class="tg-flaticon-menu-1"></i></div>
                        </nav>
                    </div>
                    <!-- Mobile Menu  -->
                    <div class="tgmobile__menu">
                        <nav class="tgmobile__menu-box">
                            <div class="close-btn"><i class="tg-flaticon-close-1"></i></div>
                            <div class="nav-logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/view/common/img/logo/logo.svg" alt="Logo"></a>
                            </div>
                            <div class="tgmobile__search">
                                <form action="#">
                                    <input type="text" placeholder="Search here...">
                                    <button><i class="fas fa-search"></i></button>
                                </form>
                            </div>
                            <div class="tgmobile__menu-outer">
                                <!--Here Menu Will Come Automatically Via Javascript / Same Menu as in Header-->
                            </div>
                            <div class="social-links">
                                <ul class="list-wrap">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                                </ul>
                            </div>
                        </nav>
                    </div>
                    <div class="tgmobile__menu-backdrop"></div>
                    <!-- End Mobile Menu -->
                </div>
            </div>
        </div>
    </div>
</header>