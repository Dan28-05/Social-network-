<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css">
    <style>
        /* Custom tweaks specific to direct chat view */
        .direct-view-wrapper {
            display: flex;
            width: 100vw;
            height: 100vh;
            background-color: #000;
            overflow: hidden;
        }

        .unread-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: var(--ig-blue);
            margin-left: auto;
            flex-shrink: 0;
        }

        .quick-emojis-bar {
            display: flex;
            gap: 10px;
            padding: 4px 16px 8px;
        }

        .quick-emoji-chip {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            padding: 2px 8px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.15s, transform 0.15s;
        }

        .quick-emoji-chip:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }

        .ws-connection-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #00c950;
            margin-right: 6px;
        }
        .ws-connection-indicator.disconnected {
            background-color: #ff3040;
        }
    </style>
</head>
<body class="ig-dark-body">
    <div class="direct-view-wrapper">
        <!-- Sidebar Navigation Trái (Header chuẩn Instagram) -->
        <jsp:include page="/WEB-INF/views/commons/header.jsp" />

        <!-- Khu vực Trò chuyện Direct (2 Cột) -->
        <div class="direct-page-container">
            <!-- CỘT TRÁI: Danh sách bạn bè & hội thoại -->
            <aside class="direct-inbox-col">
                <div class="inbox-top-header">
                    <div class="inbox-current-username" title="Tài khoản hiện tại">
                        <span>${currentUser.username}</span>
                        <i class="fa-solid fa-chevron-down" style="font-size: 13px; color: var(--text-secondary);"></i>
                    </div>
                    <i class="fa-regular fa-pen-to-square inbox-compose-icon" onclick="focusSearch()" title="Tin nhắn mới"></i>
                </div>

                <!-- Ô tìm kiếm bạn chat -->
                <div class="inbox-search-wrap">
                    <input type="text" 
                           id="partnerSearchInput" 
                           class="inbox-search-input" 
                           placeholder="Tìm kiếm cuộc trò chuyện..." 
                           oninput="filterPartners(this.value)">
                </div>

                <!-- Danh sách đối tác chat -->
                <div class="inbox-partners-list" id="partnersListContainer">
                    <c:choose>
                        <c:when test="${not empty partners}">
                            <c:forEach items="${partners}" var="p">
                                <a href="${pageContext.request.contextPath}/direct?userId=${p.userId}" 
                                   class="inbox-partner-item ${not empty activeUser and activeUser.userId == p.userId ? 'active' : ''}" 
                                   data-user-id="${p.userId}"
                                   data-username="${p.username.toLowerCase()}" 
                                   data-fullname="${p.fullname.toLowerCase()}">
                                    <div class="inbox-avatar-wrap">
                                        <img src="${p.avatar}" alt="${p.username}" class="inbox-avatar-img">
                                        <span class="online-indicator"></span>
                                    </div>
                                    <div class="inbox-partner-info">
                                        <span class="inbox-partner-name">${p.fullname}</span>
                                        <span class="inbox-partner-handle">@${p.username}</span>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 30px 20px; text-align: center; color: var(--text-secondary); font-size: 13px;">
                                <i class="fa-regular fa-comments" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                                Chưa có tin nhắn nào.<br>Theo dõi bạn bè để bắt đầu trò chuyện!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </aside>

            <!-- CỘT PHẢI: Khung chat tin nhắn -->
            <main class="direct-conversation-col">
                <c:choose>
                    <c:when test="${not empty activeUser}">
                        <!-- Topbar của người đang chat -->
                        <div class="chat-topbar">
                            <div class="chat-partner-brief">
                                <img src="${activeUser.avatar}" alt="${activeUser.username}" class="chat-topbar-avatar">
                                <div class="chat-topbar-meta">
                                    <span class="chat-topbar-name">${activeUser.fullname} (@${activeUser.username})</span>
                                    <span class="chat-topbar-status">
                                        <span class="ws-connection-indicator" id="wsStatusDot" title="WebSocket kết nối"></span>
                                        <span id="wsStatusText">Đang hoạt động</span>
                                    </span>
                                </div>
                            </div>

                            <div class="chat-topbar-actions">
                                <a href="${pageContext.request.contextPath}/profile/${activeUser.username}" title="Xem trang cá nhân">
                                    <i class="fa-regular fa-circle-user"></i>
                                </a>
                                <a href="javascript:void(0)" onclick="alert('Tính năng gọi thoại đang được cập nhật!')" title="Bắt đầu gọi thoại">
                                    <i class="fa-solid fa-phone"></i>
                                </a>
                                <a href="javascript:void(0)" onclick="alert('Tính năng video call đang được cập nhật!')" title="Bắt đầu gọi video">
                                    <i class="fa-solid fa-video"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/profile/${activeUser.username}" title="Thông tin chi tiết">
                                    <i class="fa-solid fa-circle-info"></i>
                                </a>
                            </div>
                        </div>

                        <!-- Vùng nội dung các tin nhắn (Scrollable) -->
                        <div class="chat-messages-area" id="chatMessagesArea">
                            <!-- Header thông tin đối tác ở đỉnh khung tin nhắn -->
                            <div class="chat-header-profile-box">
                                <img src="${activeUser.avatar}" alt="${activeUser.username}" class="chat-header-avatar-lg">
                                <div class="chat-header-name">${activeUser.fullname}</div>
                                <div class="chat-header-sub">@${activeUser.username} &bull; QNU_Confesstion</div>
                                <a href="${pageContext.request.contextPath}/profile/${activeUser.username}" class="btn-view-profile-sm">Xem trang cá nhân</a>
                            </div>

                            <!-- Lịch sử tin nhắn được nạp từ Server Database -->
                            <c:forEach items="${conversation}" var="msg">
                                <c:set var="isSelf" value="${msg.sender.userId == currentUser.userId}" />
                                <div class="msg-row ${isSelf ? 'self' : 'other'}">
                                    <c:if test="${!isSelf}">
                                        <img src="${msg.sender.avatar}" alt="${msg.sender.username}" class="msg-avatar-sm" title="${msg.sender.fullname}">
                                    </c:if>
                                    <div class="msg-bubble ${isSelf ? 'self' : 'other'}">
                                        <c:out value="${msg.content}" />
                                    </div>
                                    <span class="msg-time">
                                        <fmt:formatDate value="${msg.createdAt}" pattern="HH:mm" />
                                    </span>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Thanh Quick Emojis & Thanh nhập tin nhắn ở đáy -->
                        <div class="chat-bottom-input-wrap">
                            <div class="quick-emojis-bar">
                                <span class="quick-emoji-chip" onclick="insertEmoji('❤️')">❤️</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('😂')">😂</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('🔥')">🔥</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('👍')">👍</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('👏')">👏</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('😍')">😍</span>
                                <span class="quick-emoji-chip" onclick="insertEmoji('🎉')">🎉</span>
                            </div>

                            <form id="chatForm" onsubmit="handleSendChat(event)" class="chat-input-pill">
                                <button type="button" class="chat-emoji-btn" onclick="insertEmoji('😊')" title="Thêm biểu cảm">
                                    <i class="fa-regular fa-face-smile"></i>
                                </button>
                                <input type="text" 
                                       id="chatInput" 
                                       class="chat-text-input" 
                                       placeholder="Nhắn tin cho ${activeUser.fullname}..." 
                                       autocomplete="off" 
                                       required>
                                <button type="submit" class="btn-chat-send" id="btnSend">Gửi</button>
                            </form>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- Trạng thái chưa chọn đối tác nào để chat -->
                        <div class="direct-empty-state">
                            <div class="empty-icon-circle">
                                <i class="fa-regular fa-paper-plane"></i>
                            </div>
                            <h3 class="empty-title">Tin nhắn của bạn</h3>
                            <p class="empty-desc">Gửi ảnh và tin nhắn riêng tư cho bạn bè hoặc người trong trường QNU.</p>
                            <button class="btn-dark-primary-pill" onclick="focusSearch()">Gửi tin nhắn</button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>

    <!-- Modal Tạo bài viết mới dùng chung -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <!-- WebSocket & Client Logic Script -->
    <script>
        const currentUserId = ${currentUser.userId};
        const activeUserId = ${not empty activeUser ? activeUser.userId : 'null'};
        const activeUserAvatar = '${not empty activeUser ? activeUser.avatar : ""}';
        const contextPath = '${pageContext.request.contextPath}';

        let chatSocket = null;
        const messagesArea = document.getElementById('chatMessagesArea');
        const chatInput = document.getElementById('chatInput');
        const wsStatusDot = document.getElementById('wsStatusDot');
        const wsStatusText = document.getElementById('wsStatusText');

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

        // Xử lý hiển thị tin nhắn mới nhận hoặc vừa gửi
        function renderIncomingMessage(data) {
            if (!data || !data.content) return;

            // Kiểm tra xem tin nhắn có thuộc cuộc hội thoại đang mở không
            const isRelevant = activeUserId && 
                ((data.senderId === activeUserId && data.receiverId === currentUserId) ||
                 (data.senderId === currentUserId && data.receiverId === activeUserId));

            if (isRelevant && messagesArea) {
                const isSelf = (data.senderId === currentUserId);
                const msgRow = document.createElement('div');
                msgRow.className = 'msg-row ' + (isSelf ? 'self' : 'other');

                let avatarHtml = '';
                if (!isSelf) {
                    const avatarSrc = data.senderAvatar || activeUserAvatar;
                    avatarHtml = '<img src="' + escapeHtml(avatarSrc) + '" class="msg-avatar-sm" alt="Avatar">';
                }

                const contentHtml = '<div class="msg-bubble ' + (isSelf ? 'self' : 'other') + '">' + escapeHtml(data.content) + '</div>';
                const timeHtml = '<span class="msg-time">' + (data.createdAt || 'Vừa xong') + '</span>';

                msgRow.innerHTML = avatarHtml + contentHtml + timeHtml;
                messagesArea.appendChild(msgRow);

                // Cuộn xuống tin nhắn mới nhất
                scrollToBottom();
            } else if (data.senderId !== currentUserId) {
                // Nhận tin nhắn từ người khác khi đang mở chat người khác
                highlightPartner(data.senderId);
            }
        }

        // Gửi tin nhắn qua WebSocket
        function handleSendChat(e) {
            e.preventDefault();
            if (!chatInput) return;

            const text = chatInput.value.trim();
            if (!text || !activeUserId) return;

            if (!chatSocket || chatSocket.readyState !== WebSocket.OPEN) {
                alert('Mất kết nối WebSocket. Đang kết nối lại, vui lòng thử lại sau giây lát!');
                return;
            }

            const payload = {
                receiverId: activeUserId,
                content: text
            };

            chatSocket.send(JSON.stringify(payload));
            chatInput.value = '';
            chatInput.focus();
        }

        // Chèn nhanh Emoji vào khung chat
        function insertEmoji(emoji) {
            if (!chatInput) return;
            chatInput.value += emoji;
            chatInput.focus();
        }

        // Cuộn khung chat xuống đáy
        function scrollToBottom() {
            if (messagesArea) {
                messagesArea.scrollTop = messagesArea.scrollHeight;
            }
        }

        // Tìm kiếm / lọc bạn chat trong cột bên trái
        function filterPartners(query) {
            const q = query.toLowerCase().trim();
            const items = document.querySelectorAll('.inbox-partner-item');
            items.forEach(item => {
                const username = item.getAttribute('data-username') || '';
                const fullname = item.getAttribute('data-fullname') || '';
                if (username.includes(q) || fullname.includes(q)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        function focusSearch() {
            const input = document.getElementById('partnerSearchInput');
            if (input) {
                input.focus();
            }
        }

        function highlightPartner(senderId) {
            const item = document.querySelector('.inbox-partner-item[data-user-id="' + senderId + '"]');
            if (item) {
                item.style.backgroundColor = 'rgba(0, 149, 246, 0.2)';
            }
        }

        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        // Tự động khởi chạy khi tải trang
        document.addEventListener('DOMContentLoaded', function () {
            scrollToBottom();
            initWebSocket();
            if (chatInput) {
                chatInput.focus();
            }
        });
    </script>
</body>
</html>
