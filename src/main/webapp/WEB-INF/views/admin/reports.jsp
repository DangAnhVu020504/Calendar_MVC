<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo thống kê - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar-custom {
            background: var(--gradient);
            box-shadow: var(--shadow);
        }
        
        .navbar-brand, .navbar-text, .nav-link {
            color: white !important;
        }
        
        .card {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
    </style>
</head>
<body>
   <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-calendar-alt me-2"></i>
                Quản lý lịch trình
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Người dùng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/schedules">Lịch trình</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Báo cáo</a>
                    </li>
                </ul>
                <div class="navbar-nav ms-auto">
                    <span class="navbar-text me-3">
                        Xin chào, <c:out value="${user.fullName}"/>!
                    </span>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Báo cáo thống kê</h1>
        </div>

        <div class="row">
            <!-- Tổng quan -->
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Tổng quan</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="card bg-primary text-white">
                                    <div class="card-body">
                                        <h5 class="card-title">Tổng số lịch trình</h5>
                                        <h2 class="card-text">${totalSchedules}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-success text-white">
                                    <div class="card-body">
                                        <h5 class="card-title">Lịch trình lặp lại</h5>
                                        <h2 class="card-text">${recurringSchedulesCount}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-info text-white">
                                    <div class="card-body">
                                        <h5 class="card-title">Lịch trình không lặp lại</h5>
                                        <h2 class="card-text">${nonRecurringSchedulesCount}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-warning text-white">
                                    <div class="card-body">
                                        <h5 class="card-title">Đã gửi thông báo</h5>
                                        <h2 class="card-text">${notificationSentCount}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ loại lịch trình -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Phân bố theo loại lịch trình</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="scheduleTypeChart" width="400" height="300"
                                data-long-term="${empty longTermCount ? 0 : longTermCount}"
                                data-short-term="${empty shortTermCount ? 0 : shortTermCount}"
                                data-recurring="${empty recurringCount ? 0 : recurringCount}"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ mức độ ưu tiên -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Phân bố theo mức độ ưu tiên</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="priorityChart" width="400" height="300"
                                data-urgent-important="${empty urgentImportantCount ? 0 : urgentImportantCount}"
                                data-not-urgent-not-important="${empty notUrgentNotImportantCount ? 0 : notUrgentNotImportantCount}"
                                data-important-not-urgent="${empty importantNotUrgentCount ? 0 : importantNotUrgentCount}"
                                data-not-important-urgent="${empty notImportantUrgentCount ? 0 : notImportantUrgentCount}"
                                data-special="${empty specialCount ? 0 : specialCount}"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ trạng thái thông báo -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Trạng thái thông báo</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="notificationChart" width="400" height="300"
                                data-notification-sent="${empty notificationSentCount ? 0 : notificationSentCount}"
                                data-notification-not-sent="${empty notificationNotSentCount ? 0 : notificationNotSentCount}"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ lịch trình lặp lại -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Lịch trình lặp lại</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="recurringChart" width="400" height="300"
                                data-recurring-schedules="${empty recurringSchedulesCount ? 0 : recurringSchedulesCount}"
                                data-non-recurring-schedules="${empty nonRecurringSchedulesCount ? 0 : nonRecurringSchedulesCount}"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Biểu đồ loại lịch trình
        const scheduleTypeCanvas = document.getElementById('scheduleTypeChart');
        new Chart(scheduleTypeCanvas, {
            type: 'pie',
            data: {
                labels: ['Dài hạn', 'Ngắn hạn', 'Lặp lại'],
                datasets: [{
                    data: [
                        parseInt(scheduleTypeCanvas.dataset.longTerm),
                        parseInt(scheduleTypeCanvas.dataset.shortTerm),
                        parseInt(scheduleTypeCanvas.dataset.recurring)
                    ],
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Biểu đồ mức độ ưu tiên
        const priorityCanvas = document.getElementById('priorityChart');
        new Chart(priorityCanvas, {
            type: 'pie',
            data: {
                labels: ['Quan trọng, Khẩn cấp', 'Không quan trọng, Không khẩn cấp',
                        'Quan trọng, Không khẩn cấp', 'Không quan trọng, Khẩn cấp', 'Đặc biệt'],
                datasets: [{
                    data: [
                        parseInt(priorityCanvas.dataset.urgentImportant),
                        parseInt(priorityCanvas.dataset.notUrgentNotImportant),
                        parseInt(priorityCanvas.dataset.importantNotUrgent),
                        parseInt(priorityCanvas.dataset.notImportantUrgent),
                        parseInt(priorityCanvas.dataset.special)
                    ],
                    backgroundColor: ['#e74a3b', '#f6c23e', '#4e73df', '#1cc88a', '#6f42c1']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Biểu đồ trạng thái thông báo
        const notificationCanvas = document.getElementById('notificationChart');
        new Chart(notificationCanvas, {
            type: 'pie',
            data: {
                labels: ['Đã gửi', 'Chưa gửi'],
                datasets: [{
                    data: [
                        parseInt(notificationCanvas.dataset.notificationSent),
                        parseInt(notificationCanvas.dataset.notificationNotSent)
                    ],
                    backgroundColor: ['#1cc88a', '#e74a3b']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Biểu đồ lịch trình lặp lại
        const recurringCanvas = document.getElementById('recurringChart');
        new Chart(recurringCanvas, {
            type: 'pie',
            data: {
                labels: ['Lặp lại', 'Không lặp lại'],
                datasets: [{
                    data: [
                        parseInt(recurringCanvas.dataset.recurringSchedules),
                        parseInt(recurringCanvas.dataset.nonRecurringSchedules)
                    ],
                    backgroundColor: ['#4e73df', '#858796']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    </script>
</body>
</html> 