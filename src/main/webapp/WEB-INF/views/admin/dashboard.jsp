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
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
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
        
        .container-fluid {
            padding: 0 20px;
        }
        
        .main-content {
            display: flex;
            width: 100%;
            min-height: calc(100vh - 56px);
            position: relative;
        }
        
        .calendar {
            flex: 1;
            margin: 15px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            max-width: calc(100% - 30px);
            min-width: 600px;
            position: relative;
            overflow: hidden;
        }
        
        .calendar.sidebar-active {
            margin-right: 250px;
            transform: scale(0.92);
            transform-origin: left center;
        }
        
        .fc {
            font-size: 0.9em;
            width: 100% !important;
        }
        
        .fc-scrollgrid-section > * {
            width: 100% !important;
        }
        
        .fc-scrollgrid {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: var(--shadow);
            width: 100% !important;
        }
        
        .fc-scrollgrid table {
            width: 100% !important;
            table-layout: fixed;
        }
        
        .fc-col-header {
            background: #f8f9fa;
        }
        
        .fc-col-header-cell {
            padding: 8px 4px;
            font-weight: 600;
            font-size: 0.85em;
            width: 14.28% !important;
        }
        
        .fc-daygrid-day {
            min-height: 50px !important;
            background: #ffffff;
            border-radius: 3px;
            margin: 1px;
            transition: background 0.2s ease;
            width: 14.28% !important;
        }
        
        .fc-daygrid-day:hover {
            background: #e6f0fa;
        }
        
        .fc-day-today {
            background: #e6f0fa !important;
            position: relative;
        }
        
        .fc-day-today::after {
            content: '';
            position: absolute;
            bottom: 3px;
            left: 50%;
            transform: translateX(-50%);
            width: 5px;
            height: 5px;
            background: #667eea;
            border-radius: 50%;
        }
        
        .fc-daygrid-day.fc-day-selected {
            background: #667eea !important;
            color: white !important;
        }
        
        .fc-daygrid-day.fc-day-selected .fc-daygrid-day-number {
            color: white !important;
        }
        
        .fc-daygrid-day.fc-day-selected.fc-day-today::after {
            background: white;
        }
        
        .fc-daygrid-day-number {
            font-size: 0.9em;
            padding: 4px;
        }
        
        .fc-daygrid-body {
            width: 100% !important;
        }
        
        .fc-daygrid-day-frame {
            min-height: 50px;
        }
        
        .fc-event {
            cursor: pointer;
            border-radius: 3px;
            padding: 1px 4px;
            margin: 1px;
            font-size: 0.75em;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            line-height: 1.2;
        }
        
        .sidebar {
            width: 300px;
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            position: fixed;
            right: -350px;
            top: 120px;
            bottom: 1rem;
            z-index: 5;
            box-shadow: var(--shadow);
            overflow-y: auto;
            transition: right 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .sidebar.active {
            right: 1rem;
        }
        
        .sidebar .close-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 1.2em;
            cursor: pointer;
            color: #333;
            z-index: 10;
        }
        
        .sidebar h3 {
            margin-bottom: 20px;
            font-size: 1.5em;
            color: #333;
            padding-right: 30px;
        }
        
        .sidebar-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            flex-direction: column;
            gap: 5px;
            transform: translateX(50px);
            opacity: 0;
            animation: slideIn 0.3s ease forwards;
            border-left: 4px solid transparent;
            border-radius: 4px;
        }
        
        .sidebar-item:nth-child(1) { animation-delay: 0.1s; }
        .sidebar-item:nth-child(2) { animation-delay: 0.2s; }
        .sidebar-item:nth-child(3) { animation-delay: 0.3s; }
        .sidebar-item:nth-child(4) { animation-delay: 0.4s; }
        .sidebar-item:nth-child(5) { animation-delay: 0.5s; }
        .sidebar-item:nth-child(6) { animation-delay: 0.6s; }
        .sidebar-item:nth-child(7) { animation-delay: 0.7s; }
        .sidebar-item:nth-child(8) { animation-delay: 0.8s; }
        
        @keyframes slideIn {
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        .sidebar-item .event-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .sidebar-item .event-actions {
            display: flex;
            gap: 5px;
        }
        
        .sidebar-item .btn-edit {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
            padding: 4px 8px;
            font-size: 0.75rem;
            border-radius: 3px;
        }
        
        .sidebar-item .btn-edit:hover {
            background-color: #5a6268;
            border-color: #545b62;
            color: white;
        }
        
        .sidebar-item .btn-delete {
            background-color: #e83e8c;
            border-color: #e83e8c;
            color: white;
            padding: 4px 8px;
            font-size: 0.75rem;
            border-radius: 3px;
        }
        
        .sidebar-item .btn-delete:hover {
            background-color: #e21e6b;
            border-color: #d91a72;
            color: white;
        }
        
        .sidebar-item.priority-urgent-important { border-left-color: #dc3545; }
        .sidebar-item.priority-important-not-urgent { border-left-color: #0d6efd; }
        .sidebar-item.priority-not-important-urgent { border-left-color: #28a745; }
        .sidebar-item.priority-not-urgent-not-important { border-left-color: #ffc107; }
        .sidebar-item.priority-special { border-left-color: #6f42c1; }
        
        .priority-urgent-important { background-color: #dc3545; color: white; }
        .priority-not-urgent-not-important { background-color: #ffc107; color: black; }
        .priority-important-not-urgent { background-color: #0d6efd; color: white; }
        .priority-not-important-urgent { background-color: #28a745; color: white; }
        .priority-special { background-color: #6f42c1; color: white; }
        
        .fc-toolbar {
            background: #ffffff;
            border-radius: 8px;
            padding: 10px;
            box-shadow: var(--shadow);
            margin-bottom: 10px;
        }
        
        .fc-button {
            background: var(--gradient) !important;
            border: none !important;
            border-radius: 5px !important;
            text-transform: uppercase;
            font-weight: 600;
            margin: 0 2px;
            font-size: 0.85em;
            padding: 6px 12px;
        }
        
        .fc-button:hover {
            opacity: 0.9;
        }
        
        .fc-button-active {
            opacity: 1 !important;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2) !important;
        }
        
        .btn-add {
            background: var(--gradient);
            border: none;
            border-radius: 50px;
            padding: 10px 20px;
            font-weight: 600;
            color: white;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
        }
        
        .modal-content {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .dropdown-menu {
            min-width: auto;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 280px;
                right: -320px;
            }
            
            .calendar {
                min-width: 300px;
            }
            
            .calendar.sidebar-active {
                margin-right: 0;
                transform: scale(0.85);
            }
            
            .sidebar.active {
                right: 0;
                top: 80px;
                left: 10px;
                width: calc(100% - 20px);
            }
            
            .fc-daygrid-day {
                min-height: 45px !important;
            }
            
            .fc-event {
                font-size: 0.7em;
                padding: 1px 3px;
            }
        }
        
        @media (max-width: 480px) {
            .calendar {
                min-width: 280px;
                margin: 5px;
            }
            
            .calendar.sidebar-active {
                transform: scale(0.8);
                margin: 5px;
            }
            
            .fc-daygrid-day {
                min-height: 40px !important;
            }
            
            .fc-daygrid-day-number {
                font-size: 0.8em;
                padding: 2px;
            }
        }
        
        .fc-view-harness {
            height: auto !important;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
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

    <div class="container-fluid">
        <div class="main-content">
            <div id="calendar" class="calendar"></div>
            <div class="sidebar" id="todoPanel">
                <i class="fas fa-times close-btn" onclick="closeTodoPanel()"></i>
                <h3 id="todoTitle">Sự kiện ngày <span id="selectedDate"></span></h3>
                <a href="#" id="addEventLink" class="btn-add">
                    <i class="fas fa-plus me-2"></i>Thêm sự kiện
                </a>
                <div id="todoList"></div>
            </div>
        </div>
    </div>
    <p>Number of schedules: ${schedules.size()}</p>

    <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eventModalLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Mô tả:</strong> <span id="eventDescription"></span></p>
                    <p><strong>Bắt đầu:</strong> <span id="eventStart"></span></p>
                    <p><strong>Kết thúc:</strong> <span id="eventEnd"></span></p>
                    <p><strong>Loại:</strong> <span id="eventType"></span></p>
                </div>
                <div class="modal-footer">
                    <a id="editEvent" href="#" class="btn btn-sm btn-outline-success">
                        <i class="fas fa-edit"></i> Sửa
                    </a>
                    <form id="deleteEventForm" action="#" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-sm btn-outline-warning" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch trình này?')">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </form>
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
   <script>
        document.addEventListener('DOMContentLoaded', function() {
            var contextPath = '${pageContext.request.contextPath}';
            var csrfParameterName = '${_csrf.parameterName}';
            var csrfToken = '${_csrf.token}';
            var calendarEl = document.getElementById('calendar');
            var todoPanel = document.getElementById('todoPanel');
            var isTodoPanelOpen = false; // Track panel state

            var today = new Date().toISOString().split('T')[0];
            var storedDate = localStorage.getItem('selectedDate');
            var selectedDateStr = today;

            if (window.location.pathname.endsWith('/dashboard') && storedDate) {
                selectedDateStr = storedDate;
            } else {
                localStorage.setItem('selectedDate', selectedDateStr);
            }

            var currentView = localStorage.getItem('calendarView') || 'dayGridMonth';

            // Hàm highlight ngày đã chọn
            function highlightSelectedDate() {
                document.querySelectorAll('.fc-daygrid-day.fc-day-selected').forEach(function(el) {
                    el.classList.remove('fc-day-selected');
                });
                var selectedCell = document.querySelector('.fc-daygrid-day[data-date="' + selectedDateStr + '"]');
                if (selectedCell) {
                    selectedCell.classList.add('fc-day-selected');
                }
            }

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: currentView,
                initialDate: selectedDateStr,
                customButtons: {
                    today: {
                        text: 'Hôm nay',
                        click: function() {
                            var today = new Date().toISOString().split('T')[0];
                            selectedDateStr = today;
                            localStorage.setItem('selectedDate', selectedDateStr);
                            calendar.today();

                            highlightSelectedDate();

                            openTodoPanel();
                            document.getElementById('selectedDate').textContent = new Date(selectedDateStr).toLocaleDateString('vi-VN');
                            document.getElementById('addEventLink').href = contextPath + '/schedule/new?date=' + selectedDateStr;
                            updateTodoList(selectedDateStr, calendar);
                        }
                    }
                },
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                locale: 'vi',
                buttonText: {
                    today: 'Hôm nay',
                    month: 'Tháng',
                    week: 'Tuần',
                    day: 'Ngày'
                },
                showNonCurrentDates: true,
                fixedWeekCount: false,
                height: 'auto',
                aspectRatio: 1.35,
                dayMaxEvents: false,
                events: [
                    <c:forEach var="schedule" items="${schedules}" varStatus="status">
                        {
                            id: '${schedule.id}',
                            title: '${schedule.title}',
                            start: '<fmt:formatDate value="${schedule.startDateAsDate}" pattern="yyyy-MM-dd\'T\'HH:mm:ss"/>',
                            end: <c:choose>
                                <c:when test="${schedule.endDateAsDate != null}">
                                    '<fmt:formatDate value="${schedule.endDateAsDate}" pattern="yyyy-MM-dd\'T\'HH:mm:ss"/>'
                                </c:when>
                                <c:otherwise>
                                    null
                                </c:otherwise>
                            </c:choose>,
                            description: '${schedule.description}',
                            type: '<c:choose><c:when test="${schedule.type == \'LONG_TERM\'}">Dài hạn</c:when><c:when test="${schedule.type == \'SHORT_TERM\'}">Ngắn hạn</c:when><c:when test="${schedule.type == \'RECURRING\'}">Lặp lại</c:when></c:choose>',
                            className: 'priority-${schedule.priority.name().toLowerCase().replace("_", "-")}'
                        }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                eventDidMount: function(info) {
                    if (info.event.end && info.event.start) {
                        var startDate = new Date(info.event.start);
                        var endDate = new Date(info.event.end);
                        if (endDate > startDate) {
                            info.el.style.background = 'repeating-linear-gradient(45deg, ' + info.el.style.backgroundColor + ' 0, ' + info.el.style.backgroundColor + ' 10px, transparent 10px, transparent 20px)';
                        }
                    }
                },
                viewDidMount: function(info) {
                    currentView = info.view.type;
                    localStorage.setItem('calendarView', currentView);
                    
                    // Đảm bảo calendar hiển thị đúng ngày đã chọn
                    setTimeout(function() {
                        calendar.updateSize();
                        highlightSelectedDate();
                        if (isTodoPanelOpen) {
                            openTodoPanel();
                            updateTodoList(selectedDateStr, calendar);
                        }
                    }, 100);
                },
                datesSet: function(info) {
                    localStorage.setItem('calendarView', info.view.type);
                    
                    setTimeout(function() {
                        calendar.updateSize();
                        highlightSelectedDate();
                        if (isTodoPanelOpen) {
                            openTodoPanel();
                            updateTodoList(selectedDateStr, calendar);
                        }
                    }, 50);
                },
                eventClick: function(info) {
                    var event = info.event;
                    var startDate = event.start ? new Date(event.start).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'Không có';
                    var endDate = event.end ? new Date(event.end).toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' }) : 'Không có';
                    document.getElementById('eventModalLabel').textContent = event.title || 'Không có tiêu đề';
                    document.getElementById('eventDescription').textContent = event.extendedProps.description || 'Không có mô tả';
                    document.getElementById('eventStart').textContent = startDate;
                    document.getElementById('eventEnd').textContent = endDate;
                    document.getElementById('eventType').textContent = event.extendedProps.type || 'Không xác định';
                    document.getElementById('editEvent').href = contextPath + '/schedule/edit/' + event.id;
                    document.getElementById('deleteEventForm').action = contextPath + '/schedule/delete/' + event.id;

                    var modal = new bootstrap.Modal(document.getElementById('eventModal'));
                    modal.show();
                },
                dateClick: function(info) {
                    selectedDateStr = info.dateStr;
                    localStorage.setItem('selectedDate', selectedDateStr);

                    highlightSelectedDate();

                    openTodoPanel();
                    document.getElementById('selectedDate').textContent = new Date(selectedDateStr).toLocaleDateString('vi-VN');
                    document.getElementById('addEventLink').href = contextPath + '/schedule/new?date=' + selectedDateStr;
                    updateTodoList(selectedDateStr, calendar);
                }
            });

            calendar.render();

            // Event listeners cho các button view với cải thiện đồng bộ
            setTimeout(function() {
                document.querySelectorAll('.fc-dayGridMonth-button, .fc-timeGridWeek-button, .fc-timeGridDay-button').forEach(function(button) {
                    button.addEventListener('click', function() {
                        isTodoPanelOpen = todoPanel.classList.contains('active');
                        
                        // Lưu trạng thái view hiện tại
                        var newView = button.classList.contains('fc-dayGridMonth-button') ? 'dayGridMonth' : 
                                     button.classList.contains('fc-timeGridWeek-button') ? 'timeGridWeek' : 'timeGridDay';
                        
                        setTimeout(function() {
                            // Chuyển calendar đến ngày đã chọn trong view mới
                            calendar.gotoDate(selectedDateStr);
                            highlightSelectedDate();
                            
                            if (isTodoPanelOpen) {
                                openTodoPanel();
                                updateTodoList(selectedDateStr, calendar);
                            }
                        }, 50);
                    });
                });
            }, 200);

            setTimeout(function() {
                highlightSelectedDate();
            }, 100);

            document.addEventListener('click', function(event) {
                if (!todoPanel.contains(event.target) &&
                    !calendarEl.contains(event.target) &&
                    !event.target.closest('.fc-daygrid-day') &&
                    !event.target.closest('.modal') &&
                    !event.target.closest('.fc-dayGridMonth-button') &&
                    !event.target.closest('.fc-timeGridWeek-button') &&
                    !event.target.closest('.fc-timeGridDay-button')) {
                    closeTodoPanel();
                }
            });

            function openTodoPanel() {
                calendarEl.classList.add('sidebar-active');
                todoPanel.classList.add('active');
                isTodoPanelOpen = true;
                setTimeout(function() {
                    calendar.updateSize();
                }, 450);
                const items = todoPanel.querySelectorAll('.sidebar-item');
                items.forEach(item => {
                    item.style.animation = 'none';
                    item.offsetHeight;
                    item.style.animation = null;
                });
                document.getElementById('selectedDate').textContent = new Date(selectedDateStr).toLocaleDateString('vi-VN');
                document.getElementById('addEventLink').href = contextPath + '/schedule/new?date=' + selectedDateStr;
            }

            window.closeTodoPanel = function() {
                todoPanel.classList.remove('active');
                calendarEl.classList.remove('sidebar-active');
                isTodoPanelOpen = false;
                setTimeout(function() {
                    calendar.updateSize();
                }, 450);
            }

            function updateTodoList(dateStr, calendar) {
                var todoList = document.getElementById('todoList');
                todoList.innerHTML = '';

                var events = calendar.getEvents().filter(function(event) {
                    return event.start.toISOString().split('T')[0] === dateStr;
                });

                if (events.length === 0) {
                    todoList.innerHTML = '<div class="sidebar-item">Không có sự kiện nào trong ngày này</div>';
                    return;
                }

                events.forEach(function(event, index) {
                    var itemDiv = document.createElement('div');
                    var priorityClass = event.classNames[0] ? event.classNames[0] : '';
                    itemDiv.className = 'sidebar-item ' + priorityClass;

                    var eventDetailsDiv = document.createElement('div');
                    eventDetailsDiv.className = 'event-details';

                    var titleSpan = document.createElement('span');
                    titleSpan.textContent = event.title || 'Không có tiêu đề';
                    eventDetailsDiv.appendChild(titleSpan);

                    var eventActionsDiv = document.createElement('div');
                    eventActionsDiv.className = 'event-actions';

                    var editLink = document.createElement('a');
                    editLink.href = contextPath + '/schedule/edit/' + event.id;
                    editLink.className = 'btn btn-edit btn-sm';
                    var editIcon = document.createElement('i');
                    editIcon.className = 'fas fa-edit';
                    editLink.appendChild(editIcon);
                    eventActionsDiv.appendChild(editLink);

                    var deleteForm = document.createElement('form');
                    deleteForm.action = contextPath + '/schedule/delete/' + event.id;
                    deleteForm.method = 'post';
                    deleteForm.style.display = 'inline';

                    var csrfInput = document.createElement('input');
                    csrfInput.type = 'hidden';
                    csrfInput.name = csrfParameterName;
                    csrfInput.value = csrfToken;
                    deleteForm.appendChild(csrfInput);

                    var deleteButton = document.createElement('button');
                    deleteButton.type = 'submit';
                    deleteButton.className = 'btn btn-delete btn-sm';
                    deleteButton.onclick = function() { return confirm('Bạn có chắc chắn muốn xóa lịch trình này?'); };
                    var deleteIcon = document.createElement('i');
                    deleteIcon.className = 'fas fa-trash';
                    deleteButton.appendChild(deleteIcon);
                    deleteForm.appendChild(deleteButton);
                    eventActionsDiv.appendChild(deleteForm);

                    eventDetailsDiv.appendChild(eventActionsDiv);
                    itemDiv.appendChild(eventDetailsDiv);

                    var smallTag = document.createElement('small');
                    var startTimeSpan = document.createElement('strong');
                    startTimeSpan.textContent = 'Thời gian:';
                    smallTag.appendChild(startTimeSpan);
                    smallTag.innerHTML += ' ' + (event.start ? new Date(event.start).toLocaleString('vi-VN') : 'Không có') + '<br>';

                    if (event.end) {
                        var endTimeSpan = document.createElement('strong');
                        endTimeSpan.textContent = 'Kết thúc:';
                        smallTag.appendChild(endTimeSpan);
                        smallTag.innerHTML += ' ' + new Date(event.end).toLocaleString('vi-VN');
                    }
                    itemDiv.appendChild(smallTag);

                    todoList.appendChild(itemDiv);
                });
            }

            window.addEventListener('resize', function() {
                setTimeout(function() {
                    calendar.updateSize();
                }, 100);
            });

            var logoutLink = document.querySelector('a.nav-link[href$="/logout"]');
            if (logoutLink) {
                logoutLink.addEventListener('click', function() {
                    localStorage.removeItem('selectedDate');
                    localStorage.removeItem('calendarView');
                });
            }

            window.addEventListener('beforeunload', function(event) {
                if (!window.location.pathname.endsWith('/dashboard')) {
                    localStorage.removeItem('selectedDate');
                    localStorage.removeItem('calendarView');
                }
            });
        });
    </script>
</body>
</html>