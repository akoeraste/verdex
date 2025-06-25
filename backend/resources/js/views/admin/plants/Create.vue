<template>
  <div class="modern-table-container">
    <div class="modern-table-header">
      <h2>Add New Plant</h2>
      <router-link :to="{ name: 'plants.index' }" class="modern-btn">Back to Plants</router-link>
    </div>

    <!-- Error Display -->
    <div v-if="error" class="error-message">
      {{ error }}
    </div>

    <!-- Form -->
    <div class="form-container">
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

        <!-- Image Upload -->
        <div class="form-section">
          <h3>Plant Images</h3>
          
          <div class="form-group">
            <label>Upload Images (Multiple)</label>
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

          <!-- Preview Selected Images -->
          <div v-if="formData.images.length > 0" class="image-preview-grid">
            <div
              v-for="(image, index) in formData.images"
              :key="index"
              class="image-preview-item"
            >
              <img
                :src="getImagePreview(image)"
                :alt="`Plant image ${index + 1}`"
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
            {{ loading ? 'Creating Plant...' : 'Create Plant' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { usePlants } from '@/composables/plants'

const router = useRouter()

const {
    loading,
    error,
    categories,
    languages,
    formData,
    getCategories,
    getLanguages,
    storePlant,
    addTranslation,
    removeTranslation,
    addImage,
    removeImage,
    resetForm
} = usePlants()

// Initialize
onMounted(async () => {
    await Promise.all([
        getCategories(),
        getLanguages()
    ])
})

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
    try {
        await storePlant()
        router.push({ name: 'plants.index' })
    } catch (error) {
        console.error('Failed to create plant:', error)
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

.help-text {
  font-size: 0.875rem;
  color: #6c757d;
  margin-top: 0.25rem;
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
  background: #e57373;
  color: white;
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #666;
  background: #f8fafc;
  border-radius: 0.5rem;
}

.translations-list {
  space-y: 1.5rem;
}

.translation-form {
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
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
  font-size: 1.1rem;
  font-weight: 600;
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
  space-y: 1rem;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 2rem;
  background: #f8fafc;
  border-top: 1px solid #e0e0e0;
}

.btn-primary {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  padding: 0.8rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
  transition: opacity 0.2s;
}

.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-secondary {
  background: #f8fafc;
  color: #666;
  padding: 0.8rem 1.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 600;
  text-decoration: none;
  display: inline-block;
}

@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .image-preview-grid {
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  }
}
</style> 