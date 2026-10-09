package vn.iotstar.websocket;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import vn.iotstar.entity.Message;
import vn.iotstar.services.MessageService;

import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

	@Autowired
	private MessageService messageService;

	private final ObjectMapper objectMapper = new ObjectMapper();

	// Lưu trữ danh sách kết nối WebSocket theo userId (hỗ trợ nhiều tab cùng lúc)
	private static final Map<Integer, List<WebSocketSession>> userSessions = new ConcurrentHashMap<>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		Integer userId = extractUserId(session.getUri());
		if (userId != null) {
			session.getAttributes().put("userId", userId);
			userSessions.computeIfAbsent(userId, k -> new CopyOnWriteArrayList<>()).add(session);
			System.out.println(" WebSocket: User " + userId + " đã kết nối. Session: " + session.getId());
		} else {
			System.err.println("❌ WebSocket: Kết nối thiếu tham số userId, đóng kết nối.");
			session.close(CloseStatus.BAD_DATA);
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		Integer senderId = (Integer) session.getAttributes().get("userId");
		if (senderId == null) {
			return;
		}

		String payload = message.getPayload();
		JsonNode node = objectMapper.readTree(payload);

		if (!node.has("receiverId") || !node.has("content")) {
			return;
		}

		Integer receiverId = node.get("receiverId").asInt();
		String content = node.get("content").asText();

		if (content == null || content.trim().isEmpty()) {
			return;
		}

		// 1. Lưu tin nhắn vào CSDL SQL Server thông qua MessageService
		Message saved = messageService.saveMessage(senderId, receiverId, content);

		// 2. Đóng gói dữ liệu tin nhắn gửi lại cho client realtime
		Map<String, Object> resp = new HashMap<>();
		resp.put("type", "CHAT");
		resp.put("messageId", saved.getMessageId());
		resp.put("senderId", senderId);
		resp.put("senderUsername", saved.getSender().getUsername());
		resp.put("senderAvatar", saved.getSender().getAvatar());
		resp.put("receiverId", receiverId);
		resp.put("content", saved.getContent());
		resp.put("createdAt", new SimpleDateFormat("HH:mm").format(saved.getCreatedAt()));

		String jsonResponse = objectMapper.writeValueAsString(resp);
		TextMessage outMsg = new TextMessage(jsonResponse);

		// 3. Gửi lại cho người gửi (để xác nhận đã gửi thành công)
		if (session.isOpen()) {
			session.sendMessage(outMsg);
		}

		// 4. Gửi cho người nhận nếu đang online
		List<WebSocketSession> receiverList = userSessions.get(receiverId);
		if (receiverList != null) {
			for (WebSocketSession recSession : receiverList) {
				if (recSession.isOpen() && !recSession.getId().equals(session.getId())) {
					recSession.sendMessage(outMsg);
				}
			}
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		Integer userId = (Integer) session.getAttributes().get("userId");
		if (userId != null) {
			List<WebSocketSession> list = userSessions.get(userId);
			if (list != null) {
				list.remove(session);
				if (list.isEmpty()) {
					userSessions.remove(userId);
				}
			}
			System.out.println(" WebSocket: User " + userId + " đã ngắt kết nối.");
		}
	}

	// Lấy userId từ query string: ws://localhost:8080/MangXaHoi/ws/chat?userId=1
	private Integer extractUserId(URI uri) {
		if (uri == null || uri.getQuery() == null) {
			return null;
		}
		String query = uri.getQuery();
		for (String param : query.split("&")) {
			String[] pair = param.split("=");
			if (pair.length == 2 && "userId".equals(pair[0])) {
				try {
					return Integer.parseInt(pair[1]);
				} catch (NumberFormatException ignored) {
				}
			}
		}
		return null;
	}
}
