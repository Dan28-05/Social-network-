<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QNU_Confesstion</title>
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
                                    <div class="heart-pop-icon" id="heartPop-${post.postId}"><i class="fa-solid fa-heart"></i></div>
                                </div>

                                <!-- Thanh công cụ biểu tượng tương tác -->
                                <div class="post-toolbar">
                                    <div class="toolbar-left">
                                        <button type="button" 
                                                class="toolbar-btn btn-like ${likedPostIds.contains(post.postId) ? 'liked' : ''}" 
                                                id="likeBtn-${post.postId}" 
                                                onclick="handleToggleLike(${post.postId}, this)"
                                                title="Thích bài viết">
                                            <i class="fa-regular fa-heart heart-outline"></i>
                                            <i class="fa-solid fa-heart heart-filled"></i>
                                        </button>
                                        <button type="button" class="toolbar-btn" onclick="focusCommentInput(${post.postId})" title="Bình luận">
                                            <i class="fa-regular fa-comment"></i>
                                        </button>
                                        <button type="button" class="toolbar-btn" onclick="window.location.href='${pageContext.request.contextPath}/direct?userId=${post.user.userId}'" title="Nhắn tin riêng">
                                            <i class="fa-regular fa-paper-plane"></i>
                                        </button>
                                    </div>
                                    <div class="toolbar-right">
                                        <button type="button" class="toolbar-btn" title="Lưu bài viết"><i class="fa-regular fa-bookmark"></i></button>
                                    </div>
                                </div>

                                <!-- Phần thích & Nội dung caption & Bình luận -->
                                <div class="post-captions-block">
                                    <div class="likes-text" id="likesText-${post.postId}">
                                        <span id="likeCount-${post.postId}">${likeCounts[post.postId] != null ? likeCounts[post.postId] : 0}</span> lượt thích
                                    </div>
                                    <c:if test="${not empty post.caption}">
                                        <div class="caption-row">
                                            <a href="${pageContext.request.contextPath}/profile/user/${post.user.userId}" class="caption-user">${post.user.username}</a>
                                            <span class="caption-content"><c:out value="${post.caption}" /></span>
                                        </div>
                                    </c:if>

                                    <!-- Xem tất cả bình luận -->
                                    <div class="view-comments-btn" id="viewCommentsBtn-${post.postId}" onclick="openCommentsModal(${post.postId})">
                                        <c:choose>
                                            <c:when test="${commentCounts[post.postId] > 0}">
                                                Xem tất cả <span id="commentCount-${post.postId}">${commentCounts[post.postId]}</span> bình luận
                                            </c:when>
                                            <c:otherwise>
                                                <span id="commentCountText-${post.postId}">Chưa có bình luận nào. Hãy là người đầu tiên!</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Preview bình luận mới nhất ngay dưới bài viết -->
                                    <div class="post-comments-preview" id="commentsPreview-${post.postId}">
                                        <c:forEach items="${postComments[post.postId]}" var="cmt" varStatus="st">
                                            <c:if test="${st.index < 2}">
                                                <div class="comment-preview-row" id="commentItem-${cmt.commentId}">
                                                    <a href="${pageContext.request.contextPath}/profile/user/${cmt.user.userId}" class="caption-user">${cmt.user.username}</a>
                                                    <span class="caption-content"><c:out value="${cmt.content}" /></span>
                                                    <c:if test="${cmt.user.userId == currentUser.userId || post.user.userId == currentUser.userId}">
                                                        <button type="button" class="btn-delete-comment-sm" onclick="handleDeleteComment(${cmt.commentId}, ${post.postId})" title="Xóa bình luận">&times;</button>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                    <div class="post-timestamp"><fmt:formatDate value="${post.createdAt}" pattern="dd 'THÁNG' MM, yyyy" /></div>
                                </div>

                                <!-- Hộp bình luận -->
                                <form class="post-comment-input-row" onsubmit="handlePostComment(event, ${post.postId})">
                                    <i class="fa-regular fa-face-smile smile-btn" onclick="insertQuickEmoji(${post.postId}, '❤️')" title="Thêm emoji"></i>
                                    <input type="text" id="commentInput-${post.postId}" placeholder="Thêm bình luận..." class="ig-comment-field" autocomplete="off" required />
                                    <button type="submit" class="btn-post-send" id="btnSendComment-${post.postId}">Đăng</button>
                                </form>
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
                            &copy; 2026 QNU_CONFESSTION
                        </div>
                    </footer>
                </aside>
            </div>
        </div>
    </div>

    <!-- Nút Nổi "Messages" Góc Dưới Phải Chuẩn Ảnh Người Dùng -->
    <div class="floating-messages-pill" onclick="window.location.href='${pageContext.request.contextPath}/direct'">
        <i class="fa-regular fa-paper-plane"></i>
        <span>Messages</span>
        <div class="floating-avatars">
            <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=60" alt="m1" class="f-av">
            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60" alt="m2" class="f-av">
        </div>
    </div>

    <!-- Modal Xem & Quản lý tất cả bình luận chuẩn Instagram -->
    <div id="commentsModal" class="ig-modal-overlay">
        <div class="comments-modal-dialog">
            <div class="comments-modal-header">
                <span class="comments-modal-title">Bình luận</span>
                <button type="button" class="modal-close" onclick="closeCommentsModal()">&times;</button>
            </div>
            <div class="comments-modal-body" id="modalCommentsList">
                <!-- Danh sách bình luận load động qua AJAX -->
            </div>
            <div class="comments-modal-footer">
                <form id="modalCommentForm" onsubmit="handleModalSubmitComment(event)" class="post-comment-input-row">
                    <input type="hidden" id="modalPostId" value="">
                    <i class="fa-regular fa-face-smile smile-btn" onclick="insertModalEmoji('❤️')"></i>
                    <input type="text" id="modalCommentInput" placeholder="Thêm bình luận..." class="ig-comment-field" autocomplete="off" required>
                    <button type="submit" class="btn-post-send">Đăng</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Bài Viết Mới Chuẩn Instagram Hiện Đại -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        // 1. Thích / Bỏ thích bài viết qua AJAX
        function handleToggleLike(postId, btn) {
            fetch(contextPath + '/api/posts/' + postId + '/like', { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        if (data.liked) {
                            btn.classList.add('liked');
                        } else {
                            btn.classList.remove('liked');
                        }
                        const countSpan = document.getElementById('likeCount-' + postId);
                        if (countSpan) countSpan.textContent = data.likeCount;
                    }
                })
                .catch(err => console.error('Error toggling like:', err));
        }

        // 2. Nhấp đúp vào ảnh để thả tim (Double-click like animation)
        function handleImageDblClick(postId) {
            const popHeart = document.getElementById('heartPop-' + postId);
            if (popHeart) {
                popHeart.classList.add('pop');
                setTimeout(() => popHeart.classList.remove('pop'), 800);
            }
            const likeBtn = document.getElementById('likeBtn-' + postId);
            if (likeBtn && !likeBtn.classList.contains('liked')) {
                handleToggleLike(postId, likeBtn);
            }
        }

        // 3. Focus vào ô bình luận
        function focusCommentInput(postId) {
            const input = document.getElementById('commentInput-' + postId);
            if (input) {
                input.focus();
            }
        }

        // 4. Thêm bình luận dưới bài viết trên Feed
        function handlePostComment(e, postId) {
            e.preventDefault();
            const input = document.getElementById('commentInput-' + postId);
            if (!input) return;
            const content = input.value.trim();
            if (!content) return;

            const formData = new URLSearchParams();
            formData.append('content', content);

            fetch(contextPath + '/api/posts/' + postId + '/comment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    input.value = '';
                    updateCommentCountUI(postId, data.commentCount);

                    const previewContainer = document.getElementById('commentsPreview-' + postId);
                    if (previewContainer) {
                        const row = document.createElement('div');
                        row.className = 'comment-preview-row';
                        row.id = 'commentItem-' + data.comment.commentId;
                        row.innerHTML = '<a href="' + contextPath + '/profile/user/' + data.comment.userId + '" class="caption-user">' + escapeHtml(data.comment.username) + '</a> ' +
                                        '<span class="caption-content">' + escapeHtml(data.comment.content) + '</span> ' +
                                        '<button type="button" class="btn-delete-comment-sm" onclick="handleDeleteComment(' + data.comment.commentId + ', ' + postId + ')" title="Xóa bình luận">&times;</button>';
                        previewContainer.appendChild(row);
                    }
                } else {
                    alert(data.message || 'Lỗi khi gửi bình luận');
                }
            })
            .catch(err => console.error('Error adding comment:', err));
        }

        // 5. Xóa bình luận
        function handleDeleteComment(commentId, postId) {
            if (!confirm('Bạn có chắc chắn muốn xóa bình luận này?')) return;

            const formData = new URLSearchParams();
            if (postId) formData.append('postId', postId);

            fetch(contextPath + '/api/comments/' + commentId + '/delete', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    const item = document.getElementById('commentItem-' + commentId);
                    if (item) item.remove();
                    const modalItem = document.getElementById('modalCommentItem-' + commentId);
                    if (modalItem) modalItem.remove();

                    if (postId && data.commentCount !== undefined) {
                        updateCommentCountUI(postId, data.commentCount);
                    }
                }
            })
            .catch(err => console.error('Error deleting comment:', err));
        }

        function updateCommentCountUI(postId, count) {
            const btn = document.getElementById('viewCommentsBtn-' + postId);
            if (btn) {
                if (count > 0) {
                    btn.innerHTML = 'Xem tất cả <span id="commentCount-' + postId + '">' + count + '</span> bình luận';
                } else {
                    btn.innerHTML = '<span id="commentCountText-' + postId + '">Chưa có bình luận nào. Hãy là người đầu tiên!</span>';
                }
            }
        }

        // 6. Modal xem tất cả bình luận
        function openCommentsModal(postId) {
            const modal = document.getElementById('commentsModal');
            const list = document.getElementById('modalCommentsList');
            const inputHidden = document.getElementById('modalPostId');
            if (!modal || !list) return;

            inputHidden.value = postId;
            list.innerHTML = '<div style="text-align: center; color: var(--text-secondary); padding: 30px;">Đang tải bình luận...</div>';
            modal.classList.add('show');

            fetch(contextPath + '/api/posts/' + postId + '/comments')
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        if (data.comments.length === 0) {
                            list.innerHTML = '<div style="text-align: center; color: var(--text-secondary); padding: 40px;">Chưa có bình luận nào. Hãy là người đầu tiên để lại bình luận!</div>';
                        } else {
                            list.innerHTML = '';
                            data.comments.forEach(c => {
                                const div = document.createElement('div');
                                div.className = 'modal-comment-item';
                                div.id = 'modalCommentItem-' + c.commentId;
                                div.innerHTML = 
                                    '<img src="' + escapeHtml(c.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150') + '" class="modal-comment-avatar" alt="Avatar">' +
                                    '<div class="modal-comment-content">' +
                                        '<div><strong>' + escapeHtml(c.username) + '</strong> <span style="color: #e5e5e5; margin-left: 6px;">' + escapeHtml(c.content) + '</span></div>' +
                                        '<div class="modal-comment-meta">' +
                                            '<span>' + escapeHtml(c.createdAt) + '</span>' +
                                            (c.canDelete ? '<span class="modal-delete-btn" onclick="handleDeleteComment(' + c.commentId + ', ' + postId + ')">Xóa</span>' : '') +
                                        '</div>' +
                                    '</div>';
                                list.appendChild(div);
                            });
                        }
                    }
                })
                .catch(err => {
                    list.innerHTML = '<div style="text-align: center; color: red;">Không thể tải bình luận.</div>';
                });
        }

        function closeCommentsModal() {
            const modal = document.getElementById('commentsModal');
            if (modal) modal.classList.remove('show');
        }

        function handleModalSubmitComment(e) {
            e.preventDefault();
            const inputHidden = document.getElementById('modalPostId');
            const input = document.getElementById('modalCommentInput');
            if (!inputHidden || !input) return;

            const postId = inputHidden.value;
            const content = input.value.trim();
            if (!postId || !content) return;

            const formData = new URLSearchParams();
            formData.append('content', content);

            fetch(contextPath + '/api/posts/' + postId + '/comment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    input.value = '';
                    openCommentsModal(postId);
                    updateCommentCountUI(postId, data.commentCount);
                }
            });
        }

        function insertQuickEmoji(postId, emoji) {
            const input = document.getElementById('commentInput-' + postId);
            if (input) {
                input.value += emoji;
                input.focus();
            }
        }

        function insertModalEmoji(emoji) {
            const input = document.getElementById('modalCommentInput');
            if (input) {
                input.value += emoji;
                input.focus();
            }
        }

        function escapeHtml(text) {
            const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
            return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        // Toggle Follow bạn bè
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