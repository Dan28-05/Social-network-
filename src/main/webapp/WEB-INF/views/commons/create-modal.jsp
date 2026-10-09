<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Modal Tạo Bài Viết Mới Chuẩn Instagram Hiện Đại -->
<div class="ig-modal-overlay" id="createPostModal">
    <div class="ig-create-dialog" id="createDialog">
        <!-- Top Header Thanh Tiêu Đề Modal -->
        <div class="create-modal-header">
            <button type="button" class="btn-create-back" id="btnCreateBack" onclick="resetCreateMedia()" style="display: none;" title="Chọn lại ảnh/video khác">
                <i class="fa-solid fa-arrow-left"></i>
            </button>
            <h3 class="create-modal-title" id="createModalTitle">Tạo bài viết mới</h3>
            <button type="button" class="btn-create-share" id="btnCreateShare" onclick="submitCreateForm()" style="display: none;">
                Chia sẻ
            </button>
            <button type="button" class="btn-create-close" id="btnCreateClose" onclick="closeCreateModal()" title="Đóng">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form id="createPostForm" action="${pageContext.request.contextPath}/posts/create" method="post" enctype="multipart/form-data" class="create-post-form">
            <!-- Ẩn Input File Thực Tế (nhận file từ máy tính) -->
            <input type="file" id="mediaFileInput" name="mediaFile" accept="image/*,video/*" style="display: none;" onchange="handleFileSelected(this.files)" />

            <!-- GIAI ĐOẠN 1: Khu Vực Kéo Thả / Chọn File Từ Máy Tính (Dropzone) -->
            <div class="create-dropzone-section" id="dropzoneSection">
                <div class="dropzone-box" id="dropzoneBox" onclick="document.getElementById('mediaFileInput').click()">
                    <div class="dropzone-icon-circle">
                        <i class="fa-solid fa-photo-film"></i>
                    </div>
                    <h4 class="dropzone-text">Kéo ảnh và video vào đây</h4>
                    <p class="dropzone-subtext">Hỗ trợ các định dạng JPG, PNG, WEBP, MP4, WEBM...</p>
                    
                    <button type="button" class="btn-select-computer" onclick="event.stopPropagation(); document.getElementById('mediaFileInput').click();">
                        <i class="fa-solid fa-desktop"></i> Chọn từ máy tính
                    </button>
                </div>

                <!-- Tùy chọn phụ: Dán URL nếu muốn -->
                <div class="dropzone-url-fallback">
                    <button type="button" class="btn-toggle-url" onclick="toggleUrlInput()">
                        <i class="fa-solid fa-link"></i> Hoặc dán đường dẫn ảnh / video từ Internet
                    </button>
                    <div class="url-input-wrap" id="urlInputWrap" style="display: none;">
                        <div class="url-input-inner">
                            <input type="url" id="mediaUrlInput" name="imageUrl" class="ig-dark-input" placeholder="https://images.unsplash.com/... hoặc link mp4" />
                            <button type="button" class="btn-apply-url" onclick="handleUrlPreview()">Xem trước</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- GIAI ĐOẠN 2: Bố Cục 2 Cột Chuẩn Instagram Khi Đã Chọn Media (Xem Trước + Soạn Thảo) -->
            <div class="create-preview-section" id="previewSection" style="display: none;">
                <!-- Cột Trái: Khung Hiển Thị Xem Trước Ảnh / Video -->
                <div class="create-media-col">
                    <div class="media-display-container">
                        <!-- Xem trước ảnh -->
                        <img id="previewImageEl" src="" alt="Xem trước ảnh" class="preview-media-item" style="display: none;" />
                        <!-- Xem trước video -->
                        <video id="previewVideoEl" src="" controls autoplay muted loop playsinline class="preview-media-item" style="display: none;"></video>
                    </div>

                    <!-- Thanh thông tin file bên dưới -->
                    <div class="preview-media-info">
                        <span class="media-file-badge" id="mediaFileInfo"><i class="fa-regular fa-file-image"></i> Chưa có file</span>
                        <button type="button" class="btn-change-media" onclick="document.getElementById('mediaFileInput').click()">
                            <i class="fa-solid fa-arrow-rotate-right"></i> Đổi file
                        </button>
                    </div>
                </div>

                <!-- Cột Phải: Thông Tin Tác Giả & Soạn Thảo Caption -->
                <div class="create-caption-col">
                    <!-- Tác giả bài viết -->
                    <div class="create-author-row">
                        <img src="${currentUser.avatar}" alt="${currentUser.username}" class="create-author-avatar">
                        <span class="create-author-name">${currentUser.username}</span>
                    </div>

                    <!-- Ô nhập Caption -->
                    <div class="create-textarea-wrap">
                        <textarea id="captionTextarea" name="caption" rows="6" class="create-caption-textarea" placeholder="Viết chú thích..." maxlength="2200" oninput="updateCharCount(this)"></textarea>
                    </div>

                    <!-- Khay Emoji Nhanh -->
                    <div class="quick-emoji-bar">
                        <span class="emoji-chip" onclick="insertEmoji('😊')">😊</span>
                        <span class="emoji-chip" onclick="insertEmoji('❤️')">❤️</span>
                        <span class="emoji-chip" onclick="insertEmoji('🔥')">🔥</span>
                        <span class="emoji-chip" onclick="insertEmoji('👏')">👏</span>
                        <span class="emoji-chip" onclick="insertEmoji('✨')">✨</span>
                        <span class="emoji-chip" onclick="insertEmoji('🎉')">🎉</span>
                        <span class="emoji-chip" onclick="insertEmoji('☕')">☕</span>
                        <span class="emoji-chip" onclick="insertEmoji('🌿')">🌿</span>
                    </div>

                    <div class="caption-counter-row">
                        <span class="char-count" id="charCount">0/2,200</span>
                    </div>

                    <!-- Thông tin bổ sung (Vị trí) -->
                    <div class="create-extra-field">
                        <div class="extra-input-row">
                            <i class="fa-solid fa-location-dot"></i>
                            <input type="text" placeholder="Thêm vị trí (Hà Nội, TP.HCM...)" class="extra-input" />
                        </div>
                    </div>

                    <!-- Nút Chia sẻ ở đáy cho màn hình di động/tablet -->
                    <div class="create-mobile-footer">
                        <button type="button" class="btn-mobile-cancel" onclick="closeCreateModal()">Hủy</button>
                        <button type="submit" class="btn-mobile-share">Chia sẻ bài viết</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    let activeMediaObjectUrl = null;

    function openCreateModal() {
        const modal = document.getElementById('createPostModal');
        if (modal) {
            modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }
    }

    function closeCreateModal() {
        const modal = document.getElementById('createPostModal');
        if (modal) {
            modal.classList.remove('show');
            document.body.style.overflow = '';
            // Reset modal về trạng thái ban đầu
            setTimeout(resetCreateMedia, 200);
        }
    }

    // Đóng khi click ngoài hộp thoại
    window.addEventListener('click', function(e) {
        const modal = document.getElementById('createPostModal');
        if (e.target === modal) {
            closeCreateModal();
        }
    });

    // Bật/tắt dán URL
    function toggleUrlInput() {
        const wrap = document.getElementById('urlInputWrap');
        if (wrap) {
            wrap.style.display = wrap.style.display === 'none' ? 'block' : 'none';
        }
    }

    // Xử lý khi chọn file từ máy tính
    function handleFileSelected(files) {
        if (!files || files.length === 0) return;
        const file = files[0];

        if (activeMediaObjectUrl) {
            URL.revokeObjectURL(activeMediaObjectUrl);
        }
        activeMediaObjectUrl = URL.createObjectURL(file);

        const isVideo = file.type.startsWith('video/');
        const imgEl = document.getElementById('previewImageEl');
        const videoEl = document.getElementById('previewVideoEl');
        const fileInfoEl = document.getElementById('mediaFileInfo');

        // Hiển thị kích thước file đẹp
        const sizeFormatted = (file.size / (1024 * 1024)).toFixed(1) + ' MB';
        fileInfoEl.innerHTML = (isVideo ? '<i class="fa-solid fa-video"></i> ' : '<i class="fa-solid fa-image"></i> ') + file.name + ' (' + sizeFormatted + ')';

        if (isVideo) {
            imgEl.style.display = 'none';
            imgEl.src = '';
            videoEl.src = activeMediaObjectUrl;
            videoEl.style.display = 'block';
            videoEl.load();
        } else {
            videoEl.style.display = 'none';
            videoEl.src = '';
            imgEl.src = activeMediaObjectUrl;
            imgEl.style.display = 'block';
        }

        // Chuyển sang bố cục 2 cột xem trước của Instagram
        switchToPreviewMode();
    }

    // Xử lý xem trước URL dán vào
    function handleUrlPreview() {
        const urlInput = document.getElementById('mediaUrlInput');
        const url = urlInput ? urlInput.value.trim() : '';
        if (!url) {
            alert('Vui lòng dán đường dẫn ảnh hoặc video hợp lệ!');
            return;
        }

        const lower = url.toLowerCase();
        const isVideo = lower.endsWith('.mp4') || lower.endsWith('.webm') || lower.endsWith('.mov');
        const imgEl = document.getElementById('previewImageEl');
        const videoEl = document.getElementById('previewVideoEl');
        const fileInfoEl = document.getElementById('mediaFileInfo');

        fileInfoEl.innerHTML = '<i class="fa-solid fa-link"></i> ' + (isVideo ? 'Video từ liên kết' : 'Ảnh từ liên kết');

        if (isVideo) {
            imgEl.style.display = 'none';
            imgEl.src = '';
            videoEl.src = url;
            videoEl.style.display = 'block';
        } else {
            videoEl.style.display = 'none';
            videoEl.src = '';
            imgEl.src = url;
            imgEl.style.display = 'block';
        }

        switchToPreviewMode();
    }

    // Chuyển sang chế độ xem trước (2 cột)
    function switchToPreviewMode() {
        document.getElementById('dropzoneSection').style.display = 'none';
        document.getElementById('previewSection').style.display = 'flex';
        document.getElementById('btnCreateBack').style.display = 'block';
        document.getElementById('btnCreateShare').style.display = 'block';
        document.getElementById('btnCreateClose').style.display = 'none';
        document.getElementById('createDialog').classList.add('expanded');
    }

    // Reset lại khi muốn chọn file khác
    function resetCreateMedia() {
        if (activeMediaObjectUrl) {
            URL.revokeObjectURL(activeMediaObjectUrl);
            activeMediaObjectUrl = null;
        }
        document.getElementById('mediaFileInput').value = '';
        const urlInput = document.getElementById('mediaUrlInput');
        if (urlInput) urlInput.value = '';

        const imgEl = document.getElementById('previewImageEl');
        const videoEl = document.getElementById('previewVideoEl');
        imgEl.src = '';
        imgEl.style.display = 'none';
        videoEl.src = '';
        videoEl.style.display = 'none';

        document.getElementById('dropzoneSection').style.display = 'block';
        document.getElementById('previewSection').style.display = 'none';
        document.getElementById('btnCreateBack').style.display = 'none';
        document.getElementById('btnCreateShare').style.display = 'none';
        document.getElementById('btnCreateClose').style.display = 'block';
        document.getElementById('createDialog').classList.remove('expanded');
    }

    function submitCreateForm() {
        document.getElementById('createPostForm').submit();
    }

    function updateCharCount(el) {
        document.getElementById('charCount').textContent = el.value.length.toLocaleString() + '/2,200';
    }

    function insertEmoji(emoji) {
        const textarea = document.getElementById('captionTextarea');
        if (!textarea) return;
        const start = textarea.selectionStart;
        const end = textarea.selectionEnd;
        const text = textarea.value;
        textarea.value = text.substring(0, start) + emoji + text.substring(end);
        textarea.focus();
        textarea.selectionStart = textarea.selectionEnd = start + emoji.length;
        updateCharCount(textarea);
    }

    // Kéo thả file Drag & Drop
    (function initDragAndDrop() {
        const dropzone = document.getElementById('dropzoneBox');
        if (!dropzone) return;

        ['dragenter', 'dragover'].forEach(eventName => {
            dropzone.addEventListener(eventName, function(e) {
                e.preventDefault();
                e.stopPropagation();
                dropzone.classList.add('drag-active');
            }, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropzone.addEventListener(eventName, function(e) {
                e.preventDefault();
                e.stopPropagation();
                dropzone.classList.remove('drag-active');
            }, false);
        });

        dropzone.addEventListener('drop', function(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files && files.length > 0) {
                document.getElementById('mediaFileInput').files = files;
                handleFileSelected(files);
            }
        }, false);
    })();
</script>
