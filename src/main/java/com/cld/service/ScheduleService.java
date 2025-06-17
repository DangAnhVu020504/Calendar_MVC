package com.cld.service;

import com.cld.model.Schedule;
import java.util.List;

public interface ScheduleService {
    void createSchedule(Schedule schedule);
    List<Schedule> getUserSchedules(Long userId);
    List<Schedule> getUpcomingSchedules();
    void markNotificationSent(Long scheduleId);
    void updateSchedule(Schedule schedule);
    void deleteSchedule(Long id);
    Schedule getScheduleById(Long id);
    void createRecurringSchedules(Schedule baseSchedule);
    List<Schedule> getAllSchedules();
    List<Schedule> getRecentSchedules(int limit);
    List<Schedule> getSchedulesByUserId(Long userId);
    long getTotalSchedules();
    void saveSchedule(Schedule schedule);
}