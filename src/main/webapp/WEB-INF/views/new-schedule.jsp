<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo lịch trình mới - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-calendar-alt me-2"></i>
                Quản lý lịch trình
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="mb-4 text-center">
                        <i class="fas fa-plus-circle me-2"></i>
                        Tạo lịch trình mới
                    </h2>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/schedule/create" method="post">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="title" class="form-label">Tiêu đề *</label>
                                    <input type="text" class="form-control" id="title" name="title" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="type" class="form-label">Loại lịch trình *</label>
                                    <select class="form-select" id="type" name="type" required onchange="toggleEndDate()">
                                        <option value="">Chọn loại lịch trình</option>
                                        <option value="LONG_TERM">Dài hạn</option>
                                        <option value="SHORT_TERM">Ngắn hạn</option>
                                        <option value="RECURRING">Lặp lại</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="startDate" class="form-label">Thời gian bắt đầu *</label>
                                    <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3" id="endDateGroup">
                                    <label for="endDate" class="form-label">Thời gian kết thúc</label>
                                    <input type="datetime-local" class="form-control" id="endDate" name="endDate">
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="priority" class="form-label">Mức độ ưu tiên *</label>
                                    <select class="form-select" id="priority" name="priority" required>
                                        <option value="">Chọn mức độ ưu tiên</option>
                                        <option value="URGENT_IMPORTANT">Quan trọng, Khẩn cấp (Đỏ)</option>
                                        <option value="IMPORTANT_NOT_URGENT">Quan trọng, Không khẩn cấp (Xanh dương)</option>
                                        <option value="NOT_IMPORTANT_URGENT">Không quan trọng, Khẩn cấp (Xanh lá)</option>
                                        <option value="NOT_URGENT_NOT_IMPORTANT">Không quan trọng, Không khẩn cấp (Vàng)</option>
                                        <option value="SPECIAL">Ngày đặc biệt (Tím)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <div class="form-check mt-4">
                                        <input class="form-check-input" type="checkbox" id="isRecurring" name="isRecurring" onchange="toggleRecurringOptions()">
                                        <label class="form-check-label" for="isRecurring">
                                            Lặp lại
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3" id="recurringGroup" style="display: none;">
                            <label for="recurringPattern" class="form-label">Kiểu lặp lại</label>
                            <select class="form-select" id="recurringPattern" name="recurringPattern">
                                <option value="">Chọn kiểu lặp lại</option>
                                <option value="WEEKLY">Hàng tuần</option>
                                <option value="MONTHLY">Hàng tháng</option>
                            </select>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary btn-submit">
                                <i class="fas fa-save me-2"></i>Tạo lịch trình
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleEndDate() {
            const type = document.getElementById('type').value;
            const endDateGroup = document.getElementById('endDateGroup');
            const endDateInput = document.getElementById('endDate');
            
            if (type === 'SHORT_TERM') {
                endDateGroup.style.display = 'block';
                endDateInput.required = false;
            } else if (type === 'LONG_TERM') {
                endDateGroup.style.display = 'block';
                endDateInput.required = true;
            } else {
                endDateGroup.style.display = 'none';
                endDateInput.required = false;
            }
        }
        
        function toggleRecurringOptions() {
            const isRecurring = document.getElementById('isRecurring').checked;
            const recurringGroup = document.getElementById('recurringGroup');
            const recurringPattern = document.getElementById('recurringPattern');
            
            if (isRecurring) {
                recurringGroup.style.display = 'block';
                recurringPattern.required = true;
            } else {
                recurringGroup.style.display = 'none';
                recurringPattern.required = false;
            }
        }
    </script>
</body>
</html>