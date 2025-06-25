<template>
  <nav class="navbar2025">
    <div class="navbar-inner">
      <div class="navbar-brand-wrap">
        <router-link to="/admin" class="navbar-brand2025">
          <img src="/logo.png" alt="Logo" class="navbar-logo" />
          <span>Verdex Admin</span>
        </router-link>
      </div>
      <div class="navbar-actions">
        <div class="navbar-user" @click="toggleDropdown">
          <span class="navbar-user-greet clickable">Hi, {{ username }}</span>
          <button class="navbar-dropdown-btn" :aria-expanded="showDropdown">&#x25BC;</button>
          <div class="navbar-dropdown-menu" v-show="showDropdown">
            <router-link :to="{ name: 'profile.index' }" class="navbar-dropdown-item">Profile</router-link>
            <a class="navbar-dropdown-item" href="#">Setting</a>
            <div class="navbar-dropdown-divider"></div>
            <a class="navbar-dropdown-item" :class="{ 'opacity-25': processing }" :disabled="processing" href="javascript:void(0)" @click="logout">Logout</a>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import {computed, ref} from "vue";
import useAuth from "@/composables/auth";
import {useAuthStore} from "@/store/auth";

const auth = useAuthStore()
const user = computed(() => auth.user)
const {processing, logout} = useAuth();

// Computed property for username with fallback
const username = computed(() => {
    if (user.value && user.value.username) {
        return user.value.username;
    }
    if (user.value && user.value.name) {
        return user.value.name;
    }
    if (user.value && user.value.email) {
        return user.value.email.split('@')[0]; // Use email prefix as fallback
    }
    return 'User'; // Final fallback
});

// Dropdown logic
const showDropdown = ref(false);
function toggleDropdown() { showDropdown.value = !showDropdown.value; }
</script>

<style scoped>
.navbar2025 {
  width: 100%;
  background: linear-gradient(135deg, #e3f2fd 0%, #f8fafc 100%);
  border-radius: 0 0 1.5rem 1.5rem;
  box-shadow: 0 2px 16px rgba(67,233,123,0.07);
  padding: 0.7rem 0;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: sticky;
  top: 0;
  z-index: 100;
}
.navbar-inner {
  width: 100%;
  max-width: 1400px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 2rem;
}
.navbar-brand-wrap {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}
.navbar-brand2025 {
  display: flex;
  align-items: center;
  gap: 1rem;
  text-decoration: none;
}
.navbar-logo {
  width: 38px;
  height: 38px;
  border-radius: 0.7rem;
  object-fit: contain;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  background-color: #22223b;
}
.navbar-brand2025 span {
  font-size: 1.5rem;
  font-weight: 700;
  color: #22223b;
  letter-spacing: 0.01em;
}
.navbar-actions {
  display: flex;
  align-items: center;
  gap: 2rem;
  margin-left: auto;
}
.navbar-user {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.7rem;
  cursor: pointer;
  margin-right: 0.5rem;
}
.navbar-user-greet {
  font-weight: 600;
  color: #4a4e69;
  font-size: 1.1rem;
}
.clickable {
  cursor: pointer;
}
.navbar-dropdown-btn {
  cursor: pointer;
  background: none;
  border: none;
  font-size: 1.1rem;
  color: #43e97b;
  padding: 0 0.3rem;
  border-radius: 0.5rem;
  transition: background 0.18s;
}
.navbar-dropdown-btn:hover {
  background: #e3f2fd;
}
.navbar-dropdown-menu {
  display: block;
  position: absolute;
  right: 0;
  top: 2.2rem;
  min-width: 160px;
  background: #fff;
  border-radius: 1rem;
  box-shadow: 0 4px 24px rgba(67,233,123,0.10);
  padding: 0.7rem 0;
  z-index: 10;
  margin-right: 0.2rem;
}
.navbar-dropdown-item {
  display: block;
  padding: 0.7rem 1.2rem;
  color: #22223b;
  text-decoration: none;
  font-weight: 500;
  font-size: 1.05rem;
  border: none;
  background: none;
  transition: background 0.18s, color 0.18s;
  cursor: pointer;
}
.navbar-dropdown-item:hover {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
}
.navbar-dropdown-divider {
  height: 1px;
  background: #e3f2fd;
  margin: 0.3rem 0;
}
@media (max-width: 900px) {
  .navbar-inner {
    padding: 0 0.5rem;
  }
  .navbar-brand2025 span {
    font-size: 1.1rem;
  }
}
</style>
