<template>
  <nav class="sidebar2025">
    <div class="sidebar-inner">
      <ul id="menu" class="sidebar-menu">
        <li>
          <router-link to="/admin" class="sidebar-link" active-class="active">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
          </router-link>
        </li>
        <li v-if="can('user-list')">
          <router-link to="/admin/users" class="sidebar-link" active-class="active">
            <i class="bi bi-people"></i>
            <span>Users</span>
          </router-link>
        </li>
        <li v-if="can('role-list')">
          <router-link to="/admin/roles" class="sidebar-link" active-class="active">
            <i class="bi bi-person-badge"></i>
            <span>Roles</span>
          </router-link>
        </li>
        <li v-if="can('permission-list')">
          <router-link to="/admin/permissions" class="sidebar-link" active-class="active">
            <i class="bi bi-shield-lock"></i>
            <span>Permissions</span>
          </router-link>
        </li>
        <li v-if="can('post-list')">
          <router-link to="/admin/posts" class="sidebar-link" active-class="active">
            <i class="bi bi-file-earmark-text"></i>
            <span>Posts</span>
          </router-link>
        </li>
        <li v-if="can('category-list')">
          <router-link to="/admin/categories" class="sidebar-link" active-class="active">
            <i class="bi bi-tags"></i>
            <span>Categories</span>
          </router-link>
        </li>
        <li>
          <router-link to="/admin/browser-sessions" class="sidebar-link" active-class="active">
            <i class="bi bi-browser-chrome"></i>
            <span>Browser Sessions</span>
          </router-link>
        </li>
        <li>
          <router-link to="/admin/activity_log" class="sidebar-link" active-class="active">
            <i class="bi bi-clipboard-data"></i>
            <span>Activity Logs</span>
          </router-link>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import {useAbility} from '@casl/vue'
const {can} = useAbility();
</script>

<style scoped>
.sidebar2025 {
  min-width: 230px;
  max-width: 230px;
  height: 100vh;
  background: linear-gradient(135deg, #e3f2fd 0%, #f8fafc 100%);
  border-radius: 1.5rem 0 0 1.5rem;
  box-shadow: 2px 0 24px rgba(67,233,123,0.07);
  display: flex;
  flex-direction: column;
  align-items: stretch;
  padding: 2rem 0.5rem 2rem 0.5rem;
}
.sidebar-inner {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: stretch;
}
.sidebar-menu {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.9rem 1.2rem;
  border-radius: 1rem;
  color: #22223b;
  font-weight: 600;
  font-size: 1.08rem;
  text-decoration: none;
  transition: background 0.18s, color 0.18s, box-shadow 0.18s;
}
.sidebar-link i {
  font-size: 1.4rem;
  color: #43e97b;
  transition: color 0.18s;
}
.sidebar-link.active, .sidebar-link:hover {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  box-shadow: 0 2px 12px rgba(67,233,123,0.10);
}
.sidebar-link.active i, .sidebar-link:hover i {
  color: #fff;
}
.sidebar-link span {
  flex: 1;
  white-space: nowrap;
}
@media (max-width: 900px) {
  .sidebar2025 {
    min-width: 60px;
    max-width: 60px;
    padding: 1rem 0.2rem 1rem 0.2rem;
  }
  .sidebar-link span {
    display: none;
  }
}
</style>
