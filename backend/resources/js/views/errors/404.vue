<template>
  <div class="error-bg">
    <div class="error-card">
      <div class="error-icon">🚫</div>
      <h1 class="error-title">404</h1>
      <p class="error-message">Oops! Page not found.</p>
      <p class="error-desc">The page you're looking for doesn't exist or has been moved.</p>
      <p class="error-redirect">Redirecting to home page in 10 seconds...</p>
      <router-link to="/" class="error-btn">Go Home</router-link>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';
const router = useRouter();
onMounted(() => {
  setTimeout(() => {
    router.push('/');
  }, 10000);
});
</script>

<style scoped>
.error-bg {
  min-height: 100vh;
  background: linear-gradient(120deg, #e3f2fd 0%, #f8fafc 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.error-card {
  background: #fff;
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(67,233,123,0.10), 0 1.5px 8px rgba(34,34,59,0.07);
  padding: 3rem 2.5rem 2.5rem 2.5rem;
  max-width: 400px;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}
.error-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}
.error-title {
  font-size: 4rem;
  font-weight: 800;
  color: #43e97b;
  margin-bottom: 0.5rem;
  letter-spacing: 0.05em;
}
.error-message {
  font-size: 1.5rem;
  font-weight: 600;
  color: #22223b;
  margin-bottom: 0.5rem;
}
.error-desc {
  color: #4a4e69;
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
}
.error-redirect {
  color: #a18cd1;
  font-size: 1rem;
  margin-bottom: 1.5rem;
}
.error-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 0.9rem 2.2rem;
  border-radius: 2rem;
  font-weight: 700;
  font-size: 1.1rem;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  transition: background 0.2s, box-shadow 0.2s;
  display: inline-block;
}
.error-btn:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  box-shadow: 0 4px 16px rgba(250,139,255,0.15);
}
@media (max-width: 600px) {
  .error-card {
    padding: 2rem 1rem 1.5rem 1rem;
    max-width: 98vw;
  }
  .error-title {
    font-size: 2.5rem;
  }
}
</style>
