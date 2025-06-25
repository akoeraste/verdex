<template>
  <div class="modern-table-container">
    <div class="modern-table-header">
      <h2>Edit Plant</h2>
      <router-link :to="{ name: 'plants.index' }" class="modern-btn">Back to Plants</router-link>
    </div>

    <!-- Loading State -->
    <div v-if="loading && !plant" class="loading-container">
      <div class="loading-spinner"></div>
      <p>Loading plant data...</p>
    </div>

    <!-- Error Display -->
    <div v-if="error" class="error-message">
      {{ error }}
    </div>

    <!-- Form -->
    <div v-if="plant" class="form-container">
      <!-- Debug section -->
      <div class="debug-section" style="background: #f0f0f0; padding: 1rem; margin-bottom: 1rem; border-radius: 0.5rem;">
        <h4>Debug Info</h4>
        <p><strong>Plant ID:</strong> {{ plantId }}</p>
        <p><strong>Plant Loaded:</strong> {{ plant ? 'Yes' : 'No' }}</p>
        <p><strong>Form Data Scientific Name:</strong> {{ formData.scientific_name || 'EMPTY' }}</p>
        <p><strong>Form Data Category ID:</strong> {{ formData.plant_category_id || 'EMPTY' }}</p>
        <p><strong>Translations Count:</strong> {{ formData.translations.length }}</p>
        <button @click="debugFormData" type="button" style="background: #007bff; color: white; padding: 0.5rem 1rem; border: none; border-radius: 0.25rem; margin-right: 0.5rem;">
          Debug Form Data
        </button>
        <button @click="reloadPlantData" type="button" style="background: #28a745; color: white; padding: 0.5rem 1rem; border: none; border-radius: 0.25rem;">
          Reload Plant Data
        </button>
      </div>

      <form @submit.prevent="handleSubmit">
        <!-- Basic Plant Information -->
        <div class="form-section">
          <h3>Basic Information</h3>
          
          <div class="form-grid">
            <div class="form-group">
              <label>Scientific Name *</label>
              <input
                v-model="formData.scientific_name"
                type="text"
                placeholder="e.g., Azadirachta indica"
                required
              />
            </div>

            <div class="form-group">
              <label>Plant Category *</label>
              <select v-model="formData.plant_category_id" required>
                <option value="">Select Category</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </div>

            <div class="form-group">
              <label>Family</label>
              <input
                v-model="formData.family"
                type="text"
                placeholder="e.g., Meliaceae"
              />
            </div>

            <div class="form-group">
              <label>Genus</label>
              <input
                v-model="formData.genus"
                type="text"
                placeholder="e.g., Azadirachta"
              />
            </div>

            <div class="form-group">
              <label>Species</label>
              <input
                v-model="formData.species"
                type="text"
                placeholder="e.g., indica"
              />
            </div>

            <div class="form-group">
              <label>Toxicity Level</label>
              <select v-model="formData.toxicity_level">
                <option value="">Select Toxicity Level</option>
                <option value="none">None</option>
                <option value="low">Low</option>
                <option value="moderate">Moderate</option>
                <option value="high">High</option>
                <option value="very_high">Very High</option>
              </select>
            </div>
          </div>
        </div>

        <!-- Current Images -->
        <div class="form-section">
          <h3>Current Images</h3>
          
          <div v-if="plant.image_urls && plant.image_urls.length > 0" class="image-grid">
            <div
              v-for="(imageUrl, index) in plant.image_urls"
              :key="index"
              class="image-item"
            >
              <img
                :src="imageUrl"
                :alt="`Plant image ${index + 1}`"
                class="current-image"
              />
              <div class="image-overlay">
                <span>Existing Image</span>
              </div>
            </div>
          </div>
          <p v-else class="empty-state">No images uploaded yet.</p>
        </div>

        <!-- Add New Images -->
        <div class="form-section">
          <h3>Add New Images</h3>
          
          <div class="form-group">
            <label>Upload Additional Images (Multiple)</label>
            <input
              type="file"
              @change="handleImageUpload"
              multiple
              accept="image/*"
            />
            <p class="help-text">
              You can select multiple images. Supported formats: JPEG, PNG, WebP (max 2MB each)
            </p>
          </div>

          <!-- Preview New Images -->
          <div v-if="formData.images.length > 0" class="image-preview-grid">
            <div
              v-for="(image, index) in formData.images"
              :key="index"
              class="image-preview-item"
            >
              <img
                :src="getImagePreview(image)"
                :alt="`New plant image ${index + 1}`"
                class="preview-image"
              />
              <button
                type="button"
                @click="removeImage(index)"
                class="remove-image-btn"
              >
                ×
              </button>
            </div>
          </div>
        </div>

        <!-- Translations Section -->
        <div class="form-section">
          <div class="section-header">
            <h3>Translations</h3>
            <button
              type="button"
              @click="addTranslation"
              class="add-btn"
            >
              Add Translation
            </button>
          </div>

          <div v-if="formData.translations.length === 0" class="empty-state">
            <p>No translations added yet. Click "Add Translation" to get started.</p>
          </div>

          <div v-else class="translations-list">
            <div
              v-for="(translation, index) in formData.translations"
              :key="index"
              class="translation-form"
            >
              <div class="translation-header">
                <h4>Translation {{ index + 1 }}</h4>
                <button
                  type="button"
                  @click="removeTranslation(index)"
                  class="remove-btn"
                >
                  Remove
                </button>
              </div>

              <div class="translation-fields">
                <div class="form-group">
                  <label>Language</label>
                  <select v-model="translation.language_code" required>
                    <option value="">Select Language</option>
                    <option v-for="lang in languages" :key="lang.code" :value="lang.code">
                      {{ lang.name }}
                    </option>
                  </select>
                </div>
                
                <div class="form-group">
                  <label>Common Name</label>
                  <input type="text" v-model="translation.common_name" required>
                </div>
                
                <div class="form-group">
                  <label>Description</label>
                  <textarea v-model="translation.description" required></textarea>
                </div>
                
                <div class="form-group">
                  <label>Uses</label>
                  <textarea v-model="translation.uses" required></textarea>
                </div>

                <div class="form-group">
                  <label>Audio File</label>
                  <input 
                    type="file" 
                    @change="handleAudioUpload($event, index)"
                    accept="audio/*"
                  />
                  <p class="help-text">Supported formats: MP3, WAV, OGG (max 10MB)</p>
                  
                  <!-- Show existing audio if available -->
                  <div v-if="translation.audio_url" class="existing-audio">
                    <p><strong>Current Audio:</strong></p>
                    <audio controls>
                      <source :src="translation.audio_url" type="audio/mpeg">
                      Your browser does not support the audio element.
                    </audio>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
          <router-link :to="{ name: 'plants.index' }" class="btn-secondary">
            Cancel
          </router-link>
          <button
            type="submit"
            :disabled="loading || formData.translations.length === 0"
            class="btn-primary"
          >
            {{ loading ? 'Updating Plant...' : 'Update Plant' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { usePlants } from '@/composables/plants'

const router = useRouter()
const route = useRoute()

const {
    plant,
    loading,
    error,
    categories,
    languages,
    formData,
    getPlant,
    getCategories,
    getLanguages,
    updatePlant,
    addTranslation,
    removeTranslation,
    addImage,
    removeImage,
    loadPlantForEdit
} = usePlants()

// Get plant ID from route
const plantId = route.params.id

// Initialize
onMounted(async () => {
    console.log('Loading plant with ID:', plantId)
    try {
        await Promise.all([
            getPlant(plantId),
            getCategories(),
            getLanguages()
        ])
        console.log('All data loaded successfully')
    } catch (error) {
        console.error('Error loading data:', error)
    }
})

// Watch for plant data to load form
watch(plant, (newPlant) => {
    if (newPlant) {
        console.log('Plant data received, loading form:', newPlant)
        loadPlantForEdit(newPlant)
        console.log('Form loaded, checking formData:', {
            scientific_name: formData.scientific_name,
            plant_category_id: formData.plant_category_id,
            translations_count: formData.translations.length,
            translations: formData.translations
        })
    } else {
        console.log('No plant data available yet')
    }
}, { immediate: true })

// Handle image upload
const handleImageUpload = (event) => {
    const files = Array.from(event.target.files)
    files.forEach(file => {
        addImage(file)
    })
}

// Handle audio upload
const handleAudioUpload = (event, translationIndex) => {
    const file = event.target.files[0]
    if (file) {
        formData.translations[translationIndex].audio_file = file
    }
}

// Get image preview URL
const getImagePreview = (file) => {
    return URL.createObjectURL(file)
}

// Handle form submission
const handleSubmit = async () => {
    console.log('=== FORM SUBMISSION START ===')
    console.log('Submitting form with plant ID:', plantId)
    console.log('Current formData state:', {
        scientific_name: formData.scientific_name,
        plant_category_id: formData.plant_category_id,
        family: formData.family,
        genus: formData.genus,
        species: formData.species,
        toxicity_level: formData.toxicity_level,
        translations_count: formData.translations.length,
        images_count: formData.images.length
    })
    console.log('Full formData object:', formData)
    
    // Validate required fields before submitting
    if (!formData.scientific_name) {
        console.error('scientific_name is missing!')
        return
    }
    if (!formData.plant_category_id) {
        console.error('plant_category_id is missing!')
        return
    }
    if (!formData.translations || formData.translations.length === 0) {
        console.error('translations array is empty!')
        return
    }
    
    console.log('All required fields present, proceeding with update...')
    
    try {
        await updatePlant(plantId)
        router.push({ name: 'plants.index' })
    } catch (error) {
        console.error('Failed to update plant:', error)
    }
}

// Debug form data
const debugFormData = () => {
    console.log('=== DEBUG FORM DATA ===')
    console.log('Current formData state:', formData)
    console.log('Plant data:', plant.value)
    console.log('FormData scientific_name:', formData.scientific_name)
    console.log('FormData plant_category_id:', formData.plant_category_id)
    console.log('FormData translations:', formData.translations)
}

// Reload plant data
const reloadPlantData = async () => {
    console.log('Reloading plant data...')
    try {
        await getPlant(plantId)
        console.log('Plant data reloaded')
    } catch (error) {
        console.error('Error reloading plant data:', error)
    }
}
</script>

<style scoped>
.modern-table-container {
  padding: 2.5rem 0;
  max-width: 1000px;
  margin: 0 auto;
}

.modern-table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
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

.error-message {
  background: #fee;
  border: 1px solid #fcc;
  color: #c33;
  padding: 1rem;
  border-radius: 0.5rem;
  margin-bottom: 2rem;
}

.form-container {
  background: white;
  border-radius: 1rem;
  box-shadow: 0 4px 16px rgba(67,233,123,0.10);
  overflow: hidden;
}

.form-section {
  padding: 2rem;
  border-bottom: 1px solid #f0f0f0;
}

.form-section:last-child {
  border-bottom: none;
}

.form-section h3 {
  margin-bottom: 1.5rem;
  color: #22223b;
  font-size: 1.25rem;
  font-weight: 600;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.add-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  font-weight: 600;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
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

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  font-size: 1rem;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #43e97b;
}

.form-group textarea {
  resize: vertical;
  min-height: 100px;
}

.existing-audio {
  margin-top: 1rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 0.5rem;
  border: 1px solid #e9ecef;
}

.existing-audio p {
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #495057;
}

.existing-audio audio {
  width: 100%;
  max-width: 300px;
}

.help-text {
  font-size: 0.875rem;
  color: #6c757d;
  margin-top: 0.25rem;
}

.empty-state {
  text-align: center;
  padding: 2rem;
  color: #666;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.image-item {
  position: relative;
  border-radius: 0.5rem;
  overflow: hidden;
}

.current-image {
  width: 100%;
  height: 120px;
  object-fit: cover;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
}

.image-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s;
}

.image-item:hover .image-overlay {
  opacity: 1;
}

.image-overlay span {
  color: white;
  font-size: 0.875rem;
}

.image-preview-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.image-preview-item {
  position: relative;
  border-radius: 0.5rem;
  overflow: hidden;
}

.preview-image {
  width: 100%;
  height: 120px;
  object-fit: cover;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
}

.remove-image-btn {
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  background: #ef4444;
  color: white;
  border: none;
  border-radius: 50%;
  width: 1.5rem;
  height: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 0.875rem;
}

.translations-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.translation-form {
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  padding: 1.5rem;
  background: #fafafa;
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
  font-size: 1.1rem;
  font-weight: 600;
}

.remove-btn {
  background: #ef4444;
  color: white;
  border: none;
  padding: 0.25rem 0.75rem;
  border-radius: 0.25rem;
  cursor: pointer;
  font-size: 0.875rem;
}

.translation-fields {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 2rem;
  background: #fafafa;
}

.btn-secondary {
  background: #6b7280;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
  text-decoration: none;
  display: inline-block;
}

.btn-primary {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
}

.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .modern-table-header {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }
}
</style> 