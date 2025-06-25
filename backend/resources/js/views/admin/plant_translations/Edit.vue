<template>
  <div class="edit-translation-page">
    <div class="page-header">
      <div class="header-content">
        <h2>Edit Plant Translation</h2>
        <div class="plant-info">
          <span class="plant-name">{{ plant?.scientific_name }}</span>
          <span class="plant-id">(ID: {{ plant?.id }})</span>
        </div>
      </div>
      <router-link :to="{ name: 'plant_translations.index' }" class="back-btn">
        ← Back to Translations
      </router-link>
    </div>

    <div v-if="loading" class="loading-container">
      <div class="loading-spinner">Loading...</div>
    </div>

    <div v-else-if="!plant" class="error-container">
      <p>Plant not found</p>
    </div>

    <div v-else class="translation-editor">
      <!-- Language Selector -->
      <div class="language-selector">
        <h3>Select Language to Edit</h3>
        <div class="language-tabs">
          <button
            v-for="lang in availableLanguages"
            :key="lang.code"
            @click="selectLanguage(lang.code)"
            class="language-tab"
            :class="{ active: selectedLanguage === lang.code }"
          >
            <span class="language-name">{{ lang.name }}</span>
            <span class="language-code">({{ lang.code.toUpperCase() }})</span>
            <span v-if="getTranslation(lang.code)?.audio_url" class="audio-indicator">✓</span>
            <span v-else class="audio-indicator missing">✗</span>
          </button>
        </div>
      </div>

      <!-- Translation Form -->
      <div v-if="selectedLanguage" class="translation-form">
        <div class="form-header">
          <h3>{{ getLanguageName(selectedLanguage) }} Translation</h3>
          <div class="translation-status">
            <span v-if="currentTranslation?.id" class="status-existing">Existing Translation</span>
            <span v-else class="status-new">New Translation</span>
          </div>
        </div>

        <form @submit.prevent="saveTranslation">
          <div class="form-fields">
            <div class="field-group">
              <label>Common Name *</label>
              <input 
                v-model="formData.common_name" 
                type="text" 
                class="form-input" 
                required 
                placeholder="Enter common name in this language"
              />
            </div>

            <div class="field-group">
              <label>Description *</label>
              <textarea 
                v-model="formData.description" 
                class="form-textarea" 
                required 
                placeholder="Enter plant description in this language"
                rows="4"
              ></textarea>
            </div>

            <div class="field-group">
              <label>Uses *</label>
              <textarea 
                v-model="formData.uses" 
                class="form-textarea" 
                required 
                placeholder="Enter plant uses in this language"
                rows="4"
              ></textarea>
            </div>

            <div class="field-group">
              <label>Audio File</label>
              <div class="audio-section">
                <!-- Current Audio Display -->
                <div v-if="currentTranslation?.audio_url" class="current-audio">
                  <label>Current Audio:</label>
                  <div class="audio-player">
                    <audio controls>
                      <source :src="currentTranslation.audio_url" type="audio/mpeg">
                      Your browser does not support the audio element.
                    </audio>
                    <a :href="currentTranslation.audio_url" target="_blank" class="audio-link">
                      Open Audio File
                    </a>
                  </div>
                </div>

                <!-- New Audio Upload -->
                <div class="audio-upload">
                  <label>Upload New Audio (optional):</label>
                  <input 
                    type="file" 
                    @change="onAudioChange" 
                    accept="audio/*" 
                    class="file-input"
                  />
                  <p class="help-text">Supported formats: MP3, WAV, OGG (max 10MB)</p>
                </div>
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" @click="resetForm" class="btn-secondary">
              Reset
            </button>
            <button type="submit" class="btn-primary" :disabled="saving">
              {{ saving ? 'Saving...' : 'Save Translation' }}
            </button>
          </div>
        </form>
      </div>

      <!-- No Language Selected -->
      <div v-else class="no-language-selected">
        <p>Please select a language to edit from the tabs above.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { useToast } from 'vue-toastification'

