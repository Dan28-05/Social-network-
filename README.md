# QNU_Confesstion - Mạng Xã Hội Sinh Viên (Spring MVC + SQL Server)

Dự án mạng xã hội **QNU_Confesstion** với giao diện Dark Mode hiện đại, được xây dựng bằng **Spring MVC (JavaConfig thuần - không dùng XML)** kết hợp **Spring Data JPA / Hibernate** và cơ sở dữ liệu **Microsoft SQL Server**.

---

## 🌟 Tính Năng Nổi Bật

1. **Bảng tin & Khám phá (Feed & Stories):**
   - Bảng tin tự động ưu tiên bài viết của những người bạn đang theo dõi (Follow).
   - Thanh Stories hiển thị danh sách người dùng thực từ Database.
   - Cột gợi ý kết bạn (Suggested for you) hỗ trợ **Theo dõi / Bỏ theo dõi** bằng AJAX thời gian thực.
   - Thả tim bài viết, xem bình luận và menu chia sẻ.

2. **Đăng bài viết mới (Create Post Modal chuẩn Instagram):**
   - Hộp thoại tạo bài 2 giai đoạn hiện đại: Kéo thả / Chọn file ảnh hoặc video từ máy tính với tính năng xem trước trực quan.
   - Hỗ trợ viết chú thích (caption), bộ đếm ký tự (2,200 ký tự) và khay chọn Emoji nhanh.
   - **Lưu trữ dữ liệu độc lập:** Ảnh/video upload được tự động mã hóa thành chuẩn `Base64 Data URL` và lưu trực tiếp vào database (`VARCHAR(MAX)`), giúp người khác clone repo về là thấy ảnh ngay mà không phụ thuộc vào thư mục file máy chủ.

3. **Trang cá nhân (Profile):**
   - Xem trang cá nhân của bản thân và người khác.
   - Lưới ảnh bài viết tỉ lệ vuông (Grid photo) chuẩn Instagram với hiệu ứng hover xem số lượt thích & bình luận.
   - Xóa bài viết của bản thân trực tiếp trên giao diện.
   - Nút theo dõi / bỏ theo dõi và đếm số lượng người theo dõi tự động cập nhật.

4. **Chỉnh sửa trang cá nhân (Edit Profile):**
   - Tải lên ảnh đại diện mới trực tiếp từ máy tính với trình xem trước tức thì.
   - Cập nhật Họ và tên, Bio (tiểu sử).

5. **Giao diện đẳng cấp (Modern Instagram Dark Theme):**
   - Sidebar bên trái thông minh (thu gọn hiển thị icon, rê chuột vào mở rộng hiển thị tên menu kèm animation mượt mà).
   - Nút Messages nổi góc dưới phải.

---

## 🛠️ Công Nghệ Sử Dụng

- **Backend:** Java 17, Spring MVC 5.3.39 (JavaConfig: `@Configuration`, `@EnableWebMvc`), Spring Data JPA, Hibernate ORM.
- **Database:** Microsoft SQL Server 2022 (chạy qua Docker).
- **Frontend:** JSP, JSTL, CSS3 (Instagram Dark Mode Design System), JavaScript (ES6, Fetch API), FontAwesome 6, Google Fonts (Inter, Grand Hotel).
- **Server:** Apache Tomcat 9.0.
- **Build tool:** Apache Maven.

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Khởi động Cơ sở dữ liệu SQL Server (Docker)
Chạy lệnh Docker Compose để khởi tạo SQL Server:
```bash
docker-compose up -d
```
Hoặc cấu hình thông tin kết nối trong `src/main/java/vn/iotstar/configs/JpaConfig.java`:
- Host: `localhost:14333` (hoặc cổng SQL Server của bạn)
- Database: `InstagramDB`
- User: `sa`
- Password: `Password123!`

### 2. Khởi tạo CSDL & Dữ liệu mẫu
Bạn có thể chọn **1 trong 2 cách** tiện lợi sau:
- **Cách 1 (Khuyên dùng - Đầy đủ 100% dữ liệu & ảnh đã lưu):** Sử dụng file backup `sql/InstagramDB.bak` để Restore trong SQL Server (SSMS) hoặc chạy lệnh T-SQL:
  ```sql
  RESTORE DATABASE InstagramDB 
  FROM DISK = 'đường_dẫn_đến_file/sql/InstagramDB.bak' 
  WITH REPLACE;
  ```
- **Cách 2:** Mở SSMS hoặc Azure Data Studio và thực thi toàn bộ nội dung file script:
  ```text
  sql/init.sql
  ```

### 3. Chạy ứng dụng trên Eclipse
1. Mở Eclipse IDE -> **File** -> **Import...** -> **Existing Maven Projects**.
2. Chọn thư mục dự án `MangXaHoi`.
3. Nhấp chuột phải vào dự án -> **Run As** -> **Run on Server** (Chọn Apache Tomcat v9.0).
4. Truy cập ứng dụng tại: `http://localhost:8080/MangXaHoi/`

### 4. Tài khoản mẫu thử nghiệm
- **Tài khoản 1:** `nguyenvana` / Mật khẩu: `123456`
- **Tài khoản 2:** `thuhalee` / Mật khẩu: `123456`
- **Tài khoản 3:** `alligator.aixuann` / Mật khẩu: `123456`
- **Tài khoản 4:** `ngonhuy` / Mật khẩu: `123456`
- **Tài khoản 5:** `lamnhattien` / Mật khẩu: `123456`
