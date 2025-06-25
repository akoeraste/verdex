<template>
  <div class="profile-container">
    <div class="profile-header">
      <h2>User Profile</h2>
    </div>

    <div v-if="isLoading" class="loading-container">
      <div class="loading-spinner"></div>
      <p>Loading profile...</p>
    </div>

    <div v-if="profileData" class="profile-content">
      <div class="profile-sidebar">
        <div class="avatar-section">
          <img :src="avatarPreview || profile.avatar_url || 'https://via.placeholder.com/150'" alt="Avatar" class="avatar-image">
          <label for="avatar-upload" class="avatar-upload-label">
            Change Avatar
          </label>
          <input type="file" id="avatar-upload" @change="handleAvatarUpload" accept="image/*" class="avatar-upload-input">
        </div>
        <div class="user-info">
          <h3>{{ profile.username }}</h3>
          <p>{{ profile.email }}</p>
        </div>
      </div>

      <div class="profile-main">
        <form @submit.prevent="submitForm" class="profile-form">
          <div class="form-section">
            <h4>Basic Information</h4>
            <div class="form-grid">
              <div class="form-group">
                <label for="username">Username</label>
                <input type="text" v-model="profile.username" id="username" class="form-control">
                <div class="text-danger mt-1">{{ errors.username }}</div>
              </div>
              <div class="form-group">
                <label for="email">Email</label>
                <input type="email" v-model="profile.email" id="email" class="form-control">
                <div class="text-danger mt-1">{{ errors.email }}</div>
              </div>
              <div class="form-group">
                <label for="language_preference">Language Preference</label>
                <select v-model="profile.language_preference" id="language_preference" class="form-control">
                  <option value="en">English</option>
                  <option value="es">Spanish</option>
                  <option value="fr">French</option>
                  <option value="bn">Bengali</option>
                </select>
              </div>
            </div>
          </div>
          
          <div class="form-actions">
            <button :disabled="isLoading" class="btn-primary">
              <span v-if="isLoading">Saving...</span>
              <span v-else>Save Changes</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, watchEffect, ref } from "vue";
import { useForm, useField, defineRule } from "vee-validate";
import { required, min } from "@/validation/rules"
import useProfile from "@/composables/profile";

defineRule('required', required)
defineRule('min', min);

const schema = {
    username: 'required|min:3',
    email: 'required',
}

const { validate, errors } = useForm({ validationSchema: schema })
const { value: username } = useField('username', null, { initialValue: '' });
const { value: email } = useField('email', null, { initialValue: '' });
const { profile: profileData, getProfile, updateProfile, validationErrors, isLoading } = useProfile()

const profile = reactive({
    username,
    email,
    language_preference: '',
    avatar: null,
    avatar_url: ''
})

const avatarPreview = ref(null);

function handleAvatarUpload(event) {
    const file = event.target.files[0];
    if (file) {
        profile.avatar = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            avatarPreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
}

function submitForm() {
    validate().then(form => {
        if (form.valid) {
            const formData = new FormData();
            formData.append('username', profile.username);
            formData.append('email', profile.email);
            if (profile.language_preference) {
                formData.append('language_preference', profile.language_preference);
            }
            if (profile.avatar) {
                formData.append('avatar', profile.avatar);
            }
            formData.append('_method', 'PUT');
            
            updateProfile(formData).then(() => {
                avatarPreview.value = null; // Clear preview after successful upload
            });
        }
    })
}

onMounted(() => {
    getProfile()
})

watchEffect(() => {
    if (profileData.value) {
        profile.username = profileData.value.username
        profile.email = profileData.value.email
        profile.language_preference = profileData.value.language_preference
        profile.avatar_url = profileData.value.avatar
    }
})
</script>

<style scoped>
.profile-container {
  padding: 2.5rem;
  max-width: 1200px;
  margin: 0 auto;
}

.profile-header {
  margin-bottom: 2rem;
}

.profile-header h2 {
  font-size: 2rem;
  font-weight: 700;
  color: #22223b;
}

.loading-container {
  text-align: center;
  padding: 3rem;
}

.loading-spinner {
  border: 3px solid #f3f3f3;
  border-top: 3px solid #43e97b;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.profile-content {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 2.5rem;
  background: white;
  border-radius: 1rem;
  box-shadow: 0 4px 16px rgba(0,0,0,0.05);
  overflow: hidden;
}

.profile-sidebar {
  padding: 2.5rem;
  background: #f8fafc;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.avatar-section {
  position: relative;
  margin-bottom: 1.5rem;
}

.avatar-image {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid white;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.avatar-upload-label {
  position: absolute;
  bottom: 5px;
  right: 5px;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  transition: all 0.2s;
}

.avatar-upload-label:hover {
    transform: scale(1.1);
}

.avatar-upload-label::before {
    content: '✏️';
    font-size: 1.2rem;
}

.avatar-upload-input {
  display: none;
}

.user-info h3 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #22223b;
  margin-bottom: 0.25rem;
}

.user-info p {
  color: #6b7280;
}

.profile-main {
  padding: 2.5rem;
}

.form-section {
  margin-bottom: 2rem;
}

.form-section h4 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #22223b;
  margin-bottom: 1.5rem;
  border-bottom: 1px solid #e0e0e0;
  padding-bottom: 0.5rem;
}

.form-grid {
  display: grid;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
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

.text-danger {
    font-size: 0.875rem;
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

@media (max-width: 992px) {
    .profile-content {
        grid-template-columns: 1fr;
    }
    .profile-sidebar {
        border-bottom: 1px solid #e0e0e0;
    }
}
</style>
