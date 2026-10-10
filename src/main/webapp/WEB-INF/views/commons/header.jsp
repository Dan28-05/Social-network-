<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* CSS scoped cho Search Drawer và Backdrop - Chuẩn Instagram Web 2026 */
.ig-sidebar {
    z-index: 1020 !important; /* Đảm bảo sidebar luôn nổi bật, sáng rõ và tương tác được */
}

.search-backdrop {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100vw !important;
    height: 100vh !important;
    background: rgba(0, 0, 0, 0.35) !important;
    backdrop-filter: blur(2px) !important;
    -webkit-backdrop-filter: blur(2px) !important;
    z-index: 1000 !important;
    opacity: 0 !important;
    transition: opacity 0.28s ease !important;
    pointer-events: none !important;
}

.search-backdrop.active {
    opacity: 1 !important;
    pointer-events: auto !important;
}

.ig-search-drawer {
    position: fixed !important;
    top: 0 !important;
    left: 270px !important;
    width: 397px !important;
    height: 100vh !important;
    background-color: #ffffff !important;
    border-right: 1px solid #efefef !important;
    border-top-right-radius: 16px !important;
    border-bottom-right-radius: 16px !important;
    box-shadow: 6px 0 28px rgba(0, 0, 0, 0.08) !important;
    z-index: 1010 !important;
    transform: translateX(-100%) !important;
    transition: transform 0.32s cubic-bezier(0.12, 0.9, 0.24, 1), opacity 0.2s ease !important;
    display: none;
    flex-direction: column !important;
    opacity: 0 !important;
    pointer-events: none !important;
}

.ig-search-drawer.active {
    transform: translateX(0) !important;
    opacity: 1 !important;
    pointer-events: auto !important;
}

.search-drawer-inner {
    display: flex !important;
    flex-direction: column !important;
    height: 100% !important;
    padding: 24px 0 0 0 !important;
}

.search-drawer-header {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    padding: 0 24px 22px 24px !important;
}

.search-drawer-title {
    font-size: 24px !important;
    font-weight: 700 !important;
    color: #262626 !important;
    margin: 0 !important;
    letter-spacing: -0.5px !important;
}

.search-drawer-close {
    background: transparent !important;
    border: none !important;
    color: #737373 !important;
    width: 32px !important;
    height: 32px !important;
    border-radius: 50% !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 15px !important;
    cursor: pointer !important;
    transition: all 0.15s ease !important;
    padding: 0 !important;
}

.search-drawer-close:hover {
    background: #f2f2f2 !important;
    color: #262626 !important;
}

#searchModal .search-input-box {
    margin: 0 24px 16px 24px !important;
    position: relative !important;
    display: flex !important;
    align-items: center !important;
    background-color: #efefef !important;
    border: 1px solid transparent !important;
    border-radius: 10px !important;
    height: 42px !important;
    padding: 0 14px !important;
    gap: 10px !important;
    transition: all 0.2s ease !important;
}

#searchModal .search-input-box:focus-within {
    background-color: #ffffff !important;
    border-color: #dbdbdb !important;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
}

#searchModal .search-input-icon {
    color: #8e8e8e !important;
    font-size: 15px !important;
    flex-shrink: 0 !important;
    transition: color 0.2s !important;
}

#searchModal .search-input-box:focus-within .search-input-icon {
    color: #262626 !important;
}

#searchModal .search-input-box input {
    background: transparent !important;
    border: none !important;
    color: #262626 !important;
    font-size: 14.5px !important;
    font-weight: 400 !important;
    width: 100% !important;
    outline: none !important;
    padding: 0 !important;
}

#searchModal .search-input-box input::placeholder {
    color: #8e8e8e !important;
}

#searchModal .search-clear-btn {
    background: #c7c7c7 !important;
    border: none !important;
    color: #ffffff !important;
    border-radius: 50% !important;
    width: 17px !important;
    height: 17px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 10px !important;
    cursor: pointer !important;
    flex-shrink: 0 !important;
    padding: 0 !important;
    transition: background 0.15s !important;
}

#searchModal .search-clear-btn:hover {
    background: #8e8e8e !important;
}

