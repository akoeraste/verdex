<template>
  <nav class="sidebar2025">
    <div class="sidebar-inner">
      <ul id="menu" class="sidebar-menu">
        <!-- Dashboard -->
        <li>
          <router-link to="/admin" class="sidebar-link" active-class="active">
            <span>Dashboard</span>
          </router-link>
        </li>
        <!-- Plant Management -->
        <li>
          <div class="sidebar-section" @click="toggle('plant')">
            <span>Plant Management</span>
            <span class="chevron">{{ open === 'plant' ? '▲' : '▼' }}</span>
          </div>
          <ul v-show="open === 'plant'" class="sidebar-dropdown">
            <li v-if="can('plant-list')">
              <router-link to="/admin/plants" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/plants') }">
                <span class="icon-wrap">🌿</span>
                <span>Plants</span>
              </router-link>
            </li>
            <li>
              <router-link to="/admin/plant-categories" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/plant-categories') }">
                <span class="icon-wrap">📁</span>
                <span>Plant Categories</span>
              </router-link>
            </li>
            <li>
              <router-link to="/admin/plant-translations" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/plant-translations') }">
                <span class="icon-wrap">🌍</span>
                <span>Translations</span>
              </router-link>
            </li>
          </ul>
        </li>
        <!-- User Management -->
        <li>
          <div class="sidebar-section" @click="toggle('user')">
            <span>User Management</span>
            <span class="chevron">{{ open === 'user' ? '▲' : '▼' }}</span>
          </div>
          <ul v-show="open === 'user'" class="sidebar-dropdown">
            <li v-if="can('user-list')">
              <router-link to="/admin/users" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/users') }">
                <span class="icon-wrap">👤</span>
                <span>Users</span>
              </router-link>
            </li>
            <li v-if="can('role-list') || can('permission-list')">
              <router-link to="/admin/roles" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/roles') }">
                <span class="icon-wrap">🧑‍💼</span>
                <span>Roles</span>
              </router-link>
            </li>
            <li v-if="can('role-list') || can('permission-list')">
              <router-link to="/admin/permissions" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/permissions') }">
                <span class="icon-wrap">🧑‍💼</span>
                <span>Permissions</span>
              </router-link>
            </li>
          </ul>
        </li>
        <!-- Settings -->
        <li>
          <div class="sidebar-section" @click="toggle('settings')">
            <span>Settings</span>
            <span class="chevron">{{ open === 'settings' ? '▲' : '▼' }}</span>
          </div>
          <ul v-show="open === 'settings'" class="sidebar-dropdown">
            <li>
              <router-link to="/admin/languages" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/languages') }">
                <span class="icon-wrap">🌐</span>
                <span>Languages</span>
              </router-link>
            </li>
            <li>
              <router-link to="/admin/backup" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/backup') }">
                <span class="icon-wrap">📦</span>
                <span>Backup & Restore</span>
              </router-link>
            </li>
          </ul>
        </li>
        <!-- Analytics -->
        <li>
          <div class="sidebar-section" @click="toggle('analytics')">
            <span>Analytics</span>
            <span class="chevron">{{ open === 'analytics' ? '▲' : '▼' }}</span>
          </div>
          <ul v-show="open === 'analytics'" class="sidebar-dropdown">
            <li>
              <router-link to="/admin/usage-stats" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/usage-stats') }">
                <span class="icon-wrap">📈</span>
                <span>Usage Stats</span>
              </router-link>
            </li>
            <li>
              <router-link to="/admin/search-trends" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/search-trends') }">
                <span class="icon-wrap">🔎</span>
                <span>Search Trends</span>
              </router-link>
            </li>
            <li>
              <router-link to="/admin/activity-log-logs" class="sidebar-link" :class="{ active: route.path.startsWith('/admin/activity-log-logs') }">
                <span class="icon-wrap">📝</span>
                <span>Activity Log</span>
              </router-link>
            </li>
          </ul>
        </li>
        <!-- Documentation -->
        <li>
          <div class="sidebar-section" @click="toggle('documentation')">
            <span>Documentation</span>
            <span class="chevron">{{ open === 'documentation' ? '▲' : '▼' }}</span>
          </div>
          <ul v-show="open === 'documentation'" class="sidebar-dropdown">
            <li>
              <router-link to="/documentation" class="sidebar-link" :class="{ active: route.path === '/documentation' }">
                <span class="icon-wrap">📚</span>
                <span>Overview</span>
              </router-link>
            </li>
            <li>
              <router-link to="/documentation/connect" class="sidebar-link" :class="{ active: route.path.startsWith('/documentation/connect') }">
                <span class="icon-wrap">🔗</span>
                <span>Connect</span>
              </router-link>
            </li>
            <li>
              <router-link to="/documentation/backend" class="sidebar-link" :class="{ active: route.path.startsWith('/documentation/backend') }">
                <span class="icon-wrap">⚙️</span>
                <span>Backend</span>
              </router-link>
            </li>
            <li>
              <router-link to="/documentation/api" class="sidebar-link" :class="{ active: route.path.startsWith('/documentation/api') }">
                <span class="icon-wrap">🔌</span>
                <span>API</span>
              </router-link>
            </li>
            <li>
              <router-link to="/documentation/frontend" class="sidebar-link" :class="{ active: route.path.startsWith('/documentation/frontend') }">
                <span class="icon-wrap">📱</span>
                <span>Frontend</span>
              </router-link>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useAbility } from '@casl/vue';
