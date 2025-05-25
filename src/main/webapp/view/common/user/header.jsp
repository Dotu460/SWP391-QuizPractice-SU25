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
                    <div class="col-lg-8">
                        <div class="header-top-left">
                            <ul class="list-inline">
                                <li>
                                    <img src="${pageContext.request.contextPath}/assets/icons/map_marker.svg" alt="location" class="icon">
                                    589 5th Ave, NY 10024, USA
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/assets/icons/envelope.svg" alt="email" class="icon">
                                    <a href="mailto:info@skillgrodemo.com">info@skillgrodemo.com</a>
                                </li>
                                <li>
                                    <img src="${pageContext.request.contextPath}/assets/icons/phone.svg" alt="phone" class="icon">
                                    Call us: +123 599 8989
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="header-top-right text-end">
                            <div class="header-social">
                                <ul class="list-inline">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-top-end -->

    <!-- header-area -->
    <div class="header-area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-3 col-sm-6">
                    <div class="logo">
                        <a href="${pageContext.request.contextPath}/home">
                            <img src="${pageContext.request.contextPath}/assets/logo/logo.svg" alt="QuizPractice Logo">
                        </a>
                    </div>
                </div>
                <div class="col-lg-9 col-sm-6">
                    <div class="header-menu">
                        <nav class="navbar navbar-expand-lg">
                            <div class="collapse navbar-collapse">
                                <ul class="navbar-nav ms-auto">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/quizzes">Quizzes</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/practice">Practice</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/login" class="nav-link login-btn">Log In</a>
                                    </li>
                                </ul>
                            </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-area-end -->

    <style>
        .header-top-wrap {
            background: #1A1B3D;
            padding: 12px 0;
            color: #fff;
        }
        .header-top-left ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .header-top-left ul li {
            display: inline-block;
            margin-right: 30px;
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
            padding: 20px 0;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .logo img {
            max-height: 50px;
        }
        .navbar-nav .nav-link {
            color: #2D3748;
            font-weight: 500;
            padding: 8px 20px;
            transition: color 0.3s ease;
        }
        .navbar-nav .nav-link:hover {
            color: #4A90E2;
        }
        .login-btn {
            background-color: #6C5CE7;
            color: white !important;
            border: none;
            border-radius: 5px;
            padding: 8px 20px !important;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .login-btn:hover {
            background-color: #5344c7;
        }
    </style>
</header>

<!-- Login Modal -->
<div id="loginModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
    <div class="modal-content" style="background-color: white; margin: 15% auto; padding: 20px; width: 300px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
        <h2 style="color: #6C5CE7; margin-bottom: 20px;">Login</h2>
        <form id="loginForm" onsubmit="handleLogin(event)">
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
let isLoggedIn = false;

function toggleLoginState() {
    const loginButton = document.getElementById('loginButton');
    if (!isLoggedIn) {
        // Chuyển sang trạng thái đã đăng nhập
        loginButton.textContent = 'Log Out';
        loginButton.style.backgroundColor = '#8B7FD2'; // Màu tím nhạt
        isLoggedIn = true;
    } else {
        // Chuyển sang trạng thái chưa đăng nhập
        loginButton.textContent = 'Log In';
        loginButton.style.backgroundColor = '#6C5CE7'; // Màu tím đậm
        isLoggedIn = false;
    }
}

function handleLogin(event) {
    event.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    // Kiểm tra đăng nhập đơn giản (demo)
    if (username && password) {
        isLoggedIn = true;
        const loginButton = document.getElementById('loginButton');
        loginButton.textContent = 'Log Out';
        loginButton.style.backgroundColor = '#8B7FD2';
        
        // Đóng modal
        closeLoginModal();
        
        // Reset form
        document.getElementById('loginForm').reset();
        
        // Lưu trạng thái đăng nhập
        localStorage.setItem('isLoggedIn', 'true');
        localStorage.setItem('username', username);
    }
}

function handleLogout() {
    isLoggedIn = false;
    const loginButton = document.getElementById('loginButton');
    loginButton.textContent = 'Log In';
    loginButton.style.backgroundColor = '#6C5CE7';
    
    // Xóa trạng thái đăng nhập
    localStorage.removeItem('isLoggedIn');
    localStorage.removeItem('username');
}

function closeLoginModal() {
    document.getElementById('loginModal').style.display = 'none';
}

// Kiểm tra trạng thái đăng nhập khi tải trang
window.onload = function() {
    if (localStorage.getItem('isLoggedIn') === 'true') {
        isLoggedIn = true;
        const loginButton = document.getElementById('loginButton');
        loginButton.textContent = 'Log Out';
        loginButton.style.backgroundColor = '#8B7FD2';
    }
}

// Đóng modal khi click bên ngoài
window.onclick = function(event) {
    const modal = document.getElementById('loginModal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}

function handleLoginClick() {
    if (!isLoggedIn) {
        // Show login modal
        document.getElementById('loginModal').style.display = 'block';
    } else {
        // Handle logout
        handleLogout();
    }
}
</script>