package com.cld.service;

import java.awt.GraphicsEnvironment;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.swing.JOptionPane;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cld.model.Schedule;

@Service
public class NotificationService {
    
    @Autowired
    private ScheduleService scheduleService;
    
    // Phương thức này có thể được gọi định kỳ bằng cách sử dụng Timer hoặc ScheduledExecutorService
    public void checkUpcomingSchedules() {
        List<Schedule> upcomingSchedules = scheduleService.getUpcomingSchedules();
        
        for (Schedule schedule : upcomingSchedules) {
            showNotification(schedule);
            scheduleService.markNotificationSent(schedule.getId());
        }
    }
    
    private void showNotification(Schedule schedule) {
        if (GraphicsEnvironment.isHeadless()) {
            // For server environments, log the notification
            System.out.println("NOTIFICATION: " + schedule.getTitle() + " is due tomorrow!");
            return;
        }
        
        try {
            String message = String.format(
                "Lịch trình sắp đến hạn!\n\n" +
                "Tiêu đề: %s\n" +
                "Mô tả: %s\n" +
                "Thời gian kết thúc: %s\n\n" +
                "Hãy chuẩn bị hoàn thành công việc!",
                schedule.getTitle(),
                schedule.getDescription(),
                schedule.getEndDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
            );
            
            JOptionPane.showMessageDialog(
                null,
                message,
                "Thông báo lịch trình",
                JOptionPane.INFORMATION_MESSAGE
            );
        } catch (Exception e) {
            System.err.println("Error showing notification: " + e.getMessage());
        }
    }
}