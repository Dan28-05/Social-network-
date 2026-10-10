-- 1. Tạo Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'InstagramDB')
BEGIN
    CREATE DATABASE InstagramDB;
END
GO

USE InstagramDB;
GO

-- 2. Bảng USERS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        fullname NVARCHAR(100) NULL,
        avatar VARCHAR(MAX) DEFAULT 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        bio NVARCHAR(300) NULL,
        created_at DATETIME DEFAULT GETDATE()
    );
END
GO

-- 3. Bảng POSTS
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Posts')
BEGIN
    CREATE TABLE Posts (
        post_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        image_url VARCHAR(MAX) NOT NULL,
        caption NVARCHAR(1000) NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Posts_Users FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );
END
GO

-- Nâng cấp cột avatar và image_url lên VARCHAR(MAX) nếu database đã có sẵn trước đó
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'avatar' AND max_length != -1)
BEGIN
    ALTER TABLE Users ALTER COLUMN avatar VARCHAR(MAX) NULL;
END
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Posts') AND name = 'image_url' AND max_length != -1)
BEGIN
    ALTER TABLE Posts ALTER COLUMN image_url VARCHAR(MAX) NOT NULL;
END
GO

-- 4. Bảng FOLLOWS (Theo dõi bạn bè)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Follows')
BEGIN
    CREATE TABLE Follows (
        follow_id INT IDENTITY(1,1) PRIMARY KEY,
        follower_id INT NOT NULL,
        following_id INT NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Follows_Follower FOREIGN KEY (follower_id) REFERENCES Users(user_id),
        CONSTRAINT FK_Follows_Following FOREIGN KEY (following_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        CONSTRAINT UQ_Follower_Following UNIQUE (follower_id, following_id)
    );
END
GO

-- 5. Bảng MESSAGES (Tin nhắn trực tiếp / Chat Realtime)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Messages')
BEGIN
    CREATE TABLE Messages (
        message_id INT IDENTITY(1,1) PRIMARY KEY,
        sender_id INT NOT NULL,
        receiver_id INT NOT NULL,
        content NVARCHAR(MAX) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        is_read BIT DEFAULT 0,
        CONSTRAINT FK_Messages_Sender FOREIGN KEY (sender_id) REFERENCES Users(user_id),
        CONSTRAINT FK_Messages_Receiver FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
    );
END
GO

-- 6. Bảng LIKES (Lượt thích bài viết)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Likes')
BEGIN
    CREATE TABLE Likes (
        like_id INT IDENTITY(1,1) PRIMARY KEY,
        post_id INT NOT NULL,
        user_id INT NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Likes_Posts FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
        CONSTRAINT FK_Likes_Users FOREIGN KEY (user_id) REFERENCES Users(user_id),
        CONSTRAINT UQ_Likes_User_Post UNIQUE (post_id, user_id)
    );
END
GO

-- 7. Bảng COMMENTS (Bình luận bài viết)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Comments')
BEGIN
    CREATE TABLE Comments (
        comment_id INT IDENTITY(1,1) PRIMARY KEY,
        post_id INT NOT NULL,
        user_id INT NOT NULL,
        content NVARCHAR(1000) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Comments_Posts FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
        CONSTRAINT FK_Comments_Users FOREIGN KEY (user_id) REFERENCES Users(user_id)
    );
END
GO

-- 8. Dữ liệu mẫu (Insert sample data nếu chưa có)
-- Mật khẩu mẫu mặc định cho tất cả user: 123456 (Đã mã hóa bằng BCrypt hash)
IF NOT EXISTS (SELECT * FROM Users WHERE username = 'nguyenvana')
BEGIN
    INSERT INTO Users (username, password, email, fullname, avatar, bio)
    VALUES 
    ('nguyenvana', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'vana@gmail.com', N'Nguyễn Văn A', 
     'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150', 
     N'Lập trình viên Java Web Spring MVC ☕ | Yêu nhiếp ảnh 📸'),
    ('thuhalee', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'thuha@gmail.com', N'Lê Thị Thu Hà', 
     'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150', 
     N'Designer & Traveler ✈️ | Sống tích cực mỗi ngày 🌿'),
    ('alligator.aixuann', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'aixuan@gmail.com', N'Ái Xuân', 
     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150', 
     N'Design & Content Creator 🎨 ✨'),
    ('ngonhuy', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'nhuy@gmail.com', N'Ngô Như Ý', 
     'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150', 
     N'Photography & Travel 📸 Sống để trải nghiệm 🌿'),
    ('lamnhattien', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'nhattien@gmail.com', N'Lâm Nhật Tiến', 
     'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 
     N'Software Engineer 💻 Coffee & Coding ☕'),
    ('hongthuong', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'hongthuong@gmail.com', N'Hồng Thương', 
     'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150', 
     N'Lifestyle & Foodie 🍜 🌸'),
    ('trangnguyen', '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da', 'trangnguyen@gmail.com', N'Nguyễn Thị Thu Trang', 
     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150', 
     N'UI/UX Enthusiast 💡 Minimalist 🍃');

    INSERT INTO Posts (user_id, image_url, caption, created_at)
    VALUES 
    (1, 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800', 
     N'Cuối tuần code Spring MVC cùng đồng đội thật năng suất! #Java #SpringMVC', DATEADD(HOUR, -3, GETDATE())),
    (2, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800', 
     N'Biển xanh, cát trắng và nắng vàng chiều hoàng hôn 🌊🌅', DATEADD(HOUR, -6, GETDATE())),
    (1, 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=800', 
     N'Một góc cà phê nhỏ quen thuộc ☕ #coffee #relax', DATEADD(DAY, -1, GETDATE())),
    (3, 'https://images.unsplash.com/photo-1528728329032-2972f65dfb3f?w=800', 
     N'Hà Nội mùa thu thật dịu dàng 🍂 #hanoi #autumn #vibes', DATEADD(HOUR, -2, GETDATE())),
    (4, 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800', 
     N'Thung lũng mùa hoa nở rộ 🌸 Trở về với thiên nhiên', DATEADD(HOUR, -4, GETDATE())),
    (5, 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800', 
     N'Setup bàn làm việc mới cho dự án Spring MVC 🚀 #workspace #developer', DATEADD(HOUR, -8, GETDATE()));
END
GO

-- 9. Tự động cập nhật mật khẩu mẫu cũ '123456' sang BCrypt hash nếu database đã có sẵn dữ liệu trước đó
IF EXISTS (SELECT * FROM Users WHERE password = '123456')
BEGIN
    UPDATE Users 
    SET password = '$2a$10$ylqxzrlAmXbp7G1pZfm.ueuNy4t/djCum51MJMN.yrZzJsXBHf3Da' 
    WHERE password = '123456';
END
GO
