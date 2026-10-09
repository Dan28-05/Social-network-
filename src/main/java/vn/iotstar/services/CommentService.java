package vn.iotstar.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Comment;
import vn.iotstar.entity.Post;
import vn.iotstar.entity.User;
import vn.iotstar.repository.CommentRepository;
import vn.iotstar.repository.PostRepository;
import vn.iotstar.repository.UserRepository;

import java.util.*;

@Service
public class CommentService {

	@Autowired
	private CommentRepository commentRepository;

	@Autowired
	private PostRepository postRepository;

	@Autowired
	private UserRepository userRepository;

	@Transactional
	public Comment addComment(Integer postId, Integer userId, String content) {
		if (postId == null || userId == null || content == null || content.trim().isEmpty()) {
			throw new IllegalArgumentException("Dữ liệu bình luận không hợp lệ");
		}
		Post post = postRepository.findById(postId)
				.orElseThrow(() -> new RuntimeException("Bài viết không tồn tại"));
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

		Comment comment = new Comment(post, user, content.trim());
		return commentRepository.save(comment);
	}

	public List<Comment> getCommentsByPost(Integer postId) {
		if (postId == null) return Collections.emptyList();
		return commentRepository.findByPostPostIdOrderByCreatedAtAsc(postId);
	}

	public long getCommentCount(Integer postId) {
		if (postId == null) return 0;
		return commentRepository.countByPostPostId(postId);
	}

	public Map<Integer, Long> getCommentCountsMap(List<Integer> postIds) {
		Map<Integer, Long> map = new HashMap<>();
		if (postIds == null || postIds.isEmpty()) {
			return map;
		}
		List<Object[]> results = commentRepository.countCommentsByPostIds(postIds);
		for (Object[] row : results) {
			Integer pid = (Integer) row[0];
			Long cnt = (Long) row[1];
			map.put(pid, cnt);
		}
		for (Integer pid : postIds) {
			map.putIfAbsent(pid, 0L);
		}
		return map;
	}

	@Transactional
	public boolean deleteComment(Integer commentId, Integer currentUserId) {
		if (commentId == null || currentUserId == null) return false;
		Optional<Comment> opt = commentRepository.findById(commentId);
		if (!opt.isPresent()) return false;

		Comment comment = opt.get();
		// Người được phép xóa: Tác giả bình luận HOẶC Tác giả bài viết
		if (comment.getUser().getUserId().equals(currentUserId)
				|| comment.getPost().getUser().getUserId().equals(currentUserId)) {
			commentRepository.delete(comment);
			return true;
		}
		return false;
	}
}
