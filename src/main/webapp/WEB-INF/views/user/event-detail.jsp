<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sự kiện - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
        }
        .priority-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .schedule-color {
            width: 20px;
            height: 20px;
            display: inline-block;
            border-radius: 50%;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-calendar-alt me-2"></i>
                Quản lý lịch trình
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                </a>
            </div>
        </div>
    </nav>
    <div class="container mt-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Chi tiết sự kiện</h1>
        </div>
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Thông tin sự kiện</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th>Tiêu đề:</th>
                                <td>${schedule.title}</td>
                            </tr>
                            <tr>
                                <th>Mô tả:</th>
                                <td>${schedule.description}</td>
                            </tr>
                            <tr>
                                <th>Thời gian bắt đầu:</th>
                                <td><fmt:formatDate value="${schedule.startDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <th>Thời gian kết thúc:</th>
                                <td><fmt:formatDate value="${schedule.endDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <th>Số ngày lặp lại:</th>
                                <td><c:out value="${schedule.recurringDays}"/></td>
                            </tr>
                            <tr>
                                <th>Ưu tiên:</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${schedule.priority == 'URGENT_IMPORTANT'}">
                                            <span class="badge bg-danger priority-badge">Quan trọng, Khẩn cấp (Đỏ)</span>
                                        </c:when>
                                        <c:when test="${schedule.priority == 'NOT_URGENT_NOT_IMPORTANT'}">
                                            <span class="badge bg-warning priority-badge">Không quan trọng, Không khẩn cấp (Vàng)</span>
                                        </c:when>
                                        <c:when test="${schedule.priority == 'IMPORTANT_NOT_URGENT'}">
                                            <span class="badge bg-primary priority-badge">Quan trọng, Không khẩn cấp (Xanh dương)</span>
                                        </c:when>
                                        <c:when test="${schedule.priority == 'NOT_IMPORTANT_URGENT'}">
                                            <span class="badge bg-success priority-badge">Không quan trọng, Khẩn cấp (Xanh lá)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary priority-badge">Đặc biệt (Tím)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Màu sắc:</th>
                                <td>
                                    <span class="schedule-color" style="background-color: ${schedule.color}"></span>
                                    ${schedule.color}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 