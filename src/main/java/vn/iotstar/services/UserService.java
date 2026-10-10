package vn.iotstar.services;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vn.iotstar.entity.User;
import vn.iotstar.repository.UserRepository;

import java.util.Optional;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;

	public Optional<User> login(String username, String password) {
		Optional<User> userOpt = userRepository.findByUsername(username);
		if (userOpt.isPresent()) {
			User user = userOpt.get();
			String storedPassword = user.getPassword();
			if (storedPassword != null) {
				// Nếu mật khẩu đã được mã hóa BCrypt
				if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
					if (BCrypt.checkpw(password, storedPassword)) {
						return Optional.of(user);
					}
				}
				// Hỗ trợ tương thích: Nếu tài khoản cũ lưu plain text, tự động nâng cấp sang BCrypt
				else if (storedPassword.equals(password)) {
					user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(10)));
					userRepository.save(user);
					return Optional.of(user);
				}
			}
		}
		return Optional.empty();
	}

	public User register(String username, String password, String email, String fullname) {
		if (userRepository.existsByUsername(username)) {
			throw new RuntimeException("Tên đăng nhập đã tồn tại!");
		}
		if (userRepository.existsByEmail(email)) {
			throw new RuntimeException("Email đã được sử dụng!");
		}
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(10));
		User user = new User(username, hashedPassword, email, fullname);
		return userRepository.save(user);
	}

	public Optional<User> findById(Integer userId) {
		return userRepository.findById(userId);
	}

	public User updateProfile(Integer userId, String fullname, String bio, String avatar) {
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng!"));

		if (fullname != null && !fullname.trim().isEmpty()) {
			user.setFullname(fullname);
		}
		if (bio != null) {
			user.setBio(bio);
		}
		if (avatar != null && !avatar.trim().isEmpty()) {
			user.setAvatar(avatar);
		}
		return userRepository.save(user);
	}

	public java.util.List<User> getAllOtherUsers(Integer currentUserId) {
		java.util.List<User> all = userRepository.findAll();
		if (currentUserId == null) {
			return all;
		}
		return all.stream()
				.filter(u -> !u.getUserId().equals(currentUserId))
				.collect(java.util.stream.Collectors.toList());
	}

	public java.util.List<User> searchUsers(String query) {
		if (query == null || query.trim().isEmpty()) {
			return java.util.Collections.emptyList();
		}
		String q = query.trim();
		return userRepository.findByUsernameContainingIgnoreCaseOrFullnameContainingIgnoreCase(q, q);
	}
}
