<template>
  <div class="modern-table-container">
    <div class="modern-table-header">
      <h2>Languages</h2>
      <router-link :to="{ name: 'languages.create' }" class="modern-btn">Add Language</router-link>
    </div>
    <table class="modern-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Code</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="lang in languages" :key="lang.id">
          <td>{{ lang.id }}</td>
          <td>{{ lang.code }}</td>
          <td>{{ lang.name }}</td>
          <td>
            <button @click="openEditModal(lang)" class="modern-btn small">Edit</button>
            <button @click="openDeleteModal(lang)" class="modern-btn small danger">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-if="isLoading" class="modern-table-loading">Loading...</div>
    <div v-if="languages.length === 0 && !isLoading" class="modern-table-empty">No languages found.</div>

    <!-- Edit Modal -->
    <div v-if="showEditModal" class="modal-overlay" @click="closeEditModal">
      <div class="modal-content" @click.stop>
        <h3>Edit Language</h3>
        <form @submit.prevent="submitEdit">
          <div class="form-group">
            <label>Code</label>
            <input v-model="editForm.code" type="text" required>
            <div v-if="errors.code" class="error">{{ errors.code[0] }}</div>
          </div>
          <div class="form-group">
            <label>Name</label>
            <input v-model="editForm.name" type="text" required>
            <div v-if="errors.name" class="error">{{ errors.name[0] }}</div>
          </div>
          <div class="modal-actions">
            <button type="button" @click="closeEditModal" class="btn-secondary">Cancel</button>
            <button type="submit" :disabled="isLoading" class="btn-primary">
              {{ isLoading ? 'Saving...' : 'Save' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Delete Modal -->
    <div v-if="showDeleteModal" class="modal-overlay" @click="closeDeleteModal">
      <div class="modal-content" @click.stop>
        <h3>Delete Language</h3>
        <p>Are you sure you want to delete "{{ deleteForm.name }}"?</p>
        <div class="modal-actions">
          <button @click="closeDeleteModal" class="btn-secondary">Cancel</button>
          <button @click="confirmDelete" :disabled="isLoading" class="btn-danger">
            {{ isLoading ? 'Deleting...' : 'Delete' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { useLanguages } from '@/composables/languages';

const { languages, getLanguages, updateLanguage, deleteLanguage, errors, isLoading } = useLanguages();

// Modal states
const showEditModal = ref(false);
const showDeleteModal = ref(false);
const editForm = ref({ id: null, code: '', name: '' });
const deleteForm = ref({ id: null, name: '' });

onMounted(() => {
  getLanguages();
});

function openEditModal(lang) {
  editForm.value = { id: lang.id, code: lang.code, name: lang.name };
  showEditModal.value = true;
}

function closeEditModal() {
  showEditModal.value = false;
  editForm.value = { id: null, code: '', name: '' };
}

function openDeleteModal(lang) {
  deleteForm.value = { id: lang.id, name: lang.name };
  showDeleteModal.value = true;
}

function closeDeleteModal() {
  showDeleteModal.value = false;
  deleteForm.value = { id: null, name: '' };
}

async function submitEdit() {
  try {
    await updateLanguage(editForm.value.id, {
      code: editForm.value.code,
      name: editForm.value.name
    });
    closeEditModal();
    getLanguages();
  } catch (e) {
    // Error is handled by the composable
  }
}

async function confirmDelete() {
  try {
    await deleteLanguage(deleteForm.value.id);
    closeDeleteModal();
    getLanguages();
  } catch (e) {
    // Error is handled by the composable
  }
}
</script>

<style scoped>
.modern-table-container {
  padding: 2.5rem 0;
  max-width: 800px;
  margin: 0 auto;
}
.modern-table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}
.modern-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 0.6rem 1.5rem;
  border-radius: 1.2rem;
  font-weight: 600;
  font-size: 1rem;
  border: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
  text-decoration: none;
  margin-right: 0.5rem;
}
.modern-btn.small {
  padding: 0.4rem 1rem;
  font-size: 0.95rem;
}
.modern-btn.danger {
  background: linear-gradient(135deg, #e57373 0%, #ffb199 100%);
}
.modern-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(67,233,123,0.10);
}
.modern-table th, .modern-table td {
  padding: 1rem;
  text-align: left;
}
.modern-table th {
  background: #f8fafc;
  font-weight: 700;
}
.modern-table-loading, .modern-table-empty {
  text-align: center;
  margin-top: 2rem;
  color: #888;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  min-width: 400px;
  max-width: 500px;
}

.modal-content h3 {
  margin-bottom: 1.5rem;
  color: #22223b;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #22223b;
}

.form-group input {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.form-group input:focus {
  outline: none;
  border-color: #43e97b;
}

.error {
  color: #e57373;
  font-size: 0.9rem;
  margin-top: 0.25rem;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 2rem;
}

.btn-primary {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  padding: 0.8rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
}

.btn-secondary {
  background: #f8fafc;
  color: #666;
  padding: 0.8rem 1.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
}

.btn-danger {
  background: linear-gradient(135deg, #e57373 0%, #ffb199 100%);
  color: white;
  padding: 0.8rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
}
</style> 