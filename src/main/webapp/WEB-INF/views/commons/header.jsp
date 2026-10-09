<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Instagram Left Sidebar Navigation (Dark Mode) -->
<aside class="ig-sidebar">
    <!-- Instagram Logo Top -->
    <div class="sidebar-logo">
        <a href="${pageContext.request.contextPath}/" class="logo-full">
            <span class="logo-text">Instagram</span>
        </a>
        <a href="${pageContext.request.contextPath}/" class="logo-compact">
            <i class="fa-brands fa-instagram"></i>
        </a>
    </div>

    <!-- Navigation Menu Items -->
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/" class="nav-item active" title="Trang chủ (Home)">
            <i class="fa-solid fa-house nav-icon"></i>
            <span class="nav-label">Home</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" onclick="document.getElementById('searchModal').classList.toggle('active')" title="Tìm kiếm (Search)">
            <i class="fa-solid fa-magnifying-glass nav-icon"></i>
            <span class="nav-label">Search</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" title="Khám phá (Explore)">
            <i class="fa-regular fa-compass nav-icon"></i>
            <span class="nav-label">Explore</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" title="Reels">
            <i class="fa-solid fa-clapperboard nav-icon"></i>
            <span class="nav-label">Reels</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" title="Tin nhắn (Messages)">
            <i class="fa-brands fa-facebook-messenger nav-icon"></i>
            <span class="nav-label">Messages</span>
            <span class="nav-badge">3</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" title="Thông báo (Notifications)">
            <i class="fa-regular fa-heart nav-icon"></i>
            <span class="nav-label">Notifications</span>
        </a>

        <!-- Nút Tạo bài viết mới -->
        <a href="javascript:void(0)" class="nav-item" onclick="openCreateModal()" title="Tạo bài viết mới (Create)">
            <i class="fa-regular fa-square-plus nav-icon"></i>
            <span class="nav-label">Create</span>
        </a>

        <!-- Trang cá nhân Profile -->
        <c:choose>
            <c:when test="${not empty currentUser}">
                <a href="${pageContext.request.contextPath}/profile" class="nav-item nav-profile-item" title="Trang cá nhân (@${currentUser.username})">
                    <img src="${currentUser.avatar}" alt="${currentUser.username}" class="nav-user-avatar">
                    <span class="nav-label">${currentUser.username}</span>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="nav-item" title="Đăng nhập (Log In)">
                    <i class="fa-regular fa-user nav-icon"></i>
                    <span class="nav-label">Log In</span>
                </a>
            </c:otherwise>
        </c:choose>
    </nav>

    <!-- Bottom Menu (More & Threads) -->
    <div class="sidebar-bottom">
        <a href="${pageContext.request.contextPath}/logout" class="nav-item nav-logout" title="Đăng xuất khỏi tài khoản">
            <i class="fa-solid fa-arrow-right-from-bracket nav-icon"></i>
            <span class="nav-label">Log out</span>
        </a>
        <a href="javascript:void(0)" class="nav-item" title="Xem thêm (More)">
            <i class="fa-solid fa-bars nav-icon"></i>
            <span class="nav-label">More</span>
        </a>
        <a href="javascript:void(0)" class="nav-item meta-item" title="Khác từ Meta">
            <i class="fa-brands fa-threads nav-icon"></i>
            <span class="nav-label">Also from Meta</span>
        </a>
    </div>
</aside>
