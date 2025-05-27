<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .schedule-card {
            border-left: 5px solid;
            transition: transform 0.2s;
        }
        .schedule-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .priority-urgent-important { border-left-color: #FF0000; }
        .priority-not-urgent-not-important { border-left-color: #FFFF00; }
        .priority-important-not-urgent { border-left-color: #0000FF; }
        .priority-not-important-urgent { border-left-color: #00FF00; }
        .priority-special { border-left-color: #800080; }
        
        .btn-add {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
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
                <span class="navbar-text me-3">
                    Xin chào, ${user.fullName}!
                </span>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Lịch trình của tôi</h2>
                    <a href="${pageContext.request.contextPath}/schedule/new" class="btn btn-primary btn-add">
                        <i class="fas fa-plus me-2"></i>Thêm lịch trình
                    </a>
                </div>
                
                <!-- Legend -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h6 class="card-title">Ý nghĩa màu sắc (Ma trận Eisenhower):</h6>
                        <div class="row">
                            <div class="col-md-2">
                                <span class="badge" style="background-color: #FF0000;">Đỏ</span>
                                <small class="d-block">Quan trọng, Khẩn cấp</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge" style="background-color: #0000FF;">Xanh dương</span>
                                <small class="d-block">Quan trọng, Không khẩn cấp</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge" style="background-color: #00FF00;">Xanh lá</span>
                                <small class="d-block">Không quan trọng, Khẩn cấp</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge" style="background-color: #FFFF00; color: #000;">Vàng</span>
                                <small class="d-block">Không quan trọng, Không khẩn cấp</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge" style="background-color: #800080;">Tím</span>
                                <small class="d-block">Ngày đặc biệt</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <c:if test="${empty schedules}">
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                        <h4 class="text-muted">Chưa có lịch trình nào</h4>
                        <p class="text-muted">Hãy tạo lịch trình đầu tiên của bạn!</p>
                        <a href="${pageContext.request.contextPath}/schedule/new" class="btn btn-primary btn-add">
                            <i class="fas fa-plus me-2"></i>Tạo lịch trình
                        </a>
                    </div>
                </c:if>
                
                <c:if test="${not empty schedules}">
                    <div class="row">
                        <c:forEach var="schedule" items="${schedules}">
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card schedule-card priority-${schedule.priority.name().toLowerCase().replace('_', '-')}">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title">${schedule.title}</h5>
                                            <span class="badge" style="background-color: ${schedule.color};">
                                                <c:choose>
                                                    <c:when test="${schedule.type == 'LONG_TERM'}">Dài hạn</c:when>
                                                    <c:when test="${schedule.type == 'SHORT_TERM'}">Ngắn hạn</c:when>
                                                    <c:when test="${schedule.type == 'RECURRING'}">Lặp lại</c:when>
                                                </c:choose>
                                            </span>
                                        </div>
                                        
                                        <p class="card-text">${schedule.description}</p>
                                        
                                        <div class="mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                Bắt đầu: <fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                        
                                        <c:if test="${schedule.endDate != null}">
                                            <div class="mb-2">
                                                <small class="text-muted">
                                                    <i class="fas fa-flag-checkered me-1"></i>
                                                    Kết thúc: <fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${schedule.recurring}">
                                            <div class="mb-2">
                                                <small class="text-info">
                                                    <i class="fas fa-repeat me-1"></i>
                                                    Lặp lại: ${schedule.recurringPattern}
                                                </small>
                                            </div>
                                        </c:if>
                                        
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/schedule/edit/${schedule.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <form action="${pageContext.request.contextPath}/schedule/delete/${schedule.id}" method="post" style="display: inline;" 
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa lịch trình này?')">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>