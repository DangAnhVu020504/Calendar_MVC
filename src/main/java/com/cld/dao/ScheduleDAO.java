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
            return schedule;
        }
    }
    
    public void save(Schedule schedule) {
        String sql = "INSERT INTO schedules (user_id, title, description, start_date, end_date, type, priority, color, is_recurring) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, schedule.getUserId(), schedule.getTitle(), schedule.getDescription(),
                           schedule.getStartDate(), schedule.getEndDate(), schedule.getType().name(),
                           schedule.getPriority().name(), schedule.getColor(), schedule.isRecurring());
    }
    
    public Schedule findById(Long id) {
        String sql = "SELECT * FROM schedules WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ScheduleRowMapper(), id);
        } catch (Exception e) {
            return null;
        }
    }
    
    public List<Schedule> findByUserId(Long userId) {
        String sql = "SELECT * FROM schedules WHERE user_id = ?";
        return jdbcTemplate.query(sql, new ScheduleRowMapper(), userId);
    }
    
    public List<Schedule> findUpcomingSchedules() {
        String sql = "SELECT * FROM schedules WHERE start_date > NOW() ORDER BY start_date ASC";
        return jdbcTemplate.query(sql, new ScheduleRowMapper());
    }
    
    public void update(Schedule schedule) {
        String sql = "UPDATE schedules SET user_id = ?, title = ?, description = ?, start_date = ?, end_date = ?, type = ?, " +
                     "priority = ?, color = ?, is_recurring = ?, recurring_pattern = ?, notification_sent = ? WHERE id = ?";
        jdbcTemplate.update(sql, schedule.getUserId(), schedule.getTitle(), schedule.getDescription(),
                           schedule.getStartDate(), schedule.getEndDate(), schedule.getType().name(),
                           schedule.getPriority().name(), schedule.getColor(), schedule.isRecurring(),
                           schedule.getRecurringPattern(), schedule.isNotificationSent(), schedule.getId());
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
}