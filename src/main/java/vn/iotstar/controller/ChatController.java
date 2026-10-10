package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.Message;
import vn.iotstar.entity.User;
import vn.iotstar.services.MessageService;
import vn.iotstar.services.UserService;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/direct")
public class ChatController {

	@Autowired
	private MessageService messageService;

	@Autowired
	private UserService userService;

	// Giao diện chính phần nhắn tin Direct Messages
	@GetMapping
	public String directPage(@RequestParam(value = "userId", required = false) Integer targetUserId,
							 HttpSession session,
							 Model model) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		// Lấy danh sách các đối tác chat
		List<User> partners = messageService.getChatPartners(currentUser.getUserId());
		model.addAttribute("partners", partners);

		// Lấy danh sách người dùng cho Stories Carousel (giống hệt trang Home)
		List<User> otherUsers = userService.getAllOtherUsers(currentUser.getUserId());
		model.addAttribute("storyUsers", otherUsers);

		User activeUser = null;
		if (targetUserId != null) {
			activeUser = userService.findById(targetUserId).orElse(null);
		} else if (!partners.isEmpty()) {
			activeUser = partners.get(0);
		}

		if (activeUser != null) {
			// Đánh dấu đã đọc các tin nhắn gửi từ activeUser
			messageService.markAsRead(currentUser.getUserId(), activeUser.getUserId());

			// Lấy toàn bộ lịch sử tin nhắn
			List<Message> conversation = messageService.getConversation(currentUser.getUserId(), activeUser.getUserId());
			model.addAttribute("activeUser", activeUser);
			model.addAttribute("conversation", conversation);
		}

		long unreadCount = messageService.getUnreadCount(currentUser.getUserId());
		model.addAttribute("unreadCount", unreadCount);

		return "direct";
	}

	// Đường dẫn tắt: /direct/t/2 -> Mở chat ngay với User ID = 2
	@GetMapping("/t/{userId}")
	public String chatWithUser(@PathVariable("userId") Integer userId) {
		return "redirect:/direct?userId=" + userId;
	}

	// API lấy lịch sử tin nhắn dạng JSON khi click chuyển đổi giữa các bạn chat
	@GetMapping("/api/conversation/{targetUserId}")
	@ResponseBody
	public Map<String, Object> getConversationJson(@PathVariable("targetUserId") Integer targetUserId,
												   HttpSession session) {
		Map<String, Object> res = new HashMap<>();
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			res.put("success", false);
			res.put("message", "Chưa đăng nhập");
			return res;
		}

		messageService.markAsRead(currentUser.getUserId(), targetUserId);
		List<Message> list = messageService.getConversation(currentUser.getUserId(), targetUserId);

		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		sdf.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
		List<Map<String, Object>> msgDtos = new ArrayList<>();
		for (Message m : list) {
			Map<String, Object> dto = new HashMap<>();
			dto.put("messageId", m.getMessageId());
			dto.put("senderId", m.getSender().getUserId());
			dto.put("senderUsername", m.getSender().getUsername());
			dto.put("senderAvatar", m.getSender().getAvatar());
			dto.put("receiverId", m.getReceiver().getUserId());
			dto.put("content", m.getContent());
			dto.put("createdAt", sdf.format(m.getCreatedAt()));
			dto.put("isSelf", m.getSender().getUserId().equals(currentUser.getUserId()));
			msgDtos.add(dto);
		}

		res.put("success", true);
		res.put("messages", msgDtos);
		return res;
	}
}
