package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.entity.Post;
import vn.iotstar.entity.User;
import vn.iotstar.services.PostService;
import vn.iotstar.services.UserService;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class HomeController {

	@Autowired
	private PostService postService;

	@Autowired
	private UserService userService;

	@Autowired
	private vn.iotstar.services.FollowService followService;

	@Autowired
	private vn.iotstar.services.LikeService likeService;

	@Autowired
	private vn.iotstar.services.CommentService commentService;

	@GetMapping("/")
	public String index(Model model, HttpSession session) {
		User currentUser = (User) session.getAttribute("currentUser");
		// Nếu chưa đăng nhập, chuyển sang trang Đăng nhập
		if (currentUser == null) {
			return "redirect:/login";
		}

		java.util.Set<Integer> followingIds = followService.getFollowingUserIds(currentUser.getUserId());
		List<Post> posts = postService.getFeedPosts(currentUser.getUserId(), followingIds);
		List<User> otherUsers = userService.getAllOtherUsers(currentUser.getUserId());

		// Lấy thống kê Like và Comment cho danh sách bài viết
		List<Integer> postIds = posts.stream().map(Post::getPostId).collect(java.util.stream.Collectors.toList());
		java.util.Map<Integer, Long> likeCounts = likeService.getLikeCountsMap(postIds);
		java.util.Set<Integer> likedPostIds = likeService.getLikedPostIds(currentUser.getUserId(), postIds);
		java.util.Map<Integer, Long> commentCounts = commentService.getCommentCountsMap(postIds);

		// Lấy danh sách bình luận cho từng bài viết để hiển thị preview
		java.util.Map<Integer, List<vn.iotstar.entity.Comment>> postComments = new java.util.HashMap<>();
		for (Integer pid : postIds) {
			postComments.put(pid, commentService.getCommentsByPost(pid));
		}

		model.addAttribute("posts", posts);
		model.addAttribute("currentUser", currentUser);
		model.addAttribute("storyUsers", otherUsers);
		model.addAttribute("suggestedUsers", otherUsers);
		model.addAttribute("followingIds", followingIds);
		model.addAttribute("likeCounts", likeCounts);
		model.addAttribute("likedPostIds", likedPostIds);
		model.addAttribute("commentCounts", commentCounts);
		model.addAttribute("postComments", postComments);
		return "home";
	}

	// Chức năng: Like / Bỏ like bài viết bằng Ajax
	@PostMapping(value = "/api/posts/{postId}/like", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public java.util.Map<String, Object> toggleLike(@PathVariable("postId") Integer postId, HttpSession session) {
		java.util.Map<String, Object> res = new java.util.HashMap<>();
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			res.put("success", false);
			res.put("message", "Chưa đăng nhập");
			return res;
		}

		boolean isLiked = likeService.toggleLike(postId, currentUser.getUserId());
		long likeCount = likeService.getLikeCount(postId);

		res.put("success", true);
		res.put("liked", isLiked);
		res.put("likeCount", likeCount);
		return res;
	}

	// Chức năng: Thêm bình luận mới vào bài viết bằng Ajax
	@PostMapping(value = "/api/posts/{postId}/comment", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public java.util.Map<String, Object> addComment(@PathVariable("postId") Integer postId,
													@RequestParam("content") String content,
													HttpSession session) {
		java.util.Map<String, Object> res = new java.util.HashMap<>();
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			res.put("success", false);
			res.put("message", "Chưa đăng nhập");
			return res;
		}

		if (content == null || content.trim().isEmpty()) {
			res.put("success", false);
			res.put("message", "Nội dung bình luận không được để trống");
			return res;
		}

		vn.iotstar.entity.Comment comment = commentService.addComment(postId, currentUser.getUserId(), content.trim());
		long commentCount = commentService.getCommentCount(postId);

		java.util.Map<String, Object> dto = new java.util.HashMap<>();
		dto.put("commentId", comment.getCommentId());
		dto.put("userId", currentUser.getUserId());
		dto.put("username", currentUser.getUsername());
		dto.put("avatar", currentUser.getAvatar());
		dto.put("fullname", currentUser.getFullname());
		dto.put("content", comment.getContent());
		dto.put("createdAt", "Vừa xong");
		dto.put("canDelete", true);

		res.put("success", true);
		res.put("comment", dto);
		res.put("commentCount", commentCount);
		return res;
	}

	// Chức năng: Lấy toàn bộ danh sách bình luận của bài viết bằng Ajax
	@GetMapping(value = "/api/posts/{postId}/comments", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public java.util.Map<String, Object> getComments(@PathVariable("postId") Integer postId, HttpSession session) {
		java.util.Map<String, Object> res = new java.util.HashMap<>();
		User currentUser = (User) session.getAttribute("currentUser");
		Integer currentUserId = currentUser != null ? currentUser.getUserId() : null;

		List<vn.iotstar.entity.Comment> list = commentService.getCommentsByPost(postId);
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
		List<java.util.Map<String, Object>> dtos = new java.util.ArrayList<>();
		for (vn.iotstar.entity.Comment c : list) {
			java.util.Map<String, Object> dto = new java.util.HashMap<>();
			dto.put("commentId", c.getCommentId());
			dto.put("userId", c.getUser().getUserId());
			dto.put("username", c.getUser().getUsername());
			dto.put("avatar", c.getUser().getAvatar());
			dto.put("fullname", c.getUser().getFullname());
			dto.put("content", c.getContent());
			dto.put("createdAt", sdf.format(c.getCreatedAt()));
			dto.put("canDelete", currentUserId != null &&
					(c.getUser().getUserId().equals(currentUserId) || c.getPost().getUser().getUserId().equals(currentUserId)));
			dtos.add(dto);
		}
		res.put("success", true);
		res.put("comments", dtos);
		res.put("total", dtos.size());
		return res;
	}

	// Chức năng: Xóa bình luận bài viết
	@PostMapping(value = "/api/comments/{commentId}/delete", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public java.util.Map<String, Object> deleteComment(@PathVariable("commentId") Integer commentId,
													   @RequestParam(value = "postId", required = false) Integer postId,
													   HttpSession session) {
		java.util.Map<String, Object> res = new java.util.HashMap<>();
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			res.put("success", false);
			res.put("message", "Chưa đăng nhập");
			return res;
		}

		boolean deleted = commentService.deleteComment(commentId, currentUser.getUserId());
		res.put("success", deleted);
		if (postId != null) {
			res.put("commentCount", commentService.getCommentCount(postId));
		}
		return res;
	}

	// Chức năng: Follow / Bỏ follow bạn bè bằng Ajax
	@PostMapping(value = "/api/follow/{targetUserId}", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleFollow(@PathVariable("targetUserId") Integer targetUserId,
							   HttpSession session) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "{\"success\":false,\"message\":\"Chưa đăng nhập\"}";
		}

		boolean isFollowing = followService.toggleFollow(currentUser.getUserId(), targetUserId);
		long followerCount = followService.getFollowerCount(targetUserId);

		return "{\"success\":true,\"isFollowing\":" + isFollowing + ",\"followerCount\":" + followerCount + "}";
	}

	// Chức năng 4: Đăng bài viết mới (Hỗ trợ upload ảnh/video từ máy tính và xem trước)
	@PostMapping("/posts/create")
	public String createPost(@RequestParam(value = "mediaFile", required = false) org.springframework.web.multipart.MultipartFile mediaFile,
							 @RequestParam(value = "imageUrl", required = false) String imageUrl,
							 @RequestParam(value = "caption", required = false) String caption,
							 javax.servlet.http.HttpServletRequest request,
							 HttpSession session) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		String finalMediaUrl = null;

		// 1. Kiểm tra xem người dùng có chọn file ảnh / video từ máy tính không
		if (mediaFile != null && !mediaFile.isEmpty()) {
			try {
				byte[] fileBytes = mediaFile.getBytes();
				String contentType = mediaFile.getContentType();
				String originalFilename = mediaFile.getOriginalFilename();
				String lowerName = (originalFilename != null) ? originalFilename.toLowerCase() : "";

				if (contentType == null || contentType.trim().isEmpty() || "application/octet-stream".equals(contentType)) {
					if (lowerName.endsWith(".png")) contentType = "image/png";
					else if (lowerName.endsWith(".webp")) contentType = "image/webp";
					else if (lowerName.endsWith(".gif")) contentType = "image/gif";
					else if (lowerName.endsWith(".mp4")) contentType = "video/mp4";
					else if (lowerName.endsWith(".webm")) contentType = "video/webm";
					else if (lowerName.endsWith(".mov")) contentType = "video/quicktime";
					else contentType = "image/jpeg";
				}

				// Chuyển đổi thành Base64 Data URL để lưu trực tiếp vào Database (VARCHAR(MAX))
				String base64Data = java.util.Base64.getEncoder().encodeToString(fileBytes);
				finalMediaUrl = "data:" + contentType + ";base64," + base64Data;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
			finalMediaUrl = imageUrl.trim();
		}

		if (finalMediaUrl != null && !finalMediaUrl.isEmpty()) {
			postService.createPost(currentUser.getUserId(), finalMediaUrl, caption);
		}
		return "redirect:/";
	}

	// Chức năng 6: Xóa bài viết của bản thân
	@PostMapping("/posts/delete/{id}")
	public String deletePost(@PathVariable("id") Integer postId,
							 @RequestParam(value = "redirect", required = false, defaultValue = "/") String redirectUrl,
							 HttpSession session) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser != null) {
			postService.deletePost(postId, currentUser.getUserId());
		}
		return "redirect:" + redirectUrl;
	}
}
