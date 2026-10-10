<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- ==========================================================================
     Instagram Post Detail & Comments Modal (Chuẩn Instagram 2 cột)
     - Cột trái: Ảnh / Video bài viết toàn màn hình chuẩn tỷ lệ
     - Cột phải: Header tác giả, Danh sách tất cả bình luận có thể cuộn, Action bar & Form gửi cmt
     ========================================================================== -->
        <div id="postDetailModal" class="ig-detail-backdrop" onclick="handleDetailBackdropClick(event)">
            <button type="button" class="detail-modal-close-btn" onclick="closePostDetailModal()"
                title="Đóng">&times;</button>

            <div class="ig-detail-dialog" onclick="event.stopPropagation()">
                <!-- CỘT TRÁI: KHUNG MEDIA (Ảnh hoặc Video) -->
                <div class="detail-media-container" id="detailMediaContainer">
                    <div class="detail-media-spinner" id="detailMediaSpinner">
                        <i class="fa-solid fa-spinner fa-spin"></i>
                    </div>
                    <img id="detailPostImage" src="" alt="Post image" class="detail-media-el" style="display: none;" />
                    <video id="detailPostVideo" src="" controls playsinline loop class="detail-media-el"
                        style="display: none;"></video>

                    <!-- Double click Heart Pop inside Modal -->
                    <div class="detail-heart-pop" id="detailHeartPop">
                        <i class="fa-solid fa-heart"></i>
                    </div>
                </div>

                <!-- CỘT PHẢI: THÔNG TIN BÀI VIẾT & BÌNH LUẬN -->
                <div class="detail-info-container">
                    <!-- 1. Header tác giả -->
                    <div class="detail-header-bar">
                        <div class="detail-author-info">
                            <a id="detailAuthorLink" href="#" class="detail-avatar-ring">
                                <img id="detailAuthorAvatar" src="" alt="Avatar" class="detail-avatar-img" />
                            </a>
                            <div class="detail-author-meta">
                                <div class="detail-username-row">
                                    <a id="detailAuthorUsername" href="#" class="detail-username-text"></a>
                                    <span class="detail-dot-separator">•</span>
                                    <button type="button" id="detailFollowBtn" class="detail-follow-btn"
                                        onclick="handleDetailToggleFollow()">Theo dõi</button>
                                </div>
                            </div>
                        </div>
                        <div class="detail-header-actions">
                            <button type="button" class="detail-more-btn" onclick="openDetailOptionsModal()"
                                title="Tùy chọn">
                                <i class="fa-solid fa-ellipsis"></i>
                            </button>
                        </div>
                    </div>

                    <!-- 2. Danh sách Caption & Tất cả bình luận (Cuộn độc lập) -->
                    <div class="detail-comments-stream" id="detailCommentsStream">
                        <!-- Caption của bài viết (Hiển thị đầu tiên như bình luận của tác giả) -->
                        <div class="detail-stream-item detail-caption-item" id="detailCaptionRow">
                            <a id="detailCaptionAvatarLink" href="#" class="detail-stream-avatar-link">
                                <img id="detailCaptionAvatar" src="" alt="Avatar" class="detail-stream-avatar" />
                            </a>
                            <div class="detail-stream-content">
                                <div>
                                    <a id="detailCaptionUsername" href="#" class="detail-stream-user"></a>
                                    <span id="detailCaptionText" class="detail-stream-text"></span>
                                </div>
                                <div class="detail-stream-time" id="detailCaptionTime"></div>
                            </div>
                        </div>

                        <!-- Danh sách bình luận động -->
                        <div id="detailCommentsList" class="detail-comments-list">
                            <!-- Sẽ render qua JavaScript -->
                        </div>
                    </div>

                    <!-- 3. Khu vực tương tác (Thích, Bình luận, Chia sẻ, Lưu) -->
                    <div class="detail-footer-panel">
                        <div class="detail-action-icons">
                            <div class="detail-icons-left">
                                <button type="button" class="detail-icon-btn" id="detailLikeBtn"
                                    onclick="handleDetailToggleLike()" title="Thích">
                                    <i class="fa-regular fa-heart icon-outline"></i>
                                    <i class="fa-solid fa-heart icon-filled"></i>
                                </button>
                                <button type="button" class="detail-icon-btn" onclick="focusDetailCommentInput()"
                                    title="Bình luận">
                                    <i class="fa-regular fa-comment"></i>
                                </button>
                                <button type="button" class="detail-icon-btn" onclick="handleDetailDirectMessage()"
                                    title="Nhắn tin">
                                    <i class="fa-regular fa-paper-plane"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Số lượt thích -->
                        <div class="detail-likes-count" id="detailLikesCountRow">
                            <span id="detailLikesNumber">0</span> lượt thích
                        </div>

                        <!-- Thời gian đăng bài -->
                        <div class="detail-post-timestamp" id="detailPostDate">
                            9 THÁNG 10, 2026
                        </div>

                        <!-- Form nhập bình luận chuẩn Instagram -->
                        <form class="detail-comment-form" onsubmit="handleDetailSubmitComment(event)">
                            <i class="fa-regular fa-face-smile detail-emoji-btn" onclick="insertDetailQuickEmoji('❤️')"
                                title="Thêm emoji"></i>
                            <input type="text" id="detailCommentInputField" placeholder="Thêm bình luận..."
                                class="detail-comment-input" autocomplete="off"
                                oninput="handleDetailInputChanged(this)" />
                            <button type="submit" id="detailPostSubmitBtn" class="detail-post-btn" disabled
                                title="Gửi bình luận">
                                <i class="fa-solid fa-arrow-up"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 3 chấm Tùy chọn bài viết trong Post Detail -->
        <div id="detailOptionsMenu" class="ig-detail-submodal" onclick="closeDetailOptionsModal()">
            <div class="detail-submodal-dialog" onclick="event.stopPropagation()">
                <button type="button" id="detailOptionDeletePost" class="detail-submodal-item text-danger"
                    style="display: none;" onclick="handleDetailDeletePost()">
                    <i class="fa-solid fa-trash-can" style="margin-right: 8px;"></i> Xóa bài viết
                </button>
                <button type="button" class="detail-submodal-item" onclick="handleDetailDirectMessage()">
                    <i class="fa-regular fa-paper-plane" style="margin-right: 8px;"></i> Nhắn tin cho tác giả
                </button>
                <button type="button" class="detail-submodal-item" onclick="closeDetailOptionsModal()">
                    Hủy
                </button>
            </div>
        </div>

        <script>
            // Trạng thái hiện tại của Modal chi tiết bài viết
            let currentDetailPost = null;

            /**
             * Mở Modal xem chi tiết bài viết (Instagram Style)
             * @param {number|string} postId
             */
            function openPostDetailModal(postId) {
                if (!postId) return;
                const modal = document.getElementById('postDetailModal');
                const spinner = document.getElementById('detailMediaSpinner');
                const img = document.getElementById('detailPostImage');
                const video = document.getElementById('detailPostVideo');
                const commentsList = document.getElementById('detailCommentsList');

                if (!modal) return;

                // Reset UI ban đầu
                modal.classList.add('show');
                document.body.style.overflow = 'hidden'; // Khóa cuộn trang nền
                if (spinner) spinner.style.display = 'flex';
                if (img) img.style.display = 'none';
                if (video) { video.style.display = 'none'; video.pause(); }
                if (commentsList) {
                    commentsList.innerHTML = '<div class="detail-loading-comments"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải bình luận...</div>';
                }

                const context = '${pageContext.request.contextPath}';

                fetch(context + '/api/posts/' + postId)
                    .then(res => res.json())
                    .then(data => {
                        if (!data.success || !data.post) {
                            alert(data.message || 'Không thể tải bài viết');
                            closePostDetailModal();
                            return;
                        }

                        currentDetailPost = data.post;
                        currentDetailPost.comments = data.comments || [];
                        renderPostDetailModal(currentDetailPost);
                    })
                    .catch(err => {
                        console.error('Error fetching post detail:', err);
                        alert('Đã xảy ra lỗi khi tải bài viết.');
                        closePostDetailModal();
                    });
            }

            /**
             * Render toàn bộ dữ liệu vào Modal
             */
            function renderPostDetailModal(post) {
                const context = '${pageContext.request.contextPath}';
                const spinner = document.getElementById('detailMediaSpinner');
                const img = document.getElementById('detailPostImage');
                const video = document.getElementById('detailPostVideo');

                if (spinner) spinner.style.display = 'none';

                // 1. Media
                let mediaSrc = post.imageUrl;
                if (!mediaSrc.startsWith('http') && !mediaSrc.startsWith('data:')) {
                    mediaSrc = context + mediaSrc;
                }

                if (post.isVideo) {
                    if (img) img.style.display = 'none';
                    if (video) {
                        video.src = mediaSrc;
                        video.style.display = 'block';
                    }
                } else {
                    if (video) {
                        video.style.display = 'none';
                        video.pause();
                    }
                    if (img) {
                        img.src = mediaSrc;
                        img.style.display = 'block';
                    }
                }

                // 2. Author info
                const authorLink = context + '/profile/user/' + post.user.userId;
                const authorAvatar = post.user.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150';

                document.getElementById('detailAuthorLink').href = authorLink;
                document.getElementById('detailAuthorAvatar').src = authorAvatar;
                document.getElementById('detailAuthorUsername').href = authorLink;
                document.getElementById('detailAuthorUsername').textContent = post.user.username;

                // Nút Follow
                const followBtn = document.getElementById('detailFollowBtn');
                if (followBtn) {
                    if (post.isMe) {
                        followBtn.style.display = 'none';
                        const sep = followBtn.previousElementSibling;
                        if (sep) sep.style.display = 'none';
                    } else {
                        followBtn.style.display = 'inline-block';
                        const sep = followBtn.previousElementSibling;
                        if (sep) sep.style.display = 'inline';
                        if (post.isFollowing) {
                            followBtn.textContent = 'Đang theo dõi';
                            followBtn.classList.add('following');
                        } else {
                            followBtn.textContent = 'Theo dõi';
                            followBtn.classList.remove('following');
                        }
                    }
                }

                // 3. Caption block
                const captionRow = document.getElementById('detailCaptionRow');
                if (post.caption && post.caption.trim() !== '') {
                    captionRow.style.display = 'flex';
                    document.getElementById('detailCaptionAvatarLink').href = authorLink;
                    document.getElementById('detailCaptionAvatar').src = authorAvatar;
                    document.getElementById('detailCaptionUsername').href = authorLink;
                    document.getElementById('detailCaptionUsername').textContent = post.user.username;
                    document.getElementById('detailCaptionText').textContent = post.caption;
                    document.getElementById('detailCaptionTime').textContent = post.timeAgo || '';
                } else {
                    captionRow.style.display = 'none';
                }

                // 4. Render Comments
                renderDetailCommentsList(post.comments, post.postId);

                // 5. Actions bar (Like, Date, Likes count)
                const likeBtn = document.getElementById('detailLikeBtn');
                if (likeBtn) {
                    if (post.liked) {
                        likeBtn.classList.add('liked');
                    } else {
                        likeBtn.classList.remove('liked');
                    }
                }

                document.getElementById('detailLikesNumber').textContent = post.likeCount || 0;
                document.getElementById('detailPostDate').textContent = post.createdAtFormatted || '';

                // Nút xóa bài viết trong menu 3 chấm
                const deleteOptBtn = document.getElementById('detailOptionDeletePost');
                if (deleteOptBtn) {
                    deleteOptBtn.style.display = post.canDelete ? 'block' : 'none';
                }
            }

            /**
             * Render danh sách bình luận
             */
            function renderDetailCommentsList(comments, postId) {
                const list = document.getElementById('detailCommentsList');
                const context = '${pageContext.request.contextPath}';
                if (!list) return;

                if (!comments || comments.length === 0) {
                    list.innerHTML = '<div class="detail-empty-comments">Chưa có bình luận nào.<br><span style="font-size:12px; color:var(--text-secondary); margin-top:4px; display:inline-block;">Hãy là người đầu tiên để lại bình luận!</span></div>';
                    return;
                }

                list.innerHTML = '';
                comments.forEach(c => {
                    const row = document.createElement('div');
                    row.className = 'detail-stream-item';
                    row.id = 'detailCommentItem-' + c.commentId;

                    const userLink = context + '/profile/user/' + c.userId;
                    const avatarSrc = c.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150';

                    row.innerHTML =
                        '<a href="' + userLink + '" class="detail-stream-avatar-link">' +
                        '<img src="' + escapeDetailHtml(avatarSrc) + '" class="detail-stream-avatar" alt="Avatar">' +
                        '</a>' +
                        '<div class="detail-stream-content">' +
                        '<div>' +
                        '<a href="' + userLink + '" class="detail-stream-user">' + escapeDetailHtml(c.username) + '</a>' +
                        '<span class="detail-stream-text">' + escapeDetailHtml(c.content) + '</span>' +
                        '</div>' +
                        '<div class="detail-stream-meta-row">' +
                        '<span class="detail-meta-time">' + escapeDetailHtml(c.timeAgo || '') + '</span>' +
                        '<button type="button" class="detail-meta-action" onclick="replyDetailComment(\'' + escapeDetailHtml(c.username) + '\')">Trả lời</button>' +
                        (c.canDelete ? '<button type="button" class="detail-meta-action delete-act" onclick="handleDetailDeleteComment(' + c.commentId + ', ' + postId + ')" title="Xóa bình luận"><i class="fa-regular fa-trash-can"></i></button>' : '') +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-comment-heart" onclick="toggleCommentHeart(this)">' +
                        '<i class="fa-regular fa-heart"></i>' +
                        '</div>';

                    list.appendChild(row);
                });
            }

            /**
             * Đóng Modal chi tiết
             */
            function closePostDetailModal() {
                const modal = document.getElementById('postDetailModal');
                if (modal) modal.classList.remove('show');
                document.body.style.overflow = ''; // Mở lại cuộn trang
                const video = document.getElementById('detailPostVideo');
                if (video) video.pause();
                currentDetailPost = null;
            }

            function handleDetailBackdropClick(e) {
                if (e.target.id === 'postDetailModal') {
                    closePostDetailModal();
                }
            }

            // Đóng khi nhấn phím Escape
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    const subModal = document.getElementById('detailOptionsMenu');
                    if (subModal && subModal.classList.contains('show')) {
                        closeDetailOptionsModal();
                        return;
                    }
                    closePostDetailModal();
                }
            });

            /**
             * Toggle Like trong Modal
             */
            function handleDetailToggleLike() {
                if (!currentDetailPost) return;
                const postId = currentDetailPost.postId;
                const btn = document.getElementById('detailLikeBtn');
                const countSpan = document.getElementById('detailLikesNumber');
                const context = '${pageContext.request.contextPath}';

                fetch(context + '/api/posts/' + postId + '/like', { method: 'POST' })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            currentDetailPost.liked = data.liked;
                            currentDetailPost.likeCount = data.likeCount;

                            if (data.liked) {
                                btn.classList.add('liked');
                            } else {
                                btn.classList.remove('liked');
                            }
                            if (countSpan) countSpan.textContent = data.likeCount;

                            // Đồng bộ với thẻ trên bảng tin Home (nếu có)
                            const homeLikeBtn = document.getElementById('likeBtn-' + postId);
                            const homeLikeCount = document.getElementById('likeCount-' + postId);
                            if (homeLikeBtn) {
                                if (data.liked) homeLikeBtn.classList.add('liked');
                                else homeLikeBtn.classList.remove('liked');
                            }
                            if (homeLikeCount) homeLikeCount.textContent = data.likeCount;
                        }
                    })
                    .catch(err => console.error('Error toggling like:', err));
            }

            /**
             * Input bình luận thay đổi trạng thái
             */
            function handleDetailInputChanged(input) {
                const btn = document.getElementById('detailPostSubmitBtn');
                if (btn) {
                    btn.disabled = input.value.trim().length === 0;
                }
            }

            /**
             * Gửi bình luận trong Modal
             */
            function handleDetailSubmitComment(e) {
                e.preventDefault();
                if (!currentDetailPost) return;
                const postId = currentDetailPost.postId;
                const input = document.getElementById('detailCommentInputField');
                const content = input.value.trim();
                if (!content) return;

                const context = '${pageContext.request.contextPath}';
                const formData = new URLSearchParams();
                formData.append('content', content);

                const submitBtn = document.getElementById('detailPostSubmitBtn');
                if (submitBtn) submitBtn.disabled = true;

                fetch(context + '/api/posts/' + postId + '/comment', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                    body: formData.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            input.value = '';
                            if (submitBtn) submitBtn.disabled = true;

                            // Thêm comment mới vào danh sách hiện tại
                            if (!currentDetailPost.comments) currentDetailPost.comments = [];
                            currentDetailPost.comments.push(data.comment);
                            currentDetailPost.commentCount = data.commentCount;

                            renderDetailCommentsList(currentDetailPost.comments, postId);

                            // Cuộn xuống cuối danh sách bình luận
                            const stream = document.getElementById('detailCommentsStream');
                            if (stream) stream.scrollTop = stream.scrollHeight;

                            // Đồng bộ số lượng & FIX BUG feed: CHỈ hiển thị đúng 1 comment gần nhất trên bảng tin!
                            syncFeedCommentUI(postId, data.comment, data.commentCount);
                        } else {
                            alert(data.message || 'Lỗi khi gửi bình luận');
                        }
                    })
                    .catch(err => console.error('Error adding comment:', err));
            }

            /**
             * Xóa bình luận trong Modal
             */
            function handleDetailDeleteComment(commentId, postId) {
                if (!confirm('Bạn có chắc chắn muốn xóa bình luận này?')) return;
                const context = '${pageContext.request.contextPath}';

                const formData = new URLSearchParams();
                if (postId) formData.append('postId', postId);

                fetch(context + '/api/comments/' + commentId + '/delete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                    body: formData.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            // Xóa khỏi modal
                            const row = document.getElementById('detailCommentItem-' + commentId);
                            if (row) row.remove();

                            if (currentDetailPost && currentDetailPost.comments) {
                                currentDetailPost.comments = currentDetailPost.comments.filter(c => c.commentId !== commentId);
                                currentDetailPost.commentCount = data.commentCount;
                                if (currentDetailPost.comments.length === 0) {
                                    renderDetailCommentsList([], postId);
                                }
                            }

                            // Đồng bộ bảng tin
                            syncFeedAfterDeleteComment(postId, commentId, data.commentCount);
                        }
                    })
                    .catch(err => console.error('Error deleting comment:', err));
            }

            /**
             * Đồng bộ bảng tin Home sau khi thêm bình luận (CHỈ HIỂN THỊ 1 CMT GẦN NHẤT)
             */
            function syncFeedCommentUI(postId, comment, totalCount) {
                const context = '${pageContext.request.contextPath}';

                // 1. Cập nhật nút "Xem tất cả ... bình luận"
                const countSpan = document.getElementById('commentCount-' + postId);
                const countBtn = document.getElementById('viewCommentsBtn-' + postId);
                if (countSpan) countSpan.textContent = totalCount;
                if (countBtn && totalCount > 0) {
                    countBtn.innerHTML = 'Xem tất cả <span id="commentCount-' + postId + '">' + totalCount + '</span> bình luận';
                }

                // 2. FIX BUG: Thay vì appendChild làm bài viết dài theo, CHỈ hiển thị đúng 1 cmt gần nhất!
                const previewContainer = document.getElementById('commentsPreview-' + postId);
                if (previewContainer) {
                    previewContainer.innerHTML = ''; // Xóa hết cmt cũ trong preview
                    const row = document.createElement('div');
                    row.className = 'comment-preview-row';
                    row.id = 'commentItem-' + comment.commentId;
                    row.innerHTML =
                        '<a href="' + context + '/profile/user/' + comment.userId + '" class="caption-user">' + escapeDetailHtml(comment.username) + '</a> ' +
                        '<span class="caption-content">' + escapeDetailHtml(comment.content) + '</span> ' +
                        '<button type="button" class="btn-delete-comment-sm" onclick="handleDeleteComment(' + comment.commentId + ', ' + postId + ')" title="Xóa bình luận"><i class="fa-regular fa-trash-can"></i></button>';
                    previewContainer.appendChild(row);
                }
            }

            /**
             * Đồng bộ bảng tin sau khi xóa bình luận
             */
            function syncFeedAfterDeleteComment(postId, commentId, totalCount) {
                // Xóa phần tử preview nếu nó là phần tử bị xóa
                const feedItem = document.getElementById('commentItem-' + commentId);
                if (feedItem) feedItem.remove();

                const countSpan = document.getElementById('commentCount-' + postId);
                const countBtn = document.getElementById('viewCommentsBtn-' + postId);
                if (countSpan) countSpan.textContent = totalCount;
                if (countBtn) {
                    if (totalCount > 0) {
                        countBtn.innerHTML = 'Xem tất cả <span id="commentCount-' + postId + '">' + totalCount + '</span> bình luận';
                    } else {
                        countBtn.innerHTML = '<span id="commentCountText-' + postId + '">Chưa có bình luận nào. Hãy là người đầu tiên!</span>';
                        const previewContainer = document.getElementById('commentsPreview-' + postId);
                        if (previewContainer) previewContainer.innerHTML = '';
                    }
                }
            }

            /**
             * Focus vào ô nhập bình luận
             */
            function focusDetailCommentInput() {
                const input = document.getElementById('detailCommentInputField');
                if (input) input.focus();
            }

            /**
             * Trả lời bình luận
             */
            function replyDetailComment(username) {
                const input = document.getElementById('detailCommentInputField');
                if (input) {
                    input.value = '@' + username + ' ';
                    input.focus();
                    handleDetailInputChanged(input);
                }
            }

            /**
             * Chèn emoji nhanh
             */
            function insertDetailQuickEmoji(emoji) {
                const input = document.getElementById('detailCommentInputField');
                if (input) {
                    input.value += emoji;
                    input.focus();
                    handleDetailInputChanged(input);
                }
            }

            /**
             * Thích comment
             */
            function toggleCommentHeart(heartEl) {
                const icon = heartEl.querySelector('i');
                if (icon) {
                    if (icon.classList.contains('fa-regular')) {
                        icon.className = 'fa-solid fa-heart liked-heart';
                    } else {
                        icon.className = 'fa-regular fa-heart';
                    }
                }
            }


            /**
             * Nhắn tin trực tiếp với tác giả bài viết
             */
            function handleDetailDirectMessage() {
                if (!currentDetailPost || !currentDetailPost.user) return;
                window.location.href = '${pageContext.request.contextPath}/direct?userId=' + currentDetailPost.user.userId;
            }

            /**
             * Menu 3 chấm của Post Detail
             */
            function openDetailOptionsModal() {
                const modal = document.getElementById('detailOptionsMenu');
                if (modal) modal.classList.add('show');
            }

            function closeDetailOptionsModal() {
                const modal = document.getElementById('detailOptionsMenu');
                if (modal) modal.classList.remove('show');
            }

            function handleDetailDeletePost() {
                if (!currentDetailPost) return;
                if (!confirm('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.')) return;

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/posts/delete/' + currentDetailPost.postId;
                const redirectInput = document.createElement('input');
                redirectInput.type = 'hidden';
                redirectInput.name = 'redirect';
                redirectInput.value = window.location.pathname.includes('/profile') ? '/profile' : '/';
                form.appendChild(redirectInput);
                document.body.appendChild(form);
                form.submit();
            }

            /**
             * Follow tác giả từ modal
             */
            function handleDetailToggleFollow() {
                if (!currentDetailPost) return;
                const targetUserId = currentDetailPost.user.userId;
                const btn = document.getElementById('detailFollowBtn');
                const context = '${pageContext.request.contextPath}';

                btn.disabled = true;
                fetch(context + '/api/follow/' + targetUserId, { method: 'POST' })
                    .then(res => res.json())
                    .then(data => {
                        btn.disabled = false;
                        if (data.success) {
                            currentDetailPost.isFollowing = data.isFollowing;
                            if (data.isFollowing) {
                                btn.textContent = 'Đang theo dõi';
                                btn.classList.add('following');
                            } else {
                                btn.textContent = 'Theo dõi';
                                btn.classList.remove('following');
                            }
                        }
                    })
                    .catch(() => { btn.disabled = false; });
            }

            function escapeDetailHtml(text) {
                if (!text) return '';
                const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
                return String(text).replace(/[&<>"']/g, function (m) { return map[m]; });
            }
        </script>