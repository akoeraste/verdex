<template>
  <div class="doc-layout">
    <nav class="doc-navbar floating-navbar">
      <div class="doc-navbar-center">
        <router-link v-for="item in menu" :key="item.path" :to="item.path" class="doc-navbar-link">
          <i :class="item.icon" style="margin-right: 8px;"></i>{{ item.label }}
        </router-link>
      </div>
    </nav>
    <div class="doc-main">
      <aside v-if="sidebarSections.length" class="doc-sidebar" :class="{ open: sidebarOpen }">
        <button class="sidebar-toggle" @click="sidebarOpen = !sidebarOpen">
          <i :class="sidebarOpen ? 'bi bi-x-lg' : 'bi bi-list'" />
        </button>
        <nav class="sidebar-nav">
          <div v-for="section in sidebarSections" :key="section.id" class="sidebar-section">
            <div class="sidebar-section-title">VERDEX</div>
            <div class="sidebar-section-title">{{ section.title }}</div>
            <ul>
              <li v-for="item in section.items" :key="item.id">
                <a :href="'#' + item.id" @click="sidebarOpen = false">{{ item.label }}</a>
              </li>
            </ul>
          </div>
        </nav>
      </aside>
      <main class="doc-content static-sidebar">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute } from 'vue-router';

const menu = [
  { label: 'Verdex', path: '/documentation/', icon: 'bi bi-link-45deg' },
  { label: 'Connect', path: '/documentation/connect', icon: 'bi bi-link-45deg' },
  { label: 'Backend', path: '/documentation/backend', icon: 'bi bi-server' },
  { label: 'API', path: '/documentation/api', icon: 'bi bi-code-slash' },
  { label: 'Frontend', path: '/documentation/frontend', icon: 'bi bi-phone' },
  { label: 'Login', path: '/login', icon: 'bi bi-phone' },
];

const route = useRoute();
const sidebarOpen = ref(false);

// Sidebar sections are provided by each doc page via a prop or inject
const sidebarSections = computed(() => {
  // This will be injected or set by the child page
  return route.meta.sidebarSections || [];
});
</script>

