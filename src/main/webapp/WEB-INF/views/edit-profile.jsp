<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa trang cá nhân &bull; QNU_Confesstion</title>
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

        <!-- Phần thân chính -->
        <div class="ig-main-container">
            <main class="ig-settings-layout">
                <div class="ig-settings-card">
                    <h2 class="settings-title">Chỉnh sửa trang cá nhân</h2>

                    <c:if test="${not empty error}">
                        <div class="auth-error-msg">
                            <i class="fa-solid fa-circle-exclamation"></i> ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile/edit" method="post" enctype="multipart/form-data" class="dark-settings-form">
                        <!-- Khung đổi Avatar Hiện Đại Chuẩn Instagram -->
                        <div class="settings-avatar-row">
                            <div class="settings-avatar-wrapper" onclick="document.getElementById('avatarFileInput').click()" title="Bấm vào đây để chọn ảnh đại diện mới từ máy tính">
                                <img src="${user.avatar}" alt="${user.username}" id="avatarPreviewImg" class="settings-avatar-img">
                                <div class="avatar-hover-overlay">
                                    <i class="fa-solid fa-camera"></i>
                                </div>
                            </div>
                            <div class="settings-avatar-text">
                                <span class="avatar-handle">${user.username}</span>
                                <button type="button" class="btn-change-avatar-blue" onclick="document.getElementById('avatarFileInput').click()">
                                    <i class="fa-solid fa-cloud-arrow-up"></i> Đổi ảnh đại diện từ máy tính
                                </button>
                                <span class="avatar-selected-name" id="avatarFileName">Hỗ trợ JPG, PNG, WEBP</span>
                            </div>
                            <!-- Input File Ẩn (Nhận file từ máy tính) -->
                            <input type="file" id="avatarFileInput" name="avatarFile" accept="image/*" style="display: none;" onchange="handleAvatarFileSelect(this)" />
                        </div>

                        <!-- Tùy chọn phụ: Dán URL ảnh nếu muốn -->
                        <div class="avatar-url-toggle-wrap">
                            <button type="button" class="btn-toggle-avatar-url" onclick="toggleAvatarUrlInput()">
                                <i class="fa-solid fa-link"></i> Hoặc dán đường dẫn ảnh URL trực tuyến
                            </button>
                            <div id="avatarUrlGroup" class="dark-form-group" style="display: none; margin-top: 10px;">
                                <label for="avatar">URL ảnh đại diện trực tuyến</label>
                                <input type="text" id="avatar" name="avatar" value="${user.avatar.startsWith('http') ? user.avatar : ''}" class="ig-dark-input" placeholder="https://images.unsplash.com/..." oninput="handleAvatarUrlInput(this.value)" />
                            </div>
                        </div>

                        <!-- Họ và tên -->
                        <div class="dark-form-group">
                            <label for="fullname">Họ và tên</label>
                            <input type="text" id="fullname" name="fullname" value="${user.fullname}" class="ig-dark-input" required />
                        </div>

                        <!-- Tên người dùng -->
                        <div class="dark-form-group">
                            <label for="username">Tên người dùng</label>
                            <input type="text" id="username" value="${user.username}" disabled class="ig-dark-input input-disabled-dark" />
                            <small class="field-hint-dark">Không thể thay đổi tên người dùng.</small>
                        </div>

                        <!-- Tiểu sử Bio -->
                        <div class="dark-form-group">
                            <div class="label-with-count">
                                <label for="bio">Tiểu sử (Bio)</label>
                                <span class="bio-counter" id="bioCounter">0 / 150</span>
                            </div>
                            <textarea id="bio" name="bio" rows="4" class="ig-dark-textarea" maxlength="150" placeholder="Viết vài dòng giới thiệu về bản thân..." oninput="updateBioCount(this)">${user.bio}</textarea>
                        </div>

                        <!-- Nút lưu -->
                        <div class="dark-submit-row">
                            <button type="submit" class="btn-dark-primary">Lưu thay đổi</button>
                            <a href="${pageContext.request.contextPath}/profile" class="btn-cancel-dark">Hủy</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <script>
        function handleAvatarFileSelect(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreviewImg').src = e.target.result;
                }
                reader.readAsDataURL(file);
                document.getElementById('avatarFileName').textContent = 'Đã chọn: ' + file.name + ' (' + (file.size / 1024).toFixed(0) + ' KB)';
                document.getElementById('avatarFileName').style.color = '#0095f6';
            }
        }

        function toggleAvatarUrlInput() {
            const group = document.getElementById('avatarUrlGroup');
            group.style.display = group.style.display === 'none' ? 'block' : 'none';
        }

        function handleAvatarUrlInput(url) {
            if (url && url.trim().length > 10) {
                document.getElementById('avatarPreviewImg').src = url.trim();
            }
        }

        function updateBioCount(textarea) {
            const count = textarea.value.length;
            document.getElementById('bioCounter').textContent = count + ' / 150';
        }

        document.addEventListener('DOMContentLoaded', function() {
            const bio = document.getElementById('bio');
            if (bio) updateBioCount(bio);
        });
    </script>
</body>
</html>
