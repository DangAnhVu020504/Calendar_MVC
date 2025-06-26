	CREATE DATABASE calendar CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
	USE calendar;

	CREATE TABLE users (
		id BIGINT AUTO_INCREMENT PRIMARY KEY,
		username VARCHAR(50) UNIQUE NOT NULL,
		password VARCHAR(255) NOT NULL,
		email VARCHAR(100) NOT NULL,
		full_name VARCHAR(100) NOT NULL,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		role VARCHAR(20) DEFAULT 'USER'
	) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

	CREATE TABLE schedules (
		id BIGINT AUTO_INCREMENT PRIMARY KEY,
		user_id BIGINT NOT NULL,
		title VARCHAR(200) NOT NULL,
		description TEXT,
		start_date DATETIME NOT NULL,
		end_date DATETIME,
		type ENUM('LONG_TERM', 'SHORT_TERM', 'RECURRING') NOT NULL,
		priority ENUM('URGENT_IMPORTANT', 'NOT_URGENT_NOT_IMPORTANT', 'IMPORTANT_NOT_URGENT', 'NOT_IMPORTANT_URGENT', 'SPECIAL') NOT NULL,
		color VARCHAR(7) NOT NULL,
		is_recurring BOOLEAN DEFAULT FALSE,
		recurring_pattern VARCHAR(20),
		notification_sent BOOLEAN DEFAULT FALSE,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		recurring_days INT DEFAULT 1,
		notification_1day_sent BOOLEAN DEFAULT FALSE,
		notification_5h_sent BOOLEAN DEFAULT FALSE,
		notification_1h_sent BOOLEAN DEFAULT FALSE,
		notification_ontime_sent BOOLEAN DEFAULT FALSE,
		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
	) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (username, password, email, full_name, role) VALUES 
('admin', 'admin123', 'admin@example.com', 'Administrator', 'ADMIN'),
('user', '0123456', 'user1@example.com', 'Nguyen Van A', 'USER');

	INSERT INTO schedules (user_id, title, description, start_date, end_date, type, priority, color, is_recurring) VALUES
	(1, 'Hoàn thành dự án', 'Dự án phần mềm quản lý lịch trình', '2025-06-16 09:00:00', '2025-06-16 17:00:00', 'LONG_TERM', 'URGENT_IMPORTANT', '#FF0000', FALSE),
	(1, 'Sinh nhật bạn A', 'Tham dự tiệc sinh nhật', '2025-06-17 18:00:00', '2025-06-17 22:00:00', 'SHORT_TERM', 'SPECIAL', '#800080', FALSE),
	(1, 'Họp team', 'Họp weekly team', '2025-06-14 10:00:00', '2025-06-14 11:00:00', 'RECURRING', 'IMPORTANT_NOT_URGENT', '#0000FF', TRUE);
