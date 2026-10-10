<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" scope="session" />
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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/templates/css/style.css?v=20261010_light_v1">
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
                        <!-- Nút mũi tên cuộn stories bên trái -->
                        <button type="button" class="story-arrow-prev" id="storyBtnPrev" onclick="scrollStories(-300)" title="Xem tin trước" style="display: none;">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>

                        <div class="stories-track" id="storiesTrack">
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
                        <button type="button" class="story-arrow-next" id="storyBtnNext" onclick="scrollStories(300)" title="Xem thêm tin">
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

                                    <!-- Nút 3 chấm tùy chọn (Xóa bài khi nhấn 3 chấm) -->
                                    <div class="post-header-actions">
                                        <button type="button" class="btn-more-dots" 
                                                onclick="openPostOptionsModal('${post.postId}', '${post.user.userId == currentUser.userId}')" 
                                                title="Tùy chọn bài viết">
                                            <i class="fa-solid fa-ellipsis"></i>
                                        </button>
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

                                    <!-- Khối chứa ảnh/video bài viết -->
                                    <div class="post-media-wrap" ondblclick="handleImageDblClick('${post.postId}')">
                                        <c:choose>
                                            <c:when test="${post.video}">
                                                <video src="${resolvedMediaUrl}" controls playsinline loop class="post-main-image post-main-video" preload="metadata"></video>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${resolvedMediaUrl}" alt="${post.caption}" class="post-main-image" loading="lazy">
                                            </c:otherwise>
                                        </c:choose>
                                        <!-- Nút mở chi tiết bài viết overlay góc trên phải -->
                                        <div class="image-overlay-badge" onclick="openPostDetailModal('${post.postId}')" title="Xem chi tiết bài viết">
                                            <i class="fa-solid fa-expand"></i>
                                        </div>
                                        <div class="heart-pop-icon" id="heartPop-${post.postId}"><i class="fa-solid fa-heart"></i></div>
                                    </div>
                                </div>

                                <!-- Thanh công cụ biểu tượng tương tác -->
                                <div class="post-toolbar">
                                    <div class="toolbar-left">
                                        <button type="button" 
                                                class="toolbar-btn btn-like ${likedPostIds.contains(post.postId) ? 'liked' : ''}" 
                                                id="likeBtn-${post.postId}" 
                                                onclick="handleToggleLike('${post.postId}', this)"
                                                title="Thích bài viết">
                                            <i class="fa-regular fa-heart heart-outline"></i>
                                            <i class="fa-solid fa-heart heart-filled"></i>
                                        </button>
                                        <button type="button" class="toolbar-btn" onclick="openPostDetailModal('${post.postId}')" title="Bình luận & Xem chi tiết">
                                            <i class="fa-regular fa-comment"></i>
                                        </button>
                                        <button type="button" class="toolbar-btn" onclick="window.location.href='${pageContext.request.contextPath}/direct?userId=${post.user.userId}'" title="Nhắn tin riêng">
                                            <i class="fa-regular fa-paper-plane"></i>
                                        </button>
                                    </div>
                                    <div class="toolbar-right">
                                        <button type="button" class="toolbar-btn btn-bookmark" onclick="handleBookmarkPost(this)" title="Lưu bài viết">
                                            <i class="fa-regular fa-bookmark bookmark-outline"></i>
                                            <i class="fa-solid fa-bookmark bookmark-filled" style="display: none; color: #f5f5f5;"></i>
                                        </button>
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

                                    <!-- Xem tất cả bình luận & chi tiết -->
                                    <div class="view-comments-btn" id="viewCommentsBtn-${post.postId}" onclick="openPostDetailModal('${post.postId}')">
                                        <c:choose>
                                            <c:when test="${commentCounts[post.postId] > 0}">
                                                Xem tất cả <span id="commentCount-${post.postId}">${commentCounts[post.postId]}</span> bình luận
                                            </c:when>
                                            <c:otherwise>
                                                <span id="commentCountText-${post.postId}">Chưa có bình luận nào. Hãy là người đầu tiên!</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- FIX BUG: Chỉ preview ĐÚNG 1 bình luận gần nhất ngay dưới bài viết -->
                                    <div class="post-comments-preview" id="commentsPreview-${post.postId}">
                                        <c:forEach items="${postComments[post.postId]}" var="cmt" varStatus="st">
                                            <c:if test="${st.last}">
                                                <div class="comment-preview-row" id="commentItem-${cmt.commentId}">
                                                    <a href="${pageContext.request.contextPath}/profile/user/${cmt.user.userId}" class="caption-user">${cmt.user.username}</a>
                                                    <span class="caption-content"><c:out value="${cmt.content}" /></span>
                                                    <c:if test="${cmt.user.userId == currentUser.userId || post.user.userId == currentUser.userId}">
                                                        <button type="button" class="btn-delete-comment-sm" onclick="handleDeleteComment('${cmt.commentId}', '${post.postId}')" title="Xóa bình luận"><i class="fa-regular fa-trash-can"></i></button>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                    <div class="post-timestamp"><fmt:formatDate value="${post.createdAt}" pattern="dd 'THÁNG' MM, yyyy" /></div>
                                </div>

                                <!-- Hộp bình luận -->
                                <form class="post-comment-input-row" onsubmit="handlePostComment(event, '${post.postId}')">
                                    <i class="fa-regular fa-face-smile smile-btn" onclick="insertQuickEmoji('${post.postId}', '❤️')" title="Thêm emoji"></i>
                                    <input type="text" id="commentInput-${post.postId}" placeholder="Thêm bình luận..." class="ig-comment-field" autocomplete="off" required oninput="handleFeedCommentInput(this, '${post.postId}')" />
                                    <button type="submit" class="btn-post-send" id="btnSendComment-${post.postId}" disabled title="Gửi bình luận">
                                        <i class="fa-solid fa-arrow-up"></i>
                                    </button>
                                </form>
                            </article>
                        </c:forEach>
                    </div>
                </div>

                <!-- Cột Phải: Lịch Sự Kiện QNU Đầy Đủ & Trực Quan (Campus Event Calendar) -->
                <aside class="ig-sidebar-right">
                    <div class="campus-calendar-card">
                        <!-- Header Lịch -->
                        <div class="cal-widget-header">
                            <div class="cal-title-wrap">
                                <i class="fa-solid fa-calendar-days cal-header-icon"></i>
                                <div>
                                    <h3 class="cal-main-title">Lịch sự kiện QNU</h3>
                                    <span class="cal-sub-title">Tháng 10 / 2026</span>
                                </div>
                            </div>
                            <div class="cal-nav-btns">
                                <button type="button" class="cal-nav-btn" onclick="prevMonth()" title="Tháng trước"><i class="fa-solid fa-chevron-left"></i></button>
                                <button type="button" class="cal-nav-btn" onclick="nextMonth()" title="Tháng sau"><i class="fa-solid fa-chevron-right"></i></button>
                            </div>
                        </div>

                        <!-- Khung Lịch Tháng (Calendar Grid) -->
                        <div class="cal-grid-wrapper">
                            <!-- Hàng Thứ trong tuần -->
                            <div class="cal-weekdays">
                                <span>T2</span>
                                <span>T3</span>
                                <span>T4</span>
                                <span>T5</span>
                                <span>T6</span>
                                <span>T7</span>
                                <span>CN</span>
                            </div>

                            <!-- Lưới Ngày (Tháng 10/2026 chính xác) -->
                            <div class="cal-days-grid" id="calDaysGrid">
                                <!-- Ngày tháng 9 mờ -->
                                <span class="cal-day-cell other-month">28</span>
                                <span class="cal-day-cell other-month">29</span>
                                <span class="cal-day-cell other-month">30</span>
                                <!-- Tuần 1 -->
                                <span class="cal-day-cell" onclick="selectCalDay(1, this)">1</span>
                                <span class="cal-day-cell" onclick="selectCalDay(2, this)">2</span>
                                <span class="cal-day-cell" onclick="selectCalDay(3, this)">3</span>
                                <span class="cal-day-cell" onclick="selectCalDay(4, this)">4</span>
                                <!-- Tuần 2 -->
                                <span class="cal-day-cell" onclick="selectCalDay(5, this)">5</span>
                                <span class="cal-day-cell" onclick="selectCalDay(6, this)">6</span>
                                <span class="cal-day-cell" onclick="selectCalDay(7, this)">7</span>
                                <span class="cal-day-cell" onclick="selectCalDay(8, this)">8</span>
                                <span class="cal-day-cell today" onclick="selectCalDay(9, this)" title="Hôm nay">9</span>
                                <span class="cal-day-cell" onclick="selectCalDay(10, this)">10</span>
                                <span class="cal-day-cell" onclick="selectCalDay(11, this)">11</span>
                                <!-- Tuần 3 -->
                                <span class="cal-day-cell" onclick="selectCalDay(12, this)">12</span>
                                <span class="cal-day-cell" onclick="selectCalDay(13, this)">13</span>
                                <span class="cal-day-cell" onclick="selectCalDay(14, this)">14</span>
                                <span class="cal-day-cell has-event event-blue" onclick="selectCalDay(15, this)" title="Ngày hội việc làm">
                                    15
                                    <span class="event-dot dot-blue"></span>
                                </span>
                                <span class="cal-day-cell" onclick="selectCalDay(16, this)">16</span>
                                <span class="cal-day-cell" onclick="selectCalDay(17, this)">17</span>
                                <span class="cal-day-cell" onclick="selectCalDay(18, this)">18</span>
                                <!-- Tuần 4 -->
                                <span class="cal-day-cell" onclick="selectCalDay(19, this)">19</span>
                                <span class="cal-day-cell" onclick="selectCalDay(20, this)">20</span>
                                <span class="cal-day-cell" onclick="selectCalDay(21, this)">21</span>
                                <span class="cal-day-cell has-event event-orange" onclick="selectCalDay(22, this)" title="QNU Cup">
                                    22
                                    <span class="event-dot dot-orange"></span>
                                </span>
                                <span class="cal-day-cell" onclick="selectCalDay(23, this)">23</span>
                                <span class="cal-day-cell" onclick="selectCalDay(24, this)">24</span>
                                <span class="cal-day-cell" onclick="selectCalDay(25, this)">25</span>
                                <!-- Tuần 5 -->
                                <span class="cal-day-cell" onclick="selectCalDay(26, this)">26</span>
                                <span class="cal-day-cell" onclick="selectCalDay(27, this)">27</span>
                                <span class="cal-day-cell has-event event-purple" onclick="selectCalDay(28, this)" title="Acoustic Night">
                                    28
                                    <span class="event-dot dot-purple"></span>
                                </span>
                                <span class="cal-day-cell" onclick="selectCalDay(29, this)">29</span>
                                <span class="cal-day-cell" onclick="selectCalDay(30, this)">30</span>
                                <span class="cal-day-cell" onclick="selectCalDay(31, this)">31</span>
                                <span class="cal-day-cell other-month">1</span>
                            </div>
                        </div>

                        <!-- Chú thích chấm sự kiện (Legend) -->
                        <div class="cal-legend-bar">
                            <span class="legend-item"><span class="legend-dot dot-blue"></span> Việc làm</span>
                            <span class="legend-item"><span class="legend-dot dot-orange"></span> Thể thao</span>
                            <span class="legend-item"><span class="legend-dot dot-purple"></span> Âm nhạc</span>
                            <span class="legend-item"><span class="legend-dot dot-cyan"></span> Hội thảo</span>
                        </div>

                        <!-- Danh sách sự kiện sắp tới dạng thanh cuộn ngang (Horizontal Scroll Bar) -->
                        <div class="cal-agenda-section">
                            <div class="agenda-header-row">
                                <div class="agenda-title-wrap">
                                    <span class="agenda-title">Sự kiện sắp tới</span>
                                    <div class="agenda-scroll-nav">
                                        <button type="button" class="agenda-scroll-nav-btn" onclick="scrollAgendaTrack(-230)" title="Cuộn sang trái"><i class="fa-solid fa-chevron-left"></i></button>
                                        <button type="button" class="agenda-scroll-nav-btn" onclick="scrollAgendaTrack(230)" title="Cuộn sang phải"><i class="fa-solid fa-chevron-right"></i></button>
                                    </div>
                                </div>
                                <a href="javascript:void(0)" class="agenda-link-all" onclick="openAllEventsModal()">Xem tất cả</a>
                            </div>

                            <div class="cal-agenda-horizontal-track" id="calAgendaList">
                                <!-- Sự kiện 1 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-15" onclick="viewEventDetails('Ngày hội Việc làm & Tuyển dụng 2026', '15 Thg 10', 'Hội trường B - QNU', '08:00 - 16:30', 'Việc làm', 'Cơ hội kết nối với hơn 30 doanh nghiệp hàng đầu trong và ngoài tỉnh, nhận phỏng vấn trực tiếp tại chỗ.')">
                                    <div class="agenda-date-badge badge-blue">
                                        <span class="ag-day">15</span>
                                        <span class="ag-mon">T10</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Ngày hội Việc làm QNU</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Hội trường B</span>
                                            <span><i class="fa-regular fa-clock"></i> 08:00</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sự kiện 2 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-22" onclick="viewEventDetails('Giải Bóng Đá Sinh Viên QNU Cup', '22 Thg 10', 'Sân vận động trung tâm', '15:30', 'Thể thao', 'Vòng chung kết kịch tính giữa các khoa trong toàn trường, cổ vũ cuồng nhiệt.')">
                                    <div class="agenda-date-badge badge-orange">
                                        <span class="ag-day">22</span>
                                        <span class="ag-mon">T10</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Giải Bóng Đá QNU Cup</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Sân vận động</span>
                                            <span><i class="fa-regular fa-clock"></i> 15:30</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sự kiện 3 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-28" onclick="viewEventDetails('Đêm Nhạc Acoustic Confession Night', '28 Thg 10', 'Sân trường Thư viện QNU', '19:00 - 22:00', 'Âm nhạc', 'Đêm nhạc acoustic lãng mạn ngoài trời, giao lưu các tiết mục âm nhạc từ các bạn sinh viên.')">
                                    <div class="agenda-date-badge badge-purple">
                                        <span class="ag-day">28</span>
                                        <span class="ag-mon">T10</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Acoustic Confession</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Sân Thư viện</span>
                                            <span><i class="fa-regular fa-clock"></i> 19:00</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sự kiện 4 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-5" onclick="viewEventDetails('Hội Thảo AI & Kỷ Nguyên Số Cho SV', '05 Thg 11', 'Giảng đường 1 - Khoa CNTT', '09:00', 'Học thuật', 'Xu hướng trí tuệ nhân tạo và hành trang kỹ năng số quan trọng cho sinh viên thời đại mới.')">
                                    <div class="agenda-date-badge badge-cyan">
                                        <span class="ag-day">05</span>
                                        <span class="ag-mon">T11</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Hội thảo AI & Công nghệ</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Giảng đường 1</span>
                                            <span><i class="fa-regular fa-clock"></i> 09:00</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sự kiện 5 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-12" onclick="viewEventDetails('Workshop Kỹ Năng Viết CV & Phỏng Vấn', '12 Thg 11', 'Phòng Hội Thảo A2', '14:00 - 16:30', 'Học thuật', 'Trang bị kỹ năng viết CV chuẩn ATS và kỹ năng trả lời phỏng vấn chuyên nghiệp cùng các chuyên gia nhân sự.')">
                                    <div class="agenda-date-badge badge-blue">
                                        <span class="ag-day">12</span>
                                        <span class="ag-mon">T11</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Workshop Kỹ Năng CV</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Phòng Hội Thảo</span>
                                            <span><i class="fa-regular fa-clock"></i> 14:00</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sự kiện 6 -->
                                <div class="agenda-item-card agenda-card-h" id="agenda-event-20" onclick="viewEventDetails('Lễ Tri Ân Thầy Cô Ngày Nhà Giáo VN 20/11', '20 Thg 11', 'Hội trường Trung tâm', '08:30', 'Âm nhạc', 'Chương trình mít tinh kỷ niệm và tri n các thầy cô giáo nhân ngày Nhà giáo Việt Nam 20/11.')">
                                    <div class="agenda-date-badge badge-purple">
                                        <span class="ag-day">20</span>
                                        <span class="ag-mon">T11</span>
                                    </div>
                                    <div class="agenda-item-info">
                                        <span class="agenda-item-name">Tri Ân Thầy Cô 20/11</span>
                                        <div class="agenda-item-meta">
                                            <span><i class="fa-solid fa-location-dot" style="color: #ef4444;"></i> Hội trường TT</span>
                                            <span><i class="fa-regular fa-clock"></i> 08:30</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Footer bản quyền chuẩn Instagram -->
                        <div class="cal-widget-footer">
                            <div class="cal-footer-links">
                                <a href="javascript:void(0)">Giới thiệu</a> • 
                                <a href="javascript:void(0)">Trợ giúp</a> • 
                                <a href="javascript:void(0)">Báo chí</a> • 
                                <a href="javascript:void(0)">API</a> • 
                                <a href="javascript:void(0)">Điều khoản</a>
                            </div>
                            <span class="cal-copyright">&copy; 2026 QNU CONFESSION</span>
                        </div>
                    </div>
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

    <!-- Modal Xem Chi Tiết Bài Viết & Bình Luận Chuẩn Instagram (2 Cột) -->
    <jsp:include page="/WEB-INF/views/commons/post-detail-modal.jsp" />

    <!-- Modal Tùy chọn bài viết (3 chấm) chuẩn Instagram -->
    <div id="postOptionsModal" class="ig-modal-overlay" onclick="closePostOptionsModal(event)">
        <div class="post-options-dialog">
            <div class="post-options-list">
                <!-- Nút Xóa bài viết màu đỏ (hiện khi là bài của chính mình) -->
                <button type="button" id="btnOptionDeletePost" class="post-option-item text-danger" onclick="confirmDeletePost()">
                    <i class="fa-solid fa-trash-can" style="margin-right: 8px;"></i> Xóa bài viết
                </button>
                <button type="button" class="post-option-item text-cancel" onclick="closePostOptionsModal()">
                    Hủy
                </button>
            </div>
        </div>
    </div>

    <!-- Form ẩn để gửi yêu cầu xóa bài viết -->
    <form id="hiddenDeletePostForm" method="post" style="display: none;"></form>

    <!-- Modal Tạo Bài Viết Mới Chuẩn Instagram Hiện Đại -->
    <jsp:include page="/WEB-INF/views/commons/create-modal.jsp" />

    <!-- Cấu hình an toàn cho JavaScript (Tránh lỗi cú pháp JSP trong thẻ Script của Eclipse) -->
    <div id="homeConfig" data-context-path="${pageContext.request.contextPath}" style="display:none;"></div>

    <script>
        const homeConfig = document.getElementById('homeConfig');
        const contextPath = homeConfig && homeConfig.dataset.contextPath ? homeConfig.dataset.contextPath : '';

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
                    const sendBtn = document.getElementById('btnSendComment-' + postId);
                    if (sendBtn) sendBtn.disabled = true;
                    updateCommentCountUI(postId, data.commentCount);

                    const previewContainer = document.getElementById('commentsPreview-' + postId);
                    if (previewContainer) {
                        const row = document.createElement('div');
                        row.className = 'comment-preview-row';
                        row.id = 'commentItem-' + data.comment.commentId;
                        row.innerHTML = '<a href="' + contextPath + '/profile/user/' + data.comment.userId + '" class="caption-user">' + escapeHtml(data.comment.username) + '</a> ' +
                                        '<span class="caption-content">' + escapeHtml(data.comment.content) + '</span> ' +
                                        '<button type="button" class="btn-delete-comment-sm" onclick="handleDeleteComment(' + data.comment.commentId + ', ' + postId + ')" title="Xóa bình luận"><i class="fa-regular fa-trash-can"></i></button>';
                        // FIX BUG: Xóa cmt cũ, chỉ giữ đúng 1 cmt gần nhất để bài viết không bị dài theo!
                        previewContainer.innerHTML = '';
                        previewContainer.appendChild(row);
                    }
                } else {
                    alert(data.message || 'Lỗi khi gửi bình luận');
                }
            })
            .catch(err => console.error('Error adding comment:', err));
        }

        function handleFeedCommentInput(input, postId) {
            const btn = document.getElementById('btnSendComment-' + postId);
            if (btn) {
                btn.disabled = input.value.trim().length === 0;
            }
        }

        function insertQuickEmoji(postId, emoji) {
            const input = document.getElementById('commentInput-' + postId);
            if (input) {
                input.value += emoji;
                input.focus();
                handleFeedCommentInput(input, postId);
            }
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
                    const previewContainer = document.getElementById('commentsPreview-' + postId);
                    if (previewContainer) previewContainer.innerHTML = '';
                }
            }
        }

        // 6. Modal xem chi tiết bài viết & tất cả bình luận (Instagram Style 2 cột)
        function openCommentsModal(postId) {
            openPostDetailModal(postId);
        }

        function closeCommentsModal() {
            closePostDetailModal();
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
            fetch(contextPath + '/api/follow/' + userId, {
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

        // Xử lý cuộn Stories tray (Nút mũi tên chạy sang trái/phải)
        function scrollStories(offset) {
            const track = document.getElementById('storiesTrack');
            if (track) {
                track.scrollBy({ left: offset, behavior: 'smooth' });
            }
        }

        function updateStoryArrows() {
            const track = document.getElementById('storiesTrack');
            const prevBtn = document.getElementById('storyBtnPrev');
            const nextBtn = document.getElementById('storyBtnNext');
            if (!track) return;
            if (prevBtn) {
                prevBtn.style.display = track.scrollLeft > 10 ? 'flex' : 'none';
            }
            if (nextBtn) {
                const canScrollMore = track.scrollLeft + track.clientWidth < track.scrollWidth - 10;
                nextBtn.style.display = canScrollMore ? 'flex' : 'none';
            }
        }

        const storiesTrackEl = document.getElementById('storiesTrack');
        if (storiesTrackEl) {
            storiesTrackEl.addEventListener('scroll', updateStoryArrows);
            window.addEventListener('resize', updateStoryArrows);
            setTimeout(updateStoryArrows, 300);
        }

        // Tùy chọn bài viết (Dấu 3 chấm -> Xóa bài viết của chính mình)
        let selectedPostIdForOptions = null;

        function openPostOptionsModal(postId, isOwner) {
            selectedPostIdForOptions = postId;
            const modal = document.getElementById('postOptionsModal');
            const deleteBtn = document.getElementById('btnOptionDeletePost');
            const canDelete = (isOwner === true || isOwner === 'true');
            if (deleteBtn) {
                deleteBtn.style.display = canDelete ? 'block' : 'none';
            }
            if (modal) {
                modal.classList.add('show');
            }
        }

        function closePostOptionsModal(e) {
            if (e && e.target && e.target.closest && e.target.closest('.post-options-dialog')) {
                return;
            }
            const modal = document.getElementById('postOptionsModal');
            if (modal) {
                modal.classList.remove('show');
            }
        }

        function confirmDeletePost() {
            if (!selectedPostIdForOptions) return;
            if (confirm('Bạn có chắc chắn muốn xóa bài viết này không?')) {
                const form = document.getElementById('hiddenDeletePostForm');
                form.action = contextPath + '/posts/delete/' + selectedPostIdForOptions;
                form.submit();
            }
        }

        // Cuộn thanh sự kiện ngang
        function scrollAgendaTrack(offset) {
            const track = document.getElementById('calAgendaList');
            if (track) {
                track.scrollBy({ left: offset, behavior: 'smooth' });
            }
        }

        // Tương tác bấm chọn ngày trên Lịch Tháng
        function selectCalDay(day, el) {
            document.querySelectorAll('.cal-day-cell').forEach(c => c.classList.remove('selected'));
            if (el) el.classList.add('selected');
            const eventCard = document.getElementById('agenda-event-' + day);
            if (eventCard) {
                document.querySelectorAll('.agenda-item-card').forEach(c => c.classList.remove('highlighted'));
                eventCard.classList.add('highlighted');
                eventCard.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
            }
        }


        // Chuyển tháng trên Lịch
        function prevMonth() {
            alert('Đang hiển thị Lịch Sự Kiện Tháng 10 / 2026');
        }

        function nextMonth() {
            alert('Lịch sự kiện Tháng 11 / 2026 sẽ sớm được cập nhật!');
        }

        // Bookmark toggle
        function handleBookmarkPost(btn) {
            const outline = btn.querySelector('.bookmark-outline');
            const filled = btn.querySelector('.bookmark-filled');
            if (filled.style.display === 'none') {
                filled.style.display = 'block';
                outline.style.display = 'none';
                btn.classList.add('bookmarked');
            } else {
                filled.style.display = 'none';
                outline.style.display = 'block';
                btn.classList.remove('bookmarked');
            }
        }

        // Xem chi tiết sự kiện phong cách Instagram
        function viewEventDetails(title, date, location, time, category, desc) {
            const titleEl = document.getElementById('modalEventTitle');
            const dateEl = document.getElementById('modalEventDate');
            const locEl = document.getElementById('modalEventLocation');
            const timeEl = document.getElementById('modalEventTime');
            const catEl = document.getElementById('modalEventCategory');
            const descEl = document.getElementById('modalEventDesc');

            if (titleEl) titleEl.textContent = title;
            if (dateEl) dateEl.textContent = date;
            if (locEl) locEl.textContent = location;
            if (timeEl) timeEl.textContent = time;
            if (catEl) catEl.textContent = category;
            if (descEl) descEl.textContent = desc || 'Chương trình mở cửa tự do cho toàn thể sinh viên ĐH Quy Nhơn tham gia.';

            const modal = document.getElementById('eventDetailModal');
            if (modal) modal.classList.add('show');
        }

        function closeEventDetailModal(e) {
            if (e && e.target && e.target.closest && e.target.closest('.event-detail-modal-card')) return;
            const modal = document.getElementById('eventDetailModal');
            if (modal) modal.classList.remove('show');
        }

        function toggleModalInterest() {
            const btn = document.getElementById('btnModalInterest');
            if (!btn) return;
            if (btn.classList.contains('interested')) {
                btn.classList.remove('interested');
                btn.textContent = 'Quan tâm sự kiện này';
                btn.style.background = '#0095f6';
            } else {
                btn.classList.add('interested');
                btn.textContent = '✓ Đang quan tâm';
                btn.style.background = '#363636';
            }
        }

        function openAllEventsModal() {
            viewEventDetails(
                'Ngày hội Việc làm & Tuyển dụng QNU 2026',
                '15 Thg 10',
                'Hội trường B - ĐH Quy Nhơn',
                '08:00 - 16:30',
                'Tuyển dụng',
                'Chuỗi sự kiện học thuật, thể thao và văn hóa do Đoàn Trường và các CLB ĐH Quy Nhơn phối hợp tổ chức trong tháng.'
            );
        }
    </script>

    <!-- Modal Chi Tiết Sự Kiện Tối Giản Phong Cách Instagram -->
    <div class="event-detail-modal-overlay" id="eventDetailModal" onclick="closeEventDetailModal(event)">
        <div class="event-detail-modal-card" onclick="event.stopPropagation()">
            <div class="event-modal-top">
                <span class="event-modal-title-header">Chi tiết sự kiện</span>
                <button type="button" class="event-modal-close-btn" onclick="closeEventDetailModal()">&times;</button>
            </div>
            <div class="event-modal-body">
                <div class="event-modal-badge-row">
                    <span class="event-modal-cat-tag" id="modalEventCategory">Sự kiện</span>
                </div>
                <h3 class="event-modal-item-title" id="modalEventTitle">Tên sự kiện</h3>
                <div class="event-modal-meta-grid">
                    <div><i class="fa-regular fa-calendar"></i> <span id="modalEventDate">Thời gian</span></div>
                    <div><i class="fa-regular fa-clock"></i> <span id="modalEventTime">Giờ</span></div>
                    <div><i class="fa-solid fa-location-dot"></i> <span id="modalEventLocation">Địa điểm</span></div>
                </div>
                <p class="event-modal-desc" id="modalEventDesc">Mô tả sự kiện</p>
                <div class="event-modal-footer">
                    <button type="button" class="btn-modal-interest-action" id="btnModalInterest" onclick="toggleModalInterest()">Quan tâm sự kiện này</button>
                    <button type="button" class="btn-modal-dismiss" onclick="closeEventDetailModal()">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>