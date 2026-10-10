<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập &bull; QNU_Confesstion</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Grand+Hotel&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css?v=20261010_light_v1">
</head>
<body class="ig-dark-auth-body">
    <div class="dark-auth-container">
        <!-- Card Đăng nhập Dark Mode -->
        <div class="dark-auth-card">
            <h1 class="dark-insta-logo">QNU_Confesstion</h1>

            <c:if test="${not empty error}">
                <div class="auth-error-msg-dark">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="dark-auth-form">
                <div class="dark-input-wrap">
                    <input type="text" name="username" placeholder="Số điện thoại, tên người dùng hoặc email" required autofocus autocomplete="username" class="dark-field" />
                </div>
                <div class="dark-input-wrap">
                    <input type="password" name="password" placeholder="Mật khẩu" required autocomplete="current-password" class="dark-field" />
                </div>
                <button type="submit" class="btn-dark-blue">Đăng nhập</button>
            </form>

            <div class="dark-separator">
                <span class="dark-sep-line"></span>
                <span class="dark-sep-text">HOẶC</span>
                <span class="dark-sep-line"></span>
            </div>

            <div class="dark-demo-accounts">
                <p>Tài khoản mẫu thử nghiệm:</p>
                <span>User: <strong>nguyenvana</strong> &bull; Pass: <strong>123456</strong></span><br>
                <span>User: <strong>thuhalee</strong> &bull; Pass: <strong>123456</strong></span>
            </div>
        </div>

        <!-- Card chuyển sang Đăng ký -->
        <div class="dark-auth-card dark-switch-card">
            <p>Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="dark-link-blue">Đăng ký</a></p>
        </div>
    </div>
</body>
</html>
