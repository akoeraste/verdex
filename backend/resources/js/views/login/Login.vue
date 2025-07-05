<template>
  <div class="login-bg">
    <a href="/" class="doc-btn">
      <i class="bi bi-journal-code"></i> Go Home
    </a>
    <div class="login-container">
      <div class="login-card">
        <p class="login-welcome"><strong>Welcome back!</strong> <br> Please sign In.</p>
        <form @submit.prevent="submitLogin" class="login-form">
          <div class="login-field">
            <label for="login" class="login-label">Username</label>
            <input v-model="loginForm.login" id="login" type="text" class="login-input" autofocus autocomplete="username" />
            <div class="login-error" v-if="validationErrors?.login">
              <div v-for="message in validationErrors.login" :key="message">{{ message }}</div>
            </div>
          </div>
          <div class="login-field">
            <label for="password" class="login-label">{{ $t('password') }}</label>
            <input v-model="loginForm.password" id="password" type="password" class="login-input" autocomplete="current-password" />
            <div class="login-error" v-if="validationErrors?.password">
              <div v-for="message in validationErrors.password" :key="message">{{ message }}</div>
            </div>
          </div>
          <div class="login-remember">
            <input class="login-checkbox" type="checkbox" name="remember" v-model="loginForm.remember" id="remember" />
            <label class="login-remember-label" for="remember">{{ $t('remember_me') }}</label>
          </div>
          <button class="login-btn" :class="{ 'disabled': processing }" :disabled="processing">
            {{ $t('login') }}
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import useAuth from '@/composables/auth'
const { loginForm, validationErrors, processing, submitLogin } = useAuth();
</script>

<style scoped>
.login-bg {
  min-height: 100vh;
  background: linear-gradient(135deg, rgba(131, 213, 234, 0.63) 0%, rgba(233, 211, 255, 0.53) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-container {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  border-radius: 1.5rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 3rem 2.5rem 2.5rem 2.5rem;
  max-width: 400px;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.login-logo {
background-color: rgba(29, 29, 29, 0.762);
  width: 80px;
  height: 80px;
  object-fit: contain;
  margin-bottom: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 2px 8px rgba(18, 189, 75, 0.12);
}
.login-title {
  font-size: 2rem;
  font-weight: 700;
  color: #22223b;
  margin-bottom: 0.5rem;
  letter-spacing: 0.01em;
}
.login-welcome {
  color: #4a4e69;
  font-size: 1.1rem;
  margin-bottom: 2rem;
  text-align: left !important;
}
.login-form {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.login-field {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
.login-label {
  font-weight: 600;
  color: #22223b;
  margin-bottom: 0.2rem;
}
.login-input {
  padding: 0.8rem 1rem;
  border-radius: 0.8rem;
  border: 1px solid #e0e0e0;
  background: #f8fafc;
  font-size: 1rem;
  outline: none;
  transition: border 0.2s;
}
.login-input:focus {
  border: 1.5px solid #667eea;
  background: #fff;
}
.login-error {
  color: #e57373;
  font-size: 0.95rem;
  margin-top: 0.1rem;
}
.login-remember {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}
.login-checkbox {
  accent-color: #667eea;
  width: 1.1rem;
  height: 1.1rem;
}
.login-remember-label {
  color: #4a4e69;
  font-size: 1rem;
}
.login-btn {
  width: 100%;
  padding: 0.9rem 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  border: none;
  border-radius: 2rem;
  font-weight: 700;
  font-size: 1.1rem;
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
  cursor: pointer;
  transition: all 0.3s ease;
}
.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 32px rgba(102, 126, 234, 0.4);
}
.login-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.doc-btn {
  position: fixed;
  top: 2.2rem;
  right: 2.2rem;
  z-index: 100;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  color: #667eea;
  border: 1.5px solid rgba(102, 126, 234, 0.2);
  border-radius: 2rem;
  padding: 0.6rem 1.5rem;
  font-weight: 600;
  font-size: 1.05rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  transition: all 0.3s ease;
  text-decoration: none;
}
.doc-btn:hover {
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
}
@media (max-width: 600px) {
  .login-card {
    padding: 2rem 1rem 1.5rem 1rem;
    max-width: 98vw;
  }
  .login-logo {
    width: 60px;
    height: 60px;
  }
  .doc-btn {
    top: 1rem;
    right: 1rem;
    font-size: 0.98rem;
    padding: 0.5rem 1.1rem;
  }
}
</style>