.search-divider-line {
    height: 1px !important;
    background-color: #efefef !important;
    margin: 0 !important;
    flex-shrink: 0 !important;
}

.search-section-header {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    padding: 16px 24px 8px 24px !important;
    flex-shrink: 0 !important;
}

.search-section-title {
    font-size: 14.5px !important;
    font-weight: 700 !important;
    color: #262626 !important;
    letter-spacing: -0.2px !important;
}

.search-section-action {
    font-size: 13px !important;
    font-weight: 600 !important;
    color: #0095f6 !important;
    cursor: pointer !important;
    background: none !important;
    border: none !important;
    padding: 0 !important;
    text-decoration: none !important;
}

.search-section-action:hover {
    color: #00376b !important;
}

.search-results-list {
    flex: 1 !important;
    overflow-y: auto !important;
    scrollbar-width: thin !important;
    padding: 4px 12px 24px 12px !important;
    display: flex !important;
    flex-direction: column !important;
    gap: 3px !important;
}

.search-user-card-wrap {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    border-radius: 12px !important;
    transition: background-color 0.15s ease !important;
    padding: 6px 10px !important;
}

.search-user-card-wrap:hover {
    background-color: #f7f7f7 !important;
}

.search-user-card-wrap .search-user-card {
    flex: 1 !important;
    background: transparent !important;
    display: flex !important;
    align-items: center !important;
    gap: 12px !important;
    padding: 4px 0 !important;
    text-decoration: none !important;
    color: inherit !important;
    min-width: 0 !important;
}

.search-user-avatar {
    width: 44px !important;
    height: 44px !important;
    border-radius: 50% !important;
    object-fit: cover !important;
    flex-shrink: 0 !important;
    border: 1px solid #efefef !important;
}

.search-user-info {
    flex: 1 !important;
    min-width: 0 !important;
    display: flex !important;
    flex-direction: column !important;
    gap: 2px !important;
}

.search-user-handle {
    font-size: 14px !important;
    font-weight: 600 !important;
    color: #262626 !important;
    white-space: nowrap !important;
    overflow: hidden !important;
    text-overflow: ellipsis !important;
    display: flex !important;
    align-items: center !important;
    gap: 4px !important;
}

.search-user-fullname {
    font-size: 13px !important;
    color: #737373 !important;
    white-space: nowrap !important;
    overflow: hidden !important;
    text-overflow: ellipsis !important;
}

.search-chat-btn {
    color: #737373 !important;
    font-size: 15px !important;
    width: 36px !important;
    height: 36px !important;
    border-radius: 50% !important;
    transition: all 0.2s ease !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    flex-shrink: 0 !important;
    text-decoration: none !important;
}

.search-chat-btn:hover {
    color: #0095f6 !important;
    background-color: #e0f1ff !important;
    transform: scale(1.08) !important;
}

.search-empty-state {
    padding: 60px 24px !important;
    text-align: center !important;
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: center !important;
}

.search-empty-icon-circle {
    width: 62px !important;
    height: 62px !important;
    border-radius: 50% !important;
    border: 2px solid #262626 !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 24px !important;
    color: #262626 !important;
    margin-bottom: 16px !important;
    opacity: 0.8 !important;
}

.search-empty-heading {
    font-size: 15px !important;
    font-weight: 700 !important;
    color: #262626 !important;
    margin-bottom: 6px !important;
}

.search-empty-desc {
    font-size: 13px !important;
    color: #737373 !important;
    line-height: 1.4 !important;
    max-width: 240px !important;
}

.search-loading-state {
    padding: 40px 20px !important;
    text-align: center !important;
    color: #737373 !important;
    font-size: 14px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    gap: 8px !important;
}
</style>

