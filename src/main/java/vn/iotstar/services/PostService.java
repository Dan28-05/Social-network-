package vn.iotstar.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vn.iotstar.entity.Post;
import vn.iotstar.entity.User;
import vn.iotstar.repository.PostRepository;
import vn.iotstar.repository.UserRepository;

import java.util.List;

@Service
public class PostService {

	@Autowired
	private PostRepository postRepository;

	@Autowired
	private UserRepository userRepository;

	// Lấy tất cả bài viết theo thứ tự mới nhất (Bảng tin chung)
	public List<Post> getAllPosts() {
		return postRepository.findAllByOrderByCreatedAtDesc();
	}

	// Lấy bảng tin ưu tiên: bài viết của người đang follow và của bản thân được xếp lên đầu
	public List<Post> getFeedPosts(Integer currentUserId, java.util.Set<Integer> followingIds) {
		List<Post> allPosts = postRepository.findAllByOrderByCreatedAtDesc();
		if (followingIds == null || followingIds.isEmpty()) {
			return allPosts;
		}

		return allPosts.stream().sorted((p1, p2) -> {
			boolean p1Priority = followingIds.contains(p1.getUser().getUserId())
					|| (currentUserId != null && p1.getUser().getUserId().equals(currentUserId));
			boolean p2Priority = followingIds.contains(p2.getUser().getUserId())
					|| (currentUserId != null && p2.getUser().getUserId().equals(currentUserId));

			if (p1Priority && !p2Priority) {
				return -1;
			} else if (!p1Priority && p2Priority) {
				return 1;
			} else {
				return p2.getCreatedAt().compareTo(p1.getCreatedAt());
			}
		}).collect(java.util.stream.Collectors.toList());
	}

	// Lấy bài viết của một User cụ thể (Trang cá nhân)
	public List<Post> getPostsByUserId(Integer userId) {
		return postRepository.findByUserUserIdOrderByCreatedAtDesc(userId);
	}

	// Đăng bài viết mới
	public Post createPost(Integer userId, String imageUrl, String caption) {
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("Người dùng không tồn tại!"));
		Post post = new Post(user, imageUrl, caption);
		return postRepository.save(post);
	}

	// Xóa bài viết của bản thân (kiểm tra quyền sở hữu bài viết)
	public boolean deletePost(Integer postId, Integer currentUserId) {
		return postRepository.findById(postId).map(post -> {
			if (post.getUser().getUserId().equals(currentUserId)) {
				postRepository.delete(post);
				return true;
			}
			return false; // Không có quyền xóa bài của người khác
		}).orElse(false);
	}
}
