package com.cld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.cld.model.Priority;
import com.cld.model.Schedule;
import com.cld.model.ScheduleType;

@Repository
public class ScheduleDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private static final class ScheduleRowMapper implements RowMapper<Schedule> {
        @Override
        public Schedule mapRow(ResultSet rs, int rowNum) throws SQLException {
            Schedule schedule = new Schedule();
            schedule.setId(rs.getLong("id"));
            schedule.setUserId(rs.getLong("user_id"));
            schedule.setTitle(rs.getString("title"));
            schedule.setDescription(rs.getString("description"));
            
            Timestamp startTimestamp = rs.getTimestamp("start_date");
            if (startTimestamp != null) {
                schedule.setStartDate(startTimestamp.toLocalDateTime());
            }
            
            Timestamp endTimestamp = rs.getTimestamp("end_date");
            if (endTimestamp != null) {
                schedule.setEndDate(endTimestamp.toLocalDateTime());
            }
            
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
        String sql = "INSERT INTO schedules (user_id, title, description, start_date, end_date, " +
                    "type, priority, color, is_recurring, recurring_pattern, notification_sent) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql, 
            schedule.getUserId(),
            schedule.getTitle(),
            schedule.getDescription(),
            Timestamp.valueOf(schedule.getStartDate()),
            schedule.getEndDate() != null ? Timestamp.valueOf(schedule.getEndDate()) : null,
            schedule.getType().name(),
            schedule.getPriority().name(),
            schedule.getColor(),
            schedule.isRecurring(),
            schedule.getRecurringPattern(),
            schedule.isNotificationSent()
        );
    }
    
    public List<Schedule> findByUserId(Long userId) {
        String sql = "SELECT * FROM schedules WHERE user_id = ? ORDER BY start_date";
        return jdbcTemplate.query(sql, new ScheduleRowMapper(), userId);
    }
    
    public List<Schedule> findUpcomingSchedules() {
        String sql = "SELECT * FROM schedules WHERE end_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 DAY) " +
                    "AND notification_sent = false";
        return jdbcTemplate.query(sql, new ScheduleRowMapper());
    }
    
    public void updateNotificationSent(Long scheduleId) {
        String sql = "UPDATE schedules SET notification_sent = true WHERE id = ?";
        jdbcTemplate.update(sql, scheduleId);
    }
    
    public void update(Schedule schedule) {
        String sql = "UPDATE schedules SET title = ?, description = ?, start_date = ?, end_date = ?, " +
                    "type = ?, priority = ?, color = ?, is_recurring = ?, recurring_pattern = ? WHERE id = ?";
        
        jdbcTemplate.update(sql,
            schedule.getTitle(),
            schedule.getDescription(),
            Timestamp.valueOf(schedule.getStartDate()),
            schedule.getEndDate() != null ? Timestamp.valueOf(schedule.getEndDate()) : null,
            schedule.getType().name(),
            schedule.getPriority().name(),
            schedule.getColor(),
            schedule.isRecurring(),
            schedule.getRecurringPattern(),
            schedule.getId()
        );
    }
    
    public void delete(Long id) {
        String sql = "DELETE FROM schedules WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
    
    public Schedule findById(Long id) {
        String sql = "SELECT * FROM schedules WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ScheduleRowMapper(), id);
        } catch (Exception e) {
            return null;
        }
    }
}