<style scoped>
body {
  min-height: 100vh;
  background: linear-gradient(120deg, #f8fafc 0%, #e3f2fd 100%);
  position: relative;
}
.floating-navbar {
  position: fixed;
  top: 2.5rem;
  left: 50%;
  transform: translateX(-50%);
  width: auto;
  max-width: 1100px;
  z-index: 100;
  border-radius: 2rem;
  background: linear-gradient(90deg, #464848 0%, #076423 100%);
  backdrop-filter: blur(12px) saturate(1.3);
  box-shadow:
    0 8px 32px 0 rgba(67, 233, 123, 0.18),
    0 1.5px 8px rgba(34, 34, 59, 0.10),
    0 0 0 4px #fa8bff33,
    0 0 0 8px #2bd2ff22,
    0 0 32px 0 #43e97b44;
  border: none;
  padding: 0.8rem 0;
  margin-bottom: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: box-shadow 0.2s, background 0.2s;
}
.doc-navbar {
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  box-shadow: none;
  border: solid 1px black;
  margin-bottom: 0;
  padding: 10px;
  display: flex;
  align-items: center;
  gap: 2rem;
}
.doc-navbar-appname {
  font-size: 1.5rem;
  font-weight: 800;
  letter-spacing: 0.04em;
  color: #fff;
  margin-right: 2.5rem;
  padding: 0.3rem 1.2rem;
  border-radius: 1.2rem;
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  box-shadow: 0 2px 12px #43e97b33;
  user-select: none;
  transition: background 0.18s, color 0.18s;
}
.doc-navbar-center {
  display: flex;
  justify-content: center;
  gap: 2.5rem;
}
.doc-navbar-link {
  color: #22223b;
  font-weight: 600;
  font-size: 1.1rem;
  text-decoration: none;
  padding: 0.5rem 2rem;
  border-radius: 1.2rem;
  transition: background 0.18s, color 0.18s, box-shadow 0.18s;
  position: relative;
}
.doc-navbar-link.router-link-exact-active,
.doc-navbar-link:hover {
  background: linear-gradient(90deg, #d3ebe871 0%, #d3ebe871 100%);
  color: #000000;
  box-shadow: 0 2px 12px #00000033, 0 1px 4px #09b1dfa4;
}
.doc-main {
  display: flex;
  min-height: 80vh;
  margin-top: 7.5rem; /* space for floating navbar */
  max-width: 1400px;
  margin-left: auto;
  margin-right: auto;
}
.doc-sidebar {
  width: 260px;
  background: rgba(255,255,255,0.98);
  border-radius: 1.5rem;
  margin-top: 0.1rem;
  margin-left: 0.5rem;
  margin-bottom: 0.5rem;
  box-shadow: 0 4px 24px 0 #43e97b22, 0 1.5px 8px #2bd2ff11;
  padding: 2rem 1.2rem 2rem 1.2rem;
  position: sticky;
  top: 1.5rem;
  height: fit-content;
  min-height: 60vh;
  transition: box-shadow 0.2s, background 0.2s;
  display: flex;
  flex-direction: column;
}
.sidebar-toggle {
  display: none;
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #2e7d32;
  cursor: pointer;
}
.sidebar-nav {
  margin-top: 2rem;
}
.sidebar-section {
  margin-bottom: 2rem;
}
.sidebar-section-title {
  font-weight: 600;
  color: #2e7d32;
  margin-bottom: 0.5rem;
  font-size: 1.1rem;
}
.sidebar-section-title2 {
  font-weight: 900;
  color: #2e7d32;
  margin-bottom: 1rem;
  font-size: 2.1rem;
}
.sidebar-section ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.sidebar-section li {
  margin-bottom: 0.5rem;
}
.sidebar-section a {
  color: #22223b;
  text-decoration: none;
  font-size: 1rem;
  border-radius: 0.7rem;
  padding: 0.2rem 0.7rem;
  display: inline-block;
  transition: color 0.15s, background 0.15s;
}
.sidebar-section a:hover {
  color: #0c0c0c;
  font-weight: 600;
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
}
.doc-content.static-sidebar {
  flex: 1;
  padding: 2.5rem 2rem 2rem 2rem;
  max-width: 100vw;
  overflow-x: auto;
  min-height: calc(100vh - 7.5rem);
  overflow-y: auto;
  background: transparent;
  border-radius: 1.5rem;
  margin: 0.5rem 0.5rem 0.5rem 0.5rem;
  box-shadow: 0 2px 12px #fa8bff11;
}
@media (max-width: 1200px) {
  .doc-main {
    flex-direction: column;
    margin-top: 8.5rem;
    max-width: 100vw;
  }
  .doc-sidebar {
    width: 100vw;
    border-radius: 1.5rem;
    margin: 0.5rem 0.5rem 0 0.5rem;
    position: static;
    top: unset;
    box-shadow: 0 2px 12px #43e97b22;
    min-height: unset;
    height: auto;
    flex-direction: row;
    overflow-x: auto;
    padding: 1.2rem 0.5rem;
  }
  .sidebar-nav {
    margin-top: 0;
    display: flex;
    flex-direction: row;
    gap: 2rem;
  }
  .sidebar-section {
    margin-bottom: 0;
    margin-right: 2rem;
  }
}
@media (max-width: 700px) {
  .floating-navbar {
    width: 98vw;
    max-width: 98vw;
    top: 1rem;
    border-radius: 1.1rem;
    padding: 0.5rem 0.2rem;
  }
  .doc-main {
    margin-top: 4.5rem;
  }
  .doc-sidebar {
    border-radius: 1.1rem;
    margin: 0.2rem 0.2rem 0 0.2rem;
    padding: 0.7rem 0.2rem;
  }
  .doc-content.static-sidebar {
    padding: 1.2rem 0.5rem 1rem 0.5rem;
    border-radius: 1.1rem;
    margin: 0.2rem 0.2rem 0.2rem 0.2rem;
  }
  .doc-navbar-appname {
    font-size: 1.1rem;
    margin-right: 1rem;
    padding: 0.2rem 0.7rem;
  }
}
</style> 