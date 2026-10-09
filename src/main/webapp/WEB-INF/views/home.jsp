<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instagram</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Grand+Hotel&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css">
</head>
<body class="ig-dark-body">
    <!-- Layout chính của Instagram: Sidebar trái cố định + Content bên phải -->
    <div class="ig-app-wrapper">
        <!-- Sidebar Navigation Trái -->
        <jsp:include page="/WEB-INF/views/commons/header.jsp" />

        <!-- Phần thân chính: Bảng tin ở giữa và Gợi ý bên phải -->
        <div class="ig-main-container">
            <div class="ig-content-layout">
                <!-- Cột Giữa: Bảng tin bài viết (Feed Column) -->
                <div class="ig-feed-column">
                    <!-- Thanh Tin (Stories Tray) Chuẩn ảnh người dùng -->
                    <div class="ig-stories-carousel">
                        <div class="stories-track">
                            <!-- Story của bạn / Tài khoản hiện tại -->
                            <div class="story-bubble">
                                <div class="story-avatar-wrap story-gradient">
                                    <img src="${currentUser.avatar}" alt="${currentUser.username}" class="story-img">
                                </div>
                                <span class="story-name">Tin của bạn</span>
                            </div>

                            <!-- Các Story từ người dùng thật trong Database (Không bấm vào được) -->
                            <c:forEach items="${storyUsers}" var="su">
                                <div class="story-bubble story-static" title="${su.fullname} (@${su.username})">
                                    <div class="story-avatar-wrap story-gradient">
                                        <img src="${su.avatar}" alt="${su.username}" class="story-img">
                                    </div>
                                    <span class="story-name">${su.username}</span>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Nút mũi tên cuộn stories bên phải -->
                        <button class="story-arrow-next" title="Xem thêm tin">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>

                    <!-- Danh sách bài viết (Instagram Feed Cards) -->
                    <div class="ig-feed-list">
                        <c:forEach items="${posts}" var="post">
                            <article class="ig-post-card">
                                <!-- Header Bài Viết -->
                                <div class="post-top-bar">
                                    <div class="post-author-block">
                                        <div class="post-story-ring">
                                            <img src="${post.user.avatar}" alt="${post.user.username}" class="post-author-avatar">
                                        </div>
                                        <div class="post-author-text">
                                            <div class="name-line">
                                                <a href="${pageContext.request.contextPath}/profile/user/${post.user.userId}" class="author-handle">${post.user.username}</a>
                                                <i class="fa-solid fa-circle-check verified-badge" title="Tài khoản đã xác minh"></i>
                                                <span class="bullet-dot">&bull;</span>
                                                <span class="post-age"><fmt:formatDate value="${post.createdAt}" pattern="HH:mm" /></span>
                                            </div>
                                            <span class="post-location">Việt Nam</span>
                                        </div>
                                    </div>

                                    <!-- Nút tùy chọn / Xóa bài của bản thân -->
                                    <div class="post-header-actions">
                                        <c:choose>
                                            <c:when test="${post.user.userId == currentUser.userId}">
                                                <form action="${pageContext.request.contextPath}/posts/delete/${post.postId}" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?');">
                                                    <button type="submit" class="btn-post-del" title="Xóa bài viết của tôi">
                                                        <i class="fa-solid fa-trash-can"></i> Xóa
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn-more-dots"><i class="fa-solid fa-ellipsis"></i></button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Hình ảnh hoặc Video bài viết (Instagram Ratio) -->
                                <div class="post-image-container">
                                    <c:set var="resolvedMediaUrl">
                                        <c:choose>
                                            <c:when test="${post.imageUrl.startsWith('http://') || post.imageUrl.startsWith('https://') || post.imageUrl.startsWith('data:')}">
                                                ${post.imageUrl}
                                            </c:when>
                                            <c:otherwise>
                                                <c:url value='${post.imageUrl}' />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:set>

                                    <c:choose>
                                        <c:when test="${post.video}">
                                            <video src="${resolvedMediaUrl}" controls playsinline loop class="post-main-image post-main-video" preload="metadata"></video>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${resolvedMediaUrl}" alt="${post.caption}" class="post-main-image" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                    <!-- Nút mũi tên tải ảnh overlay góc trên trái -->
                                    <div class="image-overlay-badge">
                                        <i class="fa-solid fa-arrow-down"></i>
                                    </div>
                                </div>

                                <!-- Thanh công cụ biểu tượng tương tác -->
                                <div class="post-toolbar">
                                    <div class="toolbar-left">
                                        <button class="toolbar-btn btn-like" onclick="this.classList.toggle('liked');">
                                            <i class="fa-regular fa-heart heart-outline"></i>
                                            <i class="fa-solid fa-heart heart-filled"></i>
                                        </button>
                                        <button class="toolbar-btn"><i class="fa-regular fa-comment"></i></button>
                                        <button class="toolbar-btn"><i class="fa-regular fa-paper-plane"></i></button>
                                    </div>
                                    <div class="toolbar-right">
                                        <button class="toolbar-btn"><i class="fa-regular fa-bookmark"></i></button>
                                    </div>
                                </div>

                                <!-- Phần thích & Nội dung caption -->
                                <div class="post-captions-block">
                                    <div class="likes-text">48 lượt thích</div>
                                    <c:if test="${not empty post.caption}">
                                        <div class="caption-row">
                                            <a href="${pageContext.request.contextPath}/profile/user/${post.user.userId}" class="caption-user">${post.user.username}</a>
                                            <span class="caption-content">${post.caption}</span>
                                        </div>
                                    </c:if>
                                    <div class="view-comments-btn">Xem tất cả 12 bình luận</div>
                                    <div class="post-timestamp"><fmt:formatDate value="${post.createdAt}" pattern="dd 'THÁNG' MM, yyyy" /></div>
                                </div>

                                <!-- Hộp bình luận -->
                                <div class="post-comment-input-row">
                                    <i class="fa-regular fa-face-smile smile-btn"></i>
                                    <input type="text" placeholder="Thêm bình luận..." class="ig-comment-field" />
                                    <button class="btn-post-send">Đăng</button>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </div>

                <!-- Cột Phải: Thông tin tài khoản & Gợi ý (Suggested for you) -->
                <aside class="ig-sidebar-right">
                    <!-- Tài khoản hiện tại + Nút chuyển / Đăng xuất -->
                    <div class="ig-current-user-card">
                        <a href="${pageContext.request.contextPath}/profile" class="user-info-link">
                            <img src="${currentUser.avatar}" alt="${currentUser.username}" class="user-avatar-sm">
                            <div class="user-text-meta">
                                <span class="username-strong">${currentUser.username}</span>
                                <span class="fullname-sub">${currentUser.fullname}</span>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="link-switch-action">Đăng xuất</a>
                    </div>

                    <!-- Danh sách Gợi ý cho bạn (Suggested for you) chuẩn ảnh -->
                    <div class="ig-suggestions-box">
                        <div class="suggestions-title-row">
                            <span class="title-label">Suggested for you</span>
                            <a href="javascript:void(0)" class="link-see-all">See all</a>
                        </div>

                        <div class="suggestions-items">
                            <c:forEach items="${suggestedUsers}" var="su">
                                <c:set var="isFollowed" value="${followingIds.contains(su.userId)}" />
                                <div class="sugg-profile-row" id="sugg-user-${su.userId}">
                                    <a href="${pageContext.request.contextPath}/profile/user/${su.userId}" class="sugg-avatar-wrap">
                                        <img src="${su.avatar}" alt="${su.username}" class="sugg-avatar-pic">
                                    </a>
                                    <div class="sugg-names">
                                        <a href="${pageContext.request.contextPath}/profile/user/${su.userId}" class="sugg-handle">${su.username}</a>
                                        <span class="sugg-sub">${not empty su.fullname ? su.fullname : 'Gợi ý cho bạn'}</span>
                                    </div>
                                    <button type="button" 
                                            class="btn-blue-follow ${isFollowed ? 'is-following' : ''}" 
                                            onclick="handleToggleFollow('${su.userId}', this)">
                                        ${isFollowed ? 'Đang theo dõi' : 'Follow'}
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Footer Meta Bản Quyền Chuẩn Ảnh -->
                    <footer class="ig-meta-footer">
                        <div class="meta-links">
                            <a href="javascript:void(0)">About</a> &bull;
                            <a href="javascript:void(0)">Help</a> &bull;
                            <a href="javascript:void(0)">Press</a> &bull;
                            <a href="javascript:void(0)">API</a> &bull;
                            <a href="javascript:void(0)">Jobs</a> &bull;
                            <a href="javascript:void(0)">Privacy</a> &bull;
                            <a href="javascript:void(0)">Terms</a> &bull;
                            <a href="javascript:void(0)">Locations</a> &bull;
                            <a href="javascript:void(0)">Language</a> &bull;
                            <a href="javascript:void(0)">Meta Verified</a>
                        </div>
                        <div class="meta-copyright">
                            &copy; 2026 INSTAGRAM FROM META
                        </div>
                    </footer>
                </aside>
            </div>
        </div>
    </div>

    <!-- Nút Nổi "Messages" Góc Dưới Phải Chuẩn Ảnh Người Dùng -->
    <div class="floating-messages-pill" onclick="alert('Tính năng tin nhắn trực tiếp Direct Messages!')">
        <i class="fa-regular fa-paper-plane"></i>
        <span>Messages</span>
        <div class="floating-avatars">
            <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=60" alt="m1" class="f-av">
            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60" alt="m2" class="f-av">
        </div>
    </div>

    <!-- Modal Tạo Bài Viết Mới Chuẩn Instagram Hiện Đại -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <script>
        function handleToggleFollow(userId, btn) {
            btn.disabled = true;
            fetch('${pageContext.request.contextPath}/api/follow/' + userId, {
                method: 'POST'
            })
            .then(res => res.json())
            .then(data => {
                btn.disabled = false;
                if (data.success) {
                    if (data.isFollowing) {
                        btn.textContent = 'Đang theo dõi';
                        btn.classList.add('is-following');
                    } else {
                        btn.textContent = 'Follow';
                        btn.classList.remove('is-following');
                    }
                }
            })
            .catch(() => {
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>