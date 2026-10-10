<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" scope="session" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hộp thư đến • Trò chuyện trực tiếp | QNU_Confesstion</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Grand+Hotel&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css?v=20261010_light_v1">
    <style>
        /* CSS chống chớp giật khi chuyển tab tin nhắn (Zero-Flicker Transition) */
        .chat-messages-area {
            transition: opacity 0.12s cubic-bezier(0.2, 0, 0, 1) !important;
        }
        .chat-messages-area.switching {
            opacity: 0.75 !important;
        }
        .inbox-partner-item, .inbox-story-bubble {
            cursor: pointer !important;
            user-select: none !important;
            outline: none !important;
            -webkit-tap-highlight-color: transparent !important;
        }
    </style>
</head>
<body class="ig-dark-body">
    <div class="direct-view-wrapper">
        <!-- Sidebar Navigation Trái (Header chuẩn Instagram) -->
        <jsp:include page="/WEB-INF/views/commons/header.jsp" />

        <!-- Khu vực Trò chuyện Direct (2 Cột) -->
        <div class="direct-page-container">
            <!-- CỘT TRÁI: Danh sách bạn bè & hội thoại (Chuẩn giao diện ảnh 2) -->
            <aside class="direct-inbox-col">
                <!-- Header: Username + Mũi tên dropdown + Icon soạn tin nhắn mới -->
                <div class="inbox-top-header">
                    <div class="inbox-current-username" title="Tài khoản hiện tại">
                        <span>${currentUser.username}</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                    <i class="fa-regular fa-pen-to-square inbox-compose-icon" onclick="openNewMsgModal()" title="Tin nhắn mới"></i>
                </div>

                <!-- Ô tìm kiếm bạn chat (Thon gọn, thanh mảnh, chuẩn Instagram hiện đại) -->
                <div class="inbox-search-wrap">
                    <div class="inbox-search-box">
                        <i class="fa-solid fa-magnifying-glass inbox-search-icon"></i>
                        <input type="text" 
                               id="partnerSearchInput" 
                               class="inbox-search-input" 
                               placeholder="Tìm kiếm cuộc trò chuyện..." 
                               autocomplete="off"
                               oninput="handlePartnerSearch(this.value)">
                        <button type="button" class="inbox-search-clear" id="partnerSearchClear" onclick="clearPartnerSearch()" style="display: none;" title="Xóa">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                </div>

                <!-- Thanh Instagram Stories Carousel (Có nút cuộn trái/phải giống hệt trang Home) -->
                <div class="inbox-stories-carousel">
                    <!-- Nút mũi tên cuộn stories bên trái -->
                    <button type="button" class="inbox-story-arrow prev" id="inboxStoryBtnPrev" onclick="scrollInboxStories(-180)" title="Xem tin trước" style="display: none;">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>

                    <div class="inbox-stories-track" id="inboxStoriesTrack">
                        <!-- Tin của bạn / Tài khoản hiện tại -->
                        <div class="inbox-story-bubble" title="Tin của bạn">
                            <div class="inbox-story-avatar-wrap story-gradient">
                                <img src="${currentUser.avatar}" alt="${currentUser.username}" class="inbox-story-img">
                            </div>
                            <span class="inbox-story-name">Tin của bạn</span>
                        </div>

                        <!-- Danh sách Story của người dùng thật (Có viền gradient giống trang Home) -->
                        <c:set var="stories" value="${not empty storyUsers ? storyUsers : partners}" />
                        <c:forEach items="${stories}" var="su">
                            <c:if test="${su.userId != currentUser.userId}">
                                <a href="javascript:void(0)" 
                                   class="inbox-story-bubble" 
                                   title="Trò chuyện với ${su.fullname} (@${su.username})"
                                   onclick="switchChatPartner(${su.userId}, '${su.username}', '${su.fullname}', '${su.avatar}', event); return false;">
                                    <div class="inbox-story-avatar-wrap story-gradient">
                                        <img src="${su.avatar}" alt="${su.username}" class="inbox-story-img">
                                    </div>
                                    <span class="inbox-story-name">${su.username}</span>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Nút mũi tên cuộn stories bên phải -->
                    <button type="button" class="inbox-story-arrow next" id="inboxStoryBtnNext" onclick="scrollInboxStories(180)" title="Xem thêm tin">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <!-- Tiêu đề mục: Messages & Requests -->
                <div class="inbox-section-title-row">
                    <span class="inbox-section-title">Messages</span>
                    <a href="javascript:void(0)" class="inbox-requests-link" onclick="alert('Không có yêu cầu tin nhắn nào chờ xử lý.')">Requests</a>
                </div>

                <!-- Danh sách đối tác chat -->
                <div class="inbox-partners-list" id="partnersListContainer">
                    <c:choose>
                        <c:when test="${not empty partners}">
                            <c:forEach items="${partners}" var="p" varStatus="st">
                                <a href="javascript:void(0)" 
                                   class="inbox-partner-item ${not empty activeUser and activeUser.userId == p.userId ? 'active' : ''}" 
                                   id="partnerItem_${p.userId}"
                                   data-user-id="${p.userId}"
                                   data-username="${p.username.toLowerCase()}" 
                                   data-fullname="${p.fullname.toLowerCase()}"
                                   data-avatar="${p.avatar}"
                                   onclick="switchChatPartner(${p.userId}, '${p.username}', '${p.fullname}', '${p.avatar}', event); return false;">
                                    <div class="inbox-avatar-wrap ${st.index == 4 ? 'has-story' : ''}">
                                        <img src="${p.avatar}" alt="${p.username}" class="inbox-avatar-img">
                                        <span class="online-indicator"></span>
                                    </div>
                                    <div class="inbox-partner-info">
                                        <div class="inbox-name-row">
                                            <div class="inbox-partner-name-wrap">
                                                <span class="inbox-partner-name">${p.fullname}</span>
                                                <c:if test="${st.index == 3}">
                                                    <i class="fa-solid fa-circle-check inbox-verified-badge" title="Tài khoản đã xác minh"></i>
                                                </c:if>
                                            </div>
                                            <span class="inbox-item-time">
                                                <c:choose>
                                                    <c:when test="${st.index == 0}">35m</c:when>
                                                    <c:when test="${st.index == 1}">14w</c:when>
                                                    <c:when test="${st.index == 2}">2y</c:when>
                                                    <c:when test="${st.index == 3}">2y</c:when>
                                                    <c:when test="${st.index == 4}">2y</c:when>
                                                    <c:otherwise>1d</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="inbox-sub-row">
                                            <span class="inbox-partner-status">
                                                <c:choose>
                                                    <c:when test="${st.index == 0}">Hoạt động 35 phút trước</c:when>
                                                    <c:when test="${st.index == 1}">Đã thả cảm xúc &#x1f633; vào tin nhắn</c:when>
                                                    <c:when test="${st.index == 2}">Đã thích một tin nhắn của bạn</c:when>
                                                    <c:when test="${st.index == 3}">You: Bà gỡ bạn bè với tôi r à</c:when>
                                                    <c:when test="${st.index == 4}">Tui đi du học mò bạn ơi</c:when>
                                                    <c:otherwise>Đang hoạt động</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <c:if test="${st.index == 1 || st.index == 3}">
                                                <span class="unread-dot" title="Tin nhắn chưa đọc"></span>
                                            </c:if>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 30px 20px; text-align: center; color: var(--text-secondary); font-size: 13px;">
                                <i class="fa-regular fa-comments" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                                Chưa có tin nhắn nào.<br>Theo dõi bạn bè hoặc dùng chức năng tìm kiếm để bắt đầu trò chuyện!
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Kết quả tìm kiếm người dùng mới từ hệ thống -->
                    <div id="dynamicSearchResults" style="display: none; padding-top: 10px; border-top: 1px solid #262626; margin-top: 10px;">
                        <div style="padding: 4px 14px 8px 14px; font-size: 11px; font-weight: 700; color: #a8a8a8; text-transform: uppercase; letter-spacing: 0.5px;">
                            Người dùng khác
                        </div>
                        <div id="dynamicSearchResultsList"></div>
                    </div>
                </div>
            </aside>

            <!-- CỘT PHẢI: Khung chat tin nhắn (SPA Instant Switchable) -->
            <main class="direct-conversation-col">
                <!-- Vùng Khung Chat Hoạt Động (Hiển thị khi có activeUser hoặc khi bấm chọn bất kỳ ai) -->
                <div id="activeChatWrapper" style="${empty activeUser ? 'display: none;' : 'display: flex; flex-direction: column; height: 100%;'}">
                    <!-- Topbar của người đang chat chuẩn Instagram (Avatar tròn 44px + Name + Handle + Call/Video/Info) -->
                    <div class="chat-topbar">
                        <div class="chat-partner-brief">
                            <img src="${not empty activeUser ? activeUser.avatar : ''}" alt="" class="chat-topbar-avatar" id="chatTopbarAvatar">
                            <div class="chat-topbar-meta">
                                <span class="chat-topbar-name" id="chatTopbarName">${not empty activeUser ? activeUser.fullname : ''}</span>
                                <span class="chat-topbar-handle" id="chatTopbarHandle">_${not empty activeUser ? activeUser.username : ''}</span>
                            </div>
                        </div>

                        <div class="chat-topbar-actions">
                            <a href="javascript:void(0)" onclick="handleVoiceCall()" title="Bắt đầu gọi thoại">
                                <i class="fa-solid fa-phone"></i>
                            </a>
                            <a href="javascript:void(0)" onclick="handleVideoCall()" title="Bắt đầu gọi video">
                                <i class="fa-solid fa-video"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/profile/user/${not empty activeUser ? activeUser.userId : ''}" id="chatTopbarInfoLink" title="Thông tin chi tiết">
                                <i class="fa-solid fa-circle-info"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Vùng nội dung các tin nhắn (Scrollable) -->
                    <div class="chat-messages-area" id="chatMessagesArea">
                        <!-- Header thông tin đối tác ở đỉnh khung tin nhắn (Avatar tròn chuẩn 96px) -->
                        <div class="chat-header-profile-box">
                            <img src="${not empty activeUser ? activeUser.avatar : ''}" alt="" class="chat-header-avatar-lg" id="chatHeaderAvatarLg">
                            <div class="chat-header-name" id="chatHeaderName">${not empty activeUser ? activeUser.fullname : ''}</div>
                            <div class="chat-header-sub" id="chatHeaderSub">@${not empty activeUser ? activeUser.username : ''} &bull; QNU_Confesstion</div>
                            <a href="${pageContext.request.contextPath}/profile/user/${not empty activeUser ? activeUser.userId : ''}" id="chatHeaderProfileLink" class="btn-view-profile-sm">Xem trang cá nhân</a>
                        </div>

                        <!-- Danh sách tin nhắn động -->
                        <div id="chatMessagesList">
                            <c:forEach items="${conversation}" var="msg" varStatus="st">
                                <c:set var="isSelf" value="${msg.sender.userId == currentUser.userId}" />
                                <c:if test="${st.index == 0 || st.index % 5 == 0}">
                                    <div class="chat-date-divider">
                                        <fmt:formatDate value="${msg.createdAt}" pattern="MMM dd, yyyy, hh:mm a" />
                                    </div>
                                </c:if>
                                <div class="msg-row ${isSelf ? 'self' : 'other'}">
                                    <c:if test="${!isSelf}">
                                        <img src="${msg.sender.avatar}" alt="${msg.sender.username}" class="msg-avatar-sm" title="${msg.sender.fullname}">
                                    </c:if>
                                    <div class="msg-bubble ${isSelf ? 'self' : 'other'}"><c:out value="${fn:trim(msg.content)}" /></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Form ib chuẩn Instagram (The exact Instagram Direct input bar) -->
                    <div class="chat-bottom-input-wrap">
                        <!-- Popover Bảng Emoji nhanh khi bấm vào icon 😊 -->
                        <div id="chatEmojiPicker" class="chat-emoji-popover" style="display: none;">
                            <div class="emoji-popover-grid">
                                <span class="emoji-cell" onclick="selectEmoji('❤️')">❤️</span>
                                <span class="emoji-cell" onclick="selectEmoji('😂')">😂</span>
                                <span class="emoji-cell" onclick="selectEmoji('🔥')">🔥</span>
                                <span class="emoji-cell" onclick="selectEmoji('😍')">😍</span>
                                <span class="emoji-cell" onclick="selectEmoji('🙃')">🙃</span>
                                <span class="emoji-cell" onclick="selectEmoji('👏')">👏</span>
                                <span class="emoji-cell" onclick="selectEmoji('👍')">👍</span>
                                <span class="emoji-cell" onclick="selectEmoji('🎉')">🎉</span>
                                <span class="emoji-cell" onclick="selectEmoji('✨')">✨</span>
                                <span class="emoji-cell" onclick="selectEmoji('🥺')">🥺</span>
                                <span class="emoji-cell" onclick="selectEmoji('🥰')">🥰</span>
                                <span class="emoji-cell" onclick="selectEmoji('💯')">💯</span>
                                <span class="emoji-cell" onclick="selectEmoji('😎')">😎</span>
                                <span class="emoji-cell" onclick="selectEmoji('😮')">😮</span>
                                <span class="emoji-cell" onclick="selectEmoji('😢')">😢</span>
                                <span class="emoji-cell" onclick="selectEmoji('🙏')">🙏</span>
                            </div>
                        </div>

                        <form id="chatForm" onsubmit="handleSendChat(event)" class="chat-input-pill">
                            <!-- Nút Mặt cười 😊 -->
                            <button type="button" class="chat-pill-icon-btn chat-emoji-btn" onclick="toggleEmojiPicker(event)" title="Thêm biểu cảm">
                                <i class="fa-regular fa-face-smile"></i>
                            </button>

                            <!-- Ô nhập tin nhắn: Placeholder 'Message...' chuẩn ảnh -->
                            <input type="text" 
                                   id="chatInput" 
                                   class="chat-pill-text-input" 
                                   placeholder="Message..." 
                                   autocomplete="off" 
                                   oninput="handleChatInputChange(this)">

                            <!-- Cụm nút bên phải: Mặc định hiện Mic, Ảnh, Tim; Khi gõ chữ chuyển sang 'Gửi' -->
                            <div class="chat-pill-actions-right">
                                <div class="chat-default-actions" id="chatDefaultActions">
                                    <button type="button" class="chat-pill-icon-btn" onclick="handleVoiceNote()" title="Ghi âm">
                                        <i class="fa-solid fa-microphone"></i>
                                    </button>
                                    <button type="button" class="chat-pill-icon-btn" onclick="triggerImageUpload()" title="Gửi ảnh">
                                        <i class="fa-regular fa-image"></i>
                                    </button>
                                    <input type="file" id="chatImageInput" accept="image/*" style="display: none;" onchange="handleSendImageFile(this)">
                                    <button type="button" class="chat-pill-icon-btn chat-heart-btn" onclick="sendQuickHeart()" title="Gửi tim">
                                        <i class="fa-regular fa-heart"></i>
                                    </button>
                                </div>
                                <button type="submit" class="btn-chat-send-text" id="btnSend" style="display: none;">Gửi</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Trạng thái chưa chọn đối tác nào để chat -->
                <div class="direct-empty-state" id="directEmptyState" style="${not empty activeUser ? 'display: none;' : ''}">
                    <div class="empty-icon-circle">
                        <i class="fa-regular fa-paper-plane"></i>
                    </div>
                    <h3 class="empty-title">Tin nhắn của bạn</h3>
                    <p class="empty-desc">Gửi ảnh và tin nhắn riêng tư cho bạn bè hoặc người trong trường QNU.</p>
                    <button class="btn-dark-primary-pill" onclick="openNewMsgModal()">Gửi tin nhắn</button>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal Soạn Tin Nhắn Mới (New Message Modal) -->
    <div id="newMsgModal" class="new-msg-modal" onclick="closeNewMsgModal(event)">
        <div class="new-msg-dialog">
            <div class="new-msg-header">
                <h3 class="new-msg-title">Tin nhắn mới</h3>
                <button type="button" class="new-msg-close" onclick="closeNewMsgModal()">&times;</button>
            </div>
            <div class="new-msg-search-row">
                <span class="new-msg-search-label">Tới:</span>
                <input type="text" 
                       id="newMsgSearchInput" 
                       class="new-msg-search-input" 
                       placeholder="Tìm kiếm người dùng..." 
                       autocomplete="off"
                       oninput="handleNewMsgSearch(this.value)">
            </div>
            <div class="new-msg-users-list" id="newMsgUsersList">
                <div class="search-empty-hint">Gõ tên hoặc username để tìm người nhận...</div>
            </div>
        </div>
    </div>

    <!-- Modal Tạo bài viết mới dùng chung -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <!-- Cấu hình an toàn cho JavaScript (Tránh lỗi cú pháp JSP trong thẻ Script của Eclipse) -->
    <div id="chatConfig"
         data-current-user-id="${currentUser.userId}"
         data-active-user-id="${not empty activeUser ? activeUser.userId : ''}"
         data-active-user-avatar="${not empty activeUser ? activeUser.avatar : ''}"
         data-context-path="${pageContext.request.contextPath}"
         style="display:none;"></div>

    <!-- WebSocket & Client Logic Script -->
    <script>
        const chatConfig = document.getElementById('chatConfig');
        const currentUserId = chatConfig && chatConfig.dataset.currentUserId ? parseInt(chatConfig.dataset.currentUserId) : null;
        let activeUserId = chatConfig && chatConfig.dataset.activeUserId ? parseInt(chatConfig.dataset.activeUserId) : null;
        let activeUserAvatar = chatConfig && chatConfig.dataset.activeUserAvatar ? chatConfig.dataset.activeUserAvatar : '';
        const contextPath = chatConfig && chatConfig.dataset.contextPath ? chatConfig.dataset.contextPath : '';

        // Bộ nhớ đệm tin nhắn cục bộ (Instant Cache) giúp chuyển đổi tab tức thì trong 0ms giống Instagram
        const conversationCache = {};
        const renderedMessageIds = new Set();

        let chatSocket = null;
        const messagesArea = document.getElementById('chatMessagesArea');
        const chatInput = document.getElementById('chatInput');
        const wsStatusDot = document.getElementById('wsStatusDot');
        const wsStatusText = document.getElementById('wsStatusText');

        // Cập nhật giao diện header và topbar của cuộc hội thoại
        function updateChatHeaderUI(userId, username, fullname, avatar) {
            const avatarSrc = avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
            const displayName = fullname || username || 'Người dùng';
            const handleName = username ? ('_' + username) : '';

            const tbAvatar = document.getElementById('chatTopbarAvatar');
            const tbName = document.getElementById('chatTopbarName');
            const tbHandle = document.getElementById('chatTopbarHandle');
            const tbLink = document.getElementById('chatTopbarInfoLink');

            const hAvatar = document.getElementById('chatHeaderAvatarLg');
            const hName = document.getElementById('chatHeaderName');
            const hSub = document.getElementById('chatHeaderSub');
            const hLink = document.getElementById('chatHeaderProfileLink');

            if (tbAvatar) tbAvatar.src = avatarSrc;
            if (tbName) tbName.textContent = displayName;
            if (tbHandle) tbHandle.textContent = handleName;
            if (tbLink) tbLink.href = contextPath + '/profile/user/' + userId;

            if (hAvatar) hAvatar.src = avatarSrc;
            if (hName) hName.textContent = displayName;
            if (hSub) hSub.innerHTML = '@' + escapeHtml(username || '') + ' &bull; QNU_Confesstion';
            if (hLink) hLink.href = contextPath + '/profile/user/' + userId;
        }

        // Chuyển đổi tab tin nhắn cực nhanh (Instant SPA Switch) KHÔNG HỀ TẢI LẠI TRANG
        function switchChatPartner(targetUserId, username, fullname, avatar, event, isPopState) {
            if (event && event.preventDefault) {
                event.preventDefault();
            }

            if (!targetUserId) return;
            if (!isPopState && targetUserId === activeUserId) return; // Đang mở đúng người này

            // Đóng Modal Soạn tin nhắn mới nếu đang mở
            const newMsgModal = document.getElementById('newMsgModal');
            if (newMsgModal) newMsgModal.classList.remove('show');

            // 1. Cập nhật URL trên thanh địa chỉ mà không tải lại trang
            if (!isPopState) {
                const newUrl = contextPath + '/direct?userId=' + targetUserId;
                window.history.pushState({ userId: targetUserId }, '', newUrl);
            }

            // 2. Chuyển class active trên cột đối tác bên trái
            document.querySelectorAll('.inbox-partner-item').forEach(el => el.classList.remove('active'));
            const currentItem = document.querySelector('.inbox-partner-item[data-user-id="' + targetUserId + '"]');
            if (currentItem) {
                currentItem.classList.add('active');
                const unreadDot = currentItem.querySelector('.unread-dot');
                if (unreadDot) unreadDot.remove();
            }

            // 3. Hiển thị khung chat và ẩn Empty state
            const chatWrapper = document.getElementById('activeChatWrapper');
            const emptyState = document.getElementById('directEmptyState');
            if (chatWrapper) chatWrapper.style.display = 'flex';
            if (emptyState) emptyState.style.display = 'none';

            // 4. Cập nhật ngay thông tin Header & Topbar (0ms)
            activeUserId = targetUserId;
            activeUserAvatar = avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
            updateChatHeaderUI(targetUserId, username, fullname, activeUserAvatar);

            // 5. Kiểm tra Cache: Nếu đã có dữ liệu trong cache thì vẽ NGAY TỨC THÌ (0ms)!
            const hasCache = !!conversationCache[targetUserId];
            if (hasCache) {
                renderFullConversation(conversationCache[targetUserId]);
            } else {
                // Không xóa trắng khung chat gây chớp giật, chỉ mờ nhẹ trong tích tắc
                if (messagesArea) {
                    messagesArea.classList.add('switching');
                }
            }

            // 6. Gửi API JSON siêu nhẹ (chỉ mất ~5-15ms) để lấy dữ liệu mới nhất
            fetch(contextPath + '/direct/api/conversation/' + targetUserId)
                .then(res => res.json())
                .then(data => {
                    if (data.success && activeUserId === targetUserId) {
                        const newMsgs = data.messages || [];
                        const oldMsgs = conversationCache[targetUserId];

                        // NẾU ĐÃ CÓ CACHE VÀ SỐ LƯỢNG TIN NHẮN KHÔNG ĐỔI -> TUYỆT ĐỐI KHÔNG RE-RENDER ĐỂ TRÁNH CHỚP LẦN 2!
                        if (!hasCache || !oldMsgs || oldMsgs.length !== newMsgs.length) {
                            conversationCache[targetUserId] = newMsgs;
                            renderFullConversation(newMsgs);
                        }

                        if (data.targetUser) {
                            updateChatHeaderUI(data.targetUser.userId, data.targetUser.username, data.targetUser.fullname, data.targetUser.avatar);
                        }
                    }
                })
                .catch(err => {
                    console.error('[Direct Chat] Lỗi tải tin nhắn:', err);
                })
                .finally(() => {
                    if (messagesArea) {
                        messagesArea.classList.remove('switching');
                    }
                });

            if (chatInput) {
                chatInput.focus();
            }
            return false;
        }

        // Vẽ toàn bộ danh sách tin nhắn vào #chatMessagesList
        function renderFullConversation(messages) {
            const listEl = document.getElementById('chatMessagesList');
            if (!listEl) return;

            let html = '';
            if (messages && messages.length > 0) {
                messages.forEach((msg, idx) => {
                    const isSelf = (msg.senderId === currentUserId);
                    if (idx === 0 || idx % 5 === 0) {
                        html += '<div class="chat-date-divider">' + escapeHtml(msg.createdAt || '') + '</div>';
                    }
                    html += '<div class="msg-row ' + (isSelf ? 'self' : 'other') + '">';
                    if (!isSelf) {
                        const av = msg.senderAvatar || activeUserAvatar;
                        html += '<img src="' + escapeHtml(av) + '" alt="' + escapeHtml(msg.senderUsername || '') + '" class="msg-avatar-sm" title="' + escapeHtml(msg.senderUsername || '') + '">';
                    }
                    html += '<div class="msg-bubble ' + (isSelf ? 'self' : 'other') + '">' + escapeHtml(msg.content) + '</div>';
                    html += '</div>';

                    if (msg.messageId) {
                        renderedMessageIds.add(msg.messageId);
                    }
                });
            } else {
                html = '<div style="text-align: center; padding: 50px 20px; color: var(--text-secondary); font-size: 13px;">' +
                       '<i class="fa-regular fa-paper-plane" style="font-size: 28px; margin-bottom: 10px; display: block; opacity: 0.5;"></i>' +
                       'Chưa có tin nhắn nào.<br>Hãy gửi lời chào đầu tiên để bắt đầu cuộc trò chuyện!</div>';
            }

            listEl.innerHTML = html;
            scrollToBottom();
        }

        // Khởi tạo kết nối WebSocket với Spring WebSocket Handler
        function initWebSocket() {
            if (!currentUserId) return;

            const wsProtocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
            const wsUrl = wsProtocol + window.location.host + contextPath + '/ws/chat?userId=' + currentUserId;

            console.log('[WebSocket] Đang kết nối tới:', wsUrl);
            chatSocket = new WebSocket(wsUrl);

            chatSocket.onopen = function () {
                console.log('[WebSocket] Kết nối thành công!');
                if (wsStatusDot) wsStatusDot.classList.remove('disconnected');
                if (wsStatusText) wsStatusText.textContent = 'Đang hoạt động';
            };

            chatSocket.onmessage = function (event) {
                try {
                    const data = JSON.parse(event.data);
                    console.log('[WebSocket] Nhận tin nhắn mới:', data);
                    renderIncomingMessage(data);
                } catch (e) {
                    console.error('[WebSocket] Lỗi xử lý dữ liệu nhận được:', e);
                }
            };

            chatSocket.onerror = function (error) {
                console.error('[WebSocket] Lỗi kết nối:', error);
                if (wsStatusDot) wsStatusDot.classList.add('disconnected');
                if (wsStatusText) wsStatusText.textContent = 'Lỗi kết nối';
            };

            chatSocket.onclose = function (event) {
                console.warn('[WebSocket] Đã ngắt kết nối. Thử lại sau 3 giây...', event);
                if (wsStatusDot) wsStatusDot.classList.add('disconnected');
                if (wsStatusText) wsStatusText.textContent = 'Mất kết nối...';
                setTimeout(initWebSocket, 3000);
            };
        }

        // Xử lý hiển thị tin nhắn mới nhận hoặc vừa gửi ngay lập tức (Realtime)
        function renderIncomingMessage(data) {
            if (!data || !data.content) return;

            // Chống trùng tin nhắn nếu đã render
            if (data.messageId) {
                if (renderedMessageIds.has(data.messageId)) return;
                renderedMessageIds.add(data.messageId);
            }

            // Lưu vào Cache của cuộc hội thoại tương ứng
            const partnerId = (data.senderId === currentUserId) ? data.receiverId : data.senderId;
            if (partnerId) {
                if (!conversationCache[partnerId]) {
                    conversationCache[partnerId] = [];
                }
                conversationCache[partnerId].push(data);
            }

            // Kiểm tra xem tin nhắn có thuộc cuộc hội thoại đang mở không
            const isRelevant = activeUserId && 
                ((data.senderId === activeUserId && data.receiverId === currentUserId) ||
                 (data.senderId === currentUserId && data.receiverId === activeUserId));

            if (isRelevant) {
                const listEl = document.getElementById('chatMessagesList');
                if (listEl) {
                    const isSelf = (data.senderId === currentUserId);
                    const msgRow = document.createElement('div');
                    msgRow.className = 'msg-row ' + (isSelf ? 'self' : 'other');

                    let avatarHtml = '';
                    if (!isSelf) {
                        const avatarSrc = data.senderAvatar || activeUserAvatar;
                        avatarHtml = '<img src="' + escapeHtml(avatarSrc) + '" class="msg-avatar-sm" alt="Avatar">';
                    }

                    const contentHtml = '<div class="msg-bubble ' + (isSelf ? 'self' : 'other') + '">' + escapeHtml(data.content) + '</div>';

                    msgRow.innerHTML = avatarHtml + contentHtml;
                    listEl.appendChild(msgRow);

                    // Cuộn xuống tin nhắn mới nhất
                    scrollToBottom();
                }

                // Cập nhật dòng preview tin nhắn bên danh sách đối tác chat bên trái
                const partnerItem = document.querySelector('.inbox-partner-item[data-user-id="' + activeUserId + '"]');
                if (partnerItem) {
                    const statusEl = partnerItem.querySelector('.inbox-partner-status');
                    if (statusEl) {
                        statusEl.textContent = ((data.senderId === currentUserId) ? 'Bạn: ' : '') + data.content;
                    }
                }
            } else if (data.senderId !== currentUserId) {
                // Nhận tin nhắn từ người khác khi đang mở chat người khác
                highlightPartner(data.senderId);
            }
        }

        // Gửi tin nhắn qua WebSocket (có hỗ trợ tự động fallback sang AJAX HTTP)
        function handleSendChat(e) {
            if (e && e.preventDefault) e.preventDefault();
            if (!chatInput) return;

            const text = chatInput.value.trim();
            if (!text || !activeUserId) return;

            // Xóa nội dung trong ô nhập và focus lại ngay để gõ tiếp
            chatInput.value = '';
            handleChatInputChange(chatInput);
            chatInput.focus();

            // 1. Thử gửi qua WebSocket nếu kết nối đang mở
            if (chatSocket && chatSocket.readyState === WebSocket.OPEN) {
                const payload = {
                    receiverId: activeUserId,
                    content: text
                };
                chatSocket.send(JSON.stringify(payload));
                return;
            }

            // 2. Dự phòng: Nếu WebSocket chưa kết nối/bị rớt mạng, gửi qua AJAX HTTP
            console.log('[Direct Chat] WebSocket chưa sẵn sàng, đang gửi qua AJAX...');
            const params = new URLSearchParams();
            params.append('receiverId', activeUserId);
            params.append('content', text);

            fetch(contextPath + '/direct/api/send', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    renderIncomingMessage(data);
                } else {
                    alert(data.message || 'Không thể gửi tin nhắn.');
                }
            })
            .catch(err => {
                console.error('[Direct Chat] Lỗi gửi tin nhắn qua HTTP fallback:', err);
            });
        }

        // Bật/tắt nút 'Gửi' so với các icon 'Mic, Ảnh, Tim' khi gõ chữ
        function handleChatInputChange(input) {
            const text = input ? input.value.trim() : '';
            const defaultActions = document.getElementById('chatDefaultActions');
            const sendBtn = document.getElementById('btnSend');
            if (text.length > 0) {
                if (defaultActions) defaultActions.style.display = 'none';
                if (sendBtn) sendBtn.style.display = 'block';
            } else {
                if (defaultActions) defaultActions.style.display = 'flex';
                if (sendBtn) sendBtn.style.display = 'none';
            }
        }

        // Bật/tắt Popover Emoji
        function toggleEmojiPicker(e) {
            if (e) e.stopPropagation();
            const picker = document.getElementById('chatEmojiPicker');
            if (picker) {
                picker.style.display = (picker.style.display === 'none' || !picker.style.display) ? 'block' : 'none';
            }
        }

        // Chọn Emoji từ Popover
        function selectEmoji(emoji) {
            if (!chatInput) return;
            chatInput.value += emoji;
            handleChatInputChange(chatInput);
            chatInput.focus();
            const picker = document.getElementById('chatEmojiPicker');
            if (picker) picker.style.display = 'none';
        }

        // Đóng popover emoji khi click bên ngoài
        document.addEventListener('click', function(e) {
            const picker = document.getElementById('chatEmojiPicker');
            if (picker && !picker.contains(e.target) && !e.target.closest('.chat-emoji-btn')) {
                picker.style.display = 'none';
            }
        });

        // Gửi tim nhanh khi bấm icon Tim ở góc phải
        function sendQuickHeart() {
            if (!activeUserId) return;
            const text = '❤️';
            if (chatSocket && chatSocket.readyState === WebSocket.OPEN) {
                const payload = {
                    receiverId: activeUserId,
                    content: text
                };
                chatSocket.send(JSON.stringify(payload));
                return;
            }

            const params = new URLSearchParams();
            params.append('receiverId', activeUserId);
            params.append('content', text);

            fetch(contextPath + '/direct/api/send', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    renderIncomingMessage(data);
                }
            });
        }

        // Kích hoạt chọn ảnh gửi
        function triggerImageUpload() {
            const fileInput = document.getElementById('chatImageInput');
            if (fileInput) fileInput.click();
        }

        function handleSendImageFile(input) {
            if (!input.files || !input.files[0]) return;
            const file = input.files[0];
            alert('Tính năng gửi ảnh trực tiếp: đã chọn file "' + file.name + '"!');
            input.value = '';
        }

        function handleVoiceNote() {
            alert('Tính năng tin nhắn thoại (Voice note) đang được chuẩn bị!');
        }

        function handleVoiceCall() {
            alert('Đang kết nối gọi thoại tới người dùng...');
        }

        function handleVideoCall() {
            alert('Đang kết nối gọi video tới người dùng...');
        }

        // Cuộn khung chat xuống đáy
        function scrollToBottom() {
            if (messagesArea) {
                messagesArea.scrollTop = messagesArea.scrollHeight;
            }
        }

        // Tìm kiếm và lọc trong danh sách bạn chat (Search Bar)
        let searchPartnersDebounce = null;
        function handlePartnerSearch(query) {
            const clearBtn = document.getElementById('partnerSearchClear');
            const dynamicBox = document.getElementById('dynamicSearchResults');
            const dynamicList = document.getElementById('dynamicSearchResultsList');
            const q = (query || '').toLowerCase().trim();

            if (clearBtn) {
                clearBtn.style.display = q ? 'flex' : 'none';
            }

            // 1. Lọc các bạn chat hiện có
            const items = document.querySelectorAll('.inbox-partner-item');
            let hasLocalMatch = false;
            items.forEach(item => {
                const username = item.getAttribute('data-username') || '';
                const fullname = item.getAttribute('data-fullname') || '';
                if (!q || username.includes(q) || fullname.includes(q)) {
                    item.style.display = 'flex';
                    hasLocalMatch = true;
                } else {
                    item.style.display = 'none';
                }
            });

            // 2. Tìm kiếm mở rộng qua API nếu có nhập chữ
            if (searchPartnersDebounce) clearTimeout(searchPartnersDebounce);
            if (!q) {
                if (dynamicBox) dynamicBox.style.display = 'none';
                return;
            }

            searchPartnersDebounce = setTimeout(() => {
                fetch(contextPath + '/api/users/search?q=' + encodeURIComponent(q))
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.users && data.users.length > 0) {
                            if (dynamicBox) dynamicBox.style.display = 'block';
                            let html = '';
                            data.users.forEach(u => {
                                if (u.userId !== currentUserId) {
                                    const uName = escapeJsString(u.username);
                                    const fName = escapeJsString(u.fullname || u.username);
                                    const avt = escapeJsString(u.avatar || '');
                                    html += '<a href="' + contextPath + '/direct?userId=' + u.userId + '" class="inbox-partner-item" onclick="switchChatPartner(' + u.userId + ', \'' + uName + '\', \'' + fName + '\', \'' + avt + '\', event)">' +
                                                '<div class="inbox-avatar-wrap">' +
                                                    '<img src="' + escapeHtml(u.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150') + '" class="inbox-avatar-img">' +
                                                '</div>' +
                                                '<div class="inbox-partner-info">' +
                                                    '<span class="inbox-partner-name">' + escapeHtml(u.fullname || u.username) + '</span>' +
                                                    '<span class="inbox-partner-status">@' + escapeHtml(u.username) + '</span>' +
                                                '</div>' +
                                            '</a>';
                                }
                            });
                            if (dynamicList) dynamicList.innerHTML = html;
                        } else {
                            if (dynamicBox) dynamicBox.style.display = 'none';
                        }
                    })
                    .catch(() => {
                        if (dynamicBox) dynamicBox.style.display = 'none';
                    });
            }, 250);
        }

        function clearPartnerSearch() {
            const input = document.getElementById('partnerSearchInput');
            if (input) {
                input.value = '';
                handlePartnerSearch('');
                input.focus();
            }
        }

        // Modal Soạn Tin Nhắn Mới
        function openNewMsgModal() {
            const modal = document.getElementById('newMsgModal');
            const input = document.getElementById('newMsgSearchInput');
            if (modal) {
                modal.classList.add('show');
                if (input) {
                    input.value = '';
                    setTimeout(() => input.focus(), 150);
                    handleNewMsgSearch('');
                }
            }
        }

        function closeNewMsgModal(e) {
            if (e && e.target && e.target.closest && e.target.closest('.new-msg-dialog')) {
                return;
            }
            const modal = document.getElementById('newMsgModal');
            if (modal) modal.classList.remove('show');
        }

        let newMsgDebounce = null;
        function handleNewMsgSearch(query) {
            const list = document.getElementById('newMsgUsersList');
            const q = (query || '').trim();
            if (newMsgDebounce) clearTimeout(newMsgDebounce);

            if (!q) {
                if (list) list.innerHTML = '<div class="search-empty-hint">Gõ tên hoặc username để tìm người nhận...</div>';
                return;
            }

            newMsgDebounce = setTimeout(() => {
                if (list) list.innerHTML = '<div class="search-empty-hint">Đang tìm kiếm...</div>';
                fetch(contextPath + '/api/users/search?q=' + encodeURIComponent(q))
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.users && data.users.length > 0) {
                            let html = '';
                            data.users.forEach(u => {
                                if (u.userId !== currentUserId) {
                                    const uName = escapeJsString(u.username);
                                    const fName = escapeJsString(u.fullname || u.username);
                                    const avt = escapeJsString(u.avatar || '');
                                    html += '<a href="' + contextPath + '/direct?userId=' + u.userId + '" class="search-user-card" onclick="switchChatPartner(' + u.userId + ', \'' + uName + '\', \'' + fName + '\', \'' + avt + '\', event)">' +
                                                '<img src="' + escapeHtml(u.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150') + '" class="search-user-avatar">' +
                                                '<div class="search-user-info">' +
                                                    '<span class="search-user-handle">' + escapeHtml(u.username) + '</span>' +
                                                    '<span class="search-user-fullname">' + escapeHtml(u.fullname || '') + '</span>' +
                                                '</div>' +
                                            '</a>';
                                }
                            });
                            if (list) list.innerHTML = html;
                        } else {
                            if (list) list.innerHTML = '<div class="search-empty-hint">Không tìm thấy người dùng phù hợp.</div>';
                        }
                    })
                    .catch(() => {
                        if (list) list.innerHTML = '<div class="search-empty-hint" style="color:red;">Lỗi tìm kiếm.</div>';
                    });
            }, 250);
        }

        // Xử lý cuộn Stories Carousel trong Direct Inbox (Nút mũi tên chạy sang trái/phải giống trang Home)
        function scrollInboxStories(offset) {
            const track = document.getElementById('inboxStoriesTrack');
            if (track) {
                track.scrollBy({ left: offset, behavior: 'smooth' });
            }
        }

        function updateInboxStoryArrows() {
            const track = document.getElementById('inboxStoriesTrack');
            const prevBtn = document.getElementById('inboxStoryBtnPrev');
            const nextBtn = document.getElementById('inboxStoryBtnNext');
            if (!track) return;
            if (prevBtn) {
                prevBtn.style.display = track.scrollLeft > 10 ? 'flex' : 'none';
            }
            if (nextBtn) {
                const canScrollMore = track.scrollLeft + track.clientWidth < track.scrollWidth - 10;
                nextBtn.style.display = canScrollMore ? 'flex' : 'none';
            }
        }

        const inboxTrackEl = document.getElementById('inboxStoriesTrack');
        if (inboxTrackEl) {
            inboxTrackEl.addEventListener('scroll', updateInboxStoryArrows);
            window.addEventListener('resize', updateInboxStoryArrows);
            setTimeout(updateInboxStoryArrows, 300);
        }

        function highlightPartner(senderId) {
            const item = document.querySelector('.inbox-partner-item[data-user-id="' + senderId + '"]');
            if (item) {
                item.style.backgroundColor = 'rgba(0, 149, 246, 0.25)';
            }
        }

        function escapeHtml(text) {
            if (!text) return '';
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        function escapeJsString(str) {
            if (!str) return '';
            return String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '&quot;');
        }

        // Lắng nghe sự kiện Back/Forward của trình duyệt để chuyển tab tức thì
        window.addEventListener('popstate', function(e) {
            const urlParams = new URLSearchParams(window.location.search);
            const uId = urlParams.get('userId');
            if (uId) {
                const item = document.querySelector('.inbox-partner-item[data-user-id="' + uId + '"]');
                if (item) {
                    const username = item.getAttribute('data-username') || '';
                    const fullname = item.getAttribute('data-fullname') || '';
                    const avatar = item.getAttribute('data-avatar') || '';
                    switchChatPartner(parseInt(uId), username, fullname, avatar, null, true);
                } else {
                    switchChatPartner(parseInt(uId), '', '', '', null, true);
                }
            }
        });

        // Tự động khởi chạy khi tải trang
        document.addEventListener('DOMContentLoaded', function () {
            scrollToBottom();
            initWebSocket();

            // Lưu cache cuộc hội thoại ban đầu
            if (activeUserId) {
                const initialMsgs = [];
                const rows = document.querySelectorAll('#chatMessagesList .msg-row');
                rows.forEach(r => {
                    const isSelf = r.classList.contains('self');
                    const bubble = r.querySelector('.msg-bubble');
                    const content = bubble ? bubble.textContent : '';
                    if (content) {
                        initialMsgs.push({
                            senderId: isSelf ? currentUserId : activeUserId,
                            receiverId: isSelf ? activeUserId : currentUserId,
                            content: content,
                            senderAvatar: isSelf ? '' : activeUserAvatar,
                            createdAt: ''
                        });
                    }
                });
                if (initialMsgs.length > 0) {
                    conversationCache[activeUserId] = initialMsgs;
                }
            }

            if (chatInput) {
                chatInput.focus();
            }
        });
    </script>
</body>
</html>