<!-- Instagram Left Sidebar Navigation (Dark Mode) -->
<aside class="ig-sidebar">
    <!-- QNU_Confesstion Logo Top -->
    <div class="sidebar-logo">
        <a href="${pageContext.request.contextPath}/" class="logo-full">
            <span class="logo-text">QNU_Confesstion</span>
        </a>
        <a href="${pageContext.request.contextPath}/" class="logo-compact" title="QNU_Confesstion">
            <i class="fa-brands fa-instagram"></i>
        </a>
    </div>

    <!-- Navigation Menu Items -->
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/" class="nav-item" title="Trang chủ (Home)">
            <i class="fa-solid fa-house nav-icon"></i>
            <span class="nav-label">Home</span>
        </a>

        <a href="javascript:void(0)" class="nav-item" id="navItemSearch" onclick="openSearchModal()" title="Tìm kiếm (Search)">
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

        <a href="${pageContext.request.contextPath}/direct" class="nav-item" title="Tin nhắn (Messages)">
            <i class="fa-brands fa-facebook-messenger nav-icon"></i>
            <span class="nav-label">Messages</span>
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

<!-- Backdrop che nền khi mở Drawer tìm kiếm -->
<div id="searchBackdrop" class="search-backdrop" onclick="closeSearchModal()" style="display: none;"></div>

<!-- Instagram Search Drawer (Panel tìm kiếm người dùng hiện đại) -->
<div id="searchModal" class="ig-search-drawer" style="display: none;">
    <div class="search-drawer-inner">
        <!-- Header -->
        <div class="search-drawer-header">
            <h2 class="search-drawer-title">Tìm kiếm</h2>
            <button type="button" class="search-drawer-close" onclick="closeSearchModal()" title="Đóng tìm kiếm">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <!-- Search Input Box -->
        <div class="search-input-box">
            <i class="fa-solid fa-magnifying-glass search-input-icon"></i>
            <input type="text" id="globalSearchInput" placeholder="Tìm kiếm bạn bè, tài khoản..." autocomplete="off" oninput="handleGlobalSearch(this.value)">
            <button type="button" class="search-clear-btn" id="searchClearBtn" onclick="clearGlobalSearch()" style="display: none;" title="Xóa">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <!-- Divider Line -->
        <div class="search-divider-line"></div>

        <!-- Section Header (Gợi ý cho bạn / Kết quả tìm kiếm) -->
        <div class="search-section-header" id="searchSectionHeader">
            <span class="search-section-title" id="searchSectionTitle">Gợi ý cho bạn</span>
        </div>

        <!-- Results List -->
        <div class="search-results-list" id="globalSearchResults">
            <div class="search-loading-state">
                <i class="fa-solid fa-spinner fa-spin"></i> Đang tải danh sách...
            </div>
        </div>
    </div>
</div>

<div id="searchConfig" data-context-path="${pageContext.request.contextPath}" style="display:none;"></div>

