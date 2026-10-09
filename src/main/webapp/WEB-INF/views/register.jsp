<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký &bull; QNU_Confesstion</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Grand+Hotel&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css">
</head>
<body class="ig-dark-auth-body">
    <div class="dark-auth-container">
        <!-- Card Đăng ký Dark Mode -->
        <div class="dark-auth-card">
            <h1 class="dark-insta-logo">QNU_Confesstion</h1>
            <p class="dark-auth-sub">Đăng ký để xem ảnh và video từ bạn bè.</p>

            <c:if test="${not empty error}">
                <div class="auth-error-msg-dark">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="dark-auth-form">
                <div class="dark-input-wrap">
                    <input type="email" name="email" placeholder="Email" required autocomplete="email" class="dark-field" />
                </div>
                <div class="dark-input-wrap">
                    <input type="text" name="fullname" placeholder="Tên đầy đủ" required class="dark-field" />
                </div>
                <div class="dark-input-wrap">
                    <input type="text" name="username" placeholder="Tên người dùng (không dấu)" required autocomplete="username" class="dark-field" />
                </div>
                <div class="dark-input-wrap">
                    <input type="password" name="password" placeholder="Mật khẩu" required autocomplete="new-password" class="dark-field" />
                </div>
                <button type="submit" class="btn-dark-blue">Đăng ký</button>
            </form>

            <p class="dark-terms-notice">
                Bằng cách đăng ký, bạn đồng ý với Điều khoản, Chính sách quyền riêng tư của chúng tôi.
            </p>
        </div>

        <!-- Card chuyển sang Đăng nhập -->
        <div class="dark-auth-card dark-switch-card">
            <p>Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="dark-link-blue">Đăng nhập</a></p>
        </div>
    </div>
</body>
</html>
