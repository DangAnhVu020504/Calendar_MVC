package com.cld.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cld.model.User;
import com.cld.service.UserService;

@Controller
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/")
    public String home(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        return "ADMIN".equals(user.getRole()) ? "redirect:/admin/dashboard" : "redirect:/dashboard";
    }
    
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return "ADMIN".equals(user.getRole()) ? "redirect:/admin/dashboard" : "redirect:/dashboard";
        }
        return "user/login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam("username") String username,
                       @RequestParam("password") String password,
                       HttpSession session,
                       Model model) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            // Phân quyền dựa vào role
            return "ADMIN".equals(user.getRole()) ? "redirect:/admin/dashboard" : "redirect:/dashboard";
        } else {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            return "user/login";
        }
    }
    
    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return "ADMIN".equals(user.getRole()) ? "redirect:/admin/dashboard" : "redirect:/dashboard";
        }
        return "user/register";
    }
    
    @PostMapping("/register")
    public String register(@RequestParam("username") String username,
                          @RequestParam("password") String password,
                          @RequestParam("email") String email,
                          @RequestParam("fullName") String fullName,
                          Model model) {
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) 
        {
            model.addAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            return "user/register";
        }
        
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password.trim());
        user.setEmail(email.trim());
        user.setFullName(fullName.trim());
        user.setRole("USER"); // Mặc định user mới là USER
        
        if (userService.register(user)) {
            model.addAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "user/login";
        } else {
            model.addAttribute("error", "Tên đăng nhập đã tồn tại!");
            return "user/register";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}