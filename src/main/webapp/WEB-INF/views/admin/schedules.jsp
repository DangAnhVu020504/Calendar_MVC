<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Lịch trình - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        .btn-action {
            padding: 4px 8px;
            font-size: 0.75rem;
            border-radius: 3px;
        }
        .btn-edit { background-color: #6c757d; color: white; }
        .btn-edit:hover { background-color: #5a6268; }
        .btn-delete { background-color: #e83e8c; color: white; }
        .btn-delete:hover { background-color: #e21e6b; }
        .priority-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-user-shield me-2"></i>
                Admin Dashboard
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    </li>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users me-1"></i> Người dùng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/admin/schedules"><i class="fas fa-calendar-check me-1"></i> Lịch trình</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-line me-1"></i> Báo cáo</a>
                    </li>
                </ul>
            </div>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    Xin chào, Admin!
                </span>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <c:if test="${user == null || user.id != 1}">
            <c:redirect url="${pageContext.request.contextPath}/login"/>
        </c:if>

        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Quản lý Lịch trình</h1>
        </div>

        <!-- Schedules Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu đề</th>
                                <th>Người dùng</th>
                                <th>Thời gian bắt đầu</th>
                                <th>Thời gian kết thúc</th>
                                <th>Loại</th>
                                <th>Ưu tiên</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${schedules}" var="schedule">
                                <tr>
                                    <td>${schedule.id}</td>
                                    <td>${schedule.title}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty schedule.user}">
                                                <c:out value="${schedule.user.fullName}"/>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${schedule.startDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><fmt:formatDate value="${schedule.endDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.type == 'LONG_TERM'}">Dài hạn</c:when>
                                            <c:when test="${schedule.type == 'SHORT_TERM'}">Ngắn hạn</c:when>
                                            <c:when test="${schedule.type == 'RECURRING'}">Lặp lại</c:when>
                                            <c:otherwise><c:out value="${schedule.type}"/></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.priority == 'URGENT_IMPORTANT'}">Quan trọng, Khẩn cấp (Đỏ)</c:when>
                                            <c:when test="${schedule.priority == 'IMPORTANT_NOT_URGENT'}">Quan trọng, Không khẩn cấp (Xanh dương)</c:when>
                                            <c:when test="${schedule.priority == 'NOT_IMPORTANT_URGENT'}">Không quan trọng, Khẩn cấp (Xanh lá)</c:when>
                                            <c:when test="${schedule.priority == 'NOT_URGENT_NOT_IMPORTANT'}">Không quan trọng, Không khẩn cấp (Vàng)</c:when>
                                            <c:when test="${schedule.priority == 'SPECIAL'}">Ngày đặc biệt (Tím)</c:when>
                                            <c:otherwise><c:out value="${schedule.priority}"/></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="schedule-actions">
                                        <a href="${pageContext.request.contextPath}/admin/schedules/${schedule.id}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/edit-schedule/${schedule.id}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/delete-schedule/${schedule.id}" method="POST" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch trình này?')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 