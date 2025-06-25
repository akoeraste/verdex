<template>
  <div class="modern-form-container">
    <div class="modern-form-card">
      <h2 class="modern-form-title">Edit User</h2>
      <form @submit.prevent="submitForm" class="modern-form">
        <div class="modern-form-group">
          <label for="username" class="modern-form-label">Username</label>
          <input v-model="user.username" id="username" type="text" class="modern-form-input">
          <div class="modern-form-error" v-if="errors.username">{{ errors.username }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.username" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-group">
          <label for="email" class="modern-form-label">Email</label>
          <input v-model="user.email" id="email" type="email" class="modern-form-input">
          <div class="modern-form-error" v-if="errors.email">{{ errors.email }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.email" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-group">
          <label for="password" class="modern-form-label">Password</label>
          <input v-model="user.password" id="password" type="password" class="modern-form-input">
          <div class="modern-form-error" v-if="errors.password">{{ errors.password }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.password" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-group">
          <label for="language_preference" class="modern-form-label">Language</label>
          <select v-model="user.language_preference" id="language_preference" class="modern-form-input">
            <option value="">Select Language</option>
            <option value="en">English</option>
            <option value="fr">French</option>
            <option value="es">Spanish</option>
            <option value="bn">Bengali</option>
            <option value="zh-CN">Chinese</option>
            <option value="pt-BR">Portuguese</option>
          </select>
          <div class="modern-form-error" v-if="errors.language_preference">{{ errors.language_preference }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.language_preference" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-group">
          <label for="avatar" class="modern-form-label">Avatar</label>
          <input id="avatar" type="file" class="modern-form-input" @change="onAvatarChange">
          <img v-if="avatarPreview || user.avatar" :src="avatarPreview || user.avatar" alt="avatar preview" style="width:48px;height:48px;border-radius:50%;object-fit:cover;margin-top:8px;">
          <div class="modern-form-error" v-if="errors.avatar">{{ errors.avatar }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.avatar" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-group">
          <label for="user-category" class="modern-form-label">Role</label>
          <v-select multiple v-model="user.role_id" :options="roleList" :reduce="role => role.id" label="name" class="modern-form-input" />
          <div class="modern-form-error" v-if="errors.role_id">{{ errors.role_id }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.role_id" :key="message">{{ message }}</div>
        </div>
        <div class="modern-form-actions">
          <button :disabled="isLoading" class="modern-form-btn">
            <span v-if="isLoading">Processing...</span>
            <span v-else>Save</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
<script setup>
import { onMounted, reactive, watchEffect, ref } from "vue";
import { useRoute } from "vue-router";
import useRoles from "@/composables/roles";
import useUsers from "@/composables/users";

const { roleList, getRoleList } = useRoles();
const { updateUser, getUser, user: postData, validationErrors, isLoading } = useUsers();

import { useForm, useField, defineRule } from "vee-validate";
import { required, min } from "@/validation/rules"
defineRule('required', required)
defineRule('min', min);

const schema = {
  username: 'required',
  email: 'required',
  password: 'min:8',
  language_preference: '',
  avatar: '',
  role_id: '',
}
const { validate, errors, resetForm } = useForm({ validationSchema: schema })
const { value: username } = useField('username', null, { initialValue: '' });
const { value: email } = useField('email', null, { initialValue: '' });
const { value: password } = useField('password', null, { initialValue: '' });
const { value: language_preference } = useField('language_preference', null, { initialValue: '' });
const { value: avatar } = useField('avatar', null, { initialValue: '' });
const { value: role_id } = useField('role_id', null, { initialValue: '', label: 'role' });
const user = reactive({
  id: '',
  username,
  email,
  password,
  language_preference,
  avatar,
  role_id,
})
const avatarPreview = ref(null)

const route = useRoute()
function onAvatarChange(e) {
  const file = e.target.files[0]
  user.avatar = file
  if (file) {
    const reader = new FileReader()
    reader.onload = e => { avatarPreview.value = e.target.result }
    reader.readAsDataURL(file)
  } else {
    avatarPreview.value = null
  }
}
function submitForm() {
  validate().then(form => {
    if (form.valid) {
      const formData = new FormData()
      for (const key in user) {
        formData.append(key, user[key])
      }
      updateUser(formData)
    }
  })
}
onMounted(() => {
  getUser(route.params.id)
  getRoleList()
})
watchEffect(() => {
  user.id = postData.value.id
  user.username = postData.value.username
  user.email = postData.value.email
  user.language_preference = postData.value.language_preference
  user.avatar = postData.value.avatar
  user.role_id = postData.value.role_id
})
</script>

<style scoped>
.modern-form-container {
  padding: 2.5rem 0;
  display: flex;
  justify-content: center;
}
.modern-form-card {
  background: #fff;
  border-radius: 1.5rem;
  box-shadow: 0 8px 32px rgba(67,233,123,0.10), 0 1.5px 8px rgba(34,34,59,0.07);
  padding: 2.5rem 2rem 2rem 2rem;
  width: 100%;
  max-width: 500px;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.modern-form-title {
  font-size: 2rem;
  font-weight: 700;
  color: #22223b;
  margin-bottom: 1.5rem;
  letter-spacing: 0.01em;
}
.modern-form {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.modern-form-group {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
.modern-form-label {
  font-weight: 600;
  color: #22223b;
  margin-bottom: 0.2rem;
}
.modern-form-input {
  padding: 0.8rem 1rem;
  border-radius: 0.8rem;
  border: 1px solid #e0e0e0;
  background: #f8fafc;
  font-size: 1rem;
  outline: none;
  transition: border 0.2s;
}
.modern-form-input:focus {
  border: 1.5px solid #43e97b;
  background: #fff;
}
.modern-form-error {
  color: #e57373;
  font-size: 0.95rem;
  margin-top: 0.1rem;
}
.modern-form-actions {
  margin-top: 1.2rem;
  display: flex;
  justify-content: flex-end;
}
.modern-form-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 0.9rem 2.2rem;
  border-radius: 2rem;
  font-weight: 700;
  font-size: 1.1rem;
  border: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
}
.modern-form-btn:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  box-shadow: 0 4px 16px rgba(250,139,255,0.15);
}
@media (max-width: 600px) {
  .modern-form-card {
    padding: 1.2rem 0.5rem 1rem 0.5rem;
    max-width: 98vw;
  }
}
</style>
