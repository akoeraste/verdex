<template>
  <div class="modern-table-container">
    <div class="modern-table-header">
      <h2>Plant Translations</h2>
      <div class="search-container">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Search by common name..." 
          class="search-input"
        />
      </div>
    </div>
    <table class="modern-table">
      <thead>
        <tr>
          <th>Plant ID</th>
          <th>Common Name</th>
          <th>Languages & Audio</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="plant in paginatedPlants" :key="plant.id">
          <td>{{ plant.id }}</td>
          <td>
            <div class="common-names-container">
              <div v-for="translation in plant.translations" :key="translation.language_code" class="common-name-item">
                <span class="language-badge small" :class="getLanguageClass(translation.language_code)">
                  {{ getLanguageName(translation.language_code) }}
                </span>
                <span class="common-name">{{ translation.common_name }}</span>
              </div>
            </div>
          </td>
          <td>
            <div class="languages-container">
              <div v-for="translation in plant.translations" :key="translation.language_code" class="language-item">
                <span class="language-badge" :class="getLanguageClass(translation.language_code)">
                  {{ getLanguageName(translation.language_code) }}
                </span>
                <span v-if="translation.audio_url" class="audio-available">✓</span>
                <span v-else class="audio-missing">✗</span>
              </div>
            </div>
          </td>
          <td>
            <div class="action-buttons">
              <router-link 
                :to="{ name: 'plant_translations.edit', params: { id: plant.id } }" 
                class="modern-btn small"
              >
                Edit Translations
              </router-link>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-if="loading" class="modern-table-loading">Loading...</div>
    <div v-if="paginatedPlants.length === 0 && !loading" class="modern-table-empty">No plants found.</div>

    <!-- Pagination -->
    <div v-if="totalPages > 1" class="pagination-container">
      <div class="pagination-info">
        Showing {{ startIndex + 1 }}-{{ endIndex }} of {{ groupedPlants.length }} plants
      </div>
      <div class="pagination-controls">
        <button 
          @click="changePage(currentPage - 1)" 
          :disabled="currentPage === 1"
          class="pagination-btn"
        >
          Previous
        </button>
        <span 
          v-for="page in visiblePages" 
          :key="page"
          @click="changePage(page)"
          class="page-number"
          :class="{ active: page === currentPage }"
        >
          {{ page }}
        </span>
        <button 
          @click="changePage(currentPage + 1)" 
          :disabled="currentPage === totalPages"
          class="pagination-btn"
        >
          Next
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import axios from 'axios'

const plants = ref([])
const loading = ref(false)
const currentPage = ref(1)
const itemsPerPage = 5
const searchQuery = ref('')

// Group plants by ID - each plant shows as one row
const groupedPlants = computed(() => {
  let filteredPlants = plants.value.map(plant => ({
    id: plant.id,
    scientific_name: plant.scientific_name,
    translations: plant.translations || []
  }))
  
  // Filter by search query if provided
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase().trim()
    filteredPlants = filteredPlants.filter(plant => {
      return plant.translations.some(translation => 
        translation.common_name && 
        translation.common_name.toLowerCase().includes(query)
      )
    })
  }
  
  return filteredPlants
})

// Pagination computed properties
const totalPages = computed(() => {
  return Math.ceil(groupedPlants.value.length / itemsPerPage)
})

const startIndex = computed(() => {
  return (currentPage.value - 1) * itemsPerPage
})

const endIndex = computed(() => {
  return Math.min(startIndex.value + itemsPerPage, groupedPlants.value.length)
})

const paginatedPlants = computed(() => {
  return groupedPlants.value.slice(startIndex.value, endIndex.value)
})

const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let end = Math.min(totalPages.value, start + maxVisible - 1)
  
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  
  return pages
})

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

function getLanguageName(languageCode) {
  const languageNames = {
    'en': 'English',
    'fr': 'French', 
    'pg': 'Pidgin'
  }
  return languageNames[languageCode] || languageCode.toUpperCase()
}

function getLanguageClass(languageCode) {
  const languageClasses = {
    'en': 'language-en',
    'fr': 'language-fr',
    'pg': 'language-pg'
  }
  return languageClasses[languageCode] || 'language-default'
}

async function fetchPlants() {
  loading.value = true
  try {
    const response = await axios.get('/api/plants')
    plants.value = response.data.data.map(plant => ({
      id: plant.id,
      scientific_name: plant.scientific_name,
      translations: plant.translations || []
    }))
  } catch (error) {
    console.error('Error fetching plants:', error)
  } finally {
    loading.value = false
  }
}

// Watch for search changes and reset to page 1
watch(searchQuery, () => {
  currentPage.value = 1
})

onMounted(() => {
  fetchPlants()
})
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
.modern-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.modern-btn.small {
  padding: 0.4rem 1rem;
  font-size: 0.95rem;
}
.btn-secondary {
  background: #f8fafc;
  color: #666;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
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
.languages-container {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.common-names-container {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.common-name-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.language-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.common-name {
  font-weight: 500;
  color: #374151;
  flex: 1;
}
.language-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 1rem;
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
}
.language-badge.small {
  padding: 0.2rem 0.6rem;
  font-size: 0.75rem;
}
.language-en {
  background: #dbeafe;
  color: #1e40af;
}
.language-fr {
  background: #fef3c7;
  color: #92400e;
}
.language-pg {
  background: #dcfce7;
  color: #166534;
}
.language-default {
  background: #f3f4f6;
  color: #374151;
}
.audio-available {
  color: #059669;
  font-weight: 600;
}
.audio-missing {
  color: #dc2626;
  font-weight: 600;
}
.edit-input {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
  margin-top: 0.5rem;
}
textarea.edit-input {
  min-height: 80px;
  resize: vertical;
}
.file-input {
  margin-top: 0.5rem;
}
.pagination-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2rem;
  padding: 1rem;
  background: #f8fafc;
  border-radius: 0.5rem;
}
.pagination-info {
  color: #6b7280;
  font-size: 0.9rem;
}
.pagination-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.pagination-btn {
  padding: 0.5rem 1rem;
  border: 1px solid #d1d5db;
  background: white;
  color: #374151;
  border-radius: 0.375rem;
  cursor: pointer;
  font-size: 0.875rem;
  transition: all 0.2s;
}
.pagination-btn:hover:not(:disabled) {
  background: #f3f4f6;
  border-color: #9ca3af;
}
.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.page-number {
  padding: 0.5rem 0.75rem;
  border: 1px solid #d1d5db;
  background: white;
  color: #374151;
  border-radius: 0.375rem;
  cursor: pointer;
  font-size: 0.875rem;
  transition: all 0.2s;
  min-width: 2.5rem;
  text-align: center;
}
.page-number:hover {
  background: #f3f4f6;
  border-color: #9ca3af;
}
.page-number.active {
  background: #43e97b;
  color: white;
  border-color: #43e97b;
}
.search-container {
  position: relative;
}
.search-input {
  padding: 0.8rem 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
  width: 300px;
  background: white;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.search-input:focus {
  outline: none;
  border-color: #43e97b;
  box-shadow: 0 0 0 3px rgba(67, 233, 123, 0.1);
}
.search-input::placeholder {
  color: #9ca3af;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}
</style> 