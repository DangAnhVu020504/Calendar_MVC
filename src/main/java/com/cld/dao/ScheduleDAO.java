package com.cld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.cld.model.Schedule;
import com.cld.model.Priority;
import com.cld.model.ScheduleType;

@Repository
public class ScheduleDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public JdbcTemplate getJdbcTemplate() {
        return jdbcTemplate;
    }
    
    public static class ScheduleRowMapper implements RowMapper<Schedule> {
        @Override
        public Schedule mapRow(ResultSet rs, int rowNum) throws SQLException {
            Schedule schedule = new Schedule();
            schedule.setId(rs.getLong("id"));
            schedule.setUserId(rs.getLong("user_id"));
            schedule.setTitle(rs.getString("title"));
            schedule.setDescription(rs.getString("description"));
            schedule.setStartDate(rs.getObject("start_date", java.time.LocalDateTime.class));
            schedule.setEndDate(rs.getObject("end_date", java.time.LocalDateTime.class));
            schedule.setType(ScheduleType.valueOf(rs.getString("type")));
            schedule.setPriority(Priority.valueOf(rs.getString("priority")));
            schedule.setColor(rs.getString("color"));
            schedule.setRecurring(rs.getBoolean("is_recurring"));
            schedule.setRecurringPattern(rs.getString("recurring_pattern"));
            schedule.setNotificationSent(rs.getBoolean("notification_sent"));
            schedule.setNotification1DaySent(rs.getBoolean("notification_1day_sent"));
            schedule.setNotification5HourSent(rs.getBoolean("notification_5h_sent"));
            schedule.setNotification1HourSent(rs.getBoolean("notification_1h_sent"));
            schedule.setNotificationOnTimeSent(rs.getBoolean("notification_ontime_sent"));
            return schedule;
        }
    }
    
    public void save(Schedule schedule) {
        String sql = "INSERT INTO schedules (user_id, title, description, start_date, end_date, type, priority, color, recurring_days, notification_1day_sent, notification_5h_sent, notification_1h_sent, notification_ontime_sent) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, schedule.getUserId(), schedule.getTitle(), schedule.getDescription(),
                           schedule.getStartDate(), schedule.getEndDate(),
                           schedule.getType().name(),
                           schedule.getPriority().name(), schedule.getColor(), schedule.getRecurringDays(),
                           schedule.isNotification1DaySent(), schedule.isNotification5HourSent(), schedule.isNotification1HourSent(), schedule.isNotificationOnTimeSent());
    }
    
    public Schedule findById(Long id) {
        String sql = "SELECT s.*, u.username, u.full_name FROM schedules s " +
                    "JOIN users u ON s.user_id = u.id WHERE s.id = ?";
        return jdbcTemplate.queryForObject(sql, new ScheduleRowMapper(), id);
    }
    
    public List<Schedule> findAll() {
        String sql = "SELECT s.*, u.username, u.full_name FROM schedules s " +
                    "JOIN users u ON s.user_id = u.id ORDER BY s.created_at DESC";
        return jdbcTemplate.query(sql, new ScheduleRowMapper());
    }
    
    public List<Schedule> findRecentSchedules(int limit) {
        String sql = "SELECT s.*, u.username, u.full_name FROM schedules s " +
                    "JOIN users u ON s.user_id = u.id ORDER BY s.created_at DESC LIMIT ?";
        return jdbcTemplate.query(sql, new ScheduleRowMapper(), limit);
    }
    
    public List<Schedule> findByUserId(Long userId) {
        String sql = "SELECT s.*, u.username, u.full_name FROM schedules s " +
                    "JOIN users u ON s.user_id = u.id WHERE s.user_id = ? ORDER BY s.created_at DESC";
        return jdbcTemplate.query(sql, new ScheduleRowMapper(), userId);
    }
    
    public List<Schedule> findUpcomingSchedules() {
        String sql = "SELECT s.*, u.username, u.full_name FROM schedules s " +
                    "JOIN users u ON s.user_id = u.id WHERE s.start_date > NOW() ORDER BY s.start_date ASC";
        return jdbcTemplate.query(sql, new ScheduleRowMapper());
    }
    
    public long count() {
        String sql = "SELECT COUNT(*) FROM schedules";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }
    
    public void update(Schedule schedule) {
        String sql = "UPDATE schedules SET title = ?, description = ?, start_date = ?, end_date = ?, type = ?, " +
                    "priority = ?, color = ?, recurring_days = ?, notification_1day_sent = ?, notification_5h_sent = ?, notification_1h_sent = ?, notification_ontime_sent = ? WHERE id = ?";
        jdbcTemplate.update(sql, 
            schedule.getTitle(),
            schedule.getDescription(),
            schedule.getStartDate(),
            schedule.getEndDate(),
            schedule.getType().toString(),
            schedule.getPriority().toString(),
            schedule.getColor(),
            schedule.getRecurringDays(),
            schedule.isNotification1DaySent(),
            schedule.isNotification5HourSent(),
            schedule.isNotification1HourSent(),
            schedule.isNotificationOnTimeSent(),
            schedule.getId()
        );
    }
    
    public void updateNotificationSent(Long scheduleId) {
        String sql = "UPDATE schedules SET notification_sent = TRUE WHERE id = ?";
        jdbcTemplate.update(sql, scheduleId);
    }
    
    public void delete(Long id) {
        String sql = "DELETE FROM schedules WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
    
    public void deleteRecurringSchedules(Long userId, LocalDateTime originalStartDate) {
        String sql = "DELETE FROM schedules WHERE user_id = ? AND start_date >= ? AND is_recurring = FALSE";
        jdbcTemplate.update(sql, userId, originalStartDate);
    }
    
    public void deleteRecurringGroup(Long userId, String title, Long exceptId) {
        String sql = "DELETE FROM schedules WHERE user_id = ? AND title = ? AND type = 'RECURRING' AND id <> ?";
        jdbcTemplate.update(sql, userId, title, exceptId);
    }
    
    public void updateRecurringGroupToType(Long userId, String title, String newType, String newPriority, String newColor, String newDescription, java.time.LocalDateTime newEndDate) {
        String sql = "UPDATE schedules SET type = ?, priority = ?, color = ?, description = ?, end_date = ? WHERE user_id = ? AND title = ? AND type = 'RECURRING'";
        jdbcTemplate.update(sql, newType, newPriority, newColor, newDescription, newEndDate, userId, title);
    }
}