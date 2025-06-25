<template>
  <div class="modern-table-container">
    <div class="modern-table-header">
      <h2>Plants</h2>
      <div class="header-actions">
        <input 
          type="text" 
          v-model="search" 
          placeholder="Search plants..." 
          class="search-input"
        />
        <router-link :to="{ name: 'plants.create' }" class="modern-btn">Add Plant</router-link>
      </div>
    </div>
    <table class="modern-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Scientific Name</th>
          <th>Category</th>
          <th>Translations</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="plant in plants" :key="plant.id">
          <td>{{ plant.id }}</td>
          <td>{{ plant.scientific_name }}</td>
          <td>{{ plant.plant_category?.name || 'N/A' }}</td>
          <td>
            <div v-for="translation in plant.translations" :key="translation.id" class="translation-item">
              <strong>{{ translation.language_code.toUpperCase() }}:</strong> {{ translation.common_name }}
            </div>
          </td>
          <td>
            <router-link :to="{ name: 'plants.edit', params: { id: plant.id } }" class="modern-btn small">Edit</router-link>
            <button @click="openDeleteModal(plant)" class="modern-btn small danger">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-if="loading" class="modern-table-loading">Loading...</div>
    <div v-if="plants.length === 0 && !loading" class="modern-table-empty">No plants found.</div>

    <Pagination
      :pagination="pagination.value"
      @page-changed="handlePageChange"
    />

    <!-- Delete Modal -->
    <div v-if="showDeleteModal" class="modal-overlay" @click="closeDeleteModal">
      <div class="modal-content" @click.stop>
        <h3>Delete Plant</h3>
        <p>Are you sure you want to delete "{{ selectedPlant?.scientific_name }}"?</p>
        <div class="modal-actions">
          <button @click="closeDeleteModal" class="btn-secondary">Cancel</button>
          <button @click="handleDelete" :disabled="loading" class="btn-danger">
            {{ loading ? 'Deleting...' : 'Delete' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { usePlants } from '@/composables/plants'
import Pagination from '@/components/Pagination.vue'

const {
    plants,
    loading,
    error,
    categories,
    languages,
    pagination,
    getPlants,
    getCategories,
    getLanguages,
    deletePlant
} = usePlants()

const search = ref('')
let debounceTimer = null

watch(search, () => {
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    getPlants(1, search.value)
  }, 500)
})

// Modal states
const showDeleteModal = ref(false)
const selectedPlant = ref(null)

// Initialize
onMounted(async () => {
    console.log('Plants Index component mounted')
    try {
        await Promise.all([
            getPlants(1),
            getCategories(),
            getLanguages()
        ])
        console.log('All data loaded successfully')
    } catch (error) {
        console.error('Error loading data:', error)
    }
})

// Handle page change
const handlePageChange = async (page) => {
    try {
        await getPlants(page, search.value)
    } catch (error) {
        console.error('Error fetching plants for page:', page, error)
    }
}

// Modal functions
const openDeleteModal = (plant) => {
    selectedPlant.value = plant
    showDeleteModal.value = true
}

const closeDeleteModal = () => {
    showDeleteModal.value = false
    selectedPlant.value = null
}

const handleDelete = async () => {
    try {
        await deletePlant(selectedPlant.value.id)
        closeDeleteModal()
        await getPlants(pagination.value.current_page)
    } catch (error) {
        console.error('Failed to delete plant:', error)
    }
}
</script>

<style scoped>
.modern-table-container {
  padding: 2.5rem 0;
  max-width: 1200px;
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

.translation-item {
  margin-bottom: 0.25rem;
  font-size: 0.9rem;
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
  min-width: 600px;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
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

.form-group input, .form-group select, .form-group textarea {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
  outline: none;
  border-color: #43e97b;
}

.form-group textarea {
  resize: vertical;
  min-height: 80px;
}

.translation-form {
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  padding: 1rem;
  margin-bottom: 1rem;
  background: #f8fafc;
}

.translation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.translation-header h4 {
  margin: 0;
  color: #22223b;
}

.remove-btn {
  background: #e57373;
  color: white;
  border: none;
  padding: 0.3rem 0.8rem;
  border-radius: 0.3rem;
  cursor: pointer;
  font-size: 0.8rem;
}

.translation-fields {
  display: grid;
  gap: 0.5rem;
}

.add-translation-btn {
  background: #43e97b;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  margin-top: 0.5rem;
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.search-input {
  padding: 0.6rem 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 1.2rem;
  font-size: 1rem;
  min-width: 250px;
}
</style> 