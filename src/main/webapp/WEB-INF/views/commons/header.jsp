<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* CSS scoped cho Search Drawer và Backdrop để đảm bảo hiển thị đúng trên mọi trang */
.search-backdrop {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100vw !important;
    height: 100vh !important;
    background: rgba(0, 0, 0, 0.65) !important;
    backdrop-filter: blur(3px) !important;
    z-index: 1000 !important;
    opacity: 0 !important;
    transition: opacity 0.25s ease !important;
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
    border-right: 1px solid #dbdbdb !important;
    box-shadow: 4px 0 24px rgba(0, 0, 0, 0.15) !important;
    z-index: 1001 !important;
    transform: translateX(-100%) !important;
    transition: transform 0.28s cubic-bezier(0.1, 0.9, 0.2, 1), opacity 0.25s !important;
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
    padding: 24px 0 !important;
}

.search-drawer-header {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    padding: 0 24px 20px 24px !important;
}

.search-drawer-title {
    font-size: 24px !important;
    font-weight: 700 !important;
    color: #262626 !important;
    margin: 0 !important;
}

.search-drawer-close {
    background: transparent !important;
    border: none !important;
    color: #737373 !important;
    font-size: 28px !important;
    line-height: 1 !important;
    cursor: pointer !important;
    transition: color 0.15s !important;
    padding: 0 6px !important;
}

.search-drawer-close:hover {
    color: #262626 !important;
}

#searchModal .search-input-box {
    margin: 0 24px 18px 24px !important;
    position: relative !important;
    display: flex !important;
    align-items: center !important;
    background-color: #efefef !important;
    border: 1px solid #dbdbdb !important;
    border-radius: 12px !important;
    padding: 9px 16px !important;
    gap: 12px !important;
    box-shadow: none !important;
    transition: box-shadow 0.2s, background-color 0.2s !important;
}

#searchModal .search-input-box:focus-within {
    background-color: #ffffff !important;
    border-color: #0095f6 !important;
    box-shadow: 0 0 0 1.5px rgba(0, 149, 246, 0.2) !important;
}

#searchModal .search-input-icon {
    color: #8e8e8e !important;
    font-size: 15px !important;
    flex-shrink: 0 !important;
}

#searchModal .search-input-box input {
    background: transparent !important;
    border: none !important;
    color: #262626 !important;
    font-size: 14.5px !important;
    width: 100% !important;
    outline: none !important;
    padding: 0 !important;
}

#searchModal .search-input-box input::placeholder {
    color: #8e8e8e !important;
}

#searchModal .search-clear-btn {
    background: #dbdbdb !important;
    border: none !important;
    color: #737373 !important;
    border-radius: 50% !important;
    width: 18px !important;
    height: 18px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    font-size: 13px !important;
    cursor: pointer !important;
    flex-shrink: 0 !important;
    padding: 0 !important;
    transition: background 0.15s !important;
}

#searchModal .search-clear-btn:hover {
    background: #b0b0b0 !important;
    color: #262626 !important;
}

.search-results-list {
    flex: 1 !important;
    overflow-y: auto !important;
    scrollbar-width: thin !important;
    padding: 0 12px !important;
    display: flex !important;
    flex-direction: column !important;
    gap: 4px !important;
}

.search-empty-hint {
    padding: 40px 20px !important;
    text-align: center !important;
    color: #737373 !important;
    font-size: 14px !important;
}

.search-user-card-wrap {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    border-radius: 12px !important;
    transition: background-color 0.15s ease !important;
    padding-right: 8px !important;
}

.search-user-card-wrap:hover {
    background-color: #f2f2f2 !important;
}

.search-user-card-wrap .search-user-card {
    flex: 1 !important;
    background: transparent !important;
    display: flex !important;
    align-items: center !important;
    gap: 14px !important;
    padding: 10px 14px !important;
    text-decoration: none !important;
    color: inherit !important;
}

.search-user-avatar {
    width: 48px !important;
    height: 48px !important;
    border-radius: 50% !important;
    object-fit: cover !important;
    flex-shrink: 0 !important;
    border: 1px solid #dbdbdb !important;
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
    font-size: 16px !important;
    padding: 8px 10px !important;
    border-radius: 8px !important;
    transition: color 0.15s, background-color 0.15s, transform 0.15s !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
}

.search-chat-btn:hover {
    color: #0095f6 !important;
    background-color: #efefef !important;
    transform: scale(1.1) !important;
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

<!-- Instagram Search Drawer (Panel tìm kiếm người dùng) -->
<div id="searchModal" class="ig-search-drawer" style="display: none;">
    <div class="search-drawer-inner">
        <div class="search-drawer-header">
            <h2 class="search-drawer-title">Tìm kiếm</h2>
            <button type="button" class="search-drawer-close" onclick="closeSearchModal()">&times;</button>
        </div>
        <div class="search-input-box">
            <i class="fa-solid fa-magnifying-glass search-input-icon"></i>
            <input type="text" id="globalSearchInput" placeholder="Tìm kiếm người dùng..." autocomplete="off" oninput="handleGlobalSearch(this.value)">
            <button type="button" class="search-clear-btn" id="searchClearBtn" onclick="clearGlobalSearch()" style="display: none;">&times;</button>
        </div>
        <div class="search-results-list" id="globalSearchResults">
            <div class="search-empty-hint">
                <i class="fa-solid fa-magnifying-glass" style="font-size: 26px; margin-bottom: 12px; display: block; color: #555;"></i>
                Nhập tên hoặc tài khoản để tìm kiếm...
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
                if (input) input.focus();
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
            }, 280);
        }

        if (backdrop) {
            backdrop.classList.remove('active');
            setTimeout(() => {
                if (!backdrop.classList.contains('active')) {
                    backdrop.style.display = 'none';
                }
            }, 280);
        }
    }

    function clearGlobalSearch() {
        const input = document.getElementById('globalSearchInput');
        const clearBtn = document.getElementById('searchClearBtn');
        const results = document.getElementById('globalSearchResults');
        if (input) {
            input.value = '';
            input.focus();
        }
        if (clearBtn) clearBtn.style.display = 'none';
        if (results) {
            results.innerHTML = '<div class="search-empty-hint"><i class="fa-solid fa-magnifying-glass" style="font-size: 26px; margin-bottom: 12px; display: block; color: #555;"></i>Nhập tên hoặc tài khoản để tìm kiếm...</div>';
        }
    }

    function handleGlobalSearch(query) {
        const clearBtn = document.getElementById('searchClearBtn');
        const results = document.getElementById('globalSearchResults');
        const q = (query || '').trim();

        if (clearBtn) {
            clearBtn.style.display = q.length > 0 ? 'flex' : 'none';
        }

        if (!q) {
            if (results) {
                results.innerHTML = '<div class="search-empty-hint"><i class="fa-solid fa-magnifying-glass" style="font-size: 26px; margin-bottom: 12px; display: block; color: #555;"></i>Nhập tên hoặc tài khoản để tìm kiếm...</div>';
            }
            return;
        }

        if (searchDebounceTimer) {
            clearTimeout(searchDebounceTimer);
        }

        searchDebounceTimer = setTimeout(() => {
            if (results) {
                results.innerHTML = '<div class="search-empty-hint">Đang tìm kiếm...</div>';
            }
            const ctx = getSearchContextPath();
            fetch(ctx + '/api/users/search?q=' + encodeURIComponent(q))
                .then(res => res.json())
                .then(data => {
                    if (data.success && data.users && data.users.length > 0) {
                        let html = '';
                        data.users.forEach(u => {
                            const avatar = u.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
                            const fullname = u.fullname ? u.fullname : '';
                            html += '<div class="search-user-card-wrap">' +
                                        '<a href="' + ctx + '/profile/user/' + u.userId + '" class="search-user-card">' +
                                            '<img src="' + escapeHtmlSearch(avatar) + '" alt="' + escapeHtmlSearch(u.username) + '" class="search-user-avatar">' +
                                            '<div class="search-user-info">' +
                                                '<div class="search-user-handle">' + escapeHtmlSearch(u.username) + '</div>' +
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
                        results.innerHTML = '<div class="search-empty-hint">Không tìm thấy người dùng phù hợp.</div>';
                    }
                })
                .catch(() => {
                    if (results) {
                        results.innerHTML = '<div class="search-empty-hint" style="color: #ed4956;">Lỗi khi tìm kiếm. Vui lòng thử lại.</div>';
                    }
                });
        }, 250);
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
