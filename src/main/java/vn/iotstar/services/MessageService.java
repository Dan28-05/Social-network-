package vn.iotstar.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Message;
import vn.iotstar.entity.User;
import vn.iotstar.repository.MessageRepository;
import vn.iotstar.repository.UserRepository;

import java.util.*;

@Service
public class MessageService {

	@Autowired
	private MessageRepository messageRepository;

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private FollowService followService;

	// Lưu tin nhắn mới vào CSDL
	@Transactional
	public Message saveMessage(Integer senderId, Integer receiverId, String content) {
		if (senderId == null || receiverId == null || content == null || content.trim().isEmpty()) {
			throw new IllegalArgumentException("Thông tin tin nhắn không hợp lệ!");
		}

		User sender = userRepository.findById(senderId)
				.orElseThrow(() -> new RuntimeException("Người gửi không tồn tại!"));
		User receiver = userRepository.findById(receiverId)
				.orElseThrow(() -> new RuntimeException("Người nhận không tồn tại!"));

		Message message = new Message(sender, receiver, content.trim());
		return messageRepository.save(message);
	}

	// Lấy cuộc trò chuyện giữa 2 người dùng
	public List<Message> getConversation(Integer u1, Integer u2) {
		if (u1 == null || u2 == null) {
			return Collections.emptyList();
		}
		return messageRepository.findConversation(u1, u2);
	}

	// Đánh dấu đã đọc các tin nhắn gửi đến
	@Transactional
	public void markAsRead(Integer currentUserId, Integer senderId) {
		if (currentUserId != null && senderId != null) {
			messageRepository.markAsRead(currentUserId, senderId);
		}
	}

	// Đếm tổng tin nhắn chưa đọc
	public long getUnreadCount(Integer currentUserId) {
		if (currentUserId == null) {
			return 0;
		}
		return messageRepository.countByReceiverUserIdAndIsReadFalse(currentUserId);
	}

	// Lấy danh sách các đối tác chat (ưu tiên người đã nhắn tin + người đang theo dõi)
	public List<User> getChatPartners(Integer currentUserId) {
		if (currentUserId == null) {
			return Collections.emptyList();
		}

		LinkedHashSet<Integer> partnerIds = new LinkedHashSet<>();

		// 1. Lấy những người đã từng có tin nhắn qua lại
		List<Integer> chattedIds = messageRepository.findChatPartnerIds(currentUserId);
		partnerIds.addAll(chattedIds);

		// 2. Thêm những người đang follow để dễ dàng bắt đầu nhắn tin
		Set<Integer> followingIds = followService.getFollowingUserIds(currentUserId);
		partnerIds.addAll(followingIds);

		// 3. Nếu danh sách vẫn ít, thêm các người dùng khác trong hệ thống
		List<User> allOthers = userRepository.findAll();
		for (User u : allOthers) {
			if (!u.getUserId().equals(currentUserId)) {
				partnerIds.add(u.getUserId());
			}
		}

		List<User> result = new ArrayList<>();
		for (Integer id : partnerIds) {
			userRepository.findById(id).ifPresent(result::add);
		}
		return result;
	}
}