<script>
    let searchDebounceTimer = null;

    function getSearchContextPath() {
        const cfg = document.getElementById('searchConfig');
        return cfg && cfg.dataset.contextPath ? cfg.dataset.contextPath : '';
    }

    function openSearchModal() {
        const modal = document.getElementById('searchModal');
        const backdrop = document.getElementById('searchBackdrop');
        const input = document.getElementById('globalSearchInput');
        const navSearch = document.getElementById('navItemSearch');

        if (navSearch) navSearch.classList.add('active');

        if (backdrop) {
            backdrop.style.display = 'block';
            setTimeout(() => backdrop.classList.add('active'), 10);
        }

        if (modal) {
            modal.style.display = 'flex';
            setTimeout(() => {
                modal.classList.add('active');
                if (input) {
                    input.focus();
                    // Nếu ô tìm kiếm đang trống, tải danh sách gợi ý ngay lập tức
                    if (!input.value.trim()) {
                        handleGlobalSearch('');
                    }
                }
            }, 10);
        }
    }

    function closeSearchModal() {
        const modal = document.getElementById('searchModal');
        const backdrop = document.getElementById('searchBackdrop');
        const navSearch = document.getElementById('navItemSearch');

        if (navSearch) navSearch.classList.remove('active');

        if (modal) {
            modal.classList.remove('active');
            setTimeout(() => {
                if (!modal.classList.contains('active')) {
                    modal.style.display = 'none';
                }
            }, 300);
        }

        if (backdrop) {
            backdrop.classList.remove('active');
            setTimeout(() => {
                if (!backdrop.classList.contains('active')) {
                    backdrop.style.display = 'none';
                }
            }, 300);
        }
    }

    function clearGlobalSearch() {
        const input = document.getElementById('globalSearchInput');
        const clearBtn = document.getElementById('searchClearBtn');
        if (input) {
            input.value = '';
            input.focus();
        }
        if (clearBtn) clearBtn.style.display = 'none';
        handleGlobalSearch('');
    }

    function handleGlobalSearch(query) {
        const clearBtn = document.getElementById('searchClearBtn');
        const results = document.getElementById('globalSearchResults');
        const titleEl = document.getElementById('searchSectionTitle');
        const q = (query || '').trim();

        if (clearBtn) {
            clearBtn.style.display = q.length > 0 ? 'flex' : 'none';
        }

        if (searchDebounceTimer) {
            clearTimeout(searchDebounceTimer);
        }

        const delay = q.length === 0 ? 0 : 200;

        searchDebounceTimer = setTimeout(() => {
            const ctx = getSearchContextPath();
            const fetchUrl = q.length === 0 ? (ctx + '/api/users/search') : (ctx + '/api/users/search?q=' + encodeURIComponent(q));

            if (results && q.length > 0) {
                results.innerHTML = '<div class="search-loading-state"><i class="fa-solid fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
            }

            fetch(fetchUrl)
                .then(res => res.json())
                .then(data => {
                    if (titleEl) {
                        titleEl.innerText = (data.isSuggested || q.length === 0) ? 'Gợi ý cho bạn' : 'Kết quả tìm kiếm';
                    }

                    if (data.success && data.users && data.users.length > 0) {
                        let html = '';
                        data.users.forEach(u => {
                            const avatar = u.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
                            const fullname = u.fullname || u.bio || 'Sinh viên QNU';
                            html += '<div class="search-user-card-wrap">' +
                                        '<a href="' + ctx + '/profile/user/' + u.userId + '" class="search-user-card">' +
                                            '<img src="' + escapeHtmlSearch(avatar) + '" alt="' + escapeHtmlSearch(u.username) + '" class="search-user-avatar" onerror="this.src=\'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150\'">' +
                                            '<div class="search-user-info">' +
                                                '<div class="search-user-handle">' +
                                                    escapeHtmlSearch(u.username) +
                                                '</div>' +
                                                '<div class="search-user-fullname">' + escapeHtmlSearch(fullname) + '</div>' +
                                            '</div>' +
                                        '</a>' +
                                        '<a href="' + ctx + '/direct?userId=' + u.userId + '" class="search-chat-btn" title="Gửi tin nhắn">' +
                                            '<i class="fa-regular fa-paper-plane"></i>' +
                                        '</a>' +
                                    '</div>';
                        });
                        results.innerHTML = html;
                    } else {
                        if (q.length > 0) {
                            results.innerHTML = '<div class="search-empty-state">' +
                                                    '<div class="search-empty-icon-circle"><i class="fa-solid fa-magnifying-glass"></i></div>' +
                                                    '<div class="search-empty-heading">Không tìm thấy người dùng</div>' +
                                                    '<div class="search-empty-desc">Không có kết quả nào phù hợp với từ khóa "' + escapeHtmlSearch(q) + '"</div>' +
                                                '</div>';
                        } else {
                            results.innerHTML = '<div class="search-empty-state">' +
                                                    '<div class="search-empty-icon-circle"><i class="fa-regular fa-user"></i></div>' +
                                                    '<div class="search-empty-heading">Chưa có gợi ý nào</div>' +
                                                    '<div class="search-empty-desc">Hãy nhập tên hoặc tài khoản để tìm kiếm bạn bè.</div>' +
                                                '</div>';
                        }
                    }
                })
                .catch(() => {
                    if (results) {
                        results.innerHTML = '<div class="search-empty-state"><div class="search-empty-desc" style="color: #ed4956;">Không thể tải dữ liệu tìm kiếm lúc này.</div></div>';
                    }
                });
        }, delay);
    }

    function escapeHtmlSearch(text) {
        if (!text) return '';
        const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeSearchModal();
        }
    });
</script>
