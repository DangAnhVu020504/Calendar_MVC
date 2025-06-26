package com.cld.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Schedule {
    private Long id;
    private Long userId;
    private String title;
    private String description;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private ScheduleType type;
    private Priority priority;
    private String color;
    private boolean isRecurring;
    private String recurringPattern;
    private boolean notificationSent;
    private Integer recurringDays;
    private LocalDateTime createdAt;
    private User user;
    private boolean notification1DaySent;
    private boolean notification5HourSent;
    private boolean notification1HourSent;
    private boolean notificationOnTimeSent;

    // Constructors
    public Schedule() {}

    public Schedule(Long userId, String title, String description, LocalDateTime startDate,
                   LocalDateTime endDate, ScheduleType type, Priority priority) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.type = type;
        this.priority = priority;
        this.color = getColorByPriority(priority);
        this.notificationSent = false;
        this.isRecurring = type == ScheduleType.RECURRING;
    }

    private String getColorByPriority(Priority priority) {
        switch (priority) {
            case URGENT_IMPORTANT: return "#FF0000"; // Red
            case NOT_URGENT_NOT_IMPORTANT: return "#FFFF00"; // Yellow
            case IMPORTANT_NOT_URGENT: return "#0000FF"; // Blue
            case NOT_IMPORTANT_URGENT: return "#00FF00"; // Green
            case SPECIAL: return "#800080"; // Purple
            default: return "#808080"; // Gray
        }
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    // New getters to convert LocalDateTime to Date
    public Date getStartDateAsDate() {
        return startDate != null ? Date.from(startDate.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }

    public Date getEndDateAsDate() {
        return endDate != null ? Date.from(endDate.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }

    public Date getCreatedAtAsDate() {
        return createdAt != null ? Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }

    public ScheduleType getType() { return type; }
    public void setType(ScheduleType type) { 
        this.type = type;
        this.isRecurring = type == ScheduleType.RECURRING;
    }

    public Priority getPriority() { return priority; }
    public void setPriority(Priority priority) {
        this.priority = priority;
        this.color = getColorByPriority(priority);
    }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public boolean isRecurring() { return isRecurring; }
    public void setRecurring(boolean recurring) { isRecurring = recurring; }

    public String getRecurringPattern() { return recurringPattern; }
    public void setRecurringPattern(String recurringPattern) { this.recurringPattern = recurringPattern; }

    public boolean isNotificationSent() { return notificationSent; }
    public void setNotificationSent(boolean notificationSent) { this.notificationSent = notificationSent; }

    public Integer getRecurringDays() { return recurringDays; }
    public void setRecurringDays(Integer recurringDays) { this.recurringDays = recurringDays; }

    // Getter and Setter for createdAt
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // Getter and Setter for User
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public boolean isNotification1DaySent() { return notification1DaySent; }
    public void setNotification1DaySent(boolean notification1DaySent) { this.notification1DaySent = notification1DaySent; }
    public boolean isNotification5HourSent() { return notification5HourSent; }
    public void setNotification5HourSent(boolean notification5HourSent) { this.notification5HourSent = notification5HourSent; }
    public boolean isNotification1HourSent() { return notification1HourSent; }
    public void setNotification1HourSent(boolean notification1HourSent) { this.notification1HourSent = notification1HourSent; }
    public boolean isNotificationOnTimeSent() { return notificationOnTimeSent; }
    public void setNotificationOnTimeSent(boolean notificationOnTimeSent) { this.notificationOnTimeSent = notificationOnTimeSent; }
}