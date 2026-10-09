package vn.iotstar.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Follow;
import vn.iotstar.entity.User;
import vn.iotstar.repository.FollowRepository;
import vn.iotstar.repository.UserRepository;

import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class FollowService {

	@Autowired
	private FollowRepository followRepository;

	@Autowired
	private UserRepository userRepository;

	public boolean isFollowing(Integer followerId, Integer followingId) {
		if (followerId == null || followingId == null) {
			return false;
		}
		return followRepository.existsByFollowerUserIdAndFollowingUserId(followerId, followingId);
	}

	public Set<Integer> getFollowingUserIds(Integer followerId) {
		if (followerId == null) {
			return Collections.emptySet();
		}
		return followRepository.findByFollowerUserId(followerId)
				.stream()
				.map(f -> f.getFollowing().getUserId())
				.collect(Collectors.toSet());
	}

	@Transactional
	public boolean toggleFollow(Integer followerId, Integer followingId) {
		if (followerId == null || followingId == null || followerId.equals(followingId)) {
			return false;
		}

		if (followRepository.existsByFollowerUserIdAndFollowingUserId(followerId, followingId)) {
			followRepository.deleteByFollowerUserIdAndFollowingUserId(followerId, followingId);
			return false; // đã hủy theo dõi (unfollowed)
		} else {
			User follower = userRepository.findById(followerId)
					.orElseThrow(() -> new RuntimeException("Người theo dõi không tồn tại"));
			User following = userRepository.findById(followingId)
					.orElseThrow(() -> new RuntimeException("Người được theo dõi không tồn tại"));
			Follow follow = new Follow(follower, following);
			followRepository.save(follow);
			return true; // đã theo dõi (followed)
		}
	}

	public long getFollowerCount(Integer userId) {
		if (userId == null) return 0;
		return followRepository.countByFollowingUserId(userId);
	}

	public long getFollowingCount(Integer userId) {
		if (userId == null) return 0;
		return followRepository.countByFollowerUserId(userId);
	}
}