const route = useRoute()
const router = useRouter()
const toast = useToast()

const plant = ref(null)
const loading = ref(true)
const saving = ref(false)
const selectedLanguage = ref('')
const audioFile = ref(null)

const availableLanguages = [
  { code: 'en', name: 'English' },
  { code: 'fr', name: 'French' },
  { code: 'pg', name: 'Pidgin' }
]

const formData = ref({
  common_name: '',
  description: '',
  uses: ''
})

// Get current translation for selected language
const currentTranslation = computed(() => {
  if (!plant.value || !selectedLanguage.value) return null
  return plant.value.translations?.find(t => t.language_code === selectedLanguage.value)
})

function getLanguageName(languageCode) {
  const languageNames = {
    'en': 'English',
    'fr': 'French', 
    'pg': 'Pidgin'
  }
  return languageNames[languageCode] || languageCode.toUpperCase()
}

function getTranslation(languageCode) {
  if (!plant.value) return null
  return plant.value.translations?.find(t => t.language_code === languageCode)
}

function selectLanguage(languageCode) {
  selectedLanguage.value = languageCode
  loadTranslationData(languageCode)
}

function loadTranslationData(languageCode) {
  const translation = getTranslation(languageCode)
  
  if (translation) {
    // Load existing translation data
    formData.value = {
      common_name: translation.common_name || '',
      description: translation.description || '',
      uses: translation.uses || ''
    }
  } else {
    // Reset form for new translation
    formData.value = {
      common_name: '',
      description: '',
      uses: ''
    }
  }
  
  audioFile.value = null
}

function onAudioChange(event) {
  const file = event.target.files[0]
  if (file) {
    audioFile.value = file
  }
}

function resetForm() {
  loadTranslationData(selectedLanguage.value)
}

