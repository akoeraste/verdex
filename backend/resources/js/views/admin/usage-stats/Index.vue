<template>
  <main class="usage-stats-content">
    <section class="usage-header">
      <h1>Usage Stats (Activity Log)</h1>
      <div class="filters">
        <input v-model="searchUser" placeholder="Filter by user..." />
        <select v-model="filterEvent">
          <option value="">All Events</option>
          <option v-for="event in eventTypes" :key="event" :value="event">{{ event }}</option>
        </select>
      </div>
    </section>
    <section class="usage-chart">
      <canvas id="activityChart"></canvas>
    </section>
    <section class="usage-table">
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Event</th>
            <th>Description</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="log in filteredLogs" :key="log.id">
            <td>{{ log.user }}</td>
            <td>{{ log.event }}</td>
            <td>{{ log.description }}</td>
            <td>{{ log.date }}</td>
          </tr>
        </tbody>
      </table>
    </section>
  </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

const logs = ref([]);
const eventTypes = ref([]);
const searchUser = ref('');
const filterEvent = ref('');

onMounted(async () => {
  // Fetch activity logs from API (replace with real endpoint if available)
  try {
    // Example: const res = await axios.get('/api/activity-logs');
    // logs.value = res.data;
    // eventTypes.value = [...new Set(logs.value.map(l => l.event))];
    // Mock data:
    logs.value = [
      { id: 1, user: 'prime', event: 'login', description: 'User logged in', date: '2024-06-01' },
      { id: 2, user: 'prime', event: 'plant-create', description: 'Created plant Mango', date: '2024-06-01' },
      { id: 3, user: 'admin', event: 'user-edit', description: 'Edited user prime', date: '2024-06-02' },
      { id: 4, user: 'prime', event: 'logout', description: 'User logged out', date: '2024-06-03' },
      { id: 5, user: 'admin', event: 'login', description: 'User logged in', date: '2024-06-03' },
      { id: 6, user: 'prime', event: 'plant-edit', description: 'Edited plant Banana', date: '2024-06-04' },
      { id: 7, user: 'prime', event: 'login', description: 'User logged in', date: '2024-06-05' },
    ];
    eventTypes.value = [...new Set(logs.value.map(l => l.event))];
  } catch (e) {}

  // Chart
  import('chart.js/auto').then(({ default: Chart }) => {
    const ctx = document.getElementById('activityChart');
    if (ctx) {
      // Count activities per day (mock)
      const days = ['2024-06-01', '2024-06-02', '2024-06-03', '2024-06-04', '2024-06-05', '2024-06-06', '2024-06-07'];
      const counts = days.map(day => logs.value.filter(l => l.date === day).length);
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: days,
          datasets: [{
            label: 'Activity Count',
            data: counts,
            backgroundColor: '#43e97b',
          }],
        },
        options: {
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true } },
        },
      });
    }
  });
});

const filteredLogs = computed(() => {
  return logs.value.filter(log => {
    const userMatch = !searchUser.value || log.user.toLowerCase().includes(searchUser.value.toLowerCase());
    const eventMatch = !filterEvent.value || log.event === filterEvent.value;
    return userMatch && eventMatch;
  });
});
</script>

<style scoped>
.usage-stats-content {
  padding: 2rem;
  max-width: 900px;
  margin: 0 auto;
}
.usage-header {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 2rem;
}
.filters {
  display: flex;
  gap: 1rem;
}
.usage-chart {
  margin-bottom: 2rem;
  background: #fff;
  border-radius: 1rem;
  box-shadow: 0 2px 8px rgba(67,233,123,0.07);
  padding: 1rem;
}
.usage-table table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(67,233,123,0.07);
}
.usage-table th, .usage-table td {
  padding: 0.7rem 1rem;
  text-align: left;
}
.usage-table th {
  background: #f8fafc;
  font-weight: 600;
}
.usage-table tr:nth-child(even) {
  background: #f3f6fa;
}
</style> 