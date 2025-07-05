<template>
  <div class="doc-layout">
    <!-- Modern floating navigation bar -->
    <nav class="doc-navbar">
      <div class="nav-container">
        <div class="nav-brand">
          <router-link to="/documentation" class="brand-link">
            <img src="/logo.png" alt="Verdex Logo" class="brand-logo" />
            <span class="brand-text">Verdex Docs</span>
          </router-link>
        </div>
        <div class="nav-menu">

          <!-- Overview Section -->
          <router-link to="/documentation/" class="nav-link">
            <i class="bi bi-info-circle"></i>
            <span>Overview</span>
          </router-link>
          <!-- ML Section -->
          <router-link to="/documentation/ml" class="nav-link">
            <i class="bi bi-cpu"></i>
            <span>ML</span>
          </router-link>

          <!-- Frontend Section -->
          <div class="nav-dropdown">
            <button class="nav-dropdown-btn" @click="toggleDropdown('frontend')">
              <i class="bi bi-phone"></i>
              <span>Frontend</span>
              <i class="bi bi-chevron-down dropdown-arrow"></i>
            </button>
            <div class="nav-dropdown-menu" :class="{ open: openDropdown === 'frontend' }">
              <router-link to="/documentation/frontend" class="dropdown-item">
                <i class="bi bi-phone"></i>
                <span>Frontend</span>
              </router-link>
              <router-link to="/documentation/connect" class="dropdown-item">
                <i class="bi bi-link-45deg"></i>
                <span>Connect</span>
              </router-link>
            </div>
          </div>

          <!-- Backend Section -->
          <div class="nav-dropdown">
            <button class="nav-dropdown-btn" @click="toggleDropdown('backend')">
              <i class="bi bi-server"></i>
              <span>Backend</span>
              <i class="bi bi-chevron-down dropdown-arrow"></i>
            </button>
            <div class="nav-dropdown-menu" :class="{ open: openDropdown === 'backend' }">
              <router-link to="/documentation/backend" class="dropdown-item">
                <i class="bi bi-server"></i>
                <span>Backend</span>
              </router-link>
              <router-link to="/documentation/api" class="dropdown-item">
                <i class="bi bi-code-slash"></i>
                <span>API</span>
              </router-link>
            </div>
          </div>

          <!-- Project Structure Section -->
          <router-link to="/documentation/project-structure" class="nav-link">
            <i class="bi bi-diagram-3"></i>
            <span>Project Structure</span>
          </router-link>

        </div>
        <div class="nav-actions">
          <button v-if="sidebarSections.length" class="mobile-menu-toggle" @click="sidebarOpen = !sidebarOpen">
            <i class="bi bi-list"></i>
          </button>
          <router-link to="/" class="login-btn">
            <i class="bi bi-person-circle"></i>
            <span>Home</span>
          </router-link>
        </div>
      </div>
    </nav>

    <!-- Main content area -->
    <div class="doc-main">
      <!-- Sidebar navigation -->
      <aside v-if="sidebarSections.length" class="doc-sidebar" :class="{ open: sidebarOpen }">
        <div class="sidebar-header">
          <h3 class="sidebar-title">Navigation</h3>
          <button class="sidebar-toggle" @click="sidebarOpen = !sidebarOpen">
            <i :class="sidebarOpen ? 'bi bi-x-lg' : 'bi bi-list'" />
          </button>
        </div>
        <nav class="sidebar-nav">
          <div v-for="section in sidebarSections" :key="section.id" class="sidebar-section">
            <h4 class="section-title">{{ section.title }}</h4>
            <ul class="section-links">
              <li v-for="item in section.items" :key="item.id">
                <a :href="'#' + item.id" @click="sidebarOpen = false" class="section-link">
                  {{ item.label }}
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </aside>

      <!-- Main content -->
      <main class="doc-content">
        <div class="content-wrapper">
          <slot />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const sidebarOpen = ref(false);
const openDropdown = ref(null);

const toggleDropdown = (dropdown) => {
  if (openDropdown.value === dropdown) {
    openDropdown.value = null;
  } else {
    openDropdown.value = dropdown;
  }
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest('.nav-dropdown')) {
    openDropdown.value = null;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});

const sidebarSections = computed(() => {
  return route.meta.sidebarSections || [];
});
</script>

<style scoped>
/* Global styles */
.doc-layout {
  min-height: 100vh;
  background: linear-gradient(135deg, #e1e6fc 0%, #f4ebfc 100%);
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Modern Navigation Bar */
.doc-navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 32px rgba(0, 0, 0, 0.08);
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
}

.nav-brand {
  display: flex;
  align-items: center;
}

.brand-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
  color: #1a1a1a;
  font-weight: 700;
  font-size: 1.25rem;
  transition: transform 0.2s ease;
}

