<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 20px;
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
    </style>
</head>
<body style="background-color: #f8f9fa;">
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin-dashboard">
                <i class="fas fa-user-shield me-2"></i>
                Admin Dashboard
            </a>
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
            <c:redirect url="/login"/>
        </c:if>

        <!-- Quản lý người dùng -->
        <div class="table-container">
            <h3 class="mb-4"><i class="fas fa-users me-2"></i>Quản lý Người dùng</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Email</th>
                        <th>Họ và tên</th>
                        <th>Thời gian tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td><c:out value="${user.id}"/></td>
                            <td><c:out value="${user.username}"/></td>
                            <td><c:out value="${user.email}"/></td>
                            <td><c:out value="${user.fullName}"/></td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/edit-user/${user.id}" class="btn btn-action btn-edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/delete-user/${user.id}" method="post" style="display:inline;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Quản lý lịch trình -->
        <div class="table-container mt-4">
            <h3 class="mb-4"><i class="fas fa-calendar-alt me-2"></i>Quản lý Lịch trình</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Người dùng</th>
                        <th>Tiêu đề</th>
                        <th>Thời gian bắt đầu</th>
                        <th>Thời gian kết thúc</th>
                        <th>Loại</th>
                        <th>Ưu tiên</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="schedule" items="${schedules}">
                        <tr>
                            <td><c:out value="${schedule.id}"/></td>
                            <td><c:out value="${schedule.userId}"/></td>
                            <td><c:out value="${schedule.title}"/></td>
                            <td><fmt:formatDate value="${schedule.startDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><fmt:formatDate value="${schedule.endDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><c:out value="${schedule.type}"/></td>
                            <td><c:out value="${schedule.priority}"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/edit-schedule/${schedule.id}" class="btn btn-action btn-edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/delete-schedule/${schedule.id}" method="post" style="display:inline;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch trình này?')">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>