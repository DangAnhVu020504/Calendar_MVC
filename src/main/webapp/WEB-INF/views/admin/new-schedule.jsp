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

        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: var(--shadow);
            padding: 30px;
        }
        .btn-submit {
            background: var(--gradient);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            color: white;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-calendar-alt me-2"></i>
                Quản lý lịch trình
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
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
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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
                                        <option value="" selected disabled>Chọn loại lịch trình</option>
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
                                <div class="mb-3" id="recurringDaysGroup" style="display: none;">
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
                                        <option value="" selected disabled>Chọn mức độ ưu tiên</option>
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
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
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
            const now = new Date(); // Current time: 08:44 PM +07 on June 05, 2025

            if (selectedDateStr) {
                // Parse the selected date (2025-06-11)
                const [year, month, day] = selectedDateStr.split('-').map(Number);
                const startDate = new Date(year, month - 1, day, now.getHours(), now.getMinutes(), now.getSeconds());
                
                // Set start date to selected date with current time
                startDateInput.value = startDate.toISOString().slice(0, 16);

                // Set end date to one day after start date with the same time (for LONG_TERM/SHORT_TERM)
                const endDate = new Date(startDate);
                endDate.setDate(endDate.getDate() + 1);
                endDateInput.value = endDate.toISOString().slice(0, 16);
            } else {
                // Default to current date and time if no date parameter
                startDateInput.value = now.toISOString().slice(0, 16);
                const endDate = new Date(now);
                endDate.setDate(endDate.getDate() + 1);
                endDateInput.value = endDate.toISOString().slice(0, 16);
            }

            function toggleEndDate() {
                const type = document.getElementById('type').value;
                const endDateGroup = document.getElementById('endDateGroup');
                const endDateInput = document.getElementById('endDate');
                const recurringDaysGroup = document.getElementById('recurringDaysGroup');
                const recurringDaysInput = document.getElementById('recurringDays');

                if (type === 'LONG_TERM' || type === 'SHORT_TERM') {
                    endDateGroup.style.display = 'block';
                    endDateInput.required = true;
                    recurringDaysGroup.style.display = 'none';
                    recurringDaysInput.required = false;
                    // Update end date to one day after start date
                    const startDateValue = new Date(startDateInput.value);
                    const newEndDate = new Date(startDateValue);
                    newEndDate.setDate(newEndDate.getDate() + 1);
                    endDateInput.value = newEndDate.toISOString().slice(0, 16);
                } else if (type === 'RECURRING') {
                    endDateGroup.style.display = 'none';
                    endDateInput.required = false;
                    recurringDaysGroup.style.display = 'block';
                    recurringDaysInput.required = true;
                } else {
                    endDateGroup.style.display = 'none';
                    endDateInput.required = false;
                    recurringDaysGroup.style.display = 'none';
                    recurringDaysInput.required = false;
                }
            }

            // Event listeners
            document.getElementById('type').addEventListener('change', toggleEndDate);
            document.getElementById('startDate').addEventListener('change', toggleEndDate);

            // Initial call to set visibility
            toggleEndDate();
        });
    </script>
</body>
</html> 