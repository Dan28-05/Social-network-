package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Follow;

import java.util.List;
import java.util.Optional;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Integer> {

	boolean existsByFollowerUserIdAndFollowingUserId(Integer followerId, Integer followingId);

	Optional<Follow> findByFollowerUserIdAndFollowingUserId(Integer followerId, Integer followingId);

	void deleteByFollowerUserIdAndFollowingUserId(Integer followerId, Integer followingId);

	List<Follow> findByFollowerUserId(Integer followerId);

	List<Follow> findByFollowingUserId(Integer followingId);

	long countByFollowerUserId(Integer followerId);

	long countByFollowingUserId(Integer followingId);
}
