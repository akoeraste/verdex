<template>
  <main class="dashboard-content">
    <section class="dashboard-header">
      <h1 class="dashboard-title">Welcome back, {{ userName }}!</h1>
      <p class="dashboard-subtitle">Here's a quick overview of your system today.</p>
    </section>
    <section class="dashboard-stats">
      <div class="stat-card" v-for="stat in stats" :key="stat.label">
        <div class="stat-icon" :style="{ background: stat.bg }">
          <i :class="stat.icon"></i>
        </div>
        <div class="stat-info">
          <h2>{{ stat.value }}</h2>
          <span>{{ stat.label }}</span>
        </div>
      </div>
    </section>
    <section class="dashboard-charts">
      <div class="chart-card">
        <h3>Plant Identifications (Last 7 Days)</h3>
        <canvas id="identificationChart"></canvas>
      </div>
      <div class="chart-card">
        <h3>Feedback Overview</h3>
        <canvas id="feedbackChart"></canvas>
      </div>
    </section>
    <section class="dashboard-quicklinks">
      <h3>Quick Actions</h3>
      <div class="quicklinks">
        <router-link to="/admin/plants/create" class="quicklink-btn">Add Plant</router-link>
        <router-link to="/admin/users" class="quicklink-btn">Manage Users</router-link>
        <router-link to="/admin/feedback" class="quicklink-btn">View Feedback</router-link>
        <router-link to="/admin/activity_log" class="quicklink-btn">Activity Logs</router-link>
      </div>
    </section>
  </main>
</template>

<script setup>
import { onMounted, ref } from 'vue';

const userName = 'Admin'; // Replace with actual user data
const stats = [
  { label: 'Total Plants', value: 128, icon: 'bi bi-flower1', bg: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' },
  { label: 'Users', value: 54, icon: 'bi bi-people', bg: 'linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%)' },
  { label: 'Identifications', value: 1024, icon: 'bi bi-search', bg: 'linear-gradient(135deg, #f6d365 0%, #fda085 100%)' },
  { label: 'Feedback', value: 87, icon: 'bi bi-chat-dots', bg: 'linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)' },
];

onMounted(() => {
  // Chart.js example for modern charts
  import('chart.js/auto').then(({ default: Chart }) => {
    const ctx1 = document.getElementById('identificationChart');
    if (ctx1) {
      new Chart(ctx1, {
        type: 'line',
        data: {
          labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          datasets: [{
            label: 'Identifications',
            data: [12, 19, 14, 20, 16, 22, 18],
            borderColor: '#43e97b',
            backgroundColor: 'rgba(67,233,123,0.1)',
            tension: 0.4,
            fill: true,
            pointRadius: 4,
            pointBackgroundColor: '#43e97b',
          }],
        },
        options: {
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true } },
        },
      });
    }
    const ctx2 = document.getElementById('feedbackChart');
    if (ctx2) {
      new Chart(ctx2, {
        type: 'doughnut',
        data: {
          labels: ['Positive', 'Negative', 'Neutral'],
          datasets: [{
            data: [60, 25, 15],
            backgroundColor: ['#43e97b', '#fa8bff', '#f6d365'],
            borderWidth: 0,
          }],
        },
        options: {
          plugins: { legend: { position: 'bottom' } },
        },
      });
    }
  });
});
</script>

<style scoped>
.dashboard-container {
  min-height: 100vh;
  background: linear-gradient(120deg, #f8fafc 0%, #e3f2fd 100%);
  display: flex;
  flex-direction: column;
}
.dashboard-main {
  display: flex;
  flex: 1;
}
.dashboard-content {
  flex: 1;
  padding: 2.5rem 2rem 2rem 2rem;
  max-width: 100vw;
  overflow-x: auto;
}
.dashboard-header {
  margin-bottom: 2rem;
}
.dashboard-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #22223b;
  margin-bottom: 0.5rem;
}
.dashboard-subtitle {
  color: #4a4e69;
  font-size: 1.1rem;
}
.dashboard-stats {
  display: flex;
  gap: 2rem;
  margin-bottom: 2.5rem;
  flex-wrap: wrap;
}
.stat-card {
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 4px 24px rgba(34,34,59,0.07);
  padding: 2rem 2.5rem;
  display: flex;
  align-items: center;
  min-width: 220px;
  flex: 1 1 220px;
  transition: box-shadow 0.2s;
}
.stat-card:hover {
  box-shadow: 0 8px 32px rgba(67,233,123,0.15);
}
.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1.5rem;
  font-size: 2rem;
  color: #fff;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
}
.stat-info h2 {
  font-size: 2rem;
  font-weight: 600;
  margin: 0;
  color: #22223b;
}
.stat-info span {
  color: #4a4e69;
  font-size: 1rem;
}
.dashboard-charts {
  display: flex;
  gap: 2rem;
  margin-bottom: 2.5rem;
  flex-wrap: wrap;
}
.chart-card {
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 4px 24px rgba(34,34,59,0.07);
  padding: 2rem;
  flex: 1 1 350px;
  min-width: 350px;
  max-width: 600px;
}
.chart-card h3 {
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 1.2rem;
  color: #22223b;
}
.dashboard-quicklinks {
  margin-top: 2.5rem;
}
.quicklinks {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}
.quicklink-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 0.9rem 2.2rem;
  border-radius: 2rem;
  font-weight: 600;
  font-size: 1.1rem;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  transition: background 0.2s, box-shadow 0.2s;
}
.quicklink-btn:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  box-shadow: 0 4px 16px rgba(250,139,255,0.15);
}
@media (max-width: 900px) {
  .dashboard-stats, .dashboard-charts, .quicklinks {
    flex-direction: column;
    gap: 1.2rem;
  }
  .dashboard-content {
    padding: 1.2rem;
  }
}
</style>
