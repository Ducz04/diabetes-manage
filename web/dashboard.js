// Global Variables
let glucoseTrendsChart;
let sparklineChart;

// Chart.js Configuration Defaults
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.color = '#64748b';
Chart.defaults.scale.grid.color = '#e2e8f0';

document.addEventListener('DOMContentLoaded', () => {
    initGlucoseTrendsChart();
    initSparklineChart();
    
    // Initialize default state from JSP injected variables if available
    const initialGlucose = typeof dynamicGlucoseValue !== 'undefined' ? dynamicGlucoseValue : 113;
    const initialCarb = typeof dynamicCarbValue !== 'undefined' ? dynamicCarbValue : 180;
    
    simulateGlucose(initialGlucose);
    simulateCarb(initialCarb);
});

// 1. Simulate Color Coding Logic for Glucose
function simulateGlucose(value) {
    const card = document.getElementById('card-glucose');
    const valueEl = document.getElementById('glucose-value');
    const iconEl = document.getElementById('glucose-status-icon');
    const iconWrapper = card.querySelector('.icon-wrapper');
    const icon = iconWrapper.querySelector('i');
    
    valueEl.textContent = value;
    
    // Reset classes
    valueEl.className = 'value';
    iconWrapper.className = 'icon-wrapper';
    icon.className = 'fa-solid fa-droplet';
    
    // Logic: <= 140 is Safe (Blue), > 140 is Danger (Red)
    if (value <= 140) {
        valueEl.classList.add('safe-color');
        iconWrapper.classList.add('safe-bg');
        icon.classList.add('safe-color');
        iconEl.innerHTML = '<span style="color: var(--safe);"><i class="fa-solid fa-check"></i> Safe</span>';
    } else {
        valueEl.classList.add('danger-color');
        iconWrapper.classList.add('danger-bg');
        icon.classList.add('danger-color');
        iconEl.innerHTML = '<span style="color: var(--danger);"><i class="fa-solid fa-triangle-exclamation"></i> High</span>';
    }
}

// 2. Simulate Color Coding Logic for Carbs
function simulateCarb(value) {
    const card = document.getElementById('card-carb');
    const valueEl = document.getElementById('carb-value');
    const trendIcon = document.getElementById('carb-trend-icon');
    
    valueEl.textContent = value;
    const target = 200;
    
    // Reset classes
    trendIcon.className = 'trend-indicator';
    
    if (value <= target) {
        // Safe: Blue/Green
        trendIcon.classList.add('safe-bg', 'safe-color');
        trendIcon.innerHTML = '<i class="fa-solid fa-check"></i>';
    } else {
        // Over target: Warning (Orange)
        trendIcon.classList.add('warning-bg', 'warning-color');
        trendIcon.innerHTML = '<i class="fa-solid fa-arrow-up"></i>';
    }
}

// 3. Glucose Trends Chart with Shaded Area
function initGlucoseTrendsChart() {
    const ctx = document.getElementById('glucoseTrendsChart').getContext('2d');
    
    // Data points (from JSP if available, otherwise fallback)
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const dataPoints = typeof dynamicGlucoseTrendsData !== 'undefined' ? dynamicGlucoseTrendsData : [110, 135, 105, 120, 115, 130, 118];
    
    // To create a shaded area in base Chart.js without plugins:
    // We create an upper bound line and a lower bound line and fill between them.
    const targetUpper = Array(7).fill(180);
    const targetLower = Array(7).fill(70);

    glucoseTrendsChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [
                {
                    label: 'Target Upper',
                    data: targetUpper,
                    borderColor: 'rgba(0,0,0,0)',
                    backgroundColor: 'rgba(0,0,0,0)',
                    pointRadius: 0,
                    fill: false,
                    hidden: true // Just a reference
                },
                {
                    label: 'Target Range (70-180)',
                    data: targetLower,
                    borderColor: 'rgba(14, 165, 233, 0.4)', // Safe blue dashed line
                    borderDash: [5, 5],
                    borderWidth: 1,
                    backgroundColor: 'rgba(14, 165, 233, 0.08)', // Shaded Area!
                    pointRadius: 0,
                    fill: {
                        target: {value: 180}, // Fill from this line up to value 180
                        above: 'rgba(14, 165, 233, 0.08)',
                        below: 'rgba(14, 165, 233, 0.08)'
                    }
                },
                {
                    label: 'Avg Glucose',
                    data: dataPoints,
                    borderColor: '#2563eb', // Primary blue
                    backgroundColor: '#ffffff',
                    borderWidth: 3,
                    pointBackgroundColor: '#2563eb',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    tension: 0.4, // Smooth curve
                    fill: false
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false,
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(15, 23, 42, 0.9)',
                    titleFont: { size: 13 },
                    bodyFont: { size: 14, weight: 'bold' },
                    padding: 12,
                    cornerRadius: 8,
                    displayColors: false,
                    callbacks: {
                        label: function(context) {
                            if (context.datasetIndex === 2) {
                                return context.raw + ' mg/dL';
                            }
                            return null;
                        }
                    }
                }
            },
            scales: {
                y: {
                    min: 50,
                    max: 250,
                    ticks: {
                        stepSize: 50
                    },
                    border: { display: false }
                },
                x: {
                    grid: {
                        display: false
                    },
                    border: { display: false }
                }
            }
        }
    });
}

// 4. Sparkline Chart (Smooth CGM Data)
function initSparklineChart() {
    const ctx = document.getElementById('sparklineChart').getContext('2d');
    
    // Generating smooth continuous data representing CGM (from JSP if available)
    const dataPoints = typeof dynamicCgmData !== 'undefined' ? dynamicCgmData : [120, 118, 115, 116, 119, 122, 125, 121, 118, 115, 113, 113];
    
    sparklineChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: Array(dataPoints.length).fill(''),
            datasets: [{
                data: dataPoints,
                borderColor: '#0ea5e9', // Safe blue
                borderWidth: 2,
                pointRadius: 0, // Hide points for a continuous line look
                pointHoverRadius: 4,
                tension: 0.5 // Extremely smooth curve
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: { enabled: false }
            },
            scales: {
                x: { display: false },
                y: { 
                    display: false,
                    min: 100,
                    max: 140
                }
            },
            layout: { padding: 0 }
        }
    });
}
