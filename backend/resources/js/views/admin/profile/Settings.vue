<template>
  <div class="settings-container">
    <div class="settings-header">
      <h2>Change Password</h2>
    </div>

    <div class="settings-content">
      <form @submit.prevent="submitPasswordChange" class="password-form">
        <div class="form-group">
          <label for="current_password">Current Password</label>
          <input type="password" v-model="passwordForm.current_password" id="current_password" class="form-control" required>
        </div>
        <div class="form-group">
          <label for="new_password">New Password</label>
          <input type="password" v-model="passwordForm.new_password" id="new_password" class="form-control" required>
        </div>
        <div class="form-group">
          <label for="new_password_confirmation">Confirm New Password</label>
          <input type="password" v-model="passwordForm.new_password_confirmation" id="new_password_confirmation" class="form-control" required>
        </div>
        
        <div class="form-actions">
          <button :disabled="isLoading" class="btn-primary">
            <span v-if="isLoading">Saving...</span>
            <span v-else>Change Password</span>
          </button>
        </div>

        <div v-if="validationErrors" class="error-messages">
          <ul>
            <li v-for="(error, key) in validationErrors" :key="key">{{ error[0] }}</li>
          </ul>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue';
import useProfile from "@/composables/profile";

const { changePassword, validationErrors, isLoading } = useProfile();

const passwordForm = reactive({
  current_password: '',
  new_password: '',
  new_password_confirmation: ''
});

const submitPasswordChange = async () => {
  await changePassword(passwordForm);
  if (!validationErrors.value) {
    passwordForm.current_password = '';
    passwordForm.new_password = '';
    passwordForm.new_password_confirmation = '';
  }
};
</script>

<style scoped>
.settings-container {
  padding: 2.5rem;
  max-width: 800px;
  margin: 0 auto;
}

.settings-header h2 {
  font-size: 2rem;
  font-weight: 700;
  color: #22223b;
  margin-bottom: 2rem;
}

.settings-content {
  background: white;
  padding: 2.5rem;
  border-radius: 1rem;
  box-shadow: 0 4px 16px rgba(0,0,0,0.05);
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  font-weight: 600;
  color: #4a5568;
  margin-bottom: 0.5rem;
}

.form-control {
  width: 100%;
  padding: 0.8rem 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.form-control:focus {
  outline: none;
  border-color: #43e97b;
  box-shadow: 0 0 0 2px rgba(67, 233, 123, 0.2);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 2rem;
}

.btn-primary {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  border: none;
  padding: 0.8rem 2rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
  font-size: 1rem;
}

.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.error-messages {
  margin-top: 1rem;
  color: #ef4444;
}
</style> 