.brand-link:hover {
  transform: translateY(-1px);
}

.brand-logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  object-fit: contain;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
}

.brand-text {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* Dropdown Navigation */
.nav-dropdown {
  position: relative;
}

.nav-dropdown-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  color: #4a5568;
  background: none;
  border: none;
  font-weight: 500;
  font-size: 0.95rem;
  border-radius: 12px;
  transition: all 0.2s ease;
  cursor: pointer;
  font-family: inherit;
}

.nav-dropdown-btn:hover {
  color: #667eea;
  background: rgba(102, 126, 234, 0.08);
  transform: translateY(-1px);
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  border-radius: 12px;
  transition: all 0.2s ease;
}

.nav-link:hover {
  color: #667eea;
  background: rgba(102, 126, 234, 0.08);
  transform: translateY(-1px);
}

.nav-link.router-link-active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.12);
  font-weight: 600;
}

.nav-dropdown-btn i {
  font-size: 1.1rem;
}

.dropdown-arrow {
  transition: transform 0.2s ease;
  font-size: 0.8rem;
}

.nav-dropdown:hover .dropdown-arrow,
.nav-dropdown-menu.open + .nav-dropdown-btn .dropdown-arrow {
  transform: rotate(180deg);
}

.nav-dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 200px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  opacity: 0;
  visibility: hidden;
  transform: translateY(-8px);
  transition: all 0.2s ease;
  z-index: 1001;
  margin-top: 0.5rem;
}

.nav-dropdown-menu.open {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.25rem;
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.dropdown-item:last-child {
  border-bottom: none;
}

.dropdown-item:hover {
  color: #667eea;
  background: rgba(102, 126, 234, 0.08);
}

.dropdown-item.router-link-active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.12);
  font-weight: 600;
}

.dropdown-item i {
  font-size: 1.1rem;
  width: 16px;
  text-align: center;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.mobile-menu-toggle {
  display: none;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background: rgba(102, 126, 234, 0.1);
  border: none;
  border-radius: 10px;
  color: #667eea;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 1.2rem;
}

.mobile-menu-toggle:hover {
  background: rgba(102, 126, 234, 0.2);
  transform: translateY(-1px);
}

.login-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.95rem;
  border-radius: 12px;
  transition: all 0.2s ease;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
  color: white;
}

/* Main content area */
.doc-main {
  display: flex;
  min-height: calc(100vh - 70px);
  margin-top: 70px;
}

/* Sidebar */
.doc-sidebar {
  width: 280px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  overflow-y: auto;
  position: fixed;
  top: 70px;
  left: 0;
  height: calc(100vh - 70px);
  z-index: 100;
  transition: transform 0.3s ease;
}

/* Hide sidebar toggle on desktop */
.sidebar-toggle {
  display: none;
}

.sidebar-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

.sidebar-title {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0;
}

.sidebar-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background: rgba(102, 126, 234, 0.1);
  border: none;
  border-radius: 8px;
  color: #667eea;
  cursor: pointer;
  transition: all 0.2s ease;
}

.sidebar-toggle:hover {
  background: rgba(102, 126, 234, 0.2);
}

.sidebar-nav {
  padding: 1.5rem;
}

.sidebar-section {
  margin-bottom: 2rem;
}

.sidebar-section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: #667eea;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin: 0 0 1rem 0;
}

.section-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.section-link {
  display: block;
  padding: 0.75rem 1rem;
  color: #4a5568;
  text-decoration: none;
  font-size: 0.95rem;
  border-radius: 8px;
  transition: all 0.2s ease;
  margin-bottom: 0.25rem;
}

.section-link:hover {
  color: #667eea;
  background: rgba(102, 126, 234, 0.08);
}

/* Main content */
.doc-content {
  flex: 1;
  margin-left: 280px;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  border-radius: 20px 0 0 0;
  margin-top: 1rem;
  margin-right: 1rem;
  min-height: calc(100vh - 90px);
}

.content-wrapper {
  max-width: 800px;
  margin: 0 auto;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .doc-sidebar {
    transform: translateX(-100%);
  }
  
  .doc-sidebar.open {
    transform: translateX(0);
  }
  
  .doc-content {
    margin-left: 0;
  }
  
  .sidebar-toggle {
    display: flex;
  }
}

@media (max-width: 768px) {
  .nav-container {
    padding: 0 1rem;
  }
  
  .nav-menu {
    display: none;
  }
  
  .brand-text {
    display: none;
  }
  
  .mobile-menu-toggle {
    display: flex;
  }
  
  .doc-content {
    padding: 1.5rem;
    margin: 0.5rem;
    border-radius: 16px;
  }
  
  .content-wrapper {
    max-width: none;
  }
}

@media (max-width: 480px) {
  .doc-content {
    padding: 1rem;
    margin: 0.25rem;
  }
}
</style> 