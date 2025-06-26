package com.cld.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cld.model.Priority;
import com.cld.model.Schedule;
import com.cld.model.ScheduleType;
import com.cld.model.User;
import com.cld.service.ScheduleService;

@Controller
public class ScheduleController {
    
    @Autowired
    private ScheduleService scheduleService;
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        List<Schedule> schedules = scheduleService.getUserSchedules(user.getId());
        model.addAttribute("schedules", schedules);
        model.addAttribute("user", user);
        return "user/dashboard";
    }
    
    @GetMapping("/schedule/new")
    public String newSchedulePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("priorities", Priority.values()); // dùng để hiển thị danh sách ưu tiên trong form tạo
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "user/new-schedule";
    }
    
    @PostMapping("/schedule/create")
    public String createSchedule(@RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("startDate") String startDate,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               @RequestParam("type") String type,
                               @RequestParam("priority") String priority,
                               @RequestParam(value = "recurringDays", required = false, defaultValue = "1") int recurringDays,
                               HttpSession session,
                               Model model) { // để truyền key và value từ controller sang view
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime start = LocalDateTime.parse(startDate, formatter);
            LocalDateTime end = endDate != null && !endDate.isEmpty() ? LocalDateTime.parse(endDate, formatter) : null;
            if (type.equals("RECURRING")) {
                for (int i = 0; i < recurringDays; i++) {
                    Schedule schedule = new Schedule();
                    schedule.setUserId(user.getId());
                    schedule.setTitle(title);
                    schedule.setDescription(description);
                    schedule.setStartDate(start.plusDays(i));
                    schedule.setEndDate(null);
                    schedule.setType(ScheduleType.RECURRING);
                    schedule.setPriority(Priority.valueOf(priority));
                    schedule.setRecurringDays(recurringDays);
                    scheduleService.createSchedule(schedule);
                }
            } else {
                Schedule schedule = new Schedule();
                schedule.setUserId(user.getId());
                schedule.setTitle(title);
                schedule.setDescription(description);
                schedule.setStartDate(start);
                schedule.setEndDate(end);
                schedule.setType(ScheduleType.valueOf(type));
                schedule.setPriority(Priority.valueOf(priority));
                schedule.setRecurringDays(1);
                scheduleService.createSchedule(schedule);
            }
            if (user.getId() == 1L) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/dashboard";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo lịch trình: " + e.getMessage());
            model.addAttribute("priorities", Priority.values());
            return "user/new-schedule";
        }
    }
    
    @GetMapping("/schedule/edit/{id}")
    public String editSchedulePage(@PathVariable("id") Long id, 
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null || !schedule.getUserId().equals(user.getId())) {
            return "redirect:/dashboard";
        }
        
        model.addAttribute("schedule", schedule);
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "user/edit-schedule";
    }
    
    @PostMapping("/schedule/update/{id}")
    public String updateSchedule(@PathVariable("id") Long id,
                               @RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("startDate") String startDate,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               @RequestParam("type") String type,
                               @RequestParam("priority") String priority,
                               @RequestParam(value = "recurringDays", required = false, defaultValue = "1") int recurringDays,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        Schedule oldSchedule = scheduleService.getScheduleById(id);
        if (oldSchedule == null || !oldSchedule.getUserId().equals(user.getId())) {
            return "redirect:/dashboard";
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"); // định dạng ngày giờ
            // Chuyển đổi chuỗi ngày giờ sang LocalDateTime Ví dụ: "2025-06-26T12:31" -> LocalDateTime đại diện cho 12:31 ngày 26/06/2025.
            LocalDateTime start = LocalDateTime.parse(startDate, formatter);
            //
            LocalDateTime endVal = endDate != null && !endDate.isEmpty() ? LocalDateTime.parse(endDate, formatter) : null;
            // người dùng muốn đổi lịch trình mới khác với lịch trình lặp lại và lịch trình cũ là lặp lại
           if (!type.equals("RECURRING") && oldSchedule.getType() == ScheduleType.RECURRING) {
                 scheduleService.updateRecurringGroupToType(user.getId(), oldSchedule.getTitle(), type, priority, oldSchedule.getColor(), description, endVal);
            }
            scheduleService.deleteSchedule(id);
            if (type.equals("RECURRING")) {
                for (int i = 0; i < recurringDays; i++) {
                    Schedule schedule = new Schedule();
                    schedule.setUserId(user.getId());
                    schedule.setTitle(title);
                    schedule.setDescription(description);
                    schedule.setStartDate(start.plusDays(i));
                    schedule.setEndDate(null);
                    schedule.setType(ScheduleType.RECURRING);
                    schedule.setPriority(Priority.valueOf(priority));
                    schedule.setRecurringDays(recurringDays);
                    scheduleService.createSchedule(schedule);
                }
            } else {
                Schedule schedule = new Schedule();
                schedule.setUserId(user.getId());
                schedule.setTitle(title);
                schedule.setDescription(description);
                schedule.setStartDate(start);
                schedule.setEndDate(endVal);
                schedule.setType(ScheduleType.valueOf(type));
                schedule.setPriority(Priority.valueOf(priority));
                schedule.setRecurringDays(1);
                scheduleService.createSchedule(schedule);
            }
            if (user.getId() == 1L) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/dashboard";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật lịch trình: " + e.getMessage());
            model.addAttribute("schedule", oldSchedule);
            model.addAttribute("priorities", Priority.values());
            return "user/edit-schedule";
        }
    }
    
    @PostMapping("/schedule/delete/{id}")
    public String deleteSchedule(@PathVariable("id") Long id, 
                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule != null && schedule.getUserId().equals(user.getId())) {
            scheduleService.deleteSchedule(id);
        }
        
        // Check if the user is an admin (ID = 1) and redirect accordingly
        if (user.getId() == 1L) {
            return "redirect:/admin/dashboard";
        } else {
            return "redirect:/dashboard";
        }
    }
}