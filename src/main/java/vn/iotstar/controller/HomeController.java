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

		model.addAttribute("posts", posts);
		model.addAttribute("currentUser", currentUser);
		model.addAttribute("storyUsers", otherUsers);
		model.addAttribute("suggestedUsers", otherUsers);
		model.addAttribute("followingIds", followingIds);
		return "home";
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
