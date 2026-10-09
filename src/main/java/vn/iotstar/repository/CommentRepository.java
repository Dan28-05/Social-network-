package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Comment;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {

	List<Comment> findByPostPostIdOrderByCreatedAtAsc(Integer postId);

	List<Comment> findByPostPostIdOrderByCreatedAtDesc(Integer postId);

	long countByPostPostId(Integer postId);

	@Query("SELECT c.post.postId, COUNT(c) FROM Comment c WHERE c.post.postId IN :postIds GROUP BY c.post.postId")
	List<Object[]> countCommentsByPostIds(@Param("postIds") List<Integer> postIds);
}
