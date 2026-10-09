package vn.iotstar.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Like;
import vn.iotstar.entity.Post;
import vn.iotstar.entity.User;
import vn.iotstar.repository.LikeRepository;
import vn.iotstar.repository.PostRepository;
import vn.iotstar.repository.UserRepository;

import java.util.*;

@Service
public class LikeService {

	@Autowired
	private LikeRepository likeRepository;

	@Autowired
	private PostRepository postRepository;

	@Autowired
	private UserRepository userRepository;

	public boolean isLiked(Integer postId, Integer userId) {
		if (postId == null || userId == null) return false;
		return likeRepository.existsByPostPostIdAndUserUserId(postId, userId);
	}

	public long getLikeCount(Integer postId) {
		if (postId == null) return 0;
		return likeRepository.countByPostPostId(postId);
	}

	@Transactional
	public boolean toggleLike(Integer postId, Integer userId) {
		if (postId == null || userId == null) return false;

		if (likeRepository.existsByPostPostIdAndUserUserId(postId, userId)) {
			likeRepository.deleteByPostPostIdAndUserUserId(postId, userId);
			return false; // đã bỏ thích
		} else {
			Post post = postRepository.findById(postId)
					.orElseThrow(() -> new RuntimeException("Bài viết không tồn tại"));
			User user = userRepository.findById(userId)
					.orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
			Like like = new Like(post, user);
			likeRepository.save(like);
			return true; // đã thích
		}
	}

	public Set<Integer> getLikedPostIds(Integer userId, List<Integer> postIds) {
		if (userId == null || postIds == null || postIds.isEmpty()) {
			return Collections.emptySet();
		}
		List<Integer> list = likeRepository.findLikedPostIdsByUser(userId, postIds);
		return new HashSet<>(list);
	}

	public Map<Integer, Long> getLikeCountsMap(List<Integer> postIds) {
		Map<Integer, Long> map = new HashMap<>();
		if (postIds == null || postIds.isEmpty()) {
			return map;
		}
		List<Object[]> results = likeRepository.countLikesByPostIds(postIds);
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
}
