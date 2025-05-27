package com.cld.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cld.dao.ScheduleDAO;
import com.cld.model.Schedule;

@Service
public class ScheduleService {
    
    @Autowired
    private ScheduleDAO scheduleDAO;
    
    public void createSchedule(Schedule schedule) {
        scheduleDAO.save(schedule);
    }
    
    public List<Schedule> getUserSchedules(Long userId) {
        return scheduleDAO.findByUserId(userId);
    }
    
    public List<Schedule> getUpcomingSchedules() {
        return scheduleDAO.findUpcomingSchedules();
    }
    
    public void markNotificationSent(Long scheduleId) {
        scheduleDAO.updateNotificationSent(scheduleId);
    }
    
    public void updateSchedule(Schedule schedule) {
        scheduleDAO.update(schedule);
    }
    
    public void deleteSchedule(Long id) {
        scheduleDAO.delete(id);
    }
    
    public Schedule getScheduleById(Long id) {
        return scheduleDAO.findById(id);
    }
    
    public void createRecurringSchedules(Schedule baseSchedule) {
        if (!baseSchedule.isRecurring()) {
            return;
        }
        
        LocalDateTime currentDate = baseSchedule.getStartDate();
        LocalDateTime endLimit = currentDate.plusMonths(12); // Create for next 12 months
        
        while (currentDate.isBefore(endLimit)) {
            if ("WEEKLY".equals(baseSchedule.getRecurringPattern())) {
                currentDate = currentDate.plusWeeks(1);
            } else if ("MONTHLY".equals(baseSchedule.getRecurringPattern())) {
                currentDate = currentDate.plusMonths(1);
            }
            
            if (currentDate.isBefore(endLimit)) {
                Schedule newSchedule = new Schedule();
                newSchedule.setUserId(baseSchedule.getUserId());
                newSchedule.setTitle(baseSchedule.getTitle());
                newSchedule.setDescription(baseSchedule.getDescription());
                newSchedule.setStartDate(currentDate);
                newSchedule.setEndDate(baseSchedule.getEndDate() != null ? 
                    currentDate.plusHours(baseSchedule.getEndDate().getHour() - baseSchedule.getStartDate().getHour()) : null);
                newSchedule.setType(baseSchedule.getType());
                newSchedule.setPriority(baseSchedule.getPriority());
                newSchedule.setRecurring(false); // Don't make recurring schedules recursive
                
                scheduleDAO.save(newSchedule);
            }
        }
    }
}