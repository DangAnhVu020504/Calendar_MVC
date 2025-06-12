package com.cld.controller;

import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cld.model.User;
import com.cld.model.Schedule;
import com.cld.service.UserService;
import com.cld.service.ScheduleService;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private ScheduleService scheduleService;
    
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getId() != 1) {
            return "redirect:/login";
        }
        
        List<User> users = userService.findAllUsers();
        List<Schedule> schedules = scheduleService.getAllSchedules();
        model.addAttribute("users", users);
        model.addAttribute("schedules", schedules);
        return "admin-dashboard";
    }
    
    @GetMapping("/edit-user/{id}")
    public String editUserPage(@PathVariable("id") Long id, Model model) {
        User user = userService.findById(id);
        if (user == null) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("user", user);
        return "edit-user";
    }
    
    @PostMapping("/update-user/{id}")
    public String updateUser(@PathVariable("id") Long id, User user, Model model) {
        user.setId(id);
        userService.updateUser(user); 
        return "redirect:/admin/dashboard";
    }
    
    @PostMapping("/delete-user/{id}")
    public String deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id); 
        return "redirect:/admin/dashboard";
    }
    
    @GetMapping("/edit-schedule/{id}")
    public String editSchedulePage(@PathVariable("id") Long id, Model model) {
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null) {
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("schedule", schedule);
        return "edit-schedule"; 
    }
    
    @PostMapping("/update-schedule/{id}")
    public String updateSchedule(@PathVariable("id") Long id, Schedule schedule, Model model) {
        schedule.setId(id);
        scheduleService.updateSchedule(schedule);
        return "redirect:/admin/dashboard";
    }
    
    @PostMapping("/delete-schedule/{id}")
    public String deleteSchedule(@PathVariable("id") Long id) {
        scheduleService.deleteSchedule(id);
        return "redirect:/admin/dashboard";
    }
}