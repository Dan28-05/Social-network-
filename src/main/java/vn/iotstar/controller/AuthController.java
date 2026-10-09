package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.iotstar.entity.User;
import vn.iotstar.services.UserService;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

	@Autowired
	private UserService userService;

	// Giao diện Đăng nhập
	@GetMapping("/login")
	public String loginPage(HttpSession session) {
		if (session.getAttribute("currentUser") != null) {
			return "redirect:/";
		}
		return "login";
	}

	// Xử lý Đăng nhập
	@PostMapping("/login")
	public String handleLogin(@RequestParam("username") String username,
							  @RequestParam("password") String password,
							  HttpSession session,
							  Model model) {
		Optional<User> userOpt = userService.login(username.trim(), password.trim());
		if (userOpt.isPresent()) {
			session.setAttribute("currentUser", userOpt.get());
			return "redirect:/";
		} else {
			model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
			return "login";
		}
	}

	// Giao diện Đăng ký
	@GetMapping("/register")
	public String registerPage(HttpSession session) {
		if (session.getAttribute("currentUser") != null) {
			return "redirect:/";
		}
		return "register";
	}

	// Xử lý Đăng ký
	@PostMapping("/register")
	public String handleRegister(@RequestParam("username") String username,
								 @RequestParam("password") String password,
								 @RequestParam("email") String email,
								 @RequestParam("fullname") String fullname,
								 HttpSession session,
								 Model model) {
		try {
			User newUser = userService.register(username.trim(), password.trim(), email.trim(), fullname.trim());
			session.setAttribute("currentUser", newUser);
			return "redirect:/";
		} catch (Exception e) {
			model.addAttribute("error", e.getMessage());
			return "register";
		}
	}

	// Đăng xuất
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}
}
