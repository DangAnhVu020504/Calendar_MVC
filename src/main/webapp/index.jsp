<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .hero-section {
            padding: 100px 0;
            color: white;
            text-align: center;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-subtitle {
            font-size: 1.3rem;
            margin-bottom: 40px;
            opacity: 0.9;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #667eea;
        }
        
        .btn-hero {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid white;
            color: white;
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            margin: 10px;
            transition: all 0.3s ease;
        }
        
        .btn-hero:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        
        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            color: white;
            transform: translateY(-2px);
        }
        
        .footer {
            background: rgba(0, 0, 0, 0.1);
            color: white;
            padding: 40px 0;
            margin-top: 50px;
        }
        
        .priority-demo {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .demo-section {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            margin: 40px 0;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: rgba(0,0,0,0.1);">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-calendar-alt me-2"></i>
                <strong>Schedule Manager</strong>
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                    <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/register">
                    <i class="fas fa-user-plus me-1"></i>Đăng ký
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <h1 class="hero-title">
                        <i class="fas fa-calendar-check me-3"></i>
                        Quản lý Lịch trình Thông minh
                    </h1>
                    <p class="hero-subtitle">
                        Tổ chức công việc hiệu quả với Ma trận Eisenhower. 
                        Quản lý lịch trình dài hạn, ngắn hạn và lặp lại một cách dễ dàng.
                    </p>
                    
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-hero">
                            <i class="fas fa-rocket me-2"></i>Bắt đầu ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-hero">
                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <h4>Quản lý Đa dạng</h4>
                    <p>Hỗ trợ lịch trình dài hạn, ngắn hạn và lặp lại. Phù hợp với mọi loại công việc và sự kiện.</p>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-palette"></i>
                    </div>
                    <h4>Ma trận Eisenhower</h4>
                    <p>Phân loại công việc theo mức độ quan trọng và khẩn cấp với hệ thống màu sắc trực quan.</p>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h4>Thông báo Thông minh</h4>
                    <p>Nhận thông báo trước 1 ngày khi công việc sắp đến hạn. Không bao giờ bỏ lỡ deadline.</p>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-repeat"></i>
                    </div>
                    <h4>Lặp lại Tự động</h4>
                    <p>Tạo lịch trình lặp lại hàng tuần, hàng tháng một cách tự động và tiện lợi.</p>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h4>Giao diện Responsive</h4>
                    <p>Truy cập và quản lý lịch trình trên mọi thiết bị: máy tính, tablet, điện thoại.</p>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="feature-card text-center">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h4>Bảo mật Cao</h4>
                    <p>Dữ liệu cá nhân được bảo vệ an toàn với hệ thống xác thực và mã hóa.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Priority Demo Section -->
    <div class="container">
        <div class="demo-section">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h3 class="mb-4">
                        <i class="fas fa-chart-pie me-2"></i>
                        Hệ thống Phân loại Ưu tiên
                    </h3>
                    <p class="mb-4">Sử dụng Ma trận Eisenhower để phân loại công việc theo mức độ quan trọng và khẩn cấp:</p>
                    
                    <div class="row text-start">
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #FF0000;"></span>
                            <strong>Đỏ:</strong> Quan trọng & Khẩn cấp
                            <br><small class="ms-4">Làm ngay lập tức</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #0000FF;"></span>
                            <strong>Xanh dương:</strong> Quan trọng & Không khẩn cấp
                            <br><small class="ms-4">Lên kế hoạch thực hiện</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #00FF00;"></span>
                            <strong>Xanh lá:</strong> Không quan trọng & Khẩn cấp
                            <br><small class="ms-4">Ủy thác cho người khác</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #FFFF00;"></span>
                            <strong>Vàng:</strong> Không quan trọng & Không khẩn cấp
                            <br><small class="ms-4">Loại bỏ hoặc làm khi rảnh</small>
                        </div>
                        <div class="col-12 text-center mt-3">
                            <span class="priority-demo" style="background-color: #800080;"></span>
                            <strong>Tím:</strong> Ngày đặc biệt
                            <br><small class="ms-4">Sinh nhật, kỷ niệm, sự kiện quan trọng</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Call to Action -->
    <div class="container text-center" style="color: white; padding: 50px 0;">
        <h2 class="mb-4">Sẵn sàng tổ chức cuộc sống của bạn?</h2>
        <p class="mb-4 fs-5">Tham gia ngay hôm nay và trải nghiệm sự khác biệt!</p>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom btn-lg">
            <i class="fas fa-user-plus me-2"></i>Tạo tài khoản miễn phí
        </a>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h5>
                        <i class="fas fa-calendar-alt me-2"></i>
                        Schedule Manager
                    </h5>
                    <p>Hệ thống quản lý lịch trình thông minh, giúp bạn tổ chức công việc hiệu quả và không bao giờ bỏ lỡ deadline quan trọng.</p>
                </div>
                <div class="col-lg-3">
                    <h6>Tính năng</h6>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-check me-2"></i>Lịch trình dài hạn</li>
                        <li><i class="fas fa-check me-2"></i>Lịch trình ngắn hạn</li>
                        <li><i class="fas fa-check me-2"></i>Lịch trình lặp lại</li>
                        <li><i class="fas fa-check me-2"></i>Thông báo tự động</li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <h6>Liên kết</h6>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/login" class="text-white-50 text-decoration-none">Đăng nhập</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="text-white-50 text-decoration-none">Đăng ký</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none">Hướng dẫn</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none">Hỗ trợ</a></li>
                    </ul>
                </div>
            </div>
            <hr class="my-4" style="border-color: rgba(255,255,255,0.2);">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0">&copy; 2024 Schedule Manager. Tất cả quyền được bảo lưu.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <small>Phát triển với ❤️ bằng Java Spring MVC</small>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Animation Script -->
    <script>
        // Smooth scrolling animation
        document.addEventListener('DOMContentLoaded', function() {
            // Add fade-in animation to feature cards
            const cards = document.querySelectorAll('.feature-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
        
        // Add hover effect to buttons
        document.querySelectorAll('.btn-hero').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.05)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>

<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Quản lý lịch trình</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar-custom {
            background: rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .hero-section {
            padding: 80px 0;
            color: white;
            text-align: center;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-subtitle {
            font-size: 1.2rem;
            margin-bottom: 40px;
            opacity: 0.9;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            margin: 30px 0;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            text-align: center;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #667eea;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            margin: 10px;
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-outline-custom {
            border: 2px solid white;
            color: white;
            background: transparent;
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            margin: 10px;
            transition: all 0.3s ease;
        }
        
        .btn-outline-custom:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }
        
        .stats-section {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            margin: 40px 0;
            color: white;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            display: block;
        }
        
        .priority-demo {
            display: inline-block;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            margin-right: 10px;
            vertical-align: middle;
        }
        
        .quick-actions {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            margin: 30px 0;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index">
                <i class="fas fa-calendar-alt me-2"></i>
                <strong>Schedule Manager</strong>
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/index">
                            <i class="fas fa-home me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/schedule/new">
                            <i class="fas fa-plus me-1"></i>Tạo lịch trình
                        </a>
                    </li>
                </ul>
                
                <div class="navbar-nav">
                    <span class="navbar-text me-3">
                        <i class="fas fa-user me-2"></i>Xin chào, <strong>${user.fullName}</strong>!
                    </span>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <h1 class="hero-title">
                        <i class="fas fa-calendar-check me-3"></i>
                        Chào mừng trở lại!
                    </h1>
                    <p class="hero-subtitle">
                        Sẵn sàng quản lý lịch trình của bạn một cách thông minh và hiệu quả.
                    </p>
                    
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary-custom">
                            <i class="fas fa-tachometer-alt me-2"></i>Xem Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/schedule/new" class="btn btn-outline-custom">
                            <i class="fas fa-plus me-2"></i>Tạo lịch trình mới
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Welcome Card -->
    <div class="container">
        <div class="welcome-card">
            <h3>
                <i class="fas fa-heart text-danger me-2"></i>
                Chào mừng ${user.fullName}!
            </h3>
            <p class="mb-4">Bạn đã đăng nhập thành công vào hệ thống quản lý lịch trình. Hãy bắt đầu tổ chức công việc của mình ngay hôm nay!</p>
            
            <!-- Quick Actions -->
            <div class="row">
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary-custom w-100">
                        <i class="fas fa-list me-2"></i>Xem lịch trình
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/schedule/new" class="btn btn-primary-custom w-100">
                        <i class="fas fa-plus me-2"></i>Tạo mới
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <button class="btn btn-primary-custom w-100" onclick="showTutorial()">
                        <i class="fas fa-question-circle me-2"></i>Hướng dẫn
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Grid -->
    <div class="container">
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h5>Quản lý Đa dạng</h5>
                <p>Lịch trình dài hạn, ngắn hạn và lặp lại. Phù hợp với mọi loại công việc.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-palette"></i>
                </div>
                <h5>Ma trận Eisenhower</h5>
                <p>Phân loại theo mức độ quan trọng và khẩn cấp với hệ thống màu sắc.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <h5>Thông báo Thông minh</h5>
                <p>Nhận thông báo trước 1 ngày khi công việc sắp đến hạn.</p>
            </div>
        </div>
    </div>

    <!-- Priority System -->
    <div class="container">
        <div class="stats-section">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h3 class="mb-4">
                        <i class="fas fa-chart-pie me-2"></i>
                        Hệ thống Phân loại Ưu tiên
                    </h3>
                    
                    <div class="row text-start">
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #FF0000;"></span>
                            <strong>Đỏ:</strong> Quan trọng & Khẩn cấp
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #0000FF;"></span>
                            <strong>Xanh dương:</strong> Quan trọng & Không khẩn cấp
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #00FF00;"></span>
                            <strong>Xanh lá:</strong> Không quan trọng & Khẩn cấp
                        </div>
                        <div class="col-md-6 mb-3">
                            <span class="priority-demo" style="background-color: #FFFF00;"></span>
                            <strong>Vàng:</strong> Không quan trọng & Không khẩn cấp
                        </div>
                        <div class="col-12 text-center mt-3">
                            <span class="priority-demo" style="background-color: #800080;"></span>
                            <strong>Tím:</strong> Ngày đặc biệt
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="container">
        <div class="quick-actions">
            <h4 class="text-center mb-4">
                <i class="fas fa-rocket me-2"></i>
                Bắt đầu ngay
            </h4>
            <div class="row text-center">
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/schedule/new?type=LONG_TERM" class="btn btn-outline-custom w-100">
                        <i class="fas fa-calendar-week d-block mb-2"></i>
                        Lịch trình dài hạn
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/schedule/new?type=SHORT_TERM" class="btn btn-outline-custom w-100">
                        <i class="fas fa-calendar-day d-block mb-2"></i>
                        Lịch trình ngắn hạn
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/schedule/new?type=RECURRING" class="btn btn-outline-custom w-100">
                        <i class="fas fa-repeat d-block mb-2"></i>
                        Lịch trình lặp lại
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/schedule/new?priority=SPECIAL" class="btn btn-outline-custom w-100">
                        <i class="fas fa-star d-block mb-2"></i>
                        Ngày đặc biệt
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center text-white py-4 mt-5" style="background: rgba(0,0,0,0.1);">
        <div class="container">
            <p class="mb-0">&copy; 2024 Schedule Manager. Quản lý thời gian thông minh.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Tutorial function
        function showTutorial() {
            alert(`Hướng dẫn sử dụng Schedule Manager:

1. 📅 Tạo lịch trình: Click "Tạo lịch trình mới" để thêm công việc
2. 🎨 Chọn màu sắc: Sử dụng Ma trận Eisenhower để phân loại
3. 🔄 Lặp lại: Tạo lịch trình định kỳ cho công việc thường xuyên
4. 🔔 Thông báo: Nhận thông báo trước 1 ngày khi đến hạn
5. 📊 Dashboard: Xem tổng quan tất cả lịch trình của bạn

Chúc bạn sử dụng hiệu quả!`);
        }
        
        // Animation on load
        document.addEventListener('DOMContentLoaded', function() {
            // Fade in animation for cards
            const cards = document.querySelectorAll('.feature-card, .welcome-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html> --%>