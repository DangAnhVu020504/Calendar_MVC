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
        return "dashboard";
    }
    
    @GetMapping("/schedule/new")
    public String newSchedulePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "new-schedule";
    }
    
    @PostMapping("/schedule/create")
    public String createSchedule(@RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("startDate") String startDate,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               @RequestParam(value = "recurringDays", required = false) Integer recurringDays,
                               @RequestParam("type") String type,
                               @RequestParam("priority") String priority,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime start = LocalDateTime.parse(startDate, formatter);
            
            Schedule schedule = new Schedule(
                user.getId(),
                title,
                description,
                start,
                null, // endDate sẽ được xử lý tùy theo type
                ScheduleType.valueOf(type),
                Priority.valueOf(priority)
            );
            
            if ("RECURRING".equals(type)) {
                // Xử lý lặp lại: tạo sự kiện cho từng ngày từ startDate trong recurringDays ngày
                int days = recurringDays != null && recurringDays > 0 ? recurringDays : 1;
                schedule.setRecurringDays(days);
                LocalDateTime currentStart = start;
                
                for (int i = 0; i < days; i++) {
                    Schedule recurringSchedule = new Schedule(
                        user.getId(),
                        title,
                        description,
                        currentStart,
                        null, // Không cần endDate cho RECURRING
                        ScheduleType.valueOf(type),
                        Priority.valueOf(priority)
                    );
                    scheduleService.createSchedule(recurringSchedule);
                    currentStart = currentStart.plusDays(1); // Tăng ngày, giữ nguyên giờ
                }
            } else {
                // Xử lý LONG_TERM và SHORT_TERM
                LocalDateTime end = endDate != null && !endDate.isEmpty() ? 
                    LocalDateTime.parse(endDate, formatter) : null;
                schedule.setEndDate(end);
                scheduleService.createSchedule(schedule);
            }
            
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi tạo lịch trình: " + e.getMessage());
            model.addAttribute("priorities", Priority.values());
            model.addAttribute("scheduleTypes", ScheduleType.values());
            return "new-schedule";
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
        return "edit-schedule";
    }
    
    @PostMapping("/schedule/update/{id}")
    public String updateSchedule(@PathVariable("id") Long id,
                               @RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("startDate") String startDate,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               @RequestParam(value = "recurringDays", required = false) Integer recurringDays,
                               @RequestParam("type") String type,
                               @RequestParam("priority") String priority,
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
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            schedule.setTitle(title);
            schedule.setDescription(description);
            schedule.setStartDate(LocalDateTime.parse(startDate, formatter));
            schedule.setEndDate(endDate != null && !endDate.isEmpty() ? 
                LocalDateTime.parse(endDate, formatter) : null);
            schedule.setType(ScheduleType.valueOf(type));
            schedule.setPriority(Priority.valueOf(priority));
            
            if ("RECURRING".equals(type)) {
                schedule.setRecurringDays(recurringDays != null && recurringDays > 0 ? recurringDays : 1);
            }
            
            scheduleService.updateSchedule(schedule);
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra khi cập nhật lịch trình: " + e.getMessage());
            model.addAttribute("schedule", schedule);
            model.addAttribute("priorities", Priority.values());
            model.addAttribute("scheduleTypes", ScheduleType.values());
            return "edit-schedule";
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
        
        return "redirect:/dashboard";
    }
}