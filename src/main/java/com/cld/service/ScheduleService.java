package com.cld.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cld.dao.ScheduleDAO;
import com.cld.model.Schedule;
import com.cld.model.ScheduleType;
import com.cld.model.Priority;

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
    
    @Transactional
    public void updateSchedule(Schedule schedule) {
        Schedule oldSchedule = scheduleDAO.findById(schedule.getId());
        
        if (oldSchedule != null && oldSchedule.getType() == ScheduleType.RECURRING) {
            LocalDateTime originalStartDate = oldSchedule.getStartDate();
            scheduleDAO.deleteRecurringSchedules(schedule.getUserId(), originalStartDate);
            
            if (schedule.getType() == ScheduleType.RECURRING) {
                int days = schedule.getRecurringDays() != null ? schedule.getRecurringDays() : 1;
                LocalDateTime currentStart = originalStartDate;
                for (int i = 0; i < days; i++) {
                    Schedule recurringSchedule = new Schedule(
                        schedule.getUserId(),
                        schedule.getTitle(),
                        schedule.getDescription(),
                        currentStart,
                        null,
                        ScheduleType.RECURRING,
                        schedule.getPriority()
                    );
                    scheduleDAO.save(recurringSchedule);
                    currentStart = currentStart.plusDays(1);
                }
            }
        } else {
            scheduleDAO.update(schedule);
        }
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
        LocalDateTime endLimit = currentDate.plusMonths(12);
        
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
                newSchedule.setRecurring(false);
                scheduleDAO.save(newSchedule);
            }
        }
    }
    
    public List<Schedule> getAllSchedules() {
        String sql = "SELECT * FROM schedules ORDER BY start_date DESC";
        return scheduleDAO.getJdbcTemplate().query(sql, new ScheduleDAO.ScheduleRowMapper());
    }
}