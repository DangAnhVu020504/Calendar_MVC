package com.cld.controller;

import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cld.model.User;
import com.cld.model.Schedule;
import com.cld.model.Priority;
import com.cld.model.ScheduleType;
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
    public String dashboard(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        long totalUsers = userService.getTotalUsers();
        long totalSchedules = scheduleService.getTotalSchedules();
        List<Schedule> recentSchedules = scheduleService.getRecentSchedules(5);
        List<User> recentUsers = userService.getRecentUsers(5);
        List<Schedule> allSchedules = scheduleService.getAllSchedules();
        
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalSchedules", totalSchedules);
        model.addAttribute("recentSchedules", recentSchedules);
        model.addAttribute("recentUsers", recentUsers);
        model.addAttribute("user", currentUser);
        model.addAttribute("schedules", allSchedules);
        
        return "admin/dashboard";
    }
    
    @GetMapping("/users")
    public String listUsers(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin/users";
    }
    
    @GetMapping("/users/{id}")
    public String userDetail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        User user = userService.getUserById(id);
        if (user == null) {
            return "redirect:/admin/users";
        }
        
        List<Schedule> userSchedules = scheduleService.getUserSchedules(id);
        model.addAttribute("user", user);
        model.addAttribute("schedules", userSchedules);
        return "admin/user-detail";
    }
    
    @GetMapping("/edit-user/{id}")
    public String editUserForm(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        User user = userService.getUserById(id);
        if (user == null) {
            return "redirect:/admin/users";
        }
        model.addAttribute("user", user);
        return "admin/edit-user";
    }
    
    @PostMapping("/edit-user/{id}")
    public String updateUser(@PathVariable Long id, @ModelAttribute User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        user.setId(id);
        userService.updateUser(user);
        return "redirect:/admin/users";
    }
    
    @PostMapping("/delete-user/{id}")
    public String deleteUser(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }
    
    @GetMapping("/schedules")
    public String listSchedules(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        List<Schedule> schedules = scheduleService.getAllSchedules();
        // Populate the User object for each schedule
        for (Schedule schedule : schedules) {
            User user = userService.getUserById(schedule.getUserId());
            schedule.setUser(user);
        }
        model.addAttribute("schedules", schedules);
        return "admin/schedules";
    }
    
    @GetMapping("/schedules/{id}")
    public String scheduleDetail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null) {
            return "redirect:/admin/schedules";
        }
        
        User scheduleUser = userService.getUserById(schedule.getUserId());
        model.addAttribute("schedule", schedule);
        model.addAttribute("user", scheduleUser);
        return "admin/schedule-detail";
    }
    
    @GetMapping("/edit-schedule/{id}")
    public String editScheduleForm(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null) {
            return "redirect:/admin/schedules";
        }
        
        List<User> users = userService.getAllUsers();
        model.addAttribute("schedule", schedule);
        model.addAttribute("users", users);
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "admin/edit-schedule";
    }
    
    @PostMapping("/edit-schedule/{id}")
    public String updateSchedule(@PathVariable Long id,
                               @RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("startDate") String startDate,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               @RequestParam("type") String type,
                               @RequestParam("priority") String priority,
                               @RequestParam(value = "recurringDays", required = false) Integer recurringDays,
                               HttpSession session,
                               Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        try {
            Schedule schedule = scheduleService.getScheduleById(id);
            if (schedule == null) {
                return "redirect:/admin/schedules";
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            schedule.setTitle(title);
            schedule.setDescription(description);
            schedule.setStartDate(LocalDateTime.parse(startDate, formatter));
            
            ScheduleType scheduleType = ScheduleType.valueOf(type);
            schedule.setType(scheduleType);
            schedule.setPriority(Priority.valueOf(priority));
            
            if (scheduleType == ScheduleType.RECURRING) {
                schedule.setEndDate(null); // Recurring schedules don't have an end date
                schedule.setRecurring(true);
                schedule.setRecurringPattern(recurringDays != null ? String.valueOf(recurringDays) : null); // Store recurringDays as pattern
            } else {
                schedule.setEndDate(endDate != null && !endDate.isEmpty() ? 
                    LocalDateTime.parse(endDate, formatter) : null);
                schedule.setRecurring(false);
                schedule.setRecurringPattern(null);
            }
            
            scheduleService.updateSchedule(schedule);
            return "redirect:/admin/schedules";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật lịch trình: " + e.getMessage());
            // Lấy lại schedule và các thông tin cần thiết để hiển thị lại form
            Schedule scheduleToReEdit = scheduleService.getScheduleById(id);
            List<User> users = userService.getAllUsers();
            model.addAttribute("schedule", scheduleToReEdit);
            model.addAttribute("users", users);
            model.addAttribute("priorities", Priority.values());
            model.addAttribute("scheduleTypes", ScheduleType.values());
            return "admin/edit-schedule";
        }
    }
    
    @PostMapping("/delete-schedule/{id}")
    public String deleteSchedule(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        scheduleService.deleteSchedule(id);
        return "redirect:/admin/schedules";
    }
    
    @GetMapping("/reports")
    public String reports(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getId() != 1) {
            return "redirect:/login";
        }
        
        List<Schedule> allSchedules = scheduleService.getAllSchedules();
        
        // Count schedules by type
        long longTermCount = allSchedules.stream().filter(s -> s.getType() == ScheduleType.LONG_TERM).count();
        long shortTermCount = allSchedules.stream().filter(s -> s.getType() == ScheduleType.SHORT_TERM).count();
        long recurringCount = allSchedules.stream().filter(s -> s.getType() == ScheduleType.RECURRING).count();
        
        // Count schedules by priority
        long urgentImportantCount = allSchedules.stream().filter(s -> s.getPriority() == Priority.URGENT_IMPORTANT).count();
        long notUrgentNotImportantCount = allSchedules.stream().filter(s -> s.getPriority() == Priority.NOT_URGENT_NOT_IMPORTANT).count();
        long importantNotUrgentCount = allSchedules.stream().filter(s -> s.getPriority() == Priority.IMPORTANT_NOT_URGENT).count();
        long notImportantUrgentCount = allSchedules.stream().filter(s -> s.getPriority() == Priority.NOT_IMPORTANT_URGENT).count();
        long specialCount = allSchedules.stream().filter(s -> s.getPriority() == Priority.SPECIAL).count();
        
        // Count recurring vs non-recurring
        long recurringSchedulesCount = allSchedules.stream().filter(Schedule::isRecurring).count();
        long nonRecurringSchedulesCount = allSchedules.size() - recurringSchedulesCount;
        
        // Count notification status
        long notificationSentCount = allSchedules.stream().filter(Schedule::isNotificationSent).count();
        long notificationNotSentCount = allSchedules.size() - notificationSentCount;
        
        model.addAttribute("totalSchedules", allSchedules.size());
        model.addAttribute("longTermCount", longTermCount);
        model.addAttribute("shortTermCount", shortTermCount);
        model.addAttribute("recurringCount", recurringCount);
        model.addAttribute("urgentImportantCount", urgentImportantCount);
        model.addAttribute("notUrgentNotImportantCount", notUrgentNotImportantCount);
        model.addAttribute("importantNotUrgentCount", importantNotUrgentCount);
        model.addAttribute("notImportantUrgentCount", notImportantUrgentCount);
        model.addAttribute("specialCount", specialCount);
        model.addAttribute("recurringSchedulesCount", recurringSchedulesCount);
        model.addAttribute("nonRecurringSchedulesCount", nonRecurringSchedulesCount);
        model.addAttribute("notificationSentCount", notificationSentCount);
        model.addAttribute("notificationNotSentCount", notificationNotSentCount);
        
        return "admin/reports";
    }
}