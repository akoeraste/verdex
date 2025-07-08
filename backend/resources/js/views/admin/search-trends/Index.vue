<template>
  <main class="search-trends-content">
    <section class="search-header">
      <h1>Search Trends</h1>
    </section>
    <section class="search-charts">
      <div class="chart-card">
        <h3>Most Searched Terms</h3>
        <canvas id="topTermsChart"></canvas>
      </div>
      <div class="chart-card">
        <h3>Search Frequency (Last 7 Days)</h3>
        <canvas id="searchFreqChart"></canvas>
      </div>
    </section>
    <section class="search-table">
      <h3>Recent Searches</h3>
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Term</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="search in recentSearches" :key="search.id">
            <td>{{ search.user }}</td>
            <td>{{ search.term }}</td>
            <td>{{ search.date }}</td>
          </tr>
        </tbody>
      </table>
    </section>
  </main>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const topTerms = ref([
  { term: 'Mango', count: 18 },
  { term: 'Banana', count: 15 },
  { term: 'Cassava', count: 12 },
  { term: 'Aloevera', count: 10 },
  { term: 'Spinach', count: 8 },
]);
const searchFreq = ref([5, 8, 6, 10, 7, 12, 9]);
const recentSearches = ref([
  { id: 1, user: 'prime', term: 'Mango', date: '2025-06-01' },
  { id: 2, user: 'admin', term: 'Banana', date: '2025-06-01' },
  { id: 3, user: 'prime', term: 'Cassava', date: '2025-06-02' },
  { id: 4, user: 'prime', term: 'Aloevera', date: '2025-06-03' },
  { id: 5, user: 'admin', term: 'Spinach', date: '2025-06-04' },
]);

onMounted(() => {
  import('chart.js/auto').then(({ default: Chart }) => {
    // Top Terms Bar Chart
    const ctx1 = document.getElementById('topTermsChart');
    if (ctx1) {
      new Chart(ctx1, {
        type: 'bar',
        data: {
          labels: topTerms.value.map(t => t.term),
          datasets: [{
            label: 'Search Count',
            data: topTerms.value.map(t => t.count),
            backgroundColor: '#fa8bff',
          }],
        },
        options: {
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true } },
        },
      });
    }
    // Search Frequency Line Chart
    const ctx2 = document.getElementById('searchFreqChart');
    if (ctx2) {
      new Chart(ctx2, {
        type: 'line',
        data: {
          labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          datasets: [{
            label: 'Searches',
            data: searchFreq.value,
            borderColor: '#43e97b',
            backgroundColor: 'rgba(67,233,123,0.1)',
            tension: 0.4,
            fill: true,
            pointRadius: 3,
            pointBackgroundColor: '#43e97b',
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
</script>

<style scoped>
.search-trends-content {
  padding: 2rem;
  max-width: 1000px;
  margin: 0 auto;
}
.search-header {
  margin-bottom: 2rem;
}
.search-charts {
  display: flex;
  gap: 2rem;
  margin-bottom: 2.5rem;
  flex-wrap: wrap;
}
.chart-card {
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 4px 24px rgba(34,34,59,0.07);
  padding: 1rem;
  flex: 1 1 320px;
  min-width: 320px;
  max-width: 450px;
}
.chart-card h3 {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1.2rem;
  color: #22223b;
}
.chart-card canvas {
  height: 120px !important;
  max-height: 120px !important;
}
.search-table table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(67,233,123,0.07);
}
.search-table th, .search-table td {
  padding: 0.7rem 1rem;
  text-align: left;
}
.search-table th {
  background: #f8fafc;
  font-weight: 600;
}
.search-table tr:nth-child(even) {
  background: #f3f6fa;
}
</style> 