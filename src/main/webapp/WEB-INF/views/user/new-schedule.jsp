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
                                    <select class="form-select" id="type" name="type" required>
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
                                    <label for="endDate" class="form-label">Thời gian kết thúc *</label>
                                    <input type="datetime-local" class="form-control" id="endDate" name="endDate">
                                </div>
                                <div class="mb-3" id="recurringDaysGroup" style="display:none;">
                                    <label for="recurringDays" class="form-label">Số ngày lặp lại *</label>
                                    <input type="number" class="form-control" id="recurringDays" name="recurringDays" min="1" value="1">
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
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const selectedDateStr = urlParams.get('date'); // e.g., "2025-06-11"
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            const recurringDaysInput = document.getElementById('recurringDays');
            const now = new Date();

            if (selectedDateStr) {
                // Parse the selected date (2025-06-11)
                const [year, month, day] = selectedDateStr.split('-').map(Number);
                
                // Giữ nguyên giờ từ input nếu có, nếu không thì dùng giờ hiện tại
                let currentStartDate = startDateInput.value ? new Date(startDateInput.value) : now;
                let hours = currentStartDate.getHours();
                let minutes = currentStartDate.getMinutes();
                
                const startDate = new Date(year, month - 1, day, hours, minutes);
                startDateInput.value = startDate.toISOString().slice(0, 16);

                // Set end date to same day with same time plus 1 hour
                const endDate = new Date(startDate);
                endDate.setHours(endDate.getHours() + 1);
                endDateInput.value = endDate.toISOString().slice(0, 16);
            } else {
                // Default to current date but keep existing time if any
                let currentStartDate = startDateInput.value ? new Date(startDateInput.value) : now;
                startDateInput.value = currentStartDate.toISOString().slice(0, 16);
                
                const endDate = new Date(currentStartDate);
                endDate.setHours(endDate.getHours() + 1);
                endDateInput.value = endDate.toISOString().slice(0, 16);
            }

            const typeInput = document.getElementById('type');
            const endDateGroup = document.getElementById('endDateGroup');
            const recurringDaysGroup = document.getElementById('recurringDaysGroup');
            function toggleTypeFields() {
                if (typeInput.value === 'RECURRING') {
                    endDateGroup.style.display = 'none';
                    recurringDaysGroup.style.display = 'block';
                } else {
                    endDateGroup.style.display = 'block';
                    recurringDaysGroup.style.display = 'none';
                }
            }
            typeInput.addEventListener('change', toggleTypeFields);
            toggleTypeFields();
        });
    </script>
</body>
</html> 