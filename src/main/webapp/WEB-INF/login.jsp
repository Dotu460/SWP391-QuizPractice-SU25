<%-- 
    Document   : login
    Created on : May 22, 2025, 8:43:09 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        .popup-box {
            width: 400px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
            position: absolute;
            top: 15%;
            left: 50%;
            transform: translate(-50%, -15%);
        }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
        }
        .button {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .link {
            display: block;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="popup-box">
        <h2 style="text-align:center;">LOGIN</h2>
        <form method="post" action="login">
            <label>Email</label>
            <input type="email" name="email" required>
            <label>Password</label>
            <input type="password" name="password" required>
            <div style="text-align:center;">
                <button type="submit" class="button">Login</button>
            </div>
        </form>
        <div class="link">
            <a href="forgot.jsp">Forgot password?</a>
            <br>
            <a href="register.jsp">Don't have an account? Register</a>
        </div>
        <p style="color:red; text-align:center;">${error}</p>
    </div>
</body>
</html>