<template>
  <div class="modern-form-container">
    <div class="modern-form-card">
      <h2 class="modern-form-title">Create Permission</h2>
      <form @submit.prevent="submitForm" class="modern-form">
        <div class="modern-form-group">
          <label for="post-name" class="modern-form-label">Title</label>
          <input v-model="permission.name" id="post-name" type="text" class="modern-form-input">
          <div class="modern-form-error" v-if="errors.name">{{ errors.name }}</div>
          <div class="modern-form-error" v-for="message in validationErrors?.name" :key="message">{{ message }}</div>
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
    import { reactive } from "vue";
    import usePermissions from "@/composables/permissions";
    import { useForm, useField, defineRule } from "vee-validate";
    import { required, min } from "@/validation/rules"
    defineRule('required', required)
    defineRule('min', min);

    // Define a validation schema
    const schema = {
        name: 'required|min:3'
    }
    // Create a form context with the validation schema
    const { validate, errors } = useForm({ validationSchema: schema });
    // Define actual fields for validation
    const { value: name } = useField('name', null, { initialValue: '' });
    const { storePermission, validationErrors, isLoading } = usePermissions();
    const permission = reactive({
        name
    })
    function submitForm() {
        validate().then(form => { if (form.valid) storePermission(permission) })
    }
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
