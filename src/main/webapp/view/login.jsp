<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login - SkillGro</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #6C5CE7, #4A90E2);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }
        
        h1 {
            color: #2D3748;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #718096;
            margin-bottom: 30px;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        label {
            display: block;
            color: #4A5568;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        input:focus {
            outline: none;
            border-color: #6C5CE7;
        }
        
        .forgot-password {
            display: block;
            text-align: right;
            color: #6C5CE7;
            text-decoration: none;
            margin-top: 8px;
            font-size: 14px;
        }
        
        .signin-button {
            background: #6C5CE7;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }
        
        .signin-button:hover {
            background: #5344c7;
        }
        
        .signup-text {
            margin-top: 20px;
            color: #718096;
            font-size: 14px;
        }
        
        .signup-link {
            color: #6C5CE7;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Welcome Back!</h1>
        <p class="subtitle">Please sign in to continue</p>
        
        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">Forgot password?</a>
            </div>
            
            <button type="submit" class="signin-button">Sign in to your account</button>
            
            <p class="signup-text">
                Don't have an account? 
                <a href="${pageContext.request.contextPath}/signup" class="signup-link">Sign up</a>
            </p>
        </form>
    </div>
</body>
</html> 