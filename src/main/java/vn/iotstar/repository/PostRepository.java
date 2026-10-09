package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Post;
import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {

	// Lấy tất cả bài viết theo thời gian mới nhất (Bảng tin chính)
	List<Post> findAllByOrderByCreatedAtDesc();

	// Lấy tất cả bài viết của một User theo thời gian mới nhất (Trang cá nhân)
	List<Post> findByUserUserIdOrderByCreatedAtDesc(Integer userId);
}
