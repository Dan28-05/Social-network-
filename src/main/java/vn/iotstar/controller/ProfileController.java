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
import java.util.Optional;

@Controller
@RequestMapping("/profile")
public class ProfileController {

	@Autowired
	private UserService userService;

	@Autowired
	private PostService postService;

	@Autowired
	private vn.iotstar.services.FollowService followService;

	@Autowired
	private vn.iotstar.services.LikeService likeService;

	@Autowired
	private vn.iotstar.services.CommentService commentService;

	// Xem trang cá nhân của bản thân
	@GetMapping
	public String myProfile(HttpSession session, Model model) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		// Lấy lại dữ liệu mới nhất của User từ DB
		User user = userService.findById(currentUser.getUserId()).orElse(currentUser);
		session.setAttribute("currentUser", user);

		List<Post> myPosts = postService.getPostsByUserId(user.getUserId());
		long followerCount = followService.getFollowerCount(user.getUserId());
		long followingCount = followService.getFollowingCount(user.getUserId());

		List<Integer> postIds = myPosts.stream().map(Post::getPostId).collect(java.util.stream.Collectors.toList());
		java.util.Map<Integer, Long> likeCounts = likeService.getLikeCountsMap(postIds);
		java.util.Map<Integer, Long> commentCounts = commentService.getCommentCountsMap(postIds);

		model.addAttribute("profileUser", user);
		model.addAttribute("posts", myPosts);
		model.addAttribute("isOwner", true);
		model.addAttribute("followerCount", followerCount);
		model.addAttribute("followingCount", followingCount);
		model.addAttribute("likeCounts", likeCounts);
		model.addAttribute("commentCounts", commentCounts);
		return "profile";
	}

	// Xem trang cá nhân của người khác
	@GetMapping("/user/{id}")
	public String viewUserProfile(@PathVariable("id") Integer userId, HttpSession session, Model model) {
		Optional<User> userOpt = userService.findById(userId);
		if (!userOpt.isPresent()) {
			return "redirect:/";
		}

		User profileUser = userOpt.get();
		User currentUser = (User) session.getAttribute("currentUser");
		boolean isOwner = currentUser != null && currentUser.getUserId().equals(profileUser.getUserId());
		boolean isFollowing = currentUser != null && followService.isFollowing(currentUser.getUserId(), profileUser.getUserId());
		long followerCount = followService.getFollowerCount(profileUser.getUserId());
		long followingCount = followService.getFollowingCount(profileUser.getUserId());

		List<Post> userPosts = postService.getPostsByUserId(profileUser.getUserId());
		List<Integer> postIds = userPosts.stream().map(Post::getPostId).collect(java.util.stream.Collectors.toList());
		java.util.Map<Integer, Long> likeCounts = likeService.getLikeCountsMap(postIds);
		java.util.Map<Integer, Long> commentCounts = commentService.getCommentCountsMap(postIds);

		model.addAttribute("profileUser", profileUser);
		model.addAttribute("posts", userPosts);
		model.addAttribute("isOwner", isOwner);
		model.addAttribute("isFollowing", isFollowing);
		model.addAttribute("followerCount", followerCount);
		model.addAttribute("followingCount", followingCount);
		model.addAttribute("likeCounts", likeCounts);
		model.addAttribute("commentCounts", commentCounts);
		return "profile";
	}

	// Giao diện chỉnh sửa trang cá nhân
	@GetMapping("/edit")
	public String editProfilePage(HttpSession session, Model model) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}
		User user = userService.findById(currentUser.getUserId()).orElse(currentUser);
		model.addAttribute("user", user);
		return "edit-profile";
	}

	// Xử lý cập nhật thông tin trang cá nhân (Hỗ trợ upload ảnh đại diện từ máy tính)
	@PostMapping("/edit")
	public String handleUpdateProfile(@RequestParam("fullname") String fullname,
									  @RequestParam(value = "bio", required = false) String bio,
									  @RequestParam(value = "avatarFile", required = false) org.springframework.web.multipart.MultipartFile avatarFile,
									  @RequestParam(value = "avatar", required = false) String avatarUrl,
									  javax.servlet.http.HttpServletRequest request,
									  HttpSession session,
									  Model model) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		String finalAvatar = null;

		// 1. Kiểm tra nếu người dùng chọn file ảnh đại diện từ máy tính
		if (avatarFile != null && !avatarFile.isEmpty()) {
			try {
				byte[] fileBytes = avatarFile.getBytes();
				String contentType = avatarFile.getContentType();
				String originalFilename = avatarFile.getOriginalFilename();
				String lowerName = (originalFilename != null) ? originalFilename.toLowerCase() : "";

				if (contentType == null || contentType.trim().isEmpty() || "application/octet-stream".equals(contentType)) {
					if (lowerName.endsWith(".png")) contentType = "image/png";
					else if (lowerName.endsWith(".webp")) contentType = "image/webp";
					else if (lowerName.endsWith(".gif")) contentType = "image/gif";
					else contentType = "image/jpeg";
				}

				// Chuyển đổi thành Base64 Data URL để lưu trực tiếp vào Database (VARCHAR(MAX))
				String base64Data = java.util.Base64.getEncoder().encodeToString(fileBytes);
				finalAvatar = "data:" + contentType + ";base64," + base64Data;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
			finalAvatar = avatarUrl.trim();
		}

		try {
			User updatedUser = userService.updateProfile(currentUser.getUserId(), fullname, bio, finalAvatar);
			session.setAttribute("currentUser", updatedUser);
			return "redirect:/profile";
		} catch (Exception e) {
			model.addAttribute("error", e.getMessage());
			model.addAttribute("user", currentUser);
			return "edit-profile";
		}
	}
}