const { can } = useAbility();
const route = useRoute();
const open = ref(null);

function toggle(section) {
  open.value = open.value === section ? null : section;
}

const setOpenSection = (path) => {
  if (path.startsWith('/admin/plants') || path.startsWith('/admin/plant-categories') || path.startsWith('/admin/plant-translations')) {
    open.value = 'plant';
  } else if (path.startsWith('/admin/users') || path.startsWith('/admin/roles') || path.startsWith('/admin/permissions')) {
    open.value = 'user';
  } else if (path.startsWith('/admin/languages') || path.startsWith('/admin/backup')) {
    open.value = 'settings';
  } else if (path.startsWith('/admin/usage-stats') || path.startsWith('/admin/search-trends') || path.startsWith('/admin/activity-log-logs')) {
    open.value = 'analytics';
  } else if (path.startsWith('/documentation')) {
    open.value = 'documentation';
  }
};

watch(() => route.path, (newPath) => {
  setOpenSection(newPath);
});

onMounted(() => {
  setOpenSection(route.path);
});
</script>

<style scoped>
.sidebar2025 {
  min-width: 220px;
  max-width: 400px;
  width: 400px;
  height: 100vh;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(10px) saturate(1.5);
  border-right: 1px solid #e0e0e0;
  display: flex;
  flex-direction: column;
  padding: 1.4rem 0.6rem;
  font-family: 'Inter', sans-serif;
}

.sidebar-inner {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.sidebar-menu {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.sidebar-link {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  padding: 0.55rem 1rem;
  border-radius: 0.8rem;
  color: #374151;
  font-weight: 500;
  font-size: 1.02rem;
  text-decoration: none;
  transition: all 0.15s ease;
}

.sidebar-link .icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.1rem;
  height: 2.1rem;
  border-radius: 0.6rem;
  background: #f0fdf4;
  color: #15803d;
  font-size: 1.2rem;
  transition: all 0.15s ease;
}

.sidebar-link:hover {
  background: #ecfdf5;
  color: #166534;
}

.sidebar-link:hover .icon-wrap {
  background: #d1fae5;
}

.sidebar-link.active {
  background: #d1fae5;
  color: #166534;
  font-weight: 600;
  box-shadow: inset 0 0 0 1px #34d399;
}

.sidebar-section {
  display: flex;
  align-items: center;
  font-size: 1.1rem;
  font-weight: 600;
  color: #065f46;
  padding: 0.4rem 0.9rem;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.sidebar-section:hover {
  background-color: #f0fdf4;
}

.chevron {
  margin-left: auto;
  font-size: 1rem;
  color: #a7f3d0;
  transition: transform 0.2s ease;
}

.sidebar-dropdown {
  padding-left: 1.8rem;
  display: grid;
  grid-auto-rows: 1fr;
  gap: 0.3rem;
  transition: max-height 0.2s ease-in-out;
  overflow: hidden;
}

.sidebar-dropdown li {
  list-style: none;
}

.sidebar-dropdown[style*="display: none"] {
  max-height: 0;
}

.sidebar-dropdown[style*="display: block"] {
  max-height: 600px;
}

@media (max-width: 900px) {
  .sidebar2025 {
    max-width: 56px;
    min-width: 56px;
    padding: 0.4rem;
  }

  .sidebar-link span,
  .sidebar-section span,
  .chevron {
    display: none;
  }

  .sidebar-section {
    padding: 0.4rem;
  }

  .sidebar-link .icon-wrap {
    margin-right: 0;
  }
}

</style>
