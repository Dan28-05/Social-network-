package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Like;

import java.util.List;
import java.util.Optional;

@Repository
public interface LikeRepository extends JpaRepository<Like, Integer> {

	boolean existsByPostPostIdAndUserUserId(Integer postId, Integer userId);

	Optional<Like> findByPostPostIdAndUserUserId(Integer postId, Integer userId);

	void deleteByPostPostIdAndUserUserId(Integer postId, Integer userId);

	long countByPostPostId(Integer postId);

	List<Like> findByPostPostId(Integer postId);

	@Query("SELECT l.post.postId FROM Like l WHERE l.user.userId = :userId AND l.post.postId IN :postIds")
	List<Integer> findLikedPostIdsByUser(@Param("userId") Integer userId, @Param("postIds") List<Integer> postIds);

	@Query("SELECT l.post.postId, COUNT(l) FROM Like l WHERE l.post.postId IN :postIds GROUP BY l.post.postId")
	List<Object[]> countLikesByPostIds(@Param("postIds") List<Integer> postIds);
}
