<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng - Quản lý lịch trình</title>
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
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-calendar-alt me-2"></i>
                Quản lý lịch trình
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách người dùng
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Chi tiết người dùng</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/admin/edit-user/${user.id}" class="btn btn-primary me-2">
                    <i class="fas fa-edit"></i> Sửa người dùng
                </a>
                <form action="${pageContext.request.contextPath}/admin/delete-user/${user.id}" method="POST" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')">
                        <i class="fas fa-trash"></i> Xóa người dùng
                    </button>
                </form>
            </div>
        </div>

        <!-- User Information -->
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Thông tin người dùng</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th>ID:</th>
                                <td>${user.id}</td>
                            </tr>
                            <tr>
                                <th>Tên đăng nhập:</th>
                                <td>${user.username}</td>
                            </tr>
                            <tr>
                                <th>Họ và tên:</th>
                                <td>${user.fullName}</td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td>${user.email}</td>
                            </tr>
                            <tr>
                                <th>Tạo lúc:</th>
                                <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- User's Schedules -->
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Lịch trình của người dùng</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu đề</th>
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
                                            <c:when test="${schedule.startDateAsDate != null}">
                                                <fmt:formatDate value="${schedule.startDateAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.endDateAsDate != null}">
                                                <fmt:formatDate value="${schedule.endDateAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">
                                            <c:choose>
                                                <c:when test="${schedule.type == 'LONG_TERM'}">Dài hạn</c:when>
                                                <c:when test="${schedule.type == 'SHORT_TERM'}">Ngắn hạn</c:when>
                                                <c:when test="${schedule.type == 'RECURRING'}">Lặp lại</c:when>
                                                <c:otherwise><c:out value="${schedule.type}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
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
                                    <td>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 