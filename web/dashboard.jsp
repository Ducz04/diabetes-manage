<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="patientName" value="John Doe" scope="request" />
<c:set var="patientEmail" value="john.doe@email.com" scope="request" />
<c:set var="patientInitials" value="JD" scope="request" />
<c:set var="latestGlucose" value="113" scope="request" />
<c:set var="lastHbA1c" value="6.8" scope="request" />
<c:set var="dailyCarb" value="180" scope="request" />
<c:set var="dailySteps" value="7500" scope="request" />
<c:set var="nextApptDate" value="May 20" scope="request" />
<c:set var="nextApptDoc" value="Dr. Smith - Endocrinology" scope="request" />
<c:set var="glucoseTrendsJson" value="[110, 135, 105, 120, 115, 130, 118]" scope="request" />
<c:set var="cgmDataJson" value="[120, 118, 115, 116, 119, 122, 125, 121, 118, 115, 113, 113]" scope="request" />

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DiabetesCare Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link rel="stylesheet" href="styles.css">
</head>

<body>

    <aside class="sidebar">
        <div class="logo">
            <div class="logo-icon"><i class="fa-solid fa-heart-pulse"></i></div>
            <div class="logo-text">
                <h2>DiabetesCare</h2>
                <p>Patient Portal</p>
            </div>
        </div>

        <nav class="nav-menu">
            <a href="#" class="nav-item active">
                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-droplet"></i>
                <span>Glucose Logs</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-chart-line"></i>
                <span>Trends</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-regular fa-calendar-check"></i>
                <span>Appointments</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-file-lines"></i>
                <span>Reports</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-regular fa-user"></i>
                <span>Profile</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-gear"></i>
                <span>Settings</span>
            </a>
        </nav>

        <div class="user-profile-mini">
            <div class="avatar">${patientInitials}</div>
            <div class="user-info">
                <h4>${patientName}</h4>
                <p>${patientEmail}</p>
            </div>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="welcome-text">
                <h1>Dashboard</h1>
                <p>Welcome back, ${patientName}. Here's your health overview.</p>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card" id="card-glucose">
                <div class="card-header">
                    <div class="icon-wrapper safe-bg"><i class="fa-solid fa-droplet safe-color"></i></div>
                    <div class="status-indicator" id="glucose-status-icon"></div>
                </div>
                <div class="card-body">
                    <h3>Latest Glucose</h3>
                    <div class="value-wrapper">
                        <span class="value safe-color" id="glucose-value">${latestGlucose}</span>
                        <span class="unit">mg/dL</span>
                    </div>
                    <p class="subtitle">2 hours ago</p>
                    <div class="sparkline-container">
                        <canvas id="sparklineChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="card-header">
                    <div class="icon-wrapper neutral-bg"><i class="fa-solid fa-wave-square neutral-color"></i></div>
                </div>
                <div class="card-body">
                    <h3>Last HbA1c</h3>
                    <div class="value-wrapper">
                        <span class="value">${lastHbA1c}</span>
                        <span class="unit">%</span>
                    </div>
                    <p class="subtitle">Target: &lt; 7.0%</p>
                </div>
            </div>

            <div class="stat-card" id="card-carb">
                <div class="card-header">
                    <div class="icon-wrapper carb-bg"><i class="fa-solid fa-utensils carb-color"></i></div>
                    <div class="trend-indicator safe-bg safe-color" id="carb-trend-icon"><i class="fa-solid fa-arrow-up"></i></div>
                </div>
                <div class="card-body">
                    <h3>Daily Carb Intake</h3>
                    <div class="value-wrapper">
                        <span class="value" id="carb-value">${dailyCarb}</span>
                        <span class="unit">g</span>
                    </div>
                    <p class="subtitle">Target: 200g (Today)</p>
                </div>
            </div>

            <div class="stat-card" id="card-activity">
                <div class="card-header">
                    <div class="icon-wrapper activity-bg"><i class="fa-solid fa-person-walking activity-color"></i></div>
                </div>
                <div class="card-body">
                    <h3>Physical Activity</h3>
                    <div class="value-wrapper">
                        <span class="value">${dailySteps}</span>
                        <span class="unit">steps</span>
                    </div>
                    <p class="subtitle">Goal: 10,000 steps</p>
                    <div class="progress-bar-container mt-2">
                        <div class="progress-bar activity-bg" style="width: 75%"></div>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="card-header">
                    <div class="icon-wrapper appt-bg"><i class="fa-regular fa-calendar appt-color"></i></div>
                </div>
                <div class="card-body">
                    <h3>Next Appointment</h3>
                    <div class="value-wrapper">
                        <span class="value" style="font-size: 24px;">${nextApptDate}</span>
                    </div>
                    <p class="subtitle">${nextApptDoc}</p>
                </div>
            </div>
        </section>

        <div class="dashboard-layout">

            <div class="main-column">
                <div class="panel chart-panel">
                    <div class="panel-header">
                        <div>
                            <h2>Glucose Trends</h2>
                            <p>7-day daily averages with Target Range</p>
                        </div>
                        <div class="chart-toggles">
                            <button class="toggle-btn active"><i class="fa-solid fa-syringe"></i> Insulin</button>
                            <button class="toggle-btn"><i class="fa-solid fa-utensils"></i> Meals</button>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="glucoseTrendsChart"></canvas>
                    </div>

                    <div class="test-controls">
                        <span>Test Color Coding: </span>
                        <button onclick="simulateGlucose(113)">Safe (113)</button>
                        <button onclick="simulateGlucose(260)">High (260)</button>
                        <span style="margin-left: 15px;">Carbs: </span>
                        <button onclick="simulateCarb(180)">Safe (180g)</button>
                        <button onclick="simulateCarb(220)">Over (220g)</button>
                    </div>
                </div>
            </div>

            <div class="side-column">
                <div class="panel form-panel">
                    <h2>Quick Log</h2>
                    <p>Fast data entry</p>
                    <form id="quick-log-form">
                        <div class="form-group">
                            <label><i class="fa-solid fa-droplet text-red"></i> Glucose (mg/dL)</label>
                            <input type="number" value="120" class="form-control">
                        </div>
                        <div class="form-group">
                            <label><i class="fa-solid fa-utensils text-orange"></i> Carbs (g)</label>
                            <input type="number" value="45" class="form-control">
                        </div>
                        <div class="form-group">
                            <label><i class="fa-solid fa-syringe text-purple"></i> Insulin (units)</label>
                            <input type="number" value="8" class="form-control">
                        </div>
                        <button type="button" class="btn btn-primary"><i class="fa-regular fa-floppy-disk"></i> Log Data</button>
                    </form>
                </div>

                <div class="panel highlight-panel">
                    <div class="panel-icon"><i class="fa-solid fa-shoe-prints"></i></div>
                    <div>
                        <h2>Daily Foot Check</h2>
                        <p>Not completed today</p>
                    </div>
                    <ul class="checklist">
                        <li><i class="fa-solid fa-circle-check"></i> Check for cuts, blisters, or redness</li>
                        <li><i class="fa-solid fa-circle-check"></i> Inspect between toes</li>
                        <li><i class="fa-solid fa-circle-check"></i> Look for swelling or color changes</li>
                    </ul>
                    <button class="btn btn-primary-outline"><i class="fa-solid fa-check"></i> Mark as Complete</button>
                </div>
            </div>

        </div>
    </main>

    <script>
        // Các biến này sẽ nhận dữ liệu từ JSP EL bắn xuống Javascript
        const dynamicGlucoseValue = ${latestGlucose};
        const dynamicCarbValue = ${dailyCarb};
        const dynamicGlucoseTrendsData = ${glucoseTrendsJson};
        const dynamicCgmData = ${cgmDataJson};
    </script>
    <script src="dashboard.js"></script>
</body>

</html>