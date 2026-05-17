<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng Điều Khiển Admin | Diabetes Manage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .card-counter { shadow: 0 4px 8px rgba(0,0,0,0.1); border: none; border-radius: 10px; }
        .sidebar { min-height: 100vh; background: #212529; color: white; padding-top: 20px; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar d-none d-md-block">
            <h4 class="text-center mb-4">DIABETES APP</h4>
            <ul class="nav flex-column">
                <li class="nav-item"><a class="nav-link text-white active" href="#"><i class="fas fa-chart-line me-2"></i>Dashboard</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-users me-2"></i>Bệnh nhân</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-bell me-2"></i>Cảnh báo</a></li>
            </ul>
        </div>

        <div class="col-md-10 bg-light p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Bảng điều khiển hệ thống</h2>
                <span class="badge bg-dark p-2">Phiên làm việc: Admin</span>
            </div>

            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card card-counter bg-primary text-white p-3">
                        <h6>Tổng bệnh nhân</h6>
                        <h3>${totalPatients}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-counter bg-danger text-white p-3">
                        <h6>Cảnh báo đỏ</h6>
                        <h3>${alertsCount}</h3>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-white font-weight-bold">Danh sách theo dõi gần đây</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Mã BN</th>
                            <th>Tên bệnh nhân</th>
                            <th>Chỉ số (mg/dL)</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<String[]> patients = (List<String[]>) request.getAttribute("patientData");
                            if(patients != null) {
                                for(String[] p : patients) {
                        %>
                        <tr>
                            <td><%= p[0] %></td>
                            <td><strong><%= p[1] %></strong></td>
                            <td><%= p[2] %></td>
                            <td>
                                <% if(Integer.parseInt(p[2]) > 130) { %>
                                <span class="badge bg-danger">Nguy cơ cao</span>
                                <% } else { %>
                                <span class="badge bg-success">Ổn định</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>