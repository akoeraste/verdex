<template>
  <DocumentationLayout>
    <div class="documentation-landing">
      <section class="doc-hero">
        <h1>Verdex Documentation</h1>
        <p class="doc-subtitle">Comprehensive guides for the Verdex platform: backend, frontend, API, and integration.</p>
      </section>
      <section class="doc-cards">
        <router-link v-for="item in menu" :key="item.path" :to="item.path" class="doc-card">
          <div class="doc-card-icon"><i :class="item.icon"></i></div>
          <div class="doc-card-content">
            <h2>{{ item.label }}</h2>
            <p>{{ item.desc }}</p>
          </div>
        </router-link>
      </section>
    </div>
  </DocumentationLayout>
</template>

<script setup>
  const menu = [
    {
      label: 'Connect',
      path: '/documentation/connect',
      icon: 'bi bi-link-45deg',
      desc: 'How the backend and frontend communicate, environment setup, and integration best practices.'
    },
    {
      label: 'Backend',
      path: '/documentation/backend',
      icon: 'bi bi-server',
      desc: 'Laravel backend structure, modules, database, authentication, and deployment.'
    },
    {
      label: 'API',
      path: '/documentation/api',
      icon: 'bi bi-code-slash',
      desc: 'REST API endpoints, authentication, error handling, and usage examples.'
    },
    {
      label: 'Frontend',
      path: '/documentation/frontend',
      icon: 'bi bi-phone',
      desc: 'Flutter app structure, navigation, state management, and features.'
    },
  ];

  import { ref } from 'vue';
  import DocumentationLayout from './DocumentationLayout.vue';
  const tab = ref('login');
</script>

<style scoped>
  .documentation-landing {
    min-height: 100vh;
    background: transparent;
    padding-bottom: 40px;
  }
  .doc-hero {
    text-align: center;
    margin: 2rem 0 2.5rem 0;
  }
  .doc-hero h1 {
    font-size: 2.5rem;
    font-weight: 700;
    background: linear-gradient(90deg, #062f27 0%, #43e97b 50%, #062f27 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-fill-color: transparent;
    margin-bottom: 0.5rem;
  }
  .doc-subtitle {
    color: #4a4e69;
    font-size: 1.2rem;
    margin-bottom: 0;
  }
  .doc-cards {
    display: flex;
    justify-content: center;
    gap: 2rem;
    flex-wrap: wrap;
    margin-top: 2rem;
  }
  .doc-card {
    background: #fff;
    border-radius: 1.2rem;
    box-shadow: 0 4px 24px rgba(34,34,59,0.07);
    padding: 2rem 2.5rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-width: 200px;
    max-width: 320px;
    text-align: center;
    text-decoration: none;
    color: #22223b;
    transition: box-shadow 0.2s, transform 0.2s;
  }
  .doc-card:hover {
    box-shadow: 0 8px 32px rgba(67,233,123,0.15);
    transform: translateY(-4px) scale(1.03);
  }
  .doc-card-icon {
    font-size: 2.5rem;
    color: #2e7d32;
    margin-bottom: 1rem;
  }
  .doc-card-content h2 {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
  }
  .doc-card-content p {
    color: #4a4e69;
    font-size: 1rem;
  }
  @media (max-width: 900px) {
    .doc-cards {
      flex-direction: column;
      align-items: center;
    }
  }
  </style> 