async function saveTranslation() {
  if (!selectedLanguage.value) {
    toast.error('Please select a language first')
    return
  }

  // Validate required fields
  if (!formData.value.common_name || !formData.value.description || !formData.value.uses) {
    toast.error('Please fill in all required fields')
    return
  }

  saving.value = true
  try {
    const formDataToSend = new FormData()
    
    // Add translation data
    formDataToSend.append('language_code', selectedLanguage.value)
    formDataToSend.append('common_name', formData.value.common_name)
    formDataToSend.append('description', formData.value.description)
    formDataToSend.append('uses', formData.value.uses)
    
    // Add audio file if selected
    if (audioFile.value) {
      formDataToSend.append('audio_file', audioFile.value)
    }

    // Determine if this is an update or create
    const translation = getTranslation(selectedLanguage.value)
    let response

    if (translation?.id) {
      // Update existing translation
      formDataToSend.append('_method', 'PUT')
      response = await axios.post(`/api/plants/${plant.value.id}/translations/${translation.id}`, formDataToSend, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
    } else {
      // Create new translation
      response = await axios.post(`/api/plants/${plant.value.id}/translations`, formDataToSend, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
    }

    // Update local plant data
    if (response.data.data) {
      plant.value = response.data.data
    }

    toast.success('Translation saved successfully!')
    
    // Reset audio file input
    audioFile.value = null
    
  } catch (error) {
    console.error('Error saving translation:', error)
    const message = error.response?.data?.message || error.response?.data?.details || error.message || 'Unknown error'
    toast.error('Error saving translation: ' + message)
  } finally {
    saving.value = false
  }
}

async function fetchPlant() {
  loading.value = true
  try {
    const plantId = route.params.id
    const response = await axios.get(`/api/plants/${plantId}`)
    plant.value = response.data.data
    
    // Auto-select first language if available
    if (plant.value.translations && plant.value.translations.length > 0) {
      selectedLanguage.value = plant.value.translations[0].language_code
      loadTranslationData(selectedLanguage.value)
    }
  } catch (error) {
    console.error('Error fetching plant:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchPlant()
})
</script>

<style scoped>
.edit-translation-page {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #e5e7eb;
}

.header-content h2 {
  margin: 0 0 0.5rem 0;
  color: #1f2937;
  font-size: 1.875rem;
  font-weight: 700;
}

.plant-info {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.plant-name {
  font-weight: 600;
  color: #059669;
  font-size: 1.125rem;
}

.plant-id {
  color: #6b7280;
  font-size: 0.875rem;
}

.back-btn {
  background: #6b7280;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  text-decoration: none;
  font-weight: 600;
  transition: background-color 0.2s;
}

.back-btn:hover {
  background: #4b5563;
}

.loading-container, .error-container {
  text-align: center;
  padding: 3rem;
  color: #6b7280;
}

.loading-spinner {
  font-size: 1.125rem;
  font-weight: 600;
}

.translation-editor {
  background: white;
  border-radius: 1rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.language-selector {
  background: #f8fafc;
  padding: 1.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.language-selector h3 {
  margin: 0 0 1rem 0;
  color: #374151;
  font-size: 1.25rem;
  font-weight: 600;
}

.language-tabs {
  display: flex;
  gap: 1rem;
}

.language-tab {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.2s;
  font-weight: 600;
}

.language-tab:hover {
  border-color: #43e97b;
  background: #f0fdf4;
}

.language-tab.active {
  border-color: #43e97b;
  background: #43e97b;
  color: white;
}

.language-name {
  font-size: 1rem;
}

.language-code {
  font-size: 0.875rem;
  opacity: 0.8;
}

.audio-indicator {
  font-weight: bold;
  color: #059669;
}

.audio-indicator.missing {
  color: #dc2626;
}

.language-tab.active .audio-indicator {
  color: white;
}

.translation-form {
  padding: 2rem;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e5e7eb;
}

.form-header h3 {
  margin: 0;
  color: #1f2937;
  font-size: 1.5rem;
  font-weight: 700;
}

.translation-status {
  font-size: 0.875rem;
  font-weight: 600;
}

.status-existing {
  color: #059669;
  background: #d1fae5;
  padding: 0.25rem 0.75rem;
  border-radius: 1rem;
}

.status-new {
  color: #d97706;
  background: #fed7aa;
  padding: 0.25rem 0.75rem;
  border-radius: 1rem;
}

.form-fields {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.field-group {
  display: flex;
  flex-direction: column;
}

.field-group label {
  font-weight: 600;
  color: #374151;
  margin-bottom: 0.5rem;
  font-size: 1rem;
}

.form-input, .form-textarea {
  padding: 0.75rem;
  border: 2px solid #e5e7eb;
  border-radius: 0.5rem;
  font-size: 1rem;
  transition: border-color 0.2s;
}

.form-input:focus, .form-textarea:focus {
  outline: none;
  border-color: #43e97b;
  box-shadow: 0 0 0 3px rgba(67, 233, 123, 0.1);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.audio-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.current-audio {
  background: #f8fafc;
  padding: 1rem;
  border-radius: 0.5rem;
  border: 1px solid #e5e7eb;
}

.current-audio label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #374151;
}

.audio-player {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.audio-player audio {
  width: 100%;
}

.audio-link {
  color: #3b82f6;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.875rem;
}

.audio-link:hover {
  text-decoration: underline;
}

.audio-upload {
  background: #fef3c7;
  padding: 1rem;
  border-radius: 0.5rem;
  border: 1px solid #f59e0b;
}

.audio-upload label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #92400e;
}

.file-input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
  background: white;
}

.help-text {
  margin: 0.5rem 0 0 0;
  font-size: 0.875rem;
  color: #6b7280;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid #e5e7eb;
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
  border: 1px solid #d1d5db;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

.btn-primary {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(67, 233, 123, 0.3);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.no-language-selected {
  padding: 3rem;
  text-align: center;
  color: #6b7280;
  font-size: 1.125rem;
}
</style> 