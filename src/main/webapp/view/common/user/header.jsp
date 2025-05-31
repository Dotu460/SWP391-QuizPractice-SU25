<%-- 
    Document   : header
    Created on : 23 thg 5, 2025, 23:36:22
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
    <!-- header-top -->
    <div class="header-top-wrap">
        <div class="container">
            <div class="header-top">
                <div class="row align-items-center">
                    <div class="col-lg-10">
                        <div class="header-top-left">
                            <ul class="list-inline">
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/map_marker.svg" alt="location" class="icon">
                                    Hoa Lac Hi-tech Park, Km29, Thang Long Boulevard, Thach Hoa, Thach That, Ha Noi, Vietnam
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/envelope.svg" alt="email" class="icon">
                                    <a href="mailto:info@skillgrodemo.com">se1931Group@gmail.com</a>
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/view/common/img/icons/phone.svg" alt="phone" class="icon">
                                    Call us: +84 123 456 789
                                </li>
                            </ul>
                        </div>
                    
                    </div>
                    <div class="col-lg-2">
                    <ul class="tg-header__top-social list-wrap">
                        <li>Follow Us:</li>
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
    <!-- header-top-end -->

    <!-- header-area -->

    <!-- header-area-end -->

    <style>
        .header-top-wrap {
            background: #1A1B3D;
            padding: 8px 0;
            color: #fff;
        }
        .header-top-left ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .header-top-left ul li {
            display: inline-block;
            margin-right: 20px;
            font-size: 14px;
            vertical-align: middle;
        }
        .header-top-left ul li:last-child {
            margin-right: 0;
        }
        .header-top-left ul li img.icon {
            width: 14px;
            height: 14px;
            margin-right: 8px;
            filter: brightness(0) invert(1);
            vertical-align: middle;
            display: inline-block;
        }
        .header-top-left ul li a {
            color: #fff;
            text-decoration: none;
            vertical-align: middle;
        }
        .header-social ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .header-social ul li {
            display: inline-block;
            margin-left: 15px;
        }
        .header-social ul li a {
            color: #fff;
            font-size: 14px;
        }
        .header-social ul li a:hover {
            color: #4A90E2;
        }
        .header-area {
            padding: 0;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-area .container {
            padding: 5px 0;
        }
        .logo img {
            max-height: 40px;
        }
        .header-menu {
            margin-top: -10px;
        }
        .navbar {
            padding: 0;
        }
        .navbar-nav .nav-link {
            color: #2D3748;
            font-weight: 500;
            padding: 6px 15px;
            transition: color 0.3s ease;
            display: flex;
            align-items: center;
        }
        .navbar-nav .nav-link:hover {
            color: #4A90E2;
        }
        .navbar-nav .login-btn {
            background-color: #8B7FD2;
            color: white !important;
            border: none;
            border-radius: 8px;
            padding: 2px 10px;
            height: 22px;
            line-height: 22px;
            font-size: 13px;
            font-weight: 300;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-left: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 1px 3px rgba(139, 127, 210, 0.2);
            position: relative;
            overflow: hidden;
        }
        .navbar-nav .login-btn:hover {
            background-color: #7A6DC0;
            transform: translateY(-1px);
            box-shadow: 0 2px 5px rgba(139, 127, 210, 0.3);
        }
        .navbar-nav .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                120deg,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent
            );
            transition: 0.5s;
        }
        .navbar-nav .login-btn:hover::before {
            left: 100%;
        }
        .navbar-nav {
            display: flex;
            align-items: center;
            margin: 0;
            padding: 0;
        }
        .navigation {
            display: flex;
            align-items: center;
            margin: 0;
            padding: 0;
            list-style: none;
            gap: 15px;
        }
        .navigation > li {
            display: flex;
            align-items: center;
        }
        .navigation > li > a {
            color: #2D3748;
            font-weight: 500;
            text-decoration: none;
            padding: 6px 0;
            display: flex;
            align-items: center;
        }
        .tgmenu__navbar-wrap {
            margin-top: -5px;
        }
        .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn {
            background-color: #8B7FD2;
            color: white !important;
            border: none;
            border-radius: 8px;
            padding: 4px 16px;
            height: 28px;
            line-height: 28px;
            font-size: 15px;
            font-weight: 400;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            margin-left: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 1px 3px rgba(139, 127, 210, 0.2);
            position: relative;
            overflow: hidden;
            min-height: unset;
            max-height: 28px;
        }
        .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn:hover {
            background-color: #7A6DC0;
            transform: translateY(-1px);
            box-shadow: 0 2px 5px rgba(139, 127, 210, 0.3);
        }
        .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                120deg,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent
            );
            transition: 0.5s;
        }
        .tgmenu__navbar-wrap .navigation .nav-item .nav-link.login-btn:hover::before {
            left: 100%;
        }
    </style>
</header>

<!-- Login Modal -->
<div id="loginModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
    <div class="modal-content" style="background-color: white; margin: 15% auto; padding: 20px; width: 300px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
        <h2 style="color: #6C5CE7; margin-bottom: 20px;">Login</h2>
        <form id="loginForm">
            <div style="margin-bottom: 15px;">
                <input type="text" id="username" placeholder="Username" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            <div style="margin-bottom: 20px;">
                <input type="password" id="password" placeholder="Password" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px;">
            </div>
            <div style="display: flex; justify-content: space-between;">
                <button type="submit" style="padding: 10px 20px; background-color: #6C5CE7; color: white; border: none; border-radius: 5px; cursor: pointer;">Login</button>
                <button type="button" onclick="closeLoginModal()" style="padding: 10px 20px; background-color: #8B7FD2; color: white; border: none; border-radius: 5px; cursor: pointer;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function handleLoginLogout(event) {
    event.preventDefault();
    const loginBtn = document.querySelector('.login-btn');
    
    if (loginBtn.textContent.trim() === 'Log Out') {
        console.log('Attempting to logout...');
        fetch('${pageContext.request.contextPath}/logout', {
            method: 'GET',
            credentials: 'include'
        })
        .then(response => {
            console.log('Logout response:', response);
            if (response.ok) {
                console.log('Logout successful');
                loginBtn.textContent = 'Log In';
            } else {
                console.error('Logout failed:', response.status);
            }
        })
        .catch(error => {
            console.error('Logout error:', error);
        });
    } else {
        window.location.href = '${pageContext.request.contextPath}/login';
    }
}
</script>
