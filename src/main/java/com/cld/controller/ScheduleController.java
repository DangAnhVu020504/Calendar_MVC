package com.cld.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cld.model.Priority;
import com.cld.model.Schedule;
import com.cld.model.ScheduleType;
import com.cld.model.User;
import com.cld.service.ScheduleService;

@Controller
@RequestMapping("/calendar")
public class ScheduleController {
    
    @Autowired
    private ScheduleService scheduleService;
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/calendar/login";
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
            return "redirect:/calendar/login";
        }
        
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "new-schedule";
    }
    
    @PostMapping("/schedule/create")
    public String createSchedule(@RequestParam String title,
                               @RequestParam String description,
                               @RequestParam String startDate,
                               @RequestParam(required = false) String endDate,
                               @RequestParam String type,
                               @RequestParam String priority,
                               @RequestParam(required = false) boolean isRecurring,
                               @RequestParam(required = false) String recurringPattern,
                               HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/calendar/login";
        }
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime start = LocalDateTime.parse(startDate, formatter);
            LocalDateTime end = endDate != null && !endDate.isEmpty() ? 
                LocalDateTime.parse(endDate, formatter) : null;
            
            Schedule schedule = new Schedule(
                user.getId(),
                title,
                description,
                start,
                end,
                ScheduleType.valueOf(type),
                Priority.valueOf(priority)
            );
            
            schedule.setRecurring(isRecurring);
            schedule.setRecurringPattern(recurringPattern);
            
            scheduleService.createSchedule(schedule);
            
            if (isRecurring) {
                scheduleService.createRecurringSchedules(schedule);
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
    public String editSchedulePage(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/calendar/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null || !schedule.getUserId().equals(user.getId())) {
            return "redirect:/calendar/dashboard";
        }
        
        model.addAttribute("schedule", schedule);
        model.addAttribute("priorities", Priority.values());
        model.addAttribute("scheduleTypes", ScheduleType.values());
        return "edit-schedule";
    }
    
    @PostMapping("/schedule/update/{id}")
    public String updateSchedule(@PathVariable Long id,
                               @RequestParam String title,
                               @RequestParam String description,
                               @RequestParam String startDate,
                               @RequestParam(required = false) String endDate,
                               @RequestParam String type,
                               @RequestParam String priority,
                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/calendar/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule == null || !schedule.getUserId().equals(user.getId())) {
            return "redirect:/calendar/dashboard";
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
            
            scheduleService.updateSchedule(schedule);
            return "redirect:/calendar/dashboard";
        } catch (Exception e) {
            return "redirect:/calendar/schedule/edit/" + id + "?error=true";
        }
    }
    
    @PostMapping("/schedule/delete/{id}")
    public String deleteSchedule(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/calendar/login";
        }
        
        Schedule schedule = scheduleService.getScheduleById(id);
        if (schedule != null && schedule.getUserId().equals(user.getId())) {
            scheduleService.deleteSchedule(id);
        }
        
        return "redirect:/calendar/dashboard";
    }
}