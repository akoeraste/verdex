<template>
  <main class="backup-content">
    <h1>Backup & Restore</h1>
    <p>Click the button below to download a backup of the database (SQL file).</p>
    <button :disabled="loading" @click="downloadBackup">
      <span v-if="loading">Preparing backup...</span>
      <span v-else>Download Database Backup</span>
    </button>
  </main>
</template>

<script setup>
import { ref } from 'vue';

const loading = ref(false);

function downloadBackup() {
  loading.value = true;
  fetch('/api/backup/download', {
    method: 'GET',
    headers: {
      'Accept': 'application/octet-stream',
    },
  })
    .then(async response => {
      if (!response.ok) throw new Error('Backup failed');
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'verdex-backup.sql';
      document.body.appendChild(a);
      a.click();
      a.remove();
      window.URL.revokeObjectURL(url);
    })
    .catch(() => alert('Failed to download backup.'))
    .finally(() => loading.value = false);
}
</script>

<style scoped>
.backup-content {
  max-width: 600px;
  margin: 2rem auto;
  padding: 2rem;
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 4px 24px rgba(34,34,59,0.07);
  text-align: center;
}
button {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 1rem 2.5rem;
  border: none;
  border-radius: 2rem;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  margin-top: 2rem;
  transition: background 0.2s;
}
button:disabled {
  background: #ccc;
  cursor: not-allowed;
}
</style> 