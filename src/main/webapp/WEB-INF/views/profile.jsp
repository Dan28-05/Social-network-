<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${profileUser.fullname} (@${profileUser.username}) &bull; QNU_Confesstion</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Grand+Hotel&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css?v=20261010_light_v1">
</head>
<body class="ig-dark-body">
    <div class="ig-app-wrapper">
        <!-- Sidebar Navigation Trái -->
        <jsp:include page="/WEB-INF/views/commons/header.jsp" />

        <!-- Phần thân chính Trang cá nhân Dark Mode -->
        <div class="ig-main-container">
            <main class="ig-profile-page">
                <!-- Header Hồ Sơ Cá Nhân -->
                <header class="ig-profile-header">
                    <div class="profile-avatar-block">
                        <div class="story-gradient-avatar-lg">
                            <img src="${profileUser.avatar}" alt="${profileUser.username}" class="profile-pic-large">
                        </div>
                    </div>

                    <div class="profile-info-block">
                        <div class="profile-headline-row">
                            <h2 class="profile-handle-title">${profileUser.username}</h2>
                            <i class="fa-solid fa-circle-check verified-badge-lg"></i>
                            <c:choose>
                                <c:when test="${isOwner}">
                                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn-dark-pill">Chỉnh sửa trang cá nhân</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn-dark-pill btn-logout-text">Đăng xuất</a>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" 
                                            class="btn-dark-primary-pill ${isFollowing ? 'btn-following' : ''}" 
                                            onclick="handleProfileFollow('${profileUser.userId}', this)">
                                        ${isFollowing ? 'Đang theo dõi' : 'Theo dõi'}
                                    </button>
                                    <a href="${pageContext.request.contextPath}/direct/t/${profileUser.userId}" class="btn-dark-pill">Nhắn tin</a>
                                </c:otherwise>
                            </c:choose>
                            <button class="btn-gear-icon"><i class="fa-solid fa-gear"></i></button>
                        </div>

                        <div class="profile-numbers-row">
                            <span><strong>${posts.size()}</strong> bài viết</span>
                            <span><strong id="profileFollowerCount">${followerCount}</strong> người theo dõi</span>
                            <span><strong>${followingCount}</strong> đang theo dõi</span>
                        </div>

                        <div class="profile-bio-block">
                            <h1 class="profile-realname">${profileUser.fullname}</h1>
                            <c:if test="${not empty profileUser.bio}">
                                <p class="profile-bio-text">${profileUser.bio}</p>
                            </c:if>
                        </div>
                    </div>
                </header>

                <!-- Thanh phân mục bài viết (Tabs) -->
                <nav class="ig-profile-tabs">
                    <a href="javascript:void(0)" class="profile-tab active">
                        <i class="fa-solid fa-table-cells"></i>
                        <span>BÀI VIẾT</span>
                    </a>
                    <a href="javascript:void(0)" class="profile-tab">
                        <i class="fa-solid fa-clapperboard"></i>
                        <span>REELS</span>
                    </a>
                    <a href="javascript:void(0)" class="profile-tab">
                        <i class="fa-regular fa-id-badge"></i>
                        <span>ĐƯỢC GẮN THẺ</span>
                    </a>
                </nav>

                <!-- Lưới ảnh 3 Cột (Photo Grid Dark Mode) -->
                <div class="ig-photo-grid">
                    <c:choose>
                        <c:when test="${empty posts}">
                            <div class="grid-empty-state">
                                <div class="empty-camera-circle"><i class="fa-solid fa-camera"></i></div>
                                <h2>Chia sẻ ảnh</h2>
                                <p>Khi bạn chia sẻ ảnh, ảnh sẽ xuất hiện trên trang cá nhân của bạn.</p>
                                <c:if test="${isOwner}">
                                    <a href="${pageContext.request.contextPath}/" class="empty-share-link">Chia sẻ ảnh đầu tiên</a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${posts}" var="post">
                                <div class="grid-card-box" onclick="openPostDetailModal('${post.postId}')" style="cursor: pointer;">
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
                                            <video src="${resolvedMediaUrl}" class="grid-photo" preload="metadata" muted playsinline></video>
                                            <div class="grid-video-badge"><i class="fa-solid fa-play"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${resolvedMediaUrl}" alt="${post.caption}" class="grid-photo" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="grid-card-overlay">
                                        <div class="grid-hover-stats">
                                            <span><i class="fa-solid fa-heart"></i> <span id="profileLikeCount-${post.postId}">${likeCounts[post.postId] != null ? likeCounts[post.postId] : 0}</span></span>
                                            <span><i class="fa-solid fa-comment"></i> <span id="profileCommentCount-${post.postId}">${commentCounts[post.postId] != null ? commentCounts[post.postId] : 0}</span></span>
                                        </div>
                                        <c:if test="${isOwner}">
                                            <form action="${pageContext.request.contextPath}/posts/delete/${post.postId}" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa bài viết này khỏi trang cá nhân?');" onclick="event.stopPropagation();">
                                                <input type="hidden" name="redirect" value="/profile" />
                                                <button type="submit" class="grid-delete-action" title="Xóa bài viết" onclick="event.stopPropagation();">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal Tạo Bài Viết Mới Chuẩn Instagram Hiện Đại -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <!-- Modal Xem Chi Tiết Bài Viết & Bình Luận Chuẩn Instagram (2 Cột) -->
    <jsp:include page="/WEB-INF/views/commons/post-detail-modal.jsp" />

    <script>
        function handleProfileFollow(userId, btn) {
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
                        btn.classList.add('btn-following');
                    } else {
                        btn.textContent = 'Theo dõi';
                        btn.classList.remove('btn-following');
                    }
                    const countEl = document.getElementById('profileFollowerCount');
                    if (countEl && data.followerCount !== undefined) {
                        countEl.textContent = data.followerCount;
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
