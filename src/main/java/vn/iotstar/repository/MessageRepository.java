package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Message;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Integer> {

	// Lấy toàn bộ lịch sử tin nhắn giữa 2 người dùng (sắp xếp tăng dần theo thời gian)
	@Query("SELECT m FROM Message m WHERE (m.sender.userId = :u1 AND m.receiver.userId = :u2) "
			+ "OR (m.sender.userId = :u2 AND m.receiver.userId = :u1) ORDER BY m.createdAt ASC")
	List<Message> findConversation(@Param("u1") Integer u1, @Param("u2") Integer u2);

	// Đếm số tin nhắn chưa đọc gửi đến một người dùng
	long countByReceiverUserIdAndIsReadFalse(Integer receiverId);

	// Đánh dấu đã đọc toàn bộ tin nhắn từ người gửi senderId gửi đến receiverId
	@Modifying
	@Query("UPDATE Message m SET m.isRead = true WHERE m.receiver.userId = :receiverId AND m.sender.userId = :senderId AND m.isRead = false")
	void markAsRead(@Param("receiverId") Integer receiverId, @Param("senderId") Integer senderId);

	// Lấy danh sách ID của những người đã từng nhắn tin qua lại với user
	@Query("SELECT DISTINCT CASE WHEN m.sender.userId = :userId THEN m.receiver.userId ELSE m.sender.userId END "
			+ "FROM Message m WHERE m.sender.userId = :userId OR m.receiver.userId = :userId")
	List<Integer> findChatPartnerIds(@Param("userId") Integer userId);